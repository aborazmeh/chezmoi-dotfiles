use serde::{Deserialize, Serialize};
use serde_xml_rs::from_str;
use std::{
  fs::{self, File},
  io::Write,
};

use crate::utils::get_filename_dirname;

#[derive(Debug, Serialize, Deserialize, PartialEq)]
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

  let src = match fs::read_to_string(dirname.join("bookmarks.sabp.xml")) {
    Ok(x) => x,
    Err(_) => return vec![],
  };

  let root: Root = from_str(src.as_str()).unwrap();

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

  match file.write_all(text.as_bytes()) {
    Ok(_) => Ok((filename.to_string_lossy().to_string(), position)),
    Err(_) => Err(BookmarkError::Error),
  }
}
