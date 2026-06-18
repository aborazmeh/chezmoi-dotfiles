use crate::bookmarks::get_bookmarks;
use std::collections::HashMap;
use std::fmt;
use std::path::{Path, PathBuf};
use urlencoding::decode;

#[derive(Copy, Clone, Debug)]
pub enum MetadataType<'a> {
  String(&'a str),
  Microseconds(i64),
}

impl fmt::Display for MetadataType<'_> {
  fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
    match self {
      MetadataType::String(x) => write!(f, "{x}"),
      _ => todo!(),
    }
  }
}

impl MetadataType<'_> {
  fn to_i64(&self) -> i64 {
    match self {
      MetadataType::Microseconds(x) => *x,
      _ => unreachable!(),
    }
  }
}

struct Metadata {
  url: String,
  track_type: String,
  status: String,
  icon: String,
  title: String,
  authors: String,
  album: String,
  year: String,
  length: String,
  position: String,
}

impl Metadata {
  fn new(metadata: HashMap<&str, MetadataType>) -> Self {
    let url = match metadata.get("url") {
      Some(url) => url.to_string(),
      None => String::from(""),
    };

    let track_type = metadata.get("type").unwrap().to_string();
    let status = metadata.get("status").unwrap().to_string();
    let icon = String::from(get_status_icon(
      status.clone(),
      track_type.clone(),
      url.clone(),
    ));
    let length = hms(metadata.get("length").unwrap().to_i64());

    let position = metadata.get("position").unwrap().to_i64();

    let position = match track_type.as_str() {
      "audiobook" => hms(metadata.get("remaining").unwrap().to_i64()),
      _ => format!("{}/{}", hms(position), length),
    };

    Self {
      url,
      track_type,
      status,
      icon,
      title: metadata.get("title").unwrap().to_string(),
      authors: metadata.get("authors").unwrap().to_string(),
      album: metadata.get("album").unwrap().to_string(),
      year: metadata.get("year").unwrap().to_string(),
      length,
      position,
    }
  }
}

pub fn hms(microseconds: i64) -> String {
  match microseconds {
    -1 => "∞".to_string(),
    _ => format!(
      "{:0>2}:{:0>2}:{:0>2}",
      ((microseconds / 1000000) / 60) / 60,
      ((microseconds / 1000000) / 60) % 60,
      (microseconds / 1000000) % 60
    ),
  }
}

fn truncate(s: &str, len: usize) -> &str {
  match s.char_indices().nth(len) {
    None => s,
    Some((idx, _)) => &s[..idx],
  }
}

#[derive(Debug)]
pub enum PathError {
  EmptyUrl,
  CantDecodeUrl,
  CantFindParent,
  PathDoesNotExist,
}

pub fn get_filename_dirname<'a>(url: &'a str) -> Result<(PathBuf, PathBuf), PathError> {
  if url.len() <= 7 {
    return Err(PathError::EmptyUrl);
  }

  let path = match decode(&url[7..]) {
    Ok(x) => x.to_string(),
    Err(_) => return Err(PathError::CantDecodeUrl),
  };

  let path = Path::new(path.as_str());

  let dirname = match path.parent() {
    Some(x) => x,
    None => return Err(PathError::CantFindParent),
  };

  if !dirname.exists() {
    return Err(PathError::PathDoesNotExist);
  }

  let filename = path.file_name().unwrap_or_default();

  let mut file_path = PathBuf::new();
  file_path.push(filename);

  let mut dir_path = PathBuf::new();
  dir_path.push(dirname);

  Ok((file_path, dir_path))
}

fn get_status_icon(status: String, track_type: String, url: String) -> &'static str {
  match track_type.as_str() {
    "audiobook" => match get_bookmarks(&url).len() > 0 {
      true => " ",
      false => "",
    },
    "podcast" => "",
    _ => match status.as_str() {
      //   # if [[ $PLAYER == playerctl && $(playerctl --player="$(playerctl_players)" -l | head -n1) =~ "mps-youtube" ]]; then
      //     # status=
      //   # else
      "playing" => "",
      "paused" => "",
      "stopped" => "",
      _ => "",
    },
  }
}

pub fn output(frontend: &str, metadata: HashMap<&str, MetadataType>) {
  let metadata = Metadata::new(metadata);

  match frontend {
    "i3blocks" => {
      println!(
        "{} {} ({})",
        metadata.icon, metadata.title, metadata.position
      );
      println!(
        "{} {} ({})",
        metadata.icon, metadata.title, metadata.position
      );
    }

    "polybar" => {
      // #   # FIXME
      // #   # echo "%{A1:~/scripts/bar/music toggle:}%{A4:~/scripts/bar/music seek+:}%{A5:~/scripts/bar/music seek-:}$text%{A}%{A}%{A}"
      println!(
        "%{{A1:~/scripts/bar/music toggle:}} {} {} %{{A}}",
        metadata.icon, metadata.title
      )
      // # elif [[ $FRONTEND == "polybar" && $PLAYER == mpd ]]; then
      // #   text=$($MPC -f "%track% %title%" | head -n1)
      // #   if [[ $status ==  ]]; then
      // #     status=
      // #   elif [[ $status ==  ]]; then
      // #     status=
      // #   fi
      // #   echo "%{A1:~/scripts/bar/music prev:}%{A} %{A1:~/scripts/bar/music seek-:}%{A} %{A1:~/scripts/bar/music toggle:}$status%{A} %{A1:~/scripts/bar/music seek+:}%{A} %{A1:~/scripts/bar/music next:}%{A} ($position) $text"
      // # fi
    }
    "sway" => {
      println!(
        "{}",
        serde_json::json!({
          "text": format!("{} {} ({})", metadata.icon, truncate(&metadata.title, 30), metadata.position),
          "tooltip": format_tooltip(frontend, &metadata),
          "class": metadata.status
        })
      )
    }
    _ => unreachable!(),
  }
}

fn format_tooltip(frontend: &str, metadata: &Metadata) -> String {
  let format = |frontend: &str, text: &String, color: &str| -> String {
    if frontend == "i3blocks" || frontend == "sway" {
      format!(
        "<span foreground=\"#{}\">{}</span>",
        color,
        html_escape::encode_text(text.as_str())
      )
    } else if frontend == "polybar" {
      format!(
        "%{{F#{}}}{}%{{F-}}",
        color,
        html_escape::encode_text(text.as_str())
      )
    } else {
      String::from(text)
    }
  };

  let mut text: String;

  // let track_id = self.get_metadata("xesam:trackId");
  // let total_tracks = self.get_metadata("xesam:totalTracks");

  if metadata.authors.len() == 0
    && metadata.title.len() == 0
    && metadata.album.len() == 0
    && metadata.year.len() == 0
    && metadata.url.len() > 0
  {
    text = format(frontend, &metadata.url, "E54C62");
  } else {
    text = format(frontend, &metadata.title, "E54C62");
    if metadata.authors.len() > 0 {
      text.push_str(", ");
      text.push_str(format(frontend, &metadata.authors, "C0C000").as_str());
    }
    //   if trackId and totalTracks and data.get("type") == "audiobook":
    //     text += f" ({trackId}/{totalTracks})"
    if metadata.album.len() > 0 {
      text.push_str(" ");
      text.push_str(format(frontend, &metadata.album, "00E0E0").as_str());
    }
    if metadata.year.len() > 0 {
      text.push_str(" ");
      text.push_str(format(frontend, &metadata.year, "C0C0C0").as_str());
    }

    if metadata.track_type == "audiobook" {
      text.push_str(format!(" | ({}) / {}", metadata.position, metadata.length).as_str());
    }

    let bookmarks = get_bookmarks(&metadata.url);
    if bookmarks.len() > 0 {
      let format_time = |seconds: u32| -> String {
        if seconds / 3600 > 0 {
          format!("{:02}:{:02}:{:02}", seconds / 3600, (seconds / 60) % 60, seconds % 60)
        } else {
          format!("{:02}:{:02}", (seconds / 60) % 60, seconds % 60)
        }
      };

      text.push_str("\n\nBookmarks:");

      for b in bookmarks {
        text.push_str(format!("\n{}: {}", b.file_name, format_time(b.file_position)).as_str())
      }
    }
  }

  text
}
