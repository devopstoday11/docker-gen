{{ $proto := trim (getValue $locationDict "Proto" "http") }}
{{ $upstream_name := trim (getValue $locationDict "Upstream" "") }}

		{{ if eq $proto "uwsgi" }}
			include uwsgi_params;
			uwsgi_pass {{ $proto }}://{{ $upstream_name }};
		{{ else if eq $proto "fastcgi" }}
			include fastcgi.conf;
			fastcgi_pass {{ $upstream_name }};
		{{ else }}
			proxy_pass {{ $proto }}://{{ $upstream_name }};
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

		{{ $root := trim (getValue $locationDict "Root" "") }}
		{{ if $root }}
			root   {{ $root }};
		{{ end }}