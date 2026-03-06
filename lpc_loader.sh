#!/bin/bash

# lpc_loader.sh
# Appends loading statements to *rc files for LPC customizations
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ORIGINS_DIR="$SCRIPT_DIR/rc_files_origins"
BASHRC="$HOME/.bashrc"
BASH_PROFILE="$HOME/.bash_profile"
VIMRC="$HOME/.vimrc"
SCREENRC="$HOME/.screenrc"

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
        echo "[SKIP BACKUP] $(basename "$file") already backed up in rc_files_origins/"
    else
        cp "$file" "$dest"
        echo "[BACKUP] $(basename "$file") -> rc_files_origins/"
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
    '[ -f ~/.bashrc_lpc_aliases ] && source ~/.bashrc_lpc_aliases' \
    "source .bashrc_lpc_aliases"

append_if_missing "$BASHRC" \
    '[ -f ~/.bashrc_lpc_functions ] && source ~/.bashrc_lpc_functions' \
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
    'if filereadable(expand("~/.vimrc_lpc")) | source ~/.vimrc_lpc | endif' \
    "source .vimrc_lpc"

# ─────────────────────────────────────────────
# 4. Append loading of .screenrc_lpc to .screenrc
# ─────────────────────────────────────────────
backup_file "$SCREENRC"
append_if_missing "$SCREENRC" \
    'source $HOME/.screenrc_lpc' \
    "source .screenrc_lpc"

echo ""
echo "Done. Please restart your shell or run: source ~/.bashrc"