set DEFAULT_SESSION_NAME 'MUX-WORK'

function t --description 'tmux'
	if test -n "$argv"
		tmux $argv
		return
	end

	set DEFAULT_SESSION_RUNNING (tmux list-sessions | grep $DEFAULT_SESSION_NAME)
	
	if test -n "$DEFAULT_SESSION_RUNNING"
		tmux a -t $DEFAULT_SESSION_NAME
	else
	  tmux new -s $DEFAULT_SESSION_NAME
	end
end
