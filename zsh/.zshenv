path=(
	$HOME/bin
	$HOME/.local/bin
	/usr/sbin
	$path
)

export EDITOR=vim

[ -f ~/.zshenv.override ] && source ~/.zshenv.override
