function set_proxy --description "easily set http proxy"
	if test -z $argv[1]
		__proxy_print_help
		return 0
	end

	switch $argv[1]
		case help
			__proxy_print_help
		case host_clash
			set host_ip (cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}')
			__set_proxy $host_ip 7890
		case local_clash
			__set_proxy '127.0.0.1' 7890
		case host
			set host_ip (cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}')
			set port $argv[2]
			__set_proxy $host_ip $port
		case local
			__set_proxy 127.0.0.1 $argv[2]
		case '*'
			__set_proxy $argv[1] $argv[2]
	end
end

function __set_proxy
	set -x http_proxy "http://$argv[1]:$argv[2]"
	set -x https_proxy $http_proxy
end

function __proxy_print_help
	echo "Available options:"
	echo "help                       get help information "
	echo "host_clash                 set server ip to host ip and port to 7890, suitable for wsl and VM user"
	echo "local_clash                set server ip to local and port to 7890"
	echo "host {{PORT (integer)}}    set server ip to host ip and a custom port. Eg.set_proxy host 11451"
	echo "local {{PORT (integer)}}   set server ip to local ip and a custom port. Eg.set_proxy local 11451"
	echo "{{CUSTOM_IP}} {{PORT}}     custom ip and port, no http prefix needed"
end
