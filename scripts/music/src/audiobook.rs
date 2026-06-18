use crate::utils::get_filename_dirname;
use mime_guess::from_path;
use mp3_duration;
use std::collections::BTreeMap;
use std::collections::HashMap;
use std::env;
use std::fs::{self, File, OpenOptions};
use std::io::{self, BufRead, BufReader, Write};
use std::{path::Path, path::PathBuf, process, time::Duration, time::UNIX_EPOCH};

struct TotalPlaytime {
  file_path: PathBuf,
  entries: HashMap<String, f32>,
}

impl TotalPlaytime {
  fn new() -> io::Result<Self> {
    let file_path = Self::get_total_playtime_path();

    // Ensure the directory exists
    if let Some(parent) = file_path.parent() {
      fs::create_dir_all(parent)?;
    }

    // If the file doesn't exist, create it
    if !file_path.exists() {
      File::create(&file_path)?;
    }

    // Load file content into entries
    let mut entries = HashMap::new();
    let file = File::open(&file_path)?;
    let reader = BufReader::new(file);

    for line in reader.lines() {
      let line = line?;

      let parts: Vec<&str> = line.split('\t').collect();
      if parts.len() == 2 {
        let filename = parts[0].to_string();
        if let Ok(seconds) = parts[1].parse::<f32>() {
          entries.insert(filename, seconds);
        }
      }
    }

    Ok(Self { file_path, entries })
  }

  fn get_total_playtime_path() -> PathBuf {
    if cfg!(target_os = "windows") {
      let appdata = env::var("APPDATA").expect("Failed to get APPDATA path");
      PathBuf::from(appdata)
        .join("mpv")
        .join("total_playtime.list")
    } else {
      let home = env::var("HOME").expect("Failed to get HOME path");
      PathBuf::from(home)
        .join(".config")
        .join("mpv")
        .join("scripts")
        .join("total_playtime.list")
    }
  }

  fn find_or_add_entry(&mut self, input: &str, seconds: f32) -> io::Result<()> {
    // Check if the input is already in the entries
    if let Some(_seconds) = self.entries.get(input) {
      // println!("Found entry: {} -> {} seconds", input, seconds);
    } else {
      self.entries.insert(input.to_string(), seconds);
      self.save_to_file()?;
    }
    Ok(())
  }

fn save_to_file(&self) -> io::Result<()> {
    let sorted_entries: BTreeMap<_, _> = self.entries.iter().collect();
    let mut file = OpenOptions::new()
      .write(true)
      .truncate(true)
      .open(&self.file_path)?;
    for (filename, seconds) in sorted_entries {
      writeln!(file, "{}\t{}", filename, seconds)?;
    }
    Ok(())
  }

  fn get_duration(&self, input: &str) -> Option<f32> {
    let sorted_entries: BTreeMap<_, _> = self.entries.iter().collect();

    let mut found = false;
    let mut result: f32 = 0.0;

    for (filename, &seconds) in sorted_entries {
      if filename == input {
        found = true;
      }
      if found && are_in_same_directory(input, filename) {
        result += seconds;
      }
    }

    if found {
      Some(result)
    } else {
      None
    }
  }
}

fn are_in_same_directory(path1: &str, path2: &str) -> bool {
  let path1 = Path::new(path1);
  let path2 = Path::new(path2);

  let parent1 = path1.parent();
  let parent2 = path2.parent();

  match (parent1, parent2) {
      (Some(dir1), Some(dir2)) => dir1 == dir2,
      _ => false,
  }
}

fn is_media(path: &PathBuf) -> bool {
  let mime_type = from_path(path).first_or_octet_stream();
  let mime_type = mime_type.to_string();
  mime_type.contains("audio") || mime_type.contains("video")
}

fn get_directory_fingerprint(dir: &Path) -> Option<Vec<(String, u64)>> {
  let mut entries = Vec::new();
  for entry in fs::read_dir(dir).ok()? {
    let entry = entry.ok()?;
    let path = entry.path();
    if path.is_file() && is_media(&path) {
      let mtime = entry.metadata().ok()?.modified().ok()?.duration_since(UNIX_EPOCH).ok()?.as_secs();
      entries.push((path.file_name()?.to_string_lossy().to_string(), mtime));
    }
  }
  entries.sort_by(|a, b| a.0.cmp(&b.0));
  Some(entries)
}

fn read_cached_total_duration(dir: &Path) -> Option<i64> {
  let cache_path = dir.join(".total_duration.cache");
  let file = File::open(&cache_path).ok()?;
  let reader = BufReader::new(file);
  let mut lines = reader.lines();
  let stored_fingerprint: Vec<String> = serde_json::from_str(&lines.next()?.ok()?).ok()?;
  let stored_duration: i64 = lines.next()?.ok()?.parse().ok()?;

  let current_fingerprint = get_directory_fingerprint(dir)?;
  let mut current_fingerprint_str: Vec<String> = current_fingerprint.iter()
    .map(|(name, mtime)| format!("{}:{}", name, mtime))
    .collect();
  let mut stored_fp: Vec<String> = stored_fingerprint.iter()
      .cloned()
      .collect();
  current_fingerprint_str.sort();
  stored_fp.sort();
  
  if stored_fp == current_fingerprint_str {
    Some(stored_duration)
  } else {
    None
  }
}

fn write_cached_total_duration(dir: &Path, duration_micros: i64) {
  if let Some(fingerprint) = get_directory_fingerprint(dir) {
    let fingerprint_str: Vec<String> = fingerprint.iter()
      .map(|(name, mtime)| format!("{}:{}", name, mtime))
      .collect();
    let contents = format!("{}\n{}", serde_json::to_string(&fingerprint_str).unwrap(), duration_micros);
    let _ = fs::write(dir.join(".total_duration.cache"), contents);
  }
}

fn get_file_duration(path: &PathBuf) -> Result<Duration, ()> {
  let extension = match path.extension() {
    Some(x) => x.to_str().unwrap(),
    None => return Err(()),
  };

  match extension {
    "mp3" => match mp3_duration::from_path(&path) {
      Ok(x) => Ok(x),
      Err(_) => Err(()),
    },
    _ => {
      match process::Command::new("ffprobe")
        .args([
          "-v",
          "error",
          "-show_entries",
          "format=duration",
          "-of",
          "default=noprint_wrappers=1:nokey=1",
          path.to_str().unwrap(),
        ])
        .output()
      {
        Ok(output) => match String::from_utf8(output.stdout) {
          Ok(output) => match output.trim().split(".").next().unwrap_or("").parse::<u64>() {
            Ok(duration) => match duration > 0 {
              true => Ok(Duration::new(duration, 0)),
              false => Err(()),
            },
            Err(_) => return Err(()),
          },
          Err(_) => return Err(()),
        },
        Err(_) => return Err(()),
      }
    }
  }
}

pub fn get_audiobook_duration(url: &str) -> i64 {
  let (filename, dirname) = match get_filename_dirname(url) {
    Ok(x) => x,
    Err(_) => return -1,
  };

  if let Some(cached) = read_cached_total_duration(&dirname) {
    return cached;
  }

  let mut total_playtime = TotalPlaytime::new().expect("Failed to initialize TotalPlaytime");
  let full_path = Path::new(&dirname).join(&filename);

  for entry in fs::read_dir(&dirname).unwrap() {
    let path = entry.unwrap().path();
    if path.is_file() && is_media(&path) {
      if total_playtime
        .get_duration(path.to_str().unwrap())
        .is_none()
      {
        match get_file_duration(&path) {
          Ok(d) => {
            if let Err(e) =
              total_playtime.find_or_add_entry(path.to_str().unwrap(), d.as_secs() as f32)
            {
              eprintln!("Error: {}", e);
            }
          }
          Err(_) => continue,
        };
      }
    }
  }

  let total = match total_playtime.get_duration(full_path.to_str().unwrap())  {
    Some(x) => {
      x as i64 * 1_000_000
    },
    None => 0
  };
  write_cached_total_duration(&dirname, total);
  total
}
