function t --description 'tmux'
	if test -n "$argv"
		tmux $argv
		return
	end

	tmux new -s tmux
end
