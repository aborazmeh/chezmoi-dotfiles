#!/usr/bin/env bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

info() { echo -e "${CYAN}${BOLD}[INFO]${RESET}  $*"; }
success() { echo -e "${GREEN}${BOLD}[OK]${RESET}    $*"; }
warn() { echo -e "${YELLOW}${BOLD}[WARN]${RESET}  $*"; }
error() { echo -e "${RED}${BOLD}[ERROR]${RESET} $*" >&2; }
section() { echo -e "\n${BOLD}━━━  $*  ━━━${RESET}"; }

require() {
  command -v "$1" &>/dev/null || {
    error "Required tool not found: $1"
    exit 1
  }
}

clone_or_update() {
  local repo="$1" dest="$2"
  if [[ -d "$dest/.git" ]]; then
    info "Updating $(basename "$dest") …"
    git -C "$dest" pull --ff-only
  else
    info "Cloning $repo → $dest …"
    git clone --depth=1 "$repo" "$dest"
  fi
}

install_fonts() {
  section "Fonts (FiraCode, Amiri, Nerd Fonts Symbols)"

  local font_dir="$HOME/.local/share/fonts"
  mkdir -p "$font_dir"

  # ── FiraCode ──────────────────────────────────────────────────────────────
  if fc-list | grep -qi "fira code"; then
    info "FiraCode already installed, skipping."
  else
    info "Downloading FiraCode …"
    local fira_ver="6.2"
    local fira_url="https://github.com/tonsky/FiraCode/releases/download/${fira_ver}/Fira_Code_v${fira_ver}.zip"
    local fira_zip
    fira_zip=$(mktemp --suffix=.zip)
    curl -fsSL "$fira_url" -o "$fira_zip"
    unzip -qo "$fira_zip" "ttf/*.ttf" -d "$font_dir/FiraCode" 2>/dev/null ||
      unzip -qo "$fira_zip" -d "$font_dir/FiraCode"
    rm -f "$fira_zip"
    success "FiraCode installed."
  fi

  # ── Amiri ─────────────────────────────────────────────────────────────────
  if fc-list | grep -qi "amiri"; then
    info "Amiri already installed, skipping."
  else
    info "Downloading Amiri …"
    local amiri_ver="1.000"
    local amiri_url="https://github.com/aliftype/amiri/releases/download/${amiri_ver}/Amiri-${amiri_ver}.zip"
    local amiri_zip
    amiri_zip=$(mktemp --suffix=.zip)
    curl -fsSL "$amiri_url" -o "$amiri_zip"
    unzip -qo "$amiri_zip" "*.ttf" -d "$font_dir/Amiri" 2>/dev/null ||
      unzip -qo "$amiri_zip" -d "$font_dir/Amiri"
    rm -f "$amiri_zip"
    success "Amiri installed."
  fi

  # ── Nerd Fonts Symbols Only ───────────────────────────────────────────────
  if fc-list | grep -qi "symbols nerd"; then
    info "Nerd Fonts Symbols already installed, skipping."
  else
    info "Downloading Nerd Fonts Symbols Only …"
    local nf_ver
    nf_ver=$(curl -fsSL "https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest" |
      grep '"tag_name"' | head -1 | cut -d'"' -f4)
    local nf_url="https://github.com/ryanoasis/nerd-fonts/releases/download/${nf_ver}/NerdFontsSymbolsOnly.tar.xz"
    local nf_tar
    nf_tar=$(mktemp --suffix=.tar.xz)
    curl -fsSL "$nf_url" -o "$nf_tar"
    mkdir -p "$font_dir/NerdFontsSymbolsOnly"
    tar -xf "$nf_tar" -C "$font_dir/NerdFontsSymbolsOnly"
    rm -f "$nf_tar"
    success "Nerd Fonts Symbols Only installed."
  fi

  # ── Refresh font cache ────────────────────────────────────────────────────
  info "Refreshing font cache …"
  fc-cache -f "$font_dir"
  success "Font cache updated."
}

setup_tmux() {
  section "tmux config (gpakosz/.tmux)"

  local dest="$HOME/.tmux"
  clone_or_update "https://github.com/gpakosz/.tmux.git" "$dest"

  # Symlink .tmux.conf if not already managed by dotfiles
  if [[ ! -f "$HOME/.tmux.conf" ]]; then
    ln -sf "$dest/.tmux.conf" "$HOME/.tmux.conf"
    success "Symlinked .tmux.conf"
  else
    info ".tmux.conf already exists — skipping symlink."
  fi

  # Copy the local override only if missing
  if [[ ! -f "$HOME/.tmux.conf.local" ]]; then
    cp "$dest/.tmux.conf.local" "$HOME/.tmux.conf.local"
    success "Copied .tmux.conf.local for local overrides."
  fi
}

setup_ranger_plugins() {
  section "Ranger plugins"

  local ranger_plugins="$HOME/.config/ranger/plugins"
  mkdir -p "$ranger_plugins"

  # TODO: add plugin repos here, for example:
  # clone_or_update "https://github.com/example/ranger-plugin.git" \
  #                 "$ranger_plugins/plugin-name"

  warn "Ranger plugin setup."
}

setup_mpv_plugins() {
  section "mpv plugins"

  local mpv_scripts="$HOME/.config/mpv/scripts"
  mkdir -p "$mpv_scripts"

  # TODO: add plugin repos here, for example:
  # clone_or_update "https://github.com/example/mpv-plugin.git" \
  #                 "$mpv_scripts/plugin-name"

  warn "mpv plugin setup."
}

setup_nnn_plugins() {
  section "nnn plugins"

  if [[ -d "${XDG_CONFIG_HOME:-$HOME/.config}/nnn/plugins" ]]; then
    info "nnn plugins directory already exists — re-running getplugs to update …"
  fi

  curl -fsSLo /tmp/getplugs \
    "https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs"
  chmod +x /tmp/getplugs
  sh /tmp/getplugs
  rm -f /tmp/getplugs
  success "nnn plugins installed to ${XDG_CONFIG_HOME:-$HOME/.config}/nnn/plugins"
}

setup_zinit() {
  section "zinit (zsh plugin manager)"

  local zinit_dir="${ZINIT_HOME:-${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git}"

  if [[ -d "$zinit_dir" ]]; then
    info "zinit already installed at $zinit_dir"
  else
    info "Installing zinit …"
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
    success "zinit installed."
  fi
}

declare -A PKG_ARCH=(
  [rg]="ripgrep"
  [fd]="fd"
  [delta]="git-delta"
  [btm]="bottom"
  [swaync]="swaync"
)

declare -A PKG_DEBIAN=(
  [rg]="ripgrep"
  [fd]="fd-find"
  [delta]="git-delta"
  [btm]="bottom"
  [btop]="btop"
  [swaync]="swaync"
  [rofi]="rofi"
  [lazygit]="lazygit"
  [gitui]="gitui"
  [tmuxp]="tmuxp"
  [yazi]="yazi"
  [starship]="starship"
)

declare -A PKG_FEDORA=(
  [rg]="ripgrep"
  [fd]="fd-find"
  [delta]="git-delta"
  [btm]="bottom"
  [swaync]="swaync"
)

PACKAGES=(
  starship
  yazi
  sway
  swaync
  waybar
  rofi
  lazygit
  gitui
  tmuxp
  tmux
  vim
  neovim
  micro
  rg
  fd
  delta
  btm
  btop
  nnn
)

resolve_pkg() {
  local generic="$1" distro="$2"
  case "$distro" in
  arch) echo "${PKG_ARCH[$generic]:-$generic}" ;;
  debian) echo "${PKG_DEBIAN[$generic]:-$generic}" ;;
  fedora) echo "${PKG_FEDORA[$generic]:-$generic}" ;;
  *) echo "$generic" ;;
  esac
}

detect_distro() {
  if [[ -f /etc/os-release ]]; then
    # shellcheck disable=SC1091
    source /etc/os-release
    case "${ID:-}" in
    arch | manjaro | endeavouros | garuda) echo "arch" ;;
    ubuntu | debian | linuxmint | pop) echo "debian" ;;
    fedora | rhel | centos | almalinux) echo "fedora" ;;
    *)
      case "${ID_LIKE:-}" in
      *arch*) echo "arch" ;;
      *debian*) echo "debian" ;;
      *fedora*) echo "fedora" ;;
      *) echo "unknown" ;;
      esac
      ;;
    esac
  else
    echo "unknown"
  fi
}

detect_aur_helper() {
  for h in yay paru aurman; do
    command -v "$h" &>/dev/null && {
      echo "$h"
      return
    }
  done
  echo "pacman" # fallback (AUR packages will fail gracefully)
}

install_packages() {
  section "Package installation"

  local distro
  distro=$(detect_distro)
  info "Detected distro family: ${distro}"

  local resolved=()
  for pkg in "${PACKAGES[@]}"; do
    resolved+=("$(resolve_pkg "$pkg" "$distro")")
  done

  case "$distro" in
  arch)
    local aur
    aur=$(detect_aur_helper)
    info "Using AUR helper: $aur"

    if [[ "$aur" == "pacman" ]]; then
      sudo pacman -Syu --needed --noconfirm "${resolved[@]}"
    else
      "$aur" -Syu --needed --noconfirm "${resolved[@]}"
    fi
    ;;

  debian)
    sudo apt-get update -qq
    # Attempt bulk install; warn on individual failures
    local failed=()
    for pkg in "${resolved[@]}"; do
      if ! sudo apt-get install -y --no-install-recommends "$pkg" &>/dev/null; then
        warn "apt could not install '$pkg' — may need a PPA or manual install."
        failed+=("$pkg")
      fi
    done
    if ((${#failed[@]} > 0)); then
      warn "Packages that need manual attention: ${failed[*]}"
    fi

    # starship: official installer is more reliable on Debian
    if ! command -v starship &>/dev/null; then
      info "Installing starship via official script …"
      curl -fsSL https://starship.rs/install.sh | sh -s -- --yes
    fi
    ;;

  fedora)
    sudo dnf install -y "${resolved[@]}"
    ;;

  *)
    error "Unsupported distro. Please install packages manually:"
    printf '  %s\n' "${resolved[@]}"
    return 1
    ;;
  esac

  success "Package installation complete."
}

run_scripts_makefile() {
  section "Scripts Makefile"

  local scripts_dir="$HOME/scripts"
  local bar_dir="$scripts_dir/bar"
  local makefile="$scripts_dir/Makefile"

  if [[ ! -f "$makefile" ]]; then
    info "No Makefile found at $makefile, skipping."
    return 0
  fi

  if [[ -d "$bar_dir" ]]; then
    if [[ -z "$(ls -A "$bar_dir")" ]]; then
      info "Directory $bar_dir is empty, running Makefile..."
      (cd "$scripts_dir" && make)
      success "Makefile executed."
    else
      info "Directory $bar_dir has files, skipping Makefile."
    fi
  else
    info "Directory $bar_dir does not exist, running Makefile..."
    (cd "$scripts_dir" && make)
    success "Makefile executed."
  fi
}

main() {
  echo -e "${BOLD}"
  echo "╔══════════════════════════════════════════════╗"
  echo "║      New Device Bootstrap — bootstrap.sh     ║"
  echo "╚══════════════════════════════════════════════╝"
  echo -e "${RESET}"

  require curl
  require git
  require unzip

  install_packages || warn "Package install step encountered errors."
  run_scripts_makefile || warn "Scripts Makefile encountered errors."
  setup_tmux || warn "tmux setup encountered errors."
  setup_nnn_plugins || warn "nnn plugin setup encountered errors."
  setup_zinit || warn "zinit setup encountered errors."
  setup_ranger_plugins
  setup_mpv_plugins

  echo -e "\n${GREEN}${BOLD}All done!${RESET}"
  echo "You may want to:"
  echo "  • Restart your shell (or run: exec \$SHELL)"
  echo "  • Open tmux and run: <prefix> I  (to install tmux plugins if using tpm)"
  echo "  • Check warnings above for any packages that need manual attention"
}

main "$@"
