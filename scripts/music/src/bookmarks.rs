use serde::{Deserialize, Serialize};
use serde_xml_rs::from_str;
use std::{
  fs::{self, File},
  io::Write,
};

use crate::utils::get_filename_dirname;

#[derive(Debug, Serialize, Deserialize, PartialEq, Clone)]
pub struct Bookmark {
  title: String,
  description: String,
  #[serde(rename = "fileName")]
  pub file_name: String,
  #[serde(rename = "filePosition")]
  pub file_position: u32,
}

#[derive(Debug, Serialize, Deserialize, PartialEq)]
struct Root {
  bookmark: Vec<Bookmark>,
}

pub fn get_bookmarks(url: &str) -> Vec<Bookmark> {
  let dirname = match get_filename_dirname(url) {
    Ok(x) => x.1,
    Err(_) => return vec![],
  };

  let cache_path = dirname.join(".bookmarks.cache");
  let xml_path = dirname.join("bookmarks.sabp.xml");

  if let Ok(cached) = fs::read_to_string(&cache_path) {
    let mut lines = cached.lines();
    if let Some(cached_mtime) = lines.next() {
      if let Ok(cached_mtime) = cached_mtime.parse::<u128>() {
        if let Ok(xml_meta) = fs::metadata(&xml_path) {
          if let Ok(xml_mtime) = xml_meta.modified() {
            let current_mtime = xml_mtime.duration_since(std::time::UNIX_EPOCH).ok()
              .map(|d| d.as_micros()).unwrap_or(0);
            if cached_mtime == current_mtime {
              let json: String = lines.collect();
              if let Ok(bookmarks) = serde_json::from_str(&json) {
                return bookmarks;
              }
            }
          }
        }
      }
    }
  }

  let src = match fs::read_to_string(&xml_path) {
    Ok(x) => x,
    Err(_) => return vec![],
  };

  let root: Root = match from_str(src.as_str()) {
    Ok(x) => x,
    Err(_) => return vec![],
  };

  if let Ok(xml_meta) = fs::metadata(&xml_path) {
    if let Ok(mtime) = xml_meta.modified() {
      let cached_mtime = mtime.duration_since(std::time::UNIX_EPOCH).unwrap().as_micros();
      let cached_json = serde_json::to_string(&root.bookmark).unwrap();
      let _ = fs::write(&cache_path, format!("{}\n{}", cached_mtime, cached_json));
    }
  }

  root.bookmark
}

pub enum BookmarkError {
  Error,
}

pub fn add_bookmark(url: &str, position: i64) -> Result<(String, i64), BookmarkError> {
  let (filename, dirname) = match get_filename_dirname(url) {
    Ok(x) => x,
    Err(_) => return Err(BookmarkError::Error),
  };

  let mut bookmarks = get_bookmarks(url);

  bookmarks.push(Bookmark {
    title: "".to_string(),
    description: "".to_string(),
    file_name: filename.to_string_lossy().to_string(),
    file_position: (position / 1_000_000) as u32,
  });

  let mut text = String::from("<?xml version=\"1.0\" encoding=\"UTF-8\"?><root>\n");

  for b in &bookmarks {
    text.push_str(
      format!(
        r##"    <bookmark>
        <title/>
        <description/>
        <fileName>{}</fileName>
        <filePosition>{}</filePosition>
    </bookmark>
"##,
        b.file_name, b.file_position
      )
      .as_str(),
    );
  }

  text.push_str("</root>");

  let mut file = match File::create(dirname.join("bookmarks.sabp.xml")) {
    Ok(x) => x,
    Err(_) => return Err(BookmarkError::Error),
  };

  let _ = fs::remove_file(dirname.join(".bookmarks.cache"));

  match file.write_all(text.as_bytes()) {
    Ok(_) => Ok((filename.to_string_lossy().to_string(), position)),
    Err(_) => Err(BookmarkError::Error),
  }
}
