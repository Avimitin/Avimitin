# Defined via `source`
function ra --wraps=ranger --description 'alias ra ranger'
	if test -z "$RANGER_LEVEL"
		ranger $argv
	else
		exit
	end
end
