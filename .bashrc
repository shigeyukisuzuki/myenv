# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=always'
    alias dir='dir --color=always'
    alias vdir='vdir --color=always'
    alias lsn='ls --color=none'

    alias grep='grep --color=always'
    alias fgrep='fgrep --color=always'
    alias egrep='egrep --color=always'
    alias grepn='grep --color=none'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

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

# user define
if [[ -t 0 ]]; then
  stty stop undef
  stty start undef
fi
# EOF is alerted 3 times.
export IGNOREEOF=3

export EDITOR=vi
#export PAGER=view
#fbterm -- uim-fep

### when it init, run tmux.
SESSION_NAME=main

if [[ -z "$TMUX" && -z "$STY" ]] && type tmux >/dev/null 2>&1; then
  option=""
  if tmux has-session -t ${SESSION_NAME}; then
    option="attach -t ${SESSION_NAME}"
  else
    option="new -s ${SESSION_NAME}"
  fi  
  tmux $option && exit
fi

### handmade command
export SELECTED_MAX=0

function select-file () {
	MAX=$(ls -1 | wc -l)
	ls -1FL --color=never | nl
	read -p "select file(1-$MAX): " i
	if (( i < 1 || $MAX < i )); then
		echo "specified invalid number"
		return
	fi
	SELECTED_MAX=$(( SELECTED_MAX + 1 ))
	export SELECTED_FILE${SELECTED_MAX}=$(ls -1 --color=never | sed -n "${i}p")
	# get it in full path
	if [ $# = 1 ] && [ $1 = '-f' ];then
		export SELECTED_FILE${SELECTED_MAX}=$(eval echo $PWD/'$'SELECTED_FILE${SELECTED_MAX})
	fi
}

function list-select () {
	for i in $(seq $SELECTED_MAX);do
		eval echo $i: '$'SELECTED_FILE${i}
		# double expansion needs to single quotations for $
	done
}

bind '"\C-xs":"select-file"'
bind '"\C-xf":"select-file -f"'
bind '"\C-xl":"list-select"'
# The following binding is worse because variable expansion is often failed.
#bind '"\C-xs":"select-file\" $SELECTED_FILE\e\C-e\""'
bind '"\C-xw":"\"$SELECTED_FILE\""'
# Following an assignment to bind-x to use prompting cause hang up. Don't use.
#bind -x '"\C-xS":"select-file"'

# instant path edit
bind '"\C-x/":"\C-x\C-r\C-r/"'
bind '"\C-x&":"\C-a\C-s&\C-k"'
#bind '"\C-x&":"\C-x\C-r\C-r&"'
#bind '"\C-x\C-v": vi-editing-mode'
#bind '"\C-x\C-m": emacs-editing-mode'

# brackeing
bind '"\C-x\x27":"\x27\eb\x27\ef"'	# \x27='(single quote)
bind '"\C-x$\x27":"\x27\eb$\x27\ef"'	# \x27='(single quote)
bind '"\C-x\"":"\"\eb\"\ef"'
bind '"\C-x$\"":"\"\eb$\"\ef"'
bind '"\C-x}":"}\eb{\ef"'
bind '"\C-x$}":"}\eb${\ef"'
bind '"\C-x)":")\eb(\ef"'
bind '"\C-x$)":")\eb$(\ef"'
bind '"\C-x]":" ]\eb[ \ef"'  # spaces need for squaring bracket a condition expression.
bind '"\C-x]]":" ]]\eb[[ \ef"'  # spaces need for squaring bracket a condition expression.

# call pager/editor
bind '"\C-xp":" | less -R"'
bind '"\C-xv":" +%p +q!"'

bind -x '"\ej":ls -ACF'
bind -x '"\e[B":ls -ACF'
#bind -x '"\el":ls -lF'
bind -x '"\eo":ls -1 | nl'
bind -x '"\ed":ls /dev/'
bind -x '"\ek":cd ..;echo "====> $PWD"'
#bind -x '"\e[A":cd ..;echo "====> $PWD"'
bind -x '"\e~":cd ~;echo "====> $PWD"'
#bind -x '"\e/":cd /;echo "====> $PWD"'
bind -x '"\ep":ps alx | less'
bind -x '"\et":date "+%Y%m%d"'

#PS1='${debian_chroot:+($debian_chroot)}\e[30;47m\t\e[39;45m\u\e[43m\h\e[44m\w\e[0m '
PS1='${debian_chroot:+($debian_chroot)}\[\e[30;47m\]\u\[\e[37;45m\]@\h\[\e[37;44m\]:\w\[\e[0m\] '
PS2=$(echo $PS1 | sed -e "s/\${*}//g" | sed -e "s/\\e.+m//g")\>

# For using Explorer.exe in debian
export PATH=$PATH:/mnt/c/Windows/system32:/mnt/c/Windows

function ipv6full {
	sed 's/::/:x:/' | tr ':' ' ' | awk '{for(i=1;i<=NF;i++){print 8-NF,$i}}' | awk '/x/{for(i=0;i<=$1;i++){print 0}}!/x/{print $2}' | sed 's/^/000/' | sed 's/^0*\(....\)/\1/' | xargs | tr ' ' ':'
}

# convenient for scripting
## log setting
#exec 2> "/var/log/mdpreview/$(basename $0).$(date +%Y%m%d_%H%M%S).$$"

# user define alias
if which xmllint > /dev/null; then
	alias xpath="xmllint --html --xpath 2>/dev/null"
fi
