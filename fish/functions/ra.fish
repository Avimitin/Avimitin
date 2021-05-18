function ra --wraps=ranger --description 'prevent nested instance'
	if test -z $RANGER_LEVEL
		ranger  $argv
	else
		exit
	end
end
