use dirs::home_dir;
use serde_json;
use std::fs;
use swayipc::{Connection, Event, EventType, Fallible};

fn main() -> Fallible<()> {
  let home = home_dir().expect("Couldn't get home directory");
  let json: serde_json::Value = serde_json::from_str(
    &fs::read_to_string(home.join("scripts").join("languages.json")).expect("Unable to read file"),
  )
  .expect("JSON was not well-formatted");

  let mut conn = Connection::new()?;
  let first_kbd = conn
    .get_inputs()?
    .into_iter()
    .find(|d| d.input_type == "keyboard");
  if let Some(ref kbd) = first_kbd {
    if let Some(ref layout) = kbd.xkb_active_layout_name {
      print_output(layout.clone(), &json);
    }
  }

  let mut last_layout = String::new();
  for event in conn.subscribe([EventType::Input])? {
    match event? {
      Event::Input(ev) => {
        if ev.input.input_type == "keyboard" {
          let layout = ev.input.xkb_active_layout_name.unwrap_or_default();
          if layout != last_layout && !layout.is_empty() {
            print_output(layout.clone(), &json);
            last_layout = layout;
          }
        }
      }
      _ => unreachable!(),
    }
  }
  Ok(())
}

fn print_output(layout: String, json: &serde_json::Value) {
  let json_obj = json.as_object().expect("JSON must be an object");
  let entry = json_obj.values().find(|v| {
    v.get("name")
      .and_then(|n| n.as_str())
      .map_or(false, |name| layout.starts_with(name))
  });
  let emoji = match entry.and_then(|e| e.get("emoji")).and_then(|e| e.as_str()) {
    Some(e) => e.to_owned(),
    None => {
      println!("{}", layout);
      return;
    }
  };

  println!(
    "{}",
    serde_json::json! ({
      "text": emoji,
      "tooltip": layout,
    })
  );
}
