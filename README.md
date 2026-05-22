# dotfiles

Modify the file `~/.config/chezmoi/chezmoi.toml` which will be created
automatically.

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
