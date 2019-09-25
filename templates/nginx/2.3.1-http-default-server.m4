	server {
		server_name _; # This is just an invalid value which will never trigger on a real hostname.
		listen 80;
		{{ if $enable_ipv6 }}
		listen [::]:80;
		{{ end }}
		access_log /var/log/nginx/access.log vhost;
		return 503;
	}

{{ if (and (exists "/etc/nginx/certs/default.crt") (exists "/etc/nginx/certs/default.key")) }}
	server {
		server_name _; # This is just an invalid value which will never trigger on a real hostname.
		listen 443 ssl http2;
		{{ if $enable_ipv6 }}
		listen [::]:443 ssl http2;
		{{ end }}
		access_log /var/log/nginx/access.log vhost;
		return 503;

		ssl_session_cache shared:SSL:50m;
		ssl_session_tickets off;
		ssl_certificate /etc/nginx/certs/default.crt;
		ssl_certificate_key /etc/nginx/certs/default.key;
	}
{{ end }}
