export EDITOR=vim

path=(
	$HOME/bin
	/usr/sbin
	$path
)

[ -f ~/.zshenv.override ] && source ~/.zshenv.override
