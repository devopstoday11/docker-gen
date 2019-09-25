	{{ if (exists "/etc/nginx/proxy.conf") }}
	include /etc/nginx/proxy.conf;
	{{ else }}
	# HTTP 1.1 support
	proxy_http_version 1.1;
	proxy_buffering off;
	proxy_set_header Host $http_host;
	proxy_set_header Upgrade $http_upgrade;
	proxy_set_header Connection $proxy_connection;
	proxy_set_header X-Real-IP $remote_addr;
	proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
	proxy_set_header X-Forwarded-Proto $proxy_x_forwarded_proto;
	proxy_set_header X-Forwarded-Ssl $proxy_x_forwarded_ssl;
	proxy_set_header X-Forwarded-Port $proxy_x_forwarded_port;

	# Mitigate httpoxy attack (see README for details)
	proxy_set_header Proxy "";
	{{ end }}