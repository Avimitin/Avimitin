function nvm
	echo "==checking nvm=="
	if not type -q bass
		echo "No bass, try to use fisher install"
		
		if not type -q fisher
			echo "no fisher, install fisher: https://github.com/jorgebucaran/fisher"
			exit 1
		end

		fisher install bass
	end

	if not test -d ~/.nvm
		echo "Install nvm: https://github.com/nvm-sh/nvm"
		exit 1
	end

	bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv
end
