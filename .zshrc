HISTFILE="~/.zsh_history"
SAVEHIST=10000
HISTSIZE=9999
setopt INC_APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_NO_STORE
HISTORY_IGNORE='(l|vim|v|exit|fj|ls|cd)'

export EDITOR=nvim
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export PATH="$JAVA_HOME/bin:$PATH"

setopt autocd 
setopt prompt_subst      
bindkey -v              

autoload -U compinit
zmodload zsh/complist
compinit
zstyle ':completion:*' menu select

finder() { open . }
zle -N finder
bindkey '^f' finder

autoload edit-command-line
zle -N edit-command-line
bindkey '^E' edit-command-line

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats ' %F{#B284BE} %b%f'
chpwd() { vcs_info }

PROMPT=' %1~%F{red}%B${vcs_info_msg_0_}%b%f $ '

alias z="cd"
alias clear="clear -x"
alias vim="nvim"
alias v='nvim'
alias l="ls -C -t -U -A -p --color=auto"
alias la="ls -lh --color=auto"
alias y="yt-dlp"
alias rip='yt-dlp -x --audio-format mp3'
alias fj="tmux new -s user"
alias ts="timew summary 1000h"
alias g='git'
alias ff='fastfetch'

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export PATH=$PATH:/Users/nitin/.spicetify
