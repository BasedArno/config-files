### .zshrc

## Window Title
print "\e]0;Oh My Zsh!\a"

## Set up the prompt
autoload -Uz promptinit && promptinit
autoload -U colors && colors
# Left side prompt
PROMPT="%{$fg[red]%}%n%{$reset_color%} @ %{$fg[blue]%}%m%{$reset_color%}" # user and host
PROMPT+=" in %{$fg_bold[magenta]%}%~%{$reset_color%}" # current directory
PROMPT+=$'\n'
PROMPT+="%# "

# Right side prompt
RPROMPT="#" # literal octothorpe to make copy-pasting easier
#RPROMPT+=" %t" # time in AM/PM format
RPROMPT+=""
RPROMPT+=" exited %(?.%{$fg[green]%}.%{$fg[red]%})%? %{$reset_color%}" # colored exit status
RPROMPT+="[%{$fg[cyan]%}%!%{$reset_color%}]" # command counter
## ------

## History
setopt histignorealldups
unsetopt sharehistory
# Use emacs keybindings (easy enough to enter vim mode)
bindkey -e
# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
## ------

## Environment
export PATH=/usr/local/visit/bin:$PATH
export PATH=/home/arno/bin:$PATH

export EDITOR=/usr/bin/vim
export VISUAL=/usr/bin/gedit

export TERM="xterm-256color"

setopt extendedglob
setopt interactivecomments
## ------

## Aliases
alias ls='ls --color=auto'
alias la='ls -AF'
alias ll='ls -alh'
alias l1='ls -1'
alias grep='grep --color=auto'
alias tr='noglob tr'
alias spkg='sudo aptitude'
alias nautilus='nautilus --no-desktop'
alias clock='tty-clock -c -C 1'
alias setclip='xclip -selection c'
alias getclip='xclip -selection clipboard -o'
alias timestamp='date +"%Y-%m-%d %r"'
alias ijulia='ipython notebook --profile julia'
alias iron='mocp -T yellow_red_theme'
alias yacc='bison -d --verbose --debug'
alias pstree='pstree -pAn'
alias hc='herbstclient'
alias pls='sudo $(history -p !!)'
alias reset-sound='amixer set Master unmute && amixer set Headphone toggle'
## ------

## Functions galore
source ~/.functions

imv() {
	local src dst
	for src in "$@"
	do
		[[ -e $src ]] || { print -u2 "$src does not exist"; continue }
		dst=$src
		vared dst
		[[ $src != $dst ]] && mkdir -p $dst:h && mv -n $src $dst
	done
}
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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh