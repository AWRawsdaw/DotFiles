# Copilot Instructions for dotfiles Repository

This is a **NixOS desktop environment configuration** repository managing a Hyprland wayland compositor setup with supporting applications. All dotfiles follow a **declarative, component-based architecture** where each tool has its own directory.

## Architecture Overview

**Component Structure:**
- `nixos/` — NixOS system configuration (the "single source of truth")
  - `configuration.nix` — Main system config (packages, services, hardware)
  - `hardware-configuration.nix` — Auto-generated hardware profile (do not edit manually)
- `hyprland/` — Window manager configuration (keybinds, monitors, window rules)
- `waybar/` — Status bar with custom modules (clock, Spotify, temps, audio)
- `alacritty/` — Terminal emulator config
- `rofi/` — App launcher and menus
- `mako/` — Desktop notification daemon
- `hyprpaper/` — Wallpaper manager

**Key Architectural Pattern:** System packages are declared in `nixos/configuration.nix` (line 81-93), and their configs live in matching sibling directories. Changes to any config file require manual reload (no automatic sync).

## Critical Workflows

**Applying System Changes:**
1. Edit config in the appropriate directory (e.g., `hyprland/hyprland.conf` for keybinds)
2. Reload the component:
   - Hyprland: `hyprctl reload` (live reload)
   - Waybar: Kill waybar process, restart via Hyprland autostart or manually
   - Mako: `pkill mako; mako &` (restart daemon)
   - System-level: `sudo nixos-rebuild switch` (rebuilds entire system)

**Adding New Packages:**
1. Add to `nixos/configuration.nix` environment.systemPackages list (line 81-93)
2. Run `sudo nixos-rebuild switch` to install and activate

## Project-Specific Conventions

**Multi-Monitor Setup:** Three monitors configured in `hyprland/hyprland.conf` (lines 4-6):
- DP-3 (2560×1440@155 Hz) — Right monitor
- DP-2 (2560×1440@144 Hz) — Center monitor (default for new workspaces)
- HDMI-A-1 (1920×1080@60 Hz) — Left monitor
- Steam windows pinned to DP-2 by window rule (line 15)

**Waybar Custom Modules:** Located in `waybar/scripts/`:
- `audio.sh` — Uses `wpctl` to get volume/mute state (PipeWire control)
- `power-menu.sh` — Custom power menu script
- `bluetooth.sh`, `bluetooth-menu.sh` — Bluetooth integration

**Color Scheme:** Catppuccin-inspired palette (blue: `#89b4fa`, pink: `#f5c2e7`) used consistently across rofi launcher, waybar, and hyprland borders.

## Integration Points & Dependencies

**System Service Dependencies:**
- **PipeWire** (`services.pipewire`) — Audio system (waybar cava visualization, audio module, spotify control)
- **Blueman** (`services.blueman`) — Bluetooth management
- **GDM** with Wayland — Display manager for Hyprland sessions
- **NVIDIA drivers** — Hardware acceleration (Wayland-compatible setup)
- **Udisks2 + GVFS** — Auto-mount internal drives (configured in nixos/configuration.nix)

**External Tool Dependencies:**
- `playerctl` — Spotify control in waybar (metadata polling)
- `nvidia-smi` — GPU temperature reporting in waybar
- `wpctl` — PipeWire volume control (audio.sh script)
- `grimblast` — Screenshot tool (Super+Shift+S keybind)

**File System Configuration:**
- Internal drive auto-mounted to `/mnt/internal` (uuid: 5db7cbb1...) via nixos/configuration.nix

## Editing Guidelines

- **Never edit** `nixos/hardware-configuration.nix` manually — regenerate with `nixos-generate-config`
- **Wayland-only environment** — No X11 fallbacks; Hyprland runs natively on Wayland
- **Shell integration** — Alacritty starts with fastfetch + shell (alacritty.toml line 6)
- **Rofi theming** — Both launcher and power-menu use .rasi format with consistent color variables
- **Waybar module order** — Change "modules-left", "modules-center", "modules-right" arrays to reorder status bar

when you change something always nixrebuild and debug