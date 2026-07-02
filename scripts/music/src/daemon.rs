use std::fs::OpenOptions;
use std::io::Write;
use std::thread;
use std::time::Duration;

use crate::mpdplayer::MpdPlayer;
use crate::mprisplayer::MprisPlayer;

const FILE_PATH: &str = "/tmp/music-fifo";
const NOT_SO_IMPORTANT: [&str; 2] = ["kdeconnect", "chromium"];

fn has_important_players(player_name: &str) -> bool {
  !NOT_SO_IMPORTANT.iter().any(|&p| player_name.contains(p))
}

fn get_active_player_status_json(mpris: &MprisPlayer, mpd: &mut MpdPlayer) -> String {
  if mpd.is_active() && mpris.is_active() && mpris.is_playing() {
    mpris.status_json()
  } else if mpd.is_active() && mpris.is_active() && mpd.is_playing() {
    mpd.status_json()
  } else if mpd.is_active() && mpris.is_active() && !has_important_players(mpris.get_player_name())
  {
    mpd.status_json()
  } else if mpd.is_active() && mpris.is_active() {
    mpris.status_json()
  } else if mpris.is_active() {
    mpris.status_json()
  } else if mpd.is_active() {
    mpd.status_json()
  } else {
    String::new()
  }
}

pub fn run_daemon_mode() {
  let mut last_state = String::new();
  let mut ticks_since_resend = 0u32;
  let mut ticks_since_signal = 4u32;
  let mut mpd_refresh = 0u32;
  let mut mpd_player = MpdPlayer::new();
  loop {
    let mpris_player = MprisPlayer::new();

    if mpd_refresh >= 60 {
      mpd_player = MpdPlayer::new();
      mpd_refresh = 0;
    }
    mpd_refresh += 1;

    let current_state = get_active_player_status_json(&mpris_player, &mut mpd_player);
    if current_state != last_state {
      if current_state.is_empty() {
        if let Ok(mut f) = OpenOptions::new()
          .write(true)
          .create(true)
          .truncate(true)
          .open(FILE_PATH)
        {
          let _ = f.write_all(b"{\"text\": \"\", \"class\": \"stopped\"}\n");
        }
      } else {
        if let Ok(mut f) = OpenOptions::new()
          .write(true)
          .create(true)
          .truncate(true)
          .open(FILE_PATH)
        {
          let _ = f.write_all(current_state.as_bytes());
          let _ = f.write_all(b"\n");
        }
      }
      if ticks_since_signal >= 4 {
        let _ = std::process::Command::new("pkill")
          .arg("-RTMIN+15")
          .arg("waybar")
          .output();
        ticks_since_signal = 0;
      }
      last_state = current_state;
      ticks_since_resend = 0;
    } else if !current_state.is_empty() && ticks_since_resend >= 10 {
      if let Ok(mut f) = OpenOptions::new()
        .write(true)
        .create(true)
        .truncate(true)
        .open(FILE_PATH)
      {
        let _ = f.write_all(current_state.as_bytes());
        let _ = f.write_all(b"\n");
      }
      ticks_since_resend = 0;
    } else {
      ticks_since_resend += 1;
    }
    ticks_since_signal += 1;
    thread::sleep(Duration::from_millis(500));
  }
}
