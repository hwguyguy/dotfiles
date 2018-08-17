platform='unknown'
unamestr=`uname`
if [[ $unamestr == 'Linux' ]]; then
	platform='linux'
elif [[ $unamestr == 'Darwin' ]]; then
	platform='darwin'
elif [[ $unamestr == 'MSYS'* ]]; then
	platform='msys'
fi

setopt auto_cd
#setopt always_to_end
setopt menu_complete
setopt magic_equal_subst
setopt no_flow_control
setopt prompt_subst
setopt no_beep

# Enable history
#setopt append_history
#setopt share_history
#HISTSIZE=200 # Lines of history in memory
#SAVEHIST=1000 # Lines of history in history file
#HISTFILE=$HOME/.zsh_history

# Disable history
#unsetopt append_history
#unsetopt share_history
#unset SAVEHIST
#unset HISTFILE

autoload -U select-word-style
autoload -U compinit

select-word-style bash

zmodload zsh/complist
compinit

zstyle ':completion:*' menu select

prompt_newline=$'\n%{\r%}'

if [[ $EUID == 0 ]]; then
	PS1=$'%{\e[1;32m%}%n@%m%{\e[0m%}:%{\e[1;34m%}%~ %{\e[0m%}%# '
else
	autoload -Uz vcs_info
	zstyle ':vcs_info:*' enable git
	zstyle ':vcs_info:git*' formats $' %{\e[1;32m%}(%b)'
	zstyle ':vcs_info:git*' actionformats ' %F{2}(%F{2}%b%F{3}|%F{1}%a%F{2})%f'

	precmd() {
		vcs_info
		print -Pn '\e]0;%n@%m:%~\a' # Terminal title
	}

	PS1=$'%{\e[1;32m%}%n@%m%{\e[0m%}:%{\e[1;34m%}%~${vcs_info_msg_0_}$prompt_newline%{\e[0m%}%# '

	[ -x /usr/bin/lesspipe.sh ] && eval "$(SHELL=/bin/sh /usr/bin/lesspipe.sh)"
fi

if [[ -n $INSIDE_EMACS ]]; then
	# Auto change directory in Emacs term mode
	chpwd() {
		print -P '\eAnSiTc %d'
	}
	print -P '\eAnSiTu %n'
	print -P '\eAnSiTc %d'

	if [[ $EUID != 0 ]]; then
		PS1=$'%{\e[1;32m%}%n@%m%{\e[0m%}:%{\e[1;34m%}%~${vcs_info_msg_0_} %{\e[0m%}%# '
	fi
fi

-() {
	cd -
}

alias ls='ls -aF --color=auto'
alias ll='ls -l'
alias sl=ls
alias l=ls
alias s=ls

alias grep='grep -n --color=auto'

alias g='git'
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
rake() { if [ -f bin/rake  ]; then bin/rake "$@"; else bundle exec rake "$@"; fi }

if [ -n "$TMUX" ]; then
	alias vim='TERM=screen-256color vim'
	alias vi='TERM=screen-256color vim'
	alias htop='TERM=screen-256color htop'
fi

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

[ -f ~/.zshrc.override ] && source ~/.zshrc.override
