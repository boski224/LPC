#!/bin/bash

# lpc_loader.sh
# Moves the LPC repo to ~/.lpc (if not already there) and wires dotfiles into *rc files
LPC_DIR="$HOME/.lpc"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASHRC="$HOME/.bashrc"
BASH_PROFILE="$HOME/.bash_profile"
VIMRC="$HOME/.vimrc"
SCREENRC="$HOME/.screenrc"

# ─────────────────────────────────────────────
# 0. Move repo to ~/.lpc if not already there
# ─────────────────────────────────────────────
if [ "$SCRIPT_DIR" != "$LPC_DIR" ]; then
    if [ -d "$LPC_DIR" ]; then
        echo "[ERROR] ~/.lpc already exists but the repo is at $SCRIPT_DIR"
        echo "        Remove ~/.lpc or run lpc_loader.sh from inside ~/.lpc directly."
        exit 1
    fi
    echo "[MOVE] Moving repo from $SCRIPT_DIR -> $LPC_DIR ..."
    mv "$SCRIPT_DIR" "$LPC_DIR"
    echo "[OK]   Repo is now at $LPC_DIR"
fi

ORIGINS_DIR="$LPC_DIR/rc_files_origins"

# Helper function to back up a file into rc_files_origins/ (once only)
backup_file() {
    local file="$1"
    local dest="$ORIGINS_DIR/$(basename "$file")"

    mkdir -p "$ORIGINS_DIR"

    if [ ! -f "$file" ]; then
        echo "[SKIP BACKUP] $file does not exist, nothing to back up."
        return
    fi

    if [ -f "$dest" ]; then
        echo "[SKIP BACKUP] $(basename "$file") already backed up in ~/.lpc/rc_files_origins/"
    else
        cp "$file" "$dest"
        echo "[BACKUP] $(basename "$file") -> ~/.lpc/rc_files_origins/"
    fi
}

# Helper function to append a line if it doesn't already exist
append_if_missing() {
    local file="$1"
    local line="$2"
    local description="$3"

    if [ ! -f "$file" ]; then
        echo "[WARNING] $file does not exist. Creating it..."
        touch "$file"
    fi

    if grep -qF "$line" "$file"; then
        echo "[SKIP] '$description' already present in $file"
    else
        echo "" >> "$file"
        echo "$line" >> "$file"
        echo "[OK] Appended '$description' to $file"
    fi
}

# ─────────────────────────────────────────────
# 1. Add loading of .bashrc_lpc_aliases and .bashrc_lpc_functions to .bashrc
# ─────────────────────────────────────────────
backup_file "$BASHRC"
append_if_missing "$BASHRC" \
    '[ -f ~/.lpc/.bashrc_lpc_aliases ] && source ~/.lpc/.bashrc_lpc_aliases' \
    "source .bashrc_lpc_aliases"

append_if_missing "$BASHRC" \
    '[ -f ~/.lpc/.bashrc_lpc_functions ] && source ~/.lpc/.bashrc_lpc_functions' \
    "source .bashrc_lpc_functions"

# ─────────────────────────────────────────────
# 2. Ensure .bash_profile loads .bashrc
# ─────────────────────────────────────────────
backup_file "$BASH_PROFILE"
append_if_missing "$BASH_PROFILE" \
    '[ -f ~/.bashrc ] && source ~/.bashrc' \
    "source .bashrc"

# ─────────────────────────────────────────────
# 3. Append loading of .vimrc_lpc to .vimrc
# ─────────────────────────────────────────────
backup_file "$VIMRC"
append_if_missing "$VIMRC" \
    'if filereadable(expand("~/.lpc/.vimrc_lpc")) | source ~/.lpc/.vimrc_lpc | endif' \
    "source .vimrc_lpc"

# ─────────────────────────────────────────────
# 4. Append loading of .screenrc_lpc to .screenrc
# ─────────────────────────────────────────────
backup_file "$SCREENRC"
append_if_missing "$SCREENRC" \
    'source $HOME/.lpc/.screenrc_lpc' \
    "source .screenrc_lpc"

echo ""
echo "Done. Please restart your shell or run: source ~/.bashrc"