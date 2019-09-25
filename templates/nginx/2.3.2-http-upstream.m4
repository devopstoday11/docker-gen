	# {{ $host }}
	upstream {{ $upstream_name }} {
		include(2.3.2.1-upstream-targets.m4)
	}

	include(2.3.2.2-upstream-server.m4)