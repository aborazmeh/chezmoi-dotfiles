Create template file (running `chezmoi data` shows all available variables)

```toml
# ~/.config/chezmoi/chezmoi.toml
[data]
  machine = "home" # or "work", "server" ...
  device = "laptop" # or "desktop"
  longitude =
  latitude =
  city =
  country =
  accuweather_url = "https://www.accuweather.com/en/us/new-york/10021/weather-forecast/349727"
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
[data.qbittorrent]
  hostname =
  username =
  password =
[data.ledger]
  dir =
```

Then run

```shell
chezmoi init --apply https://github.com/aborazmeh/chezmoi-dotfiles.git
```

or

```shell
sh -c "$(curl -fsLS https://get.chezmoi.io)" -- init --apply aborazmeh/chezmoi-dotfiles
```

Run `bookstrap.sh` script

---

- `chezmoi update` to update across machines
- `chezmoi add ~/.bashrc` to track a file, which copies it to `~/.local/share/chezmoi/dot_bashrc`.
- Edit via `chezmoi edit ~/.bashrc` (opens the source file in `$EDITOR`)
- Preview changes with `chezmoi diff`, then apply with `chezmoi apply` or `chezmoi -v apply` for verbose output.
- Navigate to source dir: `chezmoi cd`.
- Commit and push: `git add .`, `git commit -m "Changes"`, `git push`.
