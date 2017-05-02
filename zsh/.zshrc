# ~/.zshrc

platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
	platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
	platform='darwin'
elif [[ "$unamestr" == 'MSYS'* ]]; then
	platform='msys'
fi

NEWLINE=$'\n'

setopt no_beep
setopt noflowcontrol
setopt auto_cd
setopt prompt_subst
setopt menu_complete
#setopt complete_in_word
#setopt always_to_end
setopt magic_equal_subst

# Enable history
#setopt APPEND_HISTORY
#setopt SHARE_HISTORY
#export HISTSIZE=200 # Lines of history in memory
#export SAVEHIST=1000 # Lines of history in history file
#export HISTFILE=$HOME/.zsh_history

# Disable history
#unsetopt APPEND_HISTORY
#unsetopt SHARE_HISTORY
#unset SAVEHIST
#unset HISTFILE

autoload -U select-word-style
autoload -U compinit
autoload -Uz vcs_info

select-word-style bash

zmodload zsh/complist
compinit

zstyle ':completion:*' menu select

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats $' %{\e[1;32m%}(%b)'
zstyle ':vcs_info:git*' actionformats ' %F{2}(%F{2}%b%F{3}|%F{1}%a%F{2})%f'

function precmd() {
	vcs_info
	print -Pn "\033]0;%n@%m:%~\007"
}

PROMPT=$'%{\e[1;32m%}%n@%m%{\e[0m%}:%{\e[1;34m%}%~${vcs_info_msg_0_}${NEWLINE}%{\e[0m%}%% '

# Auto change directory in Emacs term mode
if [ -n "$INSIDE_EMACS" ]; then
	function chpwd() {
		print -P '\eAnSiTc %d'
	}
	print -P '\eAnSiTu %n'
	print -P '\eAnSiTc %d'
fi

# Switch jdk
function jdk() {
	local prefix="JAVA_"
	local suffix="_HOME"
	local version="$1"
	local new_java_home="${prefix}${version}${suffix}"

	if [ -z "${(P)new_java_home}" ]; then
		echo $JAVA_VERSION
		return
	fi

	if [ ! -z "$JAVA_VERSION" ]; then
		local old_java_home="${prefix}${JAVA_VERSION}${suffix}"
		if [ ! -z "${(P)old_java_home}" ]; then
			local old_path="${(P)old_java_home}/bin"
			export PATH=$(echo $PATH | sed -E -e "s;:$old_path;;" -e "s;$old_path:?;;")
		fi
	fi

	if [ ! -z "${(P)new_java_home}" ]; then
		export JAVA_VERSION="$version"
		export JAVA_HOME="${(P)new_java_home}"
		local new_path="${(P)new_java_home}/bin"
		export PATH="$new_path:$PATH"
	fi
}

#export JAVA_7_HOME=$HOME/opt/jdk1.7.0_79
#export JAVA_8_HOME=$HOME/opt/jdk1.8.0_51
#jdk 8

-() {
	cd -
}

alias ls='ls -aF --color=auto'
alias ll='ls -l'

alias grep='grep -n --color=auto'

alias gt='git status'
alias gd='git diff'
alias gl='git log --graph --oneline --decorate'
alias ga='git add'
alias gr='cd "$(git rev-parse --show-toplevel)"'

alias ed='emacs --daemon'
alias et='emacsclient -t'
alias eek='emacsclient -e "(kill-emacs)"'

alias gvim='gvim 2>/dev/null'
alias gvimr='gvim 2>/dev/null --remote-silent'

alias rs='rails s -b 0.0.0.0'

if [ -n "$TMUX" ]; then
	alias vim='TERM=screen-256color vim'
	alias vi='TERM=screen-256color vim'
	alias htop='TERM=screen-256color htop'
fi

export EDITOR=vim
export PATH=$HOME/bin:/usr/sbin:$PATH

bindkey -e
bindkey '\eh' backward-kill-word
bindkey -M menuselect '^M' .accept-line
bindkey -M menuselect '^[[Z' reverse-menu-complete

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

if [[ $platform == 'darwin' ]]; then
	alias ls='ls -aFG'
	alias grep='grep -n --color=auto'
	alias egrep='egrep --color=auto'
fi

if [ -f ~/.zshrc.override ]; then
	. ~/.zshrc.override
fi
