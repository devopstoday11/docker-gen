	# If we receive X-Forwarded-Proto, pass it through; otherwise, pass along the
	# scheme used to connect to this server
	map $http_x_forwarded_proto $proxy_x_forwarded_proto {
		default $http_x_forwarded_proto;
		''      $scheme;
	}

	# If we receive X-Forwarded-Port, pass it through; otherwise, pass along the
	# server port the client connected to
	map $http_x_forwarded_port $proxy_x_forwarded_port {
		default $http_x_forwarded_port;
		''      $server_port;
	}

	# If we receive Upgrade, set Connection to "upgrade"; otherwise, delete any
	# Connection header that may have been passed to this server
	map $http_upgrade $proxy_connection {
		default upgrade;
		'' close;
	}

	# Apply fix for very long server names
	server_names_hash_bucket_size 128;

	# Default dhparam
	{{ if (exists "/etc/nginx/dhparam/dhparam.pem") }}
	ssl_dhparam /etc/nginx/dhparam/dhparam.pem;
	{{ end }}

	# Set appropriate X-Forwarded-Ssl header
	map $scheme $proxy_x_forwarded_ssl {
		default off;
		https on;
	}

	include       mime.types;
	default_type  application/octet-stream;

	#log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
	#                  '$status $body_bytes_sent "$http_referer" '
	#                  '"$http_user_agent" "$http_x_forwarded_for"';

	#access_log  logs/access.log  main;

	sendfile        on;
	#tcp_nopush     on;

	keepalive_timeout  65;

	#gzip  on;

	gzip_types text/plain text/css application/javascript application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;

	log_format vhost '$host $remote_addr - $remote_user [$time_local] '
		'"$request" $status $body_bytes_sent '
		'"$http_referer" "$http_user_agent"';

	access_log off;

	{{/* Get the SSL_POLICY defined by this container, falling back to "Mozilla-Intermediate" */}}
	{{ $ssl_policy := or ($.Env.SSL_POLICY) "Mozilla-Intermediate" }}
	{{ template "ssl_policy" (dict "ssl_policy" $ssl_policy) }}

	{{ if $.Env.RESOLVERS }}
	resolver {{ $.Env.RESOLVERS }};
	{{ end }}