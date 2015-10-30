# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return;;
esac

platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
	platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
	platform='darwin'
elif [[ "$unamestr" == 'MSYS'* ]]; then
	platform='msys'
fi

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
	xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

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

if [[ $platform == 'darwin' ]]; then
	if [ -f /Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh ]; then
		. /Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh
	fi
	if [ -f /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash ]; then
		. /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash
	fi
fi

if [[ $platform == 'msys' ]]; then
	if [ -f /usr/share/git/completion/git-prompt.sh ]; then
		. /usr/share/git/completion/git-prompt.sh
	fi
	if [ -f /usr/share/git/completion/git-completion.bash ]; then
		. /usr/share/git/completion/git-completion.bash
   fi
fi

if [ "$color_prompt" = yes ]; then
	PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;32m\]$(__git_ps1) \[\033[00m\]\$ '
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
	#alias ls='ls --color=auto'
	#alias dir='dir --color=auto'
	#alias vdir='vdir --color=auto'

	#alias grep='grep --color=auto'
	#alias fgrep='fgrep --color=auto'
	#alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -alF'
#alias la='ls -A'
#alias l='ls -CF'

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

shopt -s autocd

if [[ $platform == 'darwin' ]]; then
	complete -o default -o nospace -W "$(/usr/bin/env ruby -ne 'puts $_.split(/[,\s]+/)[1..-1].reject{|host| host.match(/\*|\?/)} if $_.match(/^\s*Host\s+/);' < $HOME/.ssh/config)" scp sftp ssh
fi

# multiple JDKs

jdk() {
	local prefix="JAVA_"
	local suffix="_HOME"
	local version="$1"
	local new_java_home="${prefix}${version}${suffix}"

	if [ -z "${!new_java_home}" ]; then
		echo $JAVA_VERSION
		return
	fi

	if [ ! -z "$JAVA_VERSION" ]; then
		local old_java_home="${prefix}${JAVA_VERSION}${suffix}"
		if [ ! -z "${!old_java_home}" ]; then
			local old_path="${!old_java_home}/bin"
			export PATH=$(echo $PATH | sed -E -e "s;:$old_path;;" -e "s;$old_path:?;;")
		fi
	fi

	if [ ! -z "${!new_java_home}" ]; then
		export JAVA_VERSION="$version"
		export JAVA_HOME="${!new_java_home}"
		local new_path="${!new_java_home}/bin"
		export PATH="$new_path:$PATH"
	fi
}

#export JAVA_7_HOME=$HOME/opt/jdk1.7.0_79
#export JAVA_8_HOME=$HOME/opt/jdk1.8.0_51
#jdk 8

#

alias ls='ls -aF --color=auto'
alias ll='ls -l'

alias grep='grep -n --color=auto'

-() {
	cd -
}

alias gt='git status'
alias gd='git diff'
alias gl='git log --graph --oneline'
alias ga='git add'
alias gr='cd "$(git rev-parse --show-toplevel)"'

alias ed='emacs --daemon'
alias et='emacsclient -t'
alias eek='emacsclient -e "(kill-emacs)"'

alias gvim='gvim 2>/dev/null'
alias gvimr='gvim 2>/dev/null --remote-silent'

alias tmux='TERM=xterm-256color tmux'

# print current directory in tree view
alias lstree="ls -R | grep \":$\" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"

alias rs='rails s -b 0.0.0.0 -p 3000'

alias ds='python manage.py runserver 0.0.0.0:8000'

if [[ $platform == 'darwin' ]]; then
	alias ls='ls -aFG'
	alias grep='grep -n --color=auto'
	#alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
	#alias emacs='open -a emacs'
fi

bind '"\eh":backward-kill-word'

export EDITOR=vim
export PATH="$HOME/bin:$PATH"

if [ -f ~/.bashrc.override ]; then
	. ~/.bashrc.override
fi
