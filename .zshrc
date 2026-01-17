# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

#ZSH_THEME="robbyrussell"

zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-vi-mode docker gh httpie zoxide)
SHOW_AWS_PROMPT=false
ZVM_INIT_MODE=sourcing

source $ZSH/oh-my-zsh.sh

#####################
# User configuration
#####################

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes.
# For a full list of active aliases, run `alias`.

setopt HIST_IGNORE_ALL_DUPS
setopt nosharehistory
HISTSIZE=10000
HISTFILESIZE=20000

if command -v eza &>/dev/null; then
    alias ll='eza -al --classify=auto --icons=auto'
    alias l='eza -l --classify=auto --icons=auto'
else
    alias ll='ls -alF'
    alias l='ls -lF'
fi

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Use like `pwd | clip`
if [[ "$OSTYPE" == "darwin"* ]]; then
    alias clip="xargs echo -n | pbcopy"
else
    alias clip="xclip -in -selection clipboard"
fi

alias nv='nvim'

if command -v batman &>/dev/null; then
    eval "$(batman --export-env)"
fi

if command -v kubecolor &>/dev/null; then
    alias kubectl=kubecolor
    alias k=kubecolor
fi

if command -v fzf &>/dev/null; then
    source <(fzf --zsh)
    export FZF_DEFAULT_COMMAND='rg --files'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_DEFAULT_OPTS='--preview "bat --color=always {}"'
    export FZF_ALT_C_OPTS='--preview-window=hidden'
    export FZF_CTRL_R_OPTS='--preview-window=hidden'
fi

alias bb="git branch --sort=-committerdate | fzf --height=20% --preview-window=hidden | xargs git checkout"
alias review='nvim -c "DiffviewOpen origin/HEAD...HEAD --imply-local"'
alias activate="source .venv/bin/activate"

# See https://unix.stackexchange.com/questions/273529/shorten-path-in-zsh-prompt
# Copy the Robby Russell theme source if you want to include git info
PROMPT="%(?:%{$fg_bold[green]%}%1{❯%}:%{$fg_bold[red]%}%1{❯%}) %{$fg[cyan]%}%(5~|…/%4~|%~)%{$reset_color%} "

# Initialize uv completion if available
if command -v uv &>/dev/null; then
    eval "$(uv generate-shell-completion zsh)"
    eval "$(uvx --generate-shell-completion zsh)"
fi

# Load any machine-specific environment
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

# Load any machine-specific configuration
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
