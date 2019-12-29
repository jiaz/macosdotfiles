# Global Settings
fish_vi_key_bindings

set -Ux EDITOR vim

# Abbr and alias
abbr vi 'vim'
abbr l 'ls -l'

# https://github.com/jethrokuan/fzf
set -Ux FZF_LEGACY_KEYBINDINGS 0

set -Ux ENHANCD_COMMAND ecd

# Bootstrap fisher
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

# Spacefish
set -Ux SPACEFISH_TIME_SHOW true
set -Ux SPACEFISH_PACKAGE_SHOW false
set -Ux SPACEFISH_RUBY_SYMBOL 'Ruby '
set -Ux SPACEFISH_VI_MODE_SHOW false

# Load rbenv automatically by appending
# the following to ~/.config/fish/config.fish:

status --is-interactive; and source (rbenv init -|psub)

# Load pyenv automatically by appending
# the following to ~/.config/fish/config.fish:

status --is-interactive; and source (pyenv init -|psub)

