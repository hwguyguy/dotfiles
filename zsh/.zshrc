# ~/.zshrc

setopt no_beep
setopt auto_cd
setopt prompt_subst
setopt menu_complete
#setopt complete_in_word
#setopt always_to_end

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

precmd() {
	vcs_info
}

PROMPT=$'%{\e[1;32m%}%n@%m%{\e[0m%}:%{\e[1;34m%}%~${vcs_info_msg_0_} %{\e[0m%}# '

# multiple JDKs

function jdk() {
	local prefix="JAVA_"
	local suffix="_HOME"
	local version="$1"
	local new_java_home="${prefix}${version}${suffix}"

	if [ -z "${(P)new_java_home}" ]; then
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
alias gl='git log --graph --oneline'
alias ga='git add'
alias gr='cd "$(git rev-parse --show-toplevel)"'

alias ed='emacs --daemon'
alias et='emacsclient -t'
alias eek='emacsclient -e "(kill-emacs)"'

alias gvim='gvim 2>/dev/null'
alias gvimr='gvim 2>/dev/null --remote-silent'

alias tmux='TERM=xterm-256color tmux'

alias rs='rails s -b 0.0.0.0 -p 3000'

alias ds='python manage.py runserver 0.0.0.0:8000'

export EDITOR=vim
export PATH=$HOME/bin:/usr/sbin:$PATH

bindkey -e
bindkey '\eh' backward-kill-word
bindkey -M menuselect '^M' .accept-line
bindkey -M menuselect '^[[Z' reverse-menu-complete

if [ -f ~/.zshrc.override ]; then
	. ~/.zshrc.override
fi
