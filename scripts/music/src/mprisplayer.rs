use crate::{
  audiobook::get_audiobook_duration,
  utils::{output, MetadataType},
};
use mpris::{Metadata, Player, PlayerFinder};
use std::collections::HashMap;

pub struct MprisPlayer {
  player: Option<Player>,
}

// def getData(player):
//   data = {}
//   data["status"] = player.get_player_property("PlaybackStatus")

//   if data["status"] == "Playing" or data["status"] == "Paused":
//     meta = player.get_player_property("Metadata")
//     try:
//       pos = player.get_player_property("Position")
//     except dbus.exceptions.DBusException as ex:
//       if ex.get_dbus_name() \
//         == "org.freedesktop.DBus.Error.NotSupported":
//         # player doesn"t suport position request
//         pos = None
//       else:
//         print("Error while retrieving playback position!",
//               file=sys.stderr)
//         raise

//     speed = float(player.player_properties().get("Rate")) or 1

//     url = meta.get("xesam:url") or ""
//     title = meta.get("xesam:title") or meta.get("xesam:url") or "[No Title]"
//     album = meta.get("xesam:album")
//     genre = meta.get("xesam:genre") or ""
//     year = meta.get("xesam:contentCreated")[:4] if meta.get("xesam:contentCreated") else None

//     # length might not be defined, e.g. in case of a live stream
//     mprisLength = meta.get("mpris:length")
//     length = hms(mprisLength) if mprisLength else "???"
//     position = hms(pos) if pos and mprisLength else "???"

//     if type == "audiobook":
//       attributes = getAttributes(dirname, filename)
//       try:
//         remaining = hms(((attributes.get("duration") * 1000000) - pos) / speed)
//       except:
//         remaining = hms((mprisLength - pos) / speed) if pos and length else "???"
//       try:
//         trackId = attributes["filesList"][os.path.join(dirname, filename)]["trackId"]
//       except:
//         trackId = 1
//       totalTracks = len(attributes["filesList"])
//     else:
//       remaining = hms((mprisLength - pos) / speed) if pos and length else "???"
//       trackId = 1
//       totalTracks = 1

//     data.update({
//       "player": player.name,
//       "url": url,
//       "filename": filename,
//       "dirname": dirname,
//       "title": title,
//       "artist": artist,
//       "trackId": trackId,
//       "totalTracks": totalTracks,
//       "album": album,
//       "year": year,
//       "pos": pos,
//       "position": position,
//       "length": length,
//       "remaining": remaining,
//       "type": type,
//       "bookmarks": type == "audiobook" and getBookmarks(dirname)
//     })

//   return data

impl MprisPlayer {
  pub fn new() -> Self {
    let player = match PlayerFinder::new() {
      Ok(finder) => match finder.find_active() {
        Ok(player) => Some(player),
        Err(_) => None,
      },
      Err(_) => None,
    };

    Self { player }
  }

  pub fn get_player_name(&self) -> &str {
    match &self.player {
      Some(p) => p.bus_name(),
      None => "",
    }
  }

  fn get_speed(&self) -> f64 {
    match &self.player {
      Some(p) => match p.get_playback_rate() {
        Ok(x) => x,
        Err(_) => 1.0,
      },
      None => 1.0,
    }
  }

  pub fn get_url(&self) -> String {
    self.get_str_metadata("xesam:url")
  }

  pub fn get_position(&self) -> i64 {
    match &self.player {
      Some(p) => match p.get_position() {
        Ok(x) => x.as_micros() as i64,
        Err(_) => -1,
      },
      None => -1,
    }
  }

  fn get_metadata(&self) -> Option<Metadata> {
    match &self.player {
      Some(player) => match player.get_metadata() {
        Ok(meta) => Some(meta),
        Err(_) => None,
      },
      None => None,
    }
  }

  fn get_str_metadata(&self, m: &str) -> String {
    match self.get_metadata() {
      Some(meta) => match meta.get(m) {
        Some(data) => match data.as_str() {
          Some(v) => String::from(v),
          None => String::from(""),
        },
        None => String::from(""),
      },
      None => String::from(""),
    }
  }

  fn get_authors(&self) -> String {
    match self.get_metadata() {
      Some(meta) => match meta.artists() {
        Some(artists) => artists.join(" & "),
        None => String::from("Unknwon"),
      },
      None => String::from("Unknwon"),
    }
  }

  fn get_type(&self) -> &str {
    let url = self.get_str_metadata("xesam:url");
    let genre = self.get_str_metadata("xesam:genre");

    if url.to_lowercase().contains("audiobook") || genre.to_lowercase().contains("audiobook") {
      "audiobook"
    } else if url.to_lowercase().contains("podcast") || genre.to_lowercase().contains("podcast") {
      "podcast"
    } else {
      "unknown"
    }
  }

  pub fn is_active(&self) -> bool {
    match self.get_str_metadata("mpris:trackid").as_str() {
      "/org/mpris/MediaPlayer2/TrackList/NoTrack" => false,
      "" => false,
      _ => true,
    }
  }

  pub fn is_playing(&self) -> bool {
    match self.get_status() {
      "playing" => true,
      _ => false,
    }
  }

  fn get_status(&self) -> &str {
    match &self.player {
      Some(player) => match player.get_playback_status() {
        Ok(mpris::PlaybackStatus::Playing) => "playing",
        Ok(mpris::PlaybackStatus::Paused) => "paused",
        Ok(mpris::PlaybackStatus::Stopped) => "stopped",
        Err(_) => "",
      },
      None => "",
    }
  }

  fn get_remaining(&self) -> i64 {
    let duration = get_audiobook_duration(self.get_str_metadata("xesam:url").as_str());
    let position = self.get_position();
    let speed = self.get_speed();

    // FIXME position is only on the same file, needs to exclude other files, too
    (((duration - position) as f64) / speed) as i64
  }

  fn print(&self, frontend: &str) {
    let length = match self.get_metadata() {
      Some(meta) => match meta.get("mpris:length") {
        Some(x) => x.as_i64().unwrap(),
        None => -1,
      },
      None => -1,
    };

    let authors = self.get_authors();

    let url = self.get_str_metadata("xesam:url");
    let title = self.get_str_metadata("xesam:title");
    let album = self.get_str_metadata("xesam:album");
    let year = self.get_str_metadata("xesam:contentCreated");

    let metadata: HashMap<&str, MetadataType> = HashMap::from([
      ("status", MetadataType::String(self.get_status())),
      ("url", MetadataType::String(url.as_str())),
      ("title", MetadataType::String(title.as_str())),
      ("authors", MetadataType::String(authors.as_str())),
      ("album", MetadataType::String(album.as_str())),
      ("year", MetadataType::String(year.as_str())),
      ("type", MetadataType::String(self.get_type())),
      ("position", MetadataType::Microseconds(self.get_position())),
      ("length", MetadataType::Microseconds(length)),
      (
        "remaining",
        MetadataType::Microseconds(self.get_remaining()),
      ),
    ]);

    output(frontend, metadata);
  }

  pub fn execute_command(&self, cmd: &str, payload: HashMap<&str, &str>) {
    let player = match &self.player {
      Some(p) => p,
      None => return,
    };

    match cmd {
      "toggle" => player.play_pause().unwrap(),
      "status" => self.print(payload.get("frontend").unwrap()),
      "stop" => player.stop().unwrap(),
      "next" => player.next().unwrap(),
      "prev" => player.previous().unwrap(),
      "seek+" => player
        .seek(((10.0 * self.get_speed()) * 1000000.0) as i64)
        .unwrap(),
      "seek-" => player
        .seek(((-10.0 * self.get_speed()) * 1000000.0) as i64)
        .unwrap(),
      _ => unreachable!(),
    }
  }
}
