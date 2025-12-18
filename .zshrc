export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=100000000
export SAVEHIST=100000000
setopt INC_APPEND_HISTORY 
setopt SHARE_HISTORY       
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
export HISTIGNORE="ls:ll:la:cd:pwd:exit:clear:history:v:vim:nvim:sk:fj:gs:ga:gc:gp:gd"

export EDITOR="/Users/nitin/Downloads/nvim/bin/nvim"
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
bindkey '^Xe' edit-command-line

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats ' %F{#B284BE}*b %b%f'
chpwd() { vcs_info }

PROMPT=' %1~%F{red}%B${vcs_info_msg_0_}%b%f $ '

alias z="cd"
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset%s %Cgreen(%cr)%Creset %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
alias nf="fastfetch"
alias work="nvim ~/Documents/notes/workout/split.md"
alias nv="neovide"
alias clear="clear -x"
alias vim="/Users/nitin/Downloads/nvim/bin/nvim"
alias v="/Users/nitin/Downloads/nvim/bin/nvim"
alias l="ls -C -t -U -A -p --color=auto"
alias la="ls -lh --color=auto"
alias yt="yt-dlp -t mp4"
alias rip='yt-dlp -x --audio-format mp3'
alias fj="tmux new -s home"
alias ts="timew summary 1000h"
alias g='git'
alias ff='fastfetch'

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH="$PATH:/Users/nitin/.local/bin"
export SUDO_EDITOR="nvim"
export PATH="$PATH:/Users/nitin/Downloads/nvim/bin/"

