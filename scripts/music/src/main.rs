mod bookmarks;
mod daemon;
mod mpdplayer;
mod audiobook;
mod mprisplayer;
mod utils;

use bookmarks::add_bookmark;
use clap::{Arg, Command};
use notify_rust::Notification;
use utils::hms;
use std::collections::HashMap;
use std::env;
use std::io::prelude::*;
use std::process;
use unix_named_pipe::*;

const MPRIS_NOT_SO_IMPORTANT: [&str; 2] = ["kdeconnect", "chromium"]; // FIXME get from config

fn has_important_players(player_name: &str) -> bool {
  match MPRIS_NOT_SO_IMPORTANT
    .iter()
    .find(|&p| player_name.contains(p))
  {
    Some(_) => false,
    None => true,
  }
}

fn write_to_socket(frontend: &str, val: Vec<u8>) {
  let var = match frontend {
    "sway" => "SWAYSOCK",
    "hyprland" => "HYPRLANDSOCK",
    _ => "",
  };

  if var.len() == 0 {
    return;
  }

  let mut file = open_write(format!(
    "{}.wob",
    env::var("SWAYSOCK").expect("Environment variable unset")
  ))
  .expect("Unable to open fifo pipe file");
  file
    .write_all(&val)
    .expect("Unable to write to fifo pipe file");
}

fn main() {
  if std::env::args().any(|a| a == "--daemon") {
    daemon::run_daemon_mode();
    return;
  }

  let mpris_player = mprisplayer::MprisPlayer::new();
  let mut mpd_player = mpdplayer::MpdPlayer::new();
  // FIXME use args self-written module in all programs
  let cmd = Command::new("music")
    .arg_required_else_help(true)
    .allow_external_subcommands(true)
    .subcommand(Command::new("status").about("Show status"))
    .subcommand(Command::new("toggle").about("Play / Pause"))
    .subcommand(Command::new("stop").about("Stop player"))
    .subcommand(Command::new("next").about("Next track"))
    .subcommand(Command::new("prev").about("Previous Track"))
    .subcommand(Command::new("seek+").about("Seek 10 seconds forward"))
    .subcommand(Command::new("seek-").about("Seek 10 seconds backward"))
    .subcommand(Command::new("volume+").about("Increase volume"))
    .subcommand(Command::new("volume-").about("Decrease volume"))
    .subcommand(Command::new("mute").about("Mute / Unmute volume"))
    .subcommand(Command::new("bookmark").about("Add bookmark at the current position"))
    .arg(
      Arg::new("FRONTEND")
        .long("frontend")
        .short('f')
        .required(true),
    )
    .get_matches();

  let frontend = cmd.get_one::<String>("FRONTEND").unwrap().as_str();

  let command = match cmd.subcommand() {
    Some((x, _)) => x,
    _ => "status",
  };

  let command = match frontend {
    "i3blocks" => match env::var("BLOCK_BUTTON") {
      Ok(b) => match b.as_str() {
        "1" => "toggle",
        // 3 ) show_lyrics "notify";;
        "4" => "seek+",
        "5" => "seek-",
        _ => command,
      },
      Err(_) => command,
    },
    _ => command,
  };

  let options = HashMap::from([("frontend", frontend)]);

  match command {
    "volume+" => {
      let val = process::Command::new("pamixer")
        .args(["--unmute", "--increase", "5", "--get-volume"])
        .output()
        .expect("Unable to increase volume");
      write_to_socket(frontend, val.stdout);
    }

    "volume-" => {
      let val = process::Command::new("pamixer")
        .args(["--unmute", "--decrease", "5", "--get-volume"])
        .output()
        .expect("Unable to increase volume");
      write_to_socket(frontend, val.stdout);
    }
    "mute" => {
      process::Command::new("pamixer")
        .arg("-t")
        .output()
        .expect("Unable to increase volume");
    }
    "bookmark" => match add_bookmark(mpris_player.get_url().as_str(), mpris_player.get_position()) {
      Ok(x) => {
        let mut notification = Notification::new();
        notification
          .summary("Bookmark Added")
          .body(format!("{} : {}", x.0, hms(x.1)).as_str());
        notification.show().unwrap();
      }
      Err(_) => return,
    },
    command => {
      if mpd_player.is_active() && mpris_player.is_active() && mpris_player.is_playing() {
        mpris_player.execute_command(command, options)
      } else if mpd_player.is_active() && mpris_player.is_active() && mpd_player.is_playing() {
        mpd_player.execute_command(command, options)
      } else if mpd_player.is_active()
        && mpris_player.is_active()
        && !has_important_players(mpris_player.get_player_name())
      {
        mpd_player.execute_command(command, options)
      } else if mpd_player.is_active() && mpris_player.is_active() {
        mpris_player.execute_command(command, options)
      } else if mpris_player.is_active() {
        mpris_player.execute_command(command, options)
      } else if mpd_player.is_active() {
        mpd_player.execute_command(command, options)
      }
    }
  };
}
