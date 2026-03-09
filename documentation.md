# LPC — Linux Personal Configs

Personal shell environment customizations stored in separate files, deployed to `~/.lpc/`, and wired into the system *rc files non-destructively via a loader script.

---

## Purpose

Keep personal aliases, functions, and editor settings **outside** of the original system *rc files (`~/.bashrc`, `~/.vimrc`, `~/.screenrc`, etc.).  
The original files are never modified manually — the loader script appends a single `source` line pointing to `~/.lpc/` into each one.  
All LPC dotfiles live permanently in `~/.lpc/` so source paths are stable regardless of where the repo was cloned.

---

## Repository Structure

```
# Before running lpc_loader.sh (repo can be cloned anywhere)
LPC/
├── lpc_loader.sh                   # Installer
├── .bashrc_lpc_aliases             # Aliases, editor settings
├── .bashrc_lpc_functions           # Shell functions (SSH fix, dir navigation)
├── .vimrc_lpc                      # Personal Vim settings
├── .screenrc_lpc                   # Personal GNU Screen settings
├── .gitignore                      # Excludes rc_files_origins/ from git
├── lpcNotesandIdeas.md             # Scratch notes and ideas
└── documentation.md                # This file

# After running lpc_loader.sh (repo moved here by the script)
~/.lpc/
├── lpc_loader.sh
├── .bashrc_lpc_aliases
├── .bashrc_lpc_functions
├── .vimrc_lpc
├── .screenrc_lpc
├── .gitignore
├── lpcNotesandIdeas.md
├── documentation.md
└── rc_files_origins/               # Created by lpc_loader.sh — gitignored
    ├── .bashrc
    ├── .bash_profile
    ├── .bash_aliases
    ├── .bash_history
    ├── .vimrc
    └── .screenrc
```

---

## Installation

Run the loader script once after cloning or setting up the repo:

```bash
bash lpc_loader.sh
```

What it does:

| Step | Action |
|------|--------|
| 0 | Moves the repo directory to `~/.lpc/` (skips if already there; aborts if `~/.lpc/` exists from a different path) |
| 1 | Backs up `~/.bashrc` → `~/.lpc/rc_files_origins/`, appends `source ~/.lpc/.bashrc_lpc_aliases` and `source ~/.lpc/.bashrc_lpc_functions` |
| 2 | Backs up `~/.bash_profile`, appends `source ~/.bashrc` (ensures SSH login shells load `.bashrc`) |
| 3 | Backs up `~/.vimrc`, appends `source ~/.lpc/.vimrc_lpc` |
| 4 | Backs up `~/.screenrc`, appends `source ~/.lpc/.screenrc_lpc` |

The loader is **idempotent** — running it multiple times will not duplicate lines or overwrite existing backups.

---

## Files

### `lpc_loader.sh`

Installer script. On first run it **moves the entire repo to `~/.lpc/`** using `BASH_SOURCE[0]` to locate itself (safe for both `bash lpc_loader.sh` and `. lpc_loader.sh`). Then uses two helpers:

- `backup_file()` — copies each target *rc file into `~/.lpc/rc_files_origins/` before modifying it (skips if backup already exists)
- `append_if_missing()` — appends a `source` line to a file only if it is not already present

All operations are **idempotent** — safe to run multiple times.

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
  | `gfetch`  | `git fetch`                |                                           |
  | `gpush`   | `git push`                 | Avoids conflict with system `gp`          |
  | `gpull`   | `git pull`                 | Avoids conflict with system `gl`          |
  | `glog`    | `git log --oneline -10`    | Last 10 commits one-liner                 |
  | `gbranch` | `git branch`               |                                           |
  | `gch`     | `git checkout`             |                                           |

- **Miscellaneous**

  | Alias     | Command                                   | Note                                 |
  |-----------|-------------------------------------------|--------------------------------------|
  | `fix-ssh` | `ssh_fix`   | Shorthand for the `ssh_fix` function |
  | `cls`     | `clear`                                   | Alternate clear                      |
  | `update`  | `sudo apt update && sudo apt upgrade -y`  | Update system packages               |
  | `mkdir`   | `mkdir -p`                                | Create parent dirs as needed         |
  | `cp`      | `cp -i`                                   | Prompt before overwriting            |
  | `mv`      | `mv -i`                                   | Prompt before overwriting            |
  | `rm`      | `rm -i`                                   | Prompt before deleting               |

- **OEA aliases**

  | Alias      | Command                            | Note                              |
  |------------|------------------------------------|-----------------------------------|
  | `pyactiv`  | `pyenv activate sage_core_3_10_13` | Activate the OEA pyenv environment |

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
fix-ssh   # via alias
ssh_fix   # directly
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
                    ├─► ~/.lpc/.bashrc_lpc_aliases     (aliases, editor)
                    └─► ~/.lpc/.bashrc_lpc_functions   (ssh-fix, dirs_history, cdd)

Terminal emulator (non-login shell)
    └─► ~/.bashrc
            ├─► ~/.lpc/.bashrc_lpc_aliases
            └─► ~/.lpc/.bashrc_lpc_functions
```

---

## Adding New Customizations

Edit files directly in `~/.lpc/` (the repo lives there after installation).

- **New aliases** → edit `~/.lpc/.bashrc_lpc_aliases`
- **New functions** → edit `~/.lpc/.bashrc_lpc_functions`
- **Vim settings** → edit `~/.lpc/.vimrc_lpc`
- **Screen settings** → edit `~/.lpc/.screenrc_lpc`

Never edit the original `~/.bashrc`, `~/.vimrc`, or `~/.screenrc` directly.
