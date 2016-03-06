# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

## Environment

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# history
HISTCONTROL=ignoreboth
HISTSIZE=100000
HISTFILESIZE=200000
shopt -s histappend
shopt -s cmdhist

shopt -s checkwinsize # redo window size if necessary
shopt -s globstar # makes '**' recursive

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

export TERM="xterm-256color"

function set_prompt() {
	local last_command=$?

	# set variable identifying the chroot you work in (used in the prompt below)
	if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	    debian_chroot=$(cat /etc/debian_chroot)
	fi

	# set a fancy prompt (non-color, unless we know we "want" color)
	if [ "$TERM" == xterm-256color ]; then
	    local color_prompt=yes
	fi

	local force_color_prompt=yes

	if [ -n "$force_color_prompt" ]; then
	    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		local color_prompt=yes
	    else
		local color_prompt=
	    fi
	fi

	# must be global variables
	WHITE="\[\e[0;37m\]"
	CYAN="\[\e[0;36m\]"
	MAGENTA="\[\e[0;35m\]"
	BLUE="\[\e[0;34m\]"
	YELLOW="\[\e[0;33m\]"
	GREEN="\[\e[0;32m\]"
	RED="\[\e[0;31m\]"
	END="\[\e[0m\]"

	if [ "$color_prompt" = yes ]; then
	    PS1="${debian_chroot:+($debian_chroot)}"
	    PS1+="[${CYAN}\#${END}] ${BLUE}\u${END} at ${YELLOW}\h${END} in ${MAGENTA}\w${END} exited "
	    if [ "${last_command}" = "0" ]; then
			PS1+="${GREEN}0${END}"
	    else
	        PS1+="${RED}${last_command}${END}"
	    fi
		if [ "$CONQUE" = "1" ]; then
			PS1+="\n-> "
		else
			PS1+="\n→  "
			#PS1+="\n∴  "
			#PS1+="\n... \r"
		fi
	else
	    PS1='${debian_chroot:+($debian_chroot)}\u@\h: \w\n\$ '
	fi

	PS2="... "

	history -a
}

PROMPT_COMMAND='set_prompt'


## Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias lc='ls --color'
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias s='ls'
alias sl='ls'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i \
	"$([ $? = 0 ] && echo terminal || echo error)" \
	"$(history | tail -n1 | sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# random aliases
#alias VisIt=/usr/local/visit/bin/visit
alias ijulia='ipython notebook --profile julia'
alias timestamp='date +"%Y-%m-%d %r"'
alias pls='echo "I will do it, but just this once!" 1>&2; sudo $(history -p !!)'
alias setclip='xclip -selection c'
alias getclip='xclip -selection clipboard -o'
alias yacc='bison -d --verbose --debug'
alias pstree='pstree -pAn'
# next two aliases are already taken care of in ~/.ssh/config
#alias titan='ssh abyrd14@titan.ccs.ornl.gov'
#alias rhea='ssh abyrd14@rhea.ccs.ornl.gov'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


## Functions
if [ -f ~/.functions ]; then
    . ~/.functions
fi

winname Bash your head in

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
