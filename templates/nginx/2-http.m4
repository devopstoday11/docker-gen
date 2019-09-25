http {
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

include(2.1-http-global.m4)
include(2.2-http-proxy.m4)
include(2.3-http-servers.m4)

}