# elarsın muhteşem confiği esef tarafından değiştirildi
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# FZF
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# eza
alias ls='eza --icons --group-directories-first'
alias ll='eza -lah --icons --group-directories-first'
alias la='eza -a --icons --group-directories-first'
alias lt='eza --tree --level=2 --icons'

# zoxide
alias cd='z'

# utils
alias cat='bat'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias free='free -h'

# safety
alias cp='cp -i'
alias mv='mv -i'
alias rm='trash-put'

# system
alias sysinfo='fastfetch'
alias monitor='btop'
alias ports='sudo netstat -tulpn'
alias myip='curl ifconfig.me'

# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# extract helper
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)  tar xjf "$1"    ;;
      *.tar.gz)   tar xzf "$1"    ;;
      *.bz2)      bunzip2 "$1"    ;;
      *.rar)      unrar e "$1"    ;;
      *.gz)       gunzip "$1"     ;;
      *.tar)      tar xf "$1"     ;;
      *.tbz2)     tar xjf "$1"    ;;
      *.tgz)      tar xzf "$1"    ;;
      *.zip)      unzip "$1"      ;;
      *.Z)        uncompress "$1" ;;
      *.7z)       7z x "$1"       ;;
      *)          echo "'$1' can't be extracted" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# git
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

# history
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# completion
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
setopt AUTO_CD

#fetch
fastfetch
