# === History ===
HISTFILE=$HOME/.zsh_history
SAVEHIST=10000
HISTSIZE=9999

# === Environment Variables ===
export EDITOR=nvim
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export PATH="$JAVA_HOME/bin:$PATH"

# === Options ===
setopt autocd 
setopt prompt_subst      
bindkey -v              

# === Completion ===
autoload -U compinit
zmodload zsh/complist
compinit
zstyle ':completion:*' menu select

# === Keybindings ===
# Open Finder in current directory
finder() { open . }
zle -N finder
bindkey '^f' finder

# Edit command line in $EDITOR
autoload edit-command-line
zle -N edit-command-line
bindkey '^E' edit-command-line

# Menu select key remaps
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# === Git Info via vcs_info ===
autoload -Uz vcs_info

# Hook to run before each prompt
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )

# Enable Git support in vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats ' %F{#B284BE} %b%f'

# Trigger vcs_info on directory change
chpwd() { vcs_info }

# === Prompt ===
PROMPT=' %1~%F{red}%B${vcs_info_msg_0_}%b%f $ '

# === Aliases ===
alias z="cd"
alias clear="clear -x"
alias vim="nvim"
alias v='nvim'
alias ls="ls -C -t -U -A -p --color=auto"
alias ll="ls -lh --color=always"
alias y="yt-dlp"
alias rip='yt-dlp -x --audio-format mp3'
alias fj="tmux new -s user"
alias ts="timew summary 1000h"
alias g='git'

# === External Configs ===
[ -f ~/.config/zsh/hist.zsh ] && source ~/.config/zsh/hist.zsh

# === Syntax Highlighting ===
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
