		{{ if eq $proto "uwsgi" }}
			include uwsgi_params;
			uwsgi_pass {{ trim $proto }}://{{ trim $upstream_name }};
		{{ else if eq $proto "fastcgi" }}
			root   {{ trim $vhost_root }};
			include fastcgi.conf;
			fastcgi_pass {{ trim $upstream_name }};
		{{ else }}
			proxy_pass {{ trim $proto }}://{{ trim $upstream_name }};
		{{ end }}

		{{ if (exists (printf "/etc/nginx/htpasswd/%s" $host)) }}
			auth_basic	"Restricted {{ $host }}";
			auth_basic_user_file	{{ (printf "/etc/nginx/htpasswd/%s" $host) }};
		{{ end }}
		{{ if (exists (printf "/etc/nginx/vhost.d/%s_location" $host)) }}
			include {{ printf "/etc/nginx/vhost.d/%s_location" $host}};
		{{ else if (exists "/etc/nginx/vhost.d/default_location") }}
			include /etc/nginx/vhost.d/default_location;
		{{ end }}