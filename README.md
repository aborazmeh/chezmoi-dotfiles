```toml
# ~/.config/chezmoi/chezmoi.toml
[data]
  machine = "home" # or "work", "server" ...
  device = "laptop" # or "desktop"
  longitude =
  latitude =
  city =
  country =
  timezone = "America/New_York"
  fullname =
  email =
  wm = "wayland" # or "x11"
  password_manager = "bw" # = "bitwarden" / "vaultwarden" or "pass"
  network_interface = "enp3s0"
[data.env]
  path = ["~/.local/bin", "~/bin"]
[data.calcure]
  holiday_country =
[data.vdirsyncer]
  url =
  username =
  password =
[data.mpd]
  hostname =
  password =
  readonly_password =
```
