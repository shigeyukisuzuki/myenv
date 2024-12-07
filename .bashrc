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

# insert timestamp to each line in history.
export HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S "

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
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
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

#:() {
if [[ -z "$TMUX" && -z "$STY" ]] && type tmux >/dev/null 2>&1; then
  option=""
  if tmux has-session -t ${SESSION_NAME}; then
    option="attach -t ${SESSION_NAME}"
  else
    option="new -s ${SESSION_NAME}"
  fi  
  tmux $option && exit
fi
#}

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

# simple file finder
function fcd() {
	if ! which fzf > /dev/null; then
		echo 'command fzf not found'
		return
	fi
	local next
	next=$(pwd)
	while true; do
		next=$(ls -aF |  fzf --reverse --prompt "$next > " | sed -E 's#[*=>@|]$##')
		if [ -z "$next" ] || [ "$next" == './' ] || [ ! -d "$next" ]; then
			break
		fi
		cd "$next"
		next=$(pwd)
	done
	FCD_SELECT=$(realpath "$next")
	echo $FCD_SELECT
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

#PS1='${debian_chroot:+($debian_chroot)}\[\e[30;47m\]\u\[\e[37;45m\]@\h\[\e[37;44m\]:\w\[\e[0m\] '
case $HOSTNAME in
	[aAnN]* ) bgHost=40  ;;
	[bBoO]* ) bgHost=41  ;;
	[cCpP]* ) bgHost=42  ;;
	[dDqQ]* ) bgHost=43  ;;
	[eErR]* ) bgHost=44  ;;
	[fFsS]* ) bgHost=45  ;;
	[gGtT]* ) bgHost=46  ;;
	[hHuU]* ) bgHost=100 ;;
	[iIvV]* ) bgHost=101 ;;
	[jJwW]* ) bgHost=102 ;;
	[kKxX]* ) bgHost=104 ;;
	[lLyY]* ) bgHost=105 ;;
	[mMzZ]* ) bgHost=106 ;;
	*		) bgHost=    ;;
esac
PS1="${debian_chroot:+($debian_chroot)}\[\e[30;47m\]\u\[\e[37;${bgHost}m\]@\h\[\e[37;44m\]:\w\[\e[0m\] "
PS2=$(echo $PS1 | sed -e "s/\${*}//g" | sed -e "s/\\e.+m//g")\>

# For using Explorer.exe in debian
export PATH=$PATH:/mnt/c/Windows/system32:/mnt/c/Windows

# script for network
## get ip version 6 full address
function ipv6full {
	sed 's/::/:x:/' | tr ':' ' ' | awk '{for(i=1;i<=NF;i++){print 8-NF,$i}}' | awk '/x/{for(i=0;i<=$1;i++){print 0}}!/x/{print $2}' | sed 's/^/000/' | sed 's/^0*\(....\)/\1/' | xargs | tr ' ' ':'
}

## get global ip address beyond NAT
mygip () {
	resolvers=(resolver1.opendns.com resolver2.opendns.com resolver3.opendns.com resolver4.opendns.com)
	result=""
	for resolver in "${resolvers}"; do
		result=$(dig +short myip.opendns.com @"${resolver}")
		if [ -n "$result" ]; then
			echo "$result"
			return
		fi
	done
	echo "cannot find resolver."
	return 1
}

# convenient for scripting
## log setting
#exec 2> "/var/log/mdpreview/$(basename $0).$(date +%Y%m%d_%H%M%S).$$"

# user define alias
if which xmllint > /dev/null; then
	alias xpath="xmllint --html --xpath 2>/dev/null"
fi

# record shell manipulating
function record () {
	recordPath=~/script/record.$(date +"%Y%m%d_%H%M%S").log 
	temp=$(mktemp -p ~)
	tail -F $temp | awk '{ print strftime("%Y/%m/%d %H:%M:%S") " " $0 } {fflush() }' >> ${recordPath}&
	recordPid=$!
	echo $recordPid
	script -fq $temp
	kill $recordPid
	rm $temp
}

# display terminal colors
function listColors () {
	echo "n  FG    BG"
	for i in $(seq 0 7); do 
		echo -e "${i} \e[3${i}m 3${i}  \e[0;4${i}m  4${i}  \e[0m"
	done
	for i in $(seq 0 7); do
		echo -e "${i} \e[9${i}m 9${i}  \e[0;10${i}m 10${i}  \e[0m"
	done
}

# extract log data between datetimes
function interDatetime (){
	# 時刻を含むログデータファイル $1
	inputFile=$1
	# ファイルの各行の時刻テキストを抽出するsedコマンド $2
	# 処理結果は、dateコマンドに入力可能であるもの。
	sedCommand=$2
	# 開始日時 $3
	startTime=$(date -d "$3" +%s) 
	[ $? -ne 0 ] && return 3
	# 終了日時 $4
	endTime=$(date -d "$4" +%s) 
	[ $? -ne 0 ] && return 4
	cat $inputFile |
	sed -E "$sedCommand" | date -f- +%s | paste - $inputFile  |
	while read timeId others; do 
		if [ $startTime -le $timeId -a $timeId -le $endTime ]; then
			echo $others
		fi
	done
}

# CLIでvimコマンドを利用するための関数
function vipe (){
  COMMAND=$(echo "$@")
  # コロン':'でESC入力を代替する場合はコメントを外す。^[はCtrl+vしてESC押して入力
  # COMMAND=$(echo "$*" |sed -e 's/:/^[/g')
  vim - -es +":norm gg" +":norm $COMMAND" +:%p +:q! |sed '1d'
}

# 短縮URLを元のURLに展開する関数
function urlunzip (){
	if command -v curl > /dev/null; then
		curl -s -i $1 -L | awk -F': ' '/location:/{print $2}' | tail -n 1
	elif command -v wget > /dev/null; then
		wget -q -S $1 -O /dev/null |& awk -F ': ' '/Location/{print $2}' | tail -n 1
	else
		echo 'curl and wget are not installed in this system.' 2> /dev/stderr
	fi
}

# スクリプト実行時に行数表示
function verboseScript (){
	# initialize
	local options arg
	options=''
	arg=''

	# parse options and arg
	while [ $# -gt 0 ]; do
		if echo "$1" | grep -qP '^-'; then
			# collect options
			options="$options $1"
		else
			# set argment
			[ -n "$arg" ] && echo '[01;31mThis function use only one argment.[0m' >&2 2>/dev/null && return 1
			arg="$1"
		fi
		shift
	done

	# validation that file exist and isn't empty
	[ -e "$arg" ] || { echo '[01;31mSpecified file does not exist.[0m' >&2 2>/dev/null && return 2; }
	[ $(wc -l "$arg" | cut -d ' ' -f 1) -gt 0 ] || { echo '[01;31mSpecified file is empty.[0m' >&2 2>/dev/null && return 3; }

	# check #! (sheban)
	if head -n 1 "$arg" | grep -qE '^#!'; then
		bodyStartLine=2
	else
		bodyStartLine=1
	fi

	# execute script in debug mode
	cat "$arg" | sed -E "${bodyStartLine}itrap ""'"'echo "$((LINENO-1)):\$ $BASH_COMMAND"'"'"' DEBUG' | bash $options
}

# 漢数字変換
function kansuuji (){
	synopsis='SYNOPSIS:\n
	kansuuji NaturalNumber\n
	echo NaturalNumber | kansuuji'
	if [ $# -gt 1 ]; then
		echo -e $synopsis
		return 1
	elif [ $# -eq 1 ]; then
		arg=$1
	elif [ $# -eq 0 ]; then
		if [ ! -p /dev/stdin ]; then
			echo -e $synopsis
			return 2
		fi
		arg=$(cat /dev/stdin)
	fi
	# validate argment
	if ! echo ${arg} | grep -qP '^0$|^[1-9]\d*$' ;then
		echo 'argment must be a NaturalNumber'
		return 3
	fi
	if [ $arg -eq 0 ];then
		echo '零'
		return 0
	fi
	# transform number to kansuuji
	echo "$arg" |
	sed 'y/0123456789/〇一二三四五六七八九/' |
	grep --color=none -o . |
	tac |
	paste - <(echo {十,百,千,万,十,百,千,億,十,百,千} | fmt -1 | cat <(echo) -) |
	grep -vE ^$'\t' |
	tac |
	sed -zE 's/(\t|\n)//g'|
	perl -lpe 's/一(?!($|万|億))//g;s/〇(千|百|十)//g;s/〇//g;s/(?<=億)万//g'
}
