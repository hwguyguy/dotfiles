# ~/.zshrc

setopt no_beep
setopt auto_cd
setopt prompt_subst
#setopt complete_in_word
#setopt always_to_end

autoload -U select-word-style
autoload -U compinit
autoload -Uz vcs_info
#autoload -U colors && colors

select-word-style bash

compinit

#zstyle ':vcs_info:*' stagedstr 'M'
#zstyle ':vcs_info:*' unstagedstr 'M'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' actionformats ' %F{2}[%F{2}%b%F{3}|%F{1}%a%F{2}]%f '
#zstyle ':vcs_info:*' formats ' %F{2}[%F{2}%b%F{2}] %F{2}%c%F{3}%u%f'
zstyle ':vcs_info:*' formats ' %F{2}[%F{2}%b%F{2}]'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
zstyle ':vcs_info:*' enable git
#+vi-git-untracked() {
#	if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true'  ]] && \
#		[[ $(git ls-files --other --directory --exclude-standard | sed q | wc -l | tr -d ' ') == 1  ]] ; then
#	hook_com[unstaged]+='%F{1}??%f'
#	fi
#}

precmd() {
	vcs_info
}

PROMPT=$'%{\e[01;32m%}%n@%m%{\e[00m%}:%{\e[01;34m%}%~${vcs_info_msg_0_} %{\e[00m%}# '
#PROMPT="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m:%{$fg_no_bold[yellow]%}%~ %{$reset_color%}# "
#RPROMPT="[%{$fg_no_bold[yellow]%}%?%{$reset_color%}]"

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

if [ -f ~/.zshrc.override ]; then
	. ~/.zshrc.override
fi
