# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return;;
esac

platform='unknown'
unamestr=`uname`
if [[ $unamestr == 'Linux' ]]; then
	platform='linux'
elif [[ $unamestr == 'Darwin' ]]; then
	platform='darwin'
elif [[ $unamestr == 'MSYS'* ]]; then
	platform='msys'
fi

shopt -s autocd
shopt -s cdspell
shopt -s checkjobs
shopt -s checkwinsize
shopt -s histappend
shopt -s no_empty_cmd_completion

HISTCONTROL=ignoredups
HISTFILE=~/.bash_history
HISTFILESIZE=2000
HISTSIZE=1000

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

# Git prompt and completion on Linux and MSYS
if [[ $platform == 'linux' || $platform == 'msys' ]]; then
	if [ -f /usr/share/git/completion/git-prompt.sh ]; then
		source /usr/share/git/completion/git-prompt.sh
	fi
	if [ -f /usr/share/git/completion/git-completion.bash ]; then
		source /usr/share/git/completion/git-completion.bash
	fi
fi

# Git prompt and completion on Mac
if [[ $platform == 'darwin' ]]; then
	if [ -f /Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh ]; then
		source /Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh
	fi
	if [ -f /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash ]; then
		source /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash
	fi
fi

# Completion for ~/.ssh/config on Mac
if [[ $platform == 'darwin' ]]; then
	complete -o default -o nospace -W "$(/usr/bin/env ruby -ne 'puts $_.split(/[,\s]+/)[1..-1].reject{|host| host.match(/\*|\?/)} if $_.match(/^\s*Host\s+/);' < $HOME/.ssh/config)" scp sftp ssh
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

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

PS1='${debian_chroot:+($debian_chroot)}'

if [ "$color_prompt" = yes ]; then
	PS1="$PS1\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w"
else
	PS1="$PS1\u@\h:\w"
fi

if [ "$(type -t __git_ps1)" = 'function' ]; then
	if [ "$color_prompt" = yes ]; then
		PS1="$PS1\[\033[01;32m\]\$(__git_ps1)"
	else
		PS1="$PS1\$(__git_ps1)"
	fi
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
	xterm*|rxvt*)
		PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
		;;
	*)
		;;
esac

if [ "$color_prompt" = yes ]; then
	PS1="$PS1 \[\033[00m\]\$ "
else
	PS1="$PS1 \$ "
fi

unset color_prompt force_color_prompt

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

alias ls='ls -aF --color=auto'
alias ll='ls -l'
alias sl=ls

alias grep='grep -n --color=auto'

-() {
	cd -
}

alias gt='git status'
alias gd='git diff'
alias gl='git log --graph --oneline --decorate'
alias ga='git add'
alias gr='cd "$(git rev-parse --show-toplevel)"'
git() {
	if [[ $1 == 'reset' && $2 == '--hard' ]]; then
		echo 'WARNING: If you really want to hard reset the repository, use "command git reset --hard"'
	else
		command git "$@"
	fi
}

alias ed='emacs --daemon'
alias et='emacsclient -t'
alias eek='emacsclient -e "(kill-emacs)"'

alias gvim='gvim 2>/dev/null'
alias gvimr='gvim 2>/dev/null --remote-silent'

# print current directory in tree view
alias lstree="ls -R | grep \":$\" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"

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
