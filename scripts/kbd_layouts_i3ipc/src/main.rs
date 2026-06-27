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
  let emoji = match json.get(&layout[..2].to_lowercase()) {
    Some(x) => match x.get("emoji") {
      Some(x) => x,
      None => {
        println!("{}", layout);
        return;
      }
    },
    None => {
      println!("{}", layout);
      return;
    }
  }
  .as_str()
  .expect(&layout);

  println!(
    "{}",
    serde_json::json! ({
      "text": emoji,
      "tooltip": layout,
    })
  );
}
