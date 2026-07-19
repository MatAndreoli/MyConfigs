# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

for config in ~/.customs/.*; do
  source "$config"
done

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k (sync: it's the prompt itself)
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins (wait = load async after first prompt, lucid = no reports)
zinit ice wait lucid; zinit light zdharma-continuum/fast-syntax-highlighting
zinit ice wait lucid; zinit light zsh-users/zsh-completions
zinit ice wait lucid; zinit light zsh-users/zsh-autosuggestions
zinit ice wait lucid; zinit light Aloxaf/fzf-tab

function zvm_after_init() {
  bindkey "^P" history-beginning-search-backward
  bindkey "^N" history-beginning-search-forward
}

# zsh-vi-mode (sync: keybindings need to be ready before prompt)
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

# Add in snippets (wait = load async, lucid = no "Loaded" reports)
zinit ice wait lucid; zinit snippet OMZ::plugins/git/git.plugin.zsh
zinit ice wait lucid; zinit snippet OMZP::git
zinit ice wait lucid; zinit snippet OMZP::mvn
zinit ice wait lucid; zinit snippet OMZP::sudo
zinit ice wait lucid; zinit snippet OMZP::fzf

# Load completions (cached: rebuild only if .zcompdump missing or >7 days old)
autoload -Uz compinit
setopt extendedglob
cache="${ZDOTDIR:-$HOME}/.zcompdump"
if [[ ! -f "$cache" ]] || [[ -n "$cache(#qN.m+7)" ]]; then
  compinit
else
  compinit -C
fi

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

export EDITOR=$(which nvim)
export ZVM_VI_SURROUND_BINDKEY=s-prefix

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

setopt auto_cd
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 --color=always $realpath'
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':omz:plugins:nvm' lazy yes

# Aliases
alias ls='ls --color'
alias c='clear'

export PATH="${HOME}/.local/bin":${PATH}

# SDKMAN
export SDKMAN_DIR="$HOME/.sdkman" && [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# NVM (lazy: loads nvm.sh on first call to nvm/node/npm/npx)
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"

nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}

node() { nvm; command node "$@"; }
npm() { nvm; command npm "$@"; }
npx() { nvm; command npx "$@"; }

# PYENV
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(zoxide init zsh)"

# GVM (lazy: loads gvm scripts on first call to gvm/go/gofmt)
export GVM_ROOT="$HOME/.gvm"
export PATH="$GVM_ROOT/bin:$PATH"

gvm() {
  unset -f gvm go gofmt 2>/dev/null
  [ -s "$GVM_ROOT/scripts/gvm" ] && \. "$GVM_ROOT/scripts/gvm"
  gvm "$@"
}

go() { gvm; command go "$@"; }
gofmt() { gvm; command gofmt "$@"; }
# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
alias lzd='lazydocker'

# opencode
export PATH=/home/matandreoli/.opencode/bin:$PATH
