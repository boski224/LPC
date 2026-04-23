#!/bin/bash

# [V] curl -sS https://starship.rs/install.sh | sh
# [V] touch starShip.sh
# [V] wget https://starship.rs/presets/toml/bracketed-segments.toml
# [V] starship preset bracketed-segments -o ~/.config/starship.toml

curl -sS https://starship.rs/install.sh | sh
wget https://starship.rs/presets/toml/bracketed-segments.toml
starship preset bracketed-segments -o ~/.config/starship.toml
rm bracketed-segments.toml

