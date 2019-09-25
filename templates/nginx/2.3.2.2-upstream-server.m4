{{ $default_host := or ($.Env.DEFAULT_HOST) "" }}
{{ $default_server := index (dict $host "" $default_host "default_server") $host }}

{{/* Get the VIRTUAL_PROTO defined by containers w/ the same vhost, falling back to "http" */}}
{{ $proto := trim (or (first (groupByKeys $containers "Env.VIRTUAL_PROTO")) "http") }}

{{/* Get the NETWORK_ACCESS defined by containers w/ the same vhost, falling back to "external" */}}
{{ $network_tag := or (first (groupByKeys $containers "Env.NETWORK_ACCESS")) "external" }}

{{/* Get the HTTPS_METHOD defined by containers w/ the same vhost, falling back to "redirect" */}}
{{ $https_method := or (first (groupByKeys $containers "Env.HTTPS_METHOD")) "redirect" }}

{{/* Get the SSL_POLICY defined by containers w/ the same vhost, falling back to empty string (use default) */}}
{{ $ssl_policy := or (first (groupByKeys $containers "Env.SSL_POLICY")) "" }}

{{/* Get the HSTS defined by containers w/ the same vhost, falling back to "max-age=31536000" */}}
{{ $hsts := or (first (groupByKeys $containers "Env.HSTS")) "max-age=31536000" }}

{{/* Get the VIRTUAL_ROOT By containers w/ use fastcgi root */}}
{{ $vhost_root := or (first (groupByKeys $containers "Env.VIRTUAL_ROOT")) "/var/www/public" }}


{{/* Get the first cert name defined by containers w/ the same vhost */}}
{{ $certName := (first (groupByKeys $containers "Env.CERT_NAME")) }}

{{/* Get the best matching cert  by name for the vhost. */}}
{{ $vhostCert := "" }}
{{ if (exists "/etc/nginx/certs") }}
    {{ $vhostCert := (closest (dir "/etc/nginx/certs") (printf "%s.crt" $host)) }}
{{ end }}

{{/* vhostCert is actually a filename so remove any suffixes since they are added later */}}
{{ $vhostCert := trimSuffix ".crt" $vhostCert }}
{{ $vhostCert := trimSuffix ".key" $vhostCert }}

{{/* Use the cert specified on the container or fallback to the best vhost match */}}
{{ $cert := (coalesce $certName $vhostCert) }}

{{ $is_https := (and (ne $https_method "nohttps") (ne $cert "") (exists (printf "/etc/nginx/certs/%s.crt" $cert)) (exists (printf "/etc/nginx/certs/%s.key" $cert))) }}

{{/* HTTPS-capable server with optional redirect from HTTP */}}
{{ if $is_https }}

{{ if eq $https_method "redirect" }}
	server {
		server_name {{ $host }};
		listen 80 {{ $default_server }};
		{{ if $enable_ipv6 }}
		listen [::]:80 {{ $default_server }};
		{{ end }}
		access_log /var/log/nginx/access.log vhost;
		return 301 https://$host$request_uri;
	}
{{ end }}

	server {
		server_name {{ $host }};
		listen 443 ssl http2 {{ $default_server }};
		{{ if $enable_ipv6 }}
		listen [::]:443 ssl http2 {{ $default_server }};
		{{ end }}
		access_log /var/log/nginx/access.log vhost;

		{{ if eq $network_tag "internal" }}
		# Only allow traffic from internal clients
		include /etc/nginx/network_internal.conf;
		{{ end }}

		{{ template "ssl_policy" (dict "ssl_policy" $ssl_policy) }}

		ssl_session_timeout 5m;
		ssl_session_cache shared:SSL:50m;
		ssl_session_tickets off;

		ssl_certificate /etc/nginx/certs/{{ (printf "%s.crt" $cert) }};
		ssl_certificate_key /etc/nginx/certs/{{ (printf "%s.key" $cert) }};

		{{ if (exists (printf "/etc/nginx/certs/%s.dhparam.pem" $cert)) }}
		ssl_dhparam {{ printf "/etc/nginx/certs/%s.dhparam.pem" $cert }};
		{{ end }}

		{{ if (exists (printf "/etc/nginx/certs/%s.chain.pem" $cert)) }}
		ssl_stapling on;
		ssl_stapling_verify on;
		ssl_trusted_certificate {{ printf "/etc/nginx/certs/%s.chain.pem" $cert }};
		{{ end }}

		{{ if (not (or (eq $https_method "noredirect") (eq $hsts "off"))) }}
		add_header Strict-Transport-Security "{{ trim $hsts }}" always;
		{{ end }}

		{{ if (exists (printf "/etc/nginx/vhost.d/%s" $host)) }}
		include {{ printf "/etc/nginx/vhost.d/%s" $host }};
		{{ else if (exists "/etc/nginx/vhost.d/default") }}
		include /etc/nginx/vhost.d/default;
		{{ end }}

		location / {
			include(2.3.2.2.1-location-body.m4)
		}
	}

{{ end }}{{/* if $is_https */}}

{{/* HTTP-only server */}}
{{ if or (not $is_https) (eq $https_method "noredirect") }}
	server {
		server_name {{ $host }};
		listen 80 {{ $default_server }};
		{{ if $enable_ipv6 }}
		listen [::]:80 {{ $default_server }};
		{{ end }}
		access_log /var/log/nginx/access.log vhost;

		{{ if eq $network_tag "internal" }}
		# Only allow traffic from internal clients
		include /etc/nginx/network_internal.conf;
		{{ end }}

		{{ if (exists (printf "/etc/nginx/vhost.d/%s" $host)) }}
		include {{ printf "/etc/nginx/vhost.d/%s" $host }};
		{{ else if (exists "/etc/nginx/vhost.d/default") }}
		include /etc/nginx/vhost.d/default;
		{{ end }}

		location / {
			include(2.3.2.2.1-location-body.m4)
		}
	}

{{/* Block SSL access if no SSL is configured for the host and default certs exist */}}
{{ if (and (not $is_https) (exists "/etc/nginx/certs/default.crt") (exists "/etc/nginx/certs/default.key")) }}
	server {
		server_name {{ $host }};
		listen 443 ssl http2 {{ $default_server }};
		{{ if $enable_ipv6 }}
		listen [::]:443 ssl http2 {{ $default_server }};
		{{ end }}
		access_log /var/log/nginx/access.log vhost;
		return 500;

		ssl_certificate /etc/nginx/certs/default.crt;
		ssl_certificate_key /etc/nginx/certs/default.key;
	}
{{ end }}

{{ end }}{{/* if or (not $is_https) (eq $https_method "noredirect") */}}