# LPC — Linux Personal Configs

Personal shell environment customizations stored in separate files and wired into the system *rc files non-destructively via a loader script.

---

## Purpose

Keep personal aliases, functions, and editor settings **outside** of the original system *rc files (`~/.bashrc`, `~/.vimrc`, `~/.screenrc`, etc.).  
The original files are never modified manually — the loader script appends a single `source` line to each one.

---

## Repository Structure

```
LPC/
├── lpc_loader.sh                   # Installer — wires LPC files into *rc files
├── .bashrc_lpc_aliases             # Aliases, editor settings, directory stack
├── .bashrc_lpc_functions           # Shell functions (SSH fix, dir navigation)
├── .vimrc_lpc                      # Personal Vim settings (extend as needed)
├── .screenrc_lpc                   # Personal GNU Screen settings
├── rc_files_origins/               # Backup copies of original *rc files
│   ├── .bashrc
│   ├── .bash_profile
│   ├── .bash_aliases
│   ├── .bash_history
│   ├── .vimrc
│   └── .screenrc
└── documentation.md                # This file
└── .gitignore                      # Excludes rc_files_origins/ from git
```

---

## Installation

Run the loader script once after cloning or setting up the repo:

```bash
bash lpc_loader.sh
```

What it does:

| Target file        | Line appended                                                              |
|--------------------|----------------------------------------------------------------------------|
| `~/.bashrc`        | `source ~/.bashrc_lpc_aliases`                                             |
| `~/.bashrc`        | `source ~/.bashrc_lpc_functions`                                           |
| `~/.bash_profile`  | `source ~/.bashrc` (ensures SSH login shells also load `.bashrc`)          |
| `~/.vimrc`         | `source ~/.vimrc_lpc`                                                      |
| `~/.screenrc`      | `source $HOME/.screenrc_lpc`                                               |

The loader is **idempotent** — running it multiple times will not duplicate lines or overwrite existing backups.

---

## Files

### `lpc_loader.sh`

Installer script. Uses two helper functions:

- `backup_file()` — copies each target *rc file into `rc_files_origins/` before modifying it (skips if backup already exists)
- `append_if_missing()` — appends a `source` line to a file only if it is not already present

Both helpers are **idempotent** — safe to run multiple times.

### `.bashrc_lpc_aliases`

Loaded by `~/.bashrc`. Contains:

- **Editor defaults** — sets `$EDITOR` and `$VISUAL` to `vim`
- **Vim mode in Bash** — enables readline vi keybindings (`set -o vi`)
- **General aliases**

  | Alias    | Command              | Purpose                        |
  |----------|----------------------|--------------------------------|
  | `ll`     | `ls -la`             | Long listing with hidden files |
  | `la`     | `ls -A`              | All files except `.` and `..`  |
  | `l`      | `ls -CF`             | Compact listing                |
  | `..`     | `cd ..`              | Go up one directory            |
  | `...`    | `cd ../..`           | Go up two directories          |
  | `h`      | `history`            | Show command history           |
  | `j`      | `jobs`               | List background jobs           |
  | `v`      | `vim`                | Open Vim                       |
  | `grep`   | `grep --color=auto`  | Grep with color                |
  | `df`     | `df -h`              | Human-readable disk usage      |
  | `du`     | `du -h`              | Human-readable dir size        |
  | `free`   | `free -h`            | Human-readable memory info     |
  | `clr`    | `clear`              | Clear terminal                 |
  | `cls`    | `clear`              | Clear terminal (alternate)     |
  | `py`     | `python3`            | Run Python 3                   |
  | `ip`     | `ip addr`            | Show network interfaces        |
  | `ping`   | `ping -c 5`          | Ping 5 times                   |
  | `top`    | `htop`               | Interactive process viewer     |
  | `reload` | `source ~/.bashrc`   | Reload Bash config             |
  | `update` | `sudo apt update && sudo apt upgrade -y` | Update system packages |
  | `mkdir`  | `mkdir -p`           | Create parent dirs as needed   |
  | `cp`     | `cp -i`              | Prompt before overwriting      |
  | `mv`     | `mv -i`              | Prompt before overwriting      |
  | `rm`     | `rm -i`              | Prompt before deleting         |

- **Git aliases**

  | Alias     | Command                    | Note                                      |
  |-----------|----------------------------|-------------------------------------------|
  | `gstat`   | `git status`               | `gs` and `gst` are reserved by the system |
  | `gadd`    | `git add`                  |                                           |
  | `gcommit` | `git commit`               |                                           |
  | `gdiff`   | `git diff`                 |                                           |
  | `gpush`   | `git push`                 | Avoids conflict with system `gp`          |
  | `gpull`   | `git pull`                 | Avoids conflict with system `gl`          |
  | `glog`    | `git log --oneline -10`    | Last 10 commits one-liner                 |
  | `gbranch` | `git branch`               |                                           |
  | `gch`     | `git checkout`             |                                           |
  | `fix-ssh` | `ssh-fix`                  | Alias for the `ssh-fix` function          |

- **Directory stack** — tracks the last 5 visited directories (see also `.bashrc_lpc_functions`)

### `.bashrc_lpc_functions`

Loaded by `~/.bashrc`. Contains shell functions:

#### `ssh-fix`

Recovers a lost or broken SSH agent connection — useful when re-attaching to a `screen`/`tmux` session after SSH reconnect.

- Scans `/tmp/ssh-*` for available agent sockets
- Picks the socket with the most keys loaded
- Exports `SSH_AUTH_SOCK` to the best available socket

Usage:
```bash
ssh-fix
```

#### Directory stack functions

A lightweight directory history tracking the last 5 visited directories.  
The built-in `cd` is overridden to maintain the stack automatically.

| Function       | Usage         | Description                                |
|----------------|---------------|--------------------------------------------|
| `dirs_history` | `dirs_history`| Lists the last 5 visited directories        |
| `cdd`          | `cdd [index]` | Jumps to a directory from the stack by index|

Example:
```bash
cd ~/projects
cd /tmp
dirs_history
# Recent directories:
#   [0] /tmp
#   [1] /home/user/projects

cdd 1   # jumps back to ~/projects
```

### `.vimrc_lpc`

Personal Vim configuration. Sourced via `~/.vimrc`. Currently empty — add personal Vim settings here.

### `.screenrc_lpc`

Personal GNU Screen configuration. Sourced via `~/.screenrc`. Currently empty — add personal Screen settings here.

### `.gitignore`

Excludes `rc_files_origins/` from version control. The backup files contain personal system configuration and should not be pushed to a remote repository.

### `rc_files_origins/`

Backup copies of all *rc files affected by `lpc_loader.sh`, captured before any modifications are made. Used as a reference baseline and recovery source.

Contains: `.bashrc`, `.bash_profile`, `.bash_aliases`, `.bash_history`, `.vimrc`, `.screenrc`

---

## Shell Loading Chain

```
SSH login
    └─► ~/.bash_profile
            └─► ~/.bashrc  (sourced via loader line)
                    ├─► ~/.bashrc_lpc_aliases     (aliases, editor, dir stack)
                    └─► ~/.bashrc_lpc_functions   (ssh-fix, dirs_history, cdd)

Terminal emulator (non-login shell)
    └─► ~/.bashrc
            ├─► ~/.bashrc_lpc_aliases
            └─► ~/.bashrc_lpc_functions
```

---

## Adding New Customizations

- **New aliases** → add to `.bashrc_lpc_aliases`
- **New functions** → add to `.bashrc_lpc_functions`
- **Vim settings** → add to `.vimrc_lpc`
- **Screen settings** → add to `.screenrc_lpc`

Never edit the original `~/.bashrc`, `~/.vimrc`, or `~/.screenrc` directly.
