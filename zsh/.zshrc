export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=100000000
export SAVEHIST=100000000
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
export HISTIGNORE="ls:ll:la:cd:pwd:exit:clear:history:v:vim:nvim:sk:fj:gs:ga:gc:gp:gd"
export EDITOR="nvim"
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export PATH="$JAVA_HOME/bin:$PATH"
export PATH=$PATH:$HOME/Documents/zk/bin
export MANPAGER="nvim +Man!"
export SUDO_EDITOR=nvim
setopt autocd
bindkey -v
autoload -U compinit
zmodload zsh/complist
compinit
zstyle ':completion:*' menu select
autoload edit-command-line
zle -N edit-command-line
bindkey '^Xr' edit-command-line
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
alias im="nvim"
alias vim="nvim"
alias v="nvim"
alias clear="clear -x"
alias l="ls -C -t -U -A -p --color=auto"
alias ll="ls -lh --color=auto"
alias yt="yt-dlp -t mp4"
alias rip='yt-dlp -x --audio-format mp3'
alias fj="tmux new -s home"
alias ff='fastfetch'
alias data='cd /Users/nitin/.local/share/nvim/site/pack/core/opt '
alias update='brew update && brew upgrade && brew cleanup'
alias gem="ollama run gemma3:latest"
alias nt="cd ~/Documents/notes/ && nvim ."
# source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
export SUDO_EDITOR="nvim"
export PATH="$PATH:/Users/nitin/.local/share/bob/nightly/bin/"
export PATH="$PATH:/Users/nitin/.cargo/bin/"

export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg:#d0d0d0,fg+:#d0d0d0,bg:#141415,bg+:#262626
  --color=hl:#FFFFFF,hl+:#5fd7ff,info:#FFFFFF,marker:#87ff00
  --color=prompt:#FFFFFF,spinner:#141415,pointer:#ffffff,header:#141415
  --color=gutter:#141415,border:#262626,separator:#141415,scrollbar:#141415
  --color=preview-scrollbar:#141415,label:#aeaeae,query:#d9d9d9
  --border="rounded" --border-label="" --preview-window="border-sharp" --prompt="> "
  --marker=" " --pointer="." --separator="─" --scrollbar="│"'


source ~/.config/zsh/dirswitch.zsh


autoload -Uz promptinit
setopt prompt_subst
# PROMPT=$' %F{#7393B3}%~%f%F{#D3D3FF}%B${vcs_info_msg_0_}%b%f $ '
PROMPT=$' %F{#7393B3}%~%f%F{#D3D3FF}%B${vcs_info_msg_0_}%b%f $ '
# PROMPT=' %F{#7393B3}%1~%f%F{#D3D3FF}%B${vcs_info_msg_0_}%b%f $ '
# PROMPT=$' %F{#7393B3}%~%f%F{#D3D3FF}%B%b%f $ '
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
zstyle ':vcs_info:git:*' formats '%F{#46464a} *%b%f'
# zstyle ':vcs_info:git:*' formats '%F{#ab4242} *%b%f'
# zstyle ':vcs_info:git:*' formats '%F{#C792EA} %b%c %f'
# zstyle ':vcs_info:git:*' check-for-changes true
chpwd() { vcs_info }


finder() {
    open .
}
zle -N finder
bindkey '^f' finder

# eval "$(starship init zsh)"

alias z="cd"
