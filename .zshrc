### .zshrc

## Window Title
print "\e]0;Oh My Zsh!\a"

## Set up the prompt
autoload -Uz promptinit && promptinit
autoload -U colors && colors
## Left side prompt
# (red)user @ (blue)host
PROMPT="%{$fg[red]%}%n%{$reset_color%} at %{$fg[blue]%}%m%{$reset_color%}"
# in (magenta)directory
# with shortened dirname
PROMPT+=" in %{$fg_bold[magenta]%}"
PROMPT+="%(4~|.../%3~|%~)"
PROMPT+="%{$reset_color%}"
# newline
PROMPT+=$'\n'
# super awesome prompt
PROMPT+="%# "

## Right side prompt
# literal octothorpe to make copy-pasting easier
RPROMPT="#"
#RPROMPT+=" %t" # time in AM/PM format
RPROMPT+=""
# exited (green if 0 or red if anything else)exit status
RPROMPT+=" exited %(?"
RPROMPT+="."
RPROMPT+="%{$fg[green]%}(^_^)%{$reset_color%}"
RPROMPT+="."
RPROMPT+="%{$fg[red]%}(つ⋟﹏⋞%)つ︵%{$reset_color%}"
RPROMPT+="%{$fg[red]%}%?%{$reset_color%}"
RPROMPT+=")"
# [(cyan)command number]
#RPROMPT+="[%{$fg[cyan]%}%!%{$reset_color%}]"
## ------

## History
setopt histignorealldups
unsetopt sharehistory
# Use emacs keybindings (easy enough to enter vim mode)
bindkey -e
# Keep 100000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
## ------

## Environment
export PATH=/usr/local/visit/bin:$PATH
export PATH=/usr/games:$PATH
export PATH=/home/arno/bin:$PATH

export EDITOR=/usr/bin/vim
export VISUAL=/usr/bin/atom

export TERM="xterm-256color"

export GOPATH=/home/arno/dev/go
export PATH=$PATH:$GOPATH/bin

setopt extendedglob
setopt interactivecomments
## ------

## Aliases
alias ls='ls --color=auto'
alias la='ls -AF'
alias ll='ls -alh'
alias l1='ls -1'

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

alias tr='noglob tr'
alias history='history 1'
alias pstree='pstree -pAn'
alias nautilus='nautilus --no-desktop'

alias spkg='sudo aptitude'
alias pls='sudo $(fc -ln -1)'
alias fucking='sudo'

alias ffmpeg='avconv'
alias setclip='xclip -selection c'
alias getclip='xclip -selection clipboard -o'
alias timestamp='date +"%Y-%m-%d %r"'
alias yacc='bison -d --verbose --debug'
alias hc='herbstclient'
alias clock='tty-clock -c -C 1'
alias ijulia='jupyter notebook --profile julia'
alias iron='mocp -T yellow_red_theme'
alias remember='history | egrep'
alias reset-volume='amixer set Master unmute && amixer set Headphone toggle'
alias reset-sound="pulseaudio -k && sudo alsa force-reload"
## ------

## Moar Aliases
alias -g DAEMON=" </dev/null >/dev/null 2>&1 &"
alias -g LESS="| less -R"

hash -d	papes="/home/arno/media/pics/Wallpapers"
## ------

## Use modern completion system
autoload -Uz compinit && compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*' rehash true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
## ------

## Syntax Highlighting Plugin
source ~/repos/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
## ------

## Functions galore
source ~/.functions
# and their autocompletions
source ~/.autocomp
## ------

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
