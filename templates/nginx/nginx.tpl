

{{ $httpPort := or ($.Env.HTTP_PORT) "80" }}
{{ $httpsPort := or ($.Env.HTTPS_PORT) "443" }}

{{ define "ssl_policy" }}
{{ if eq .ssl_policy "Mozilla-Modern" }}
	ssl_protocols TLSv1.3;
	{{/* nginx currently lacks ability to choose ciphers in TLS 1.3 in configuration, see https://trac.nginx.org/nginx/ticket/1529 /*}}
	{{/* a possible workaround can be modify /etc/ssl/openssl.cnf to change it globally (see https://trac.nginx.org/nginx/ticket/1529#comment:12 ) /*}}
	{{/* explicitly set ngnix default value in order to allow single servers to override the global http value */}}
	ssl_ciphers HIGH:!aNULL:!MD5;
	ssl_prefer_server_ciphers off;
{{ else if eq .ssl_policy "Mozilla-Intermediate" }}
	ssl_protocols TLSv1.2 TLSv1.3;
	ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384';
	ssl_prefer_server_ciphers off;
{{ else if eq .ssl_policy "Mozilla-Old" }}
	ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
	ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA256:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:DES-CBC3-SHA';
	ssl_prefer_server_ciphers on;
{{ else if eq .ssl_policy "AWS-TLS-1-2-2017-01" }}
	ssl_protocols TLSv1.2 TLSv1.3;
	ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:AES128-GCM-SHA256:AES128-SHA256:AES256-GCM-SHA384:AES256-SHA256';
	ssl_prefer_server_ciphers on;
{{ else if eq .ssl_policy "AWS-TLS-1-1-2017-01" }}
	ssl_protocols TLSv1.1 TLSv1.2 TLSv1.3;
	ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:AES128-GCM-SHA256:AES128-SHA256:AES128-SHA:AES256-GCM-SHA384:AES256-SHA256:AES256-SHA';
	ssl_prefer_server_ciphers on;
{{ else if eq .ssl_policy "AWS-2016-08" }}
	ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
	ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:AES128-GCM-SHA256:AES128-SHA256:AES128-SHA:AES256-GCM-SHA384:AES256-SHA256:AES256-SHA';
	ssl_prefer_server_ciphers on;
{{ else if eq .ssl_policy "AWS-2015-05" }}
	ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
	ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:AES128-GCM-SHA256:AES128-SHA256:AES128-SHA:AES256-GCM-SHA384:AES256-SHA256:AES256-SHA:DES-CBC3-SHA';
	ssl_prefer_server_ciphers on;
{{ else if eq .ssl_policy "AWS-2015-03" }}
	ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
	ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:AES128-GCM-SHA256:AES128-SHA256:AES128-SHA:AES256-GCM-SHA384:AES256-SHA256:AES256-SHA:DHE-DSS-AES128-SHA:DES-CBC3-SHA';
	ssl_prefer_server_ciphers on;
{{ else if eq .ssl_policy "AWS-2015-02" }}
	ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
	ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:AES128-GCM-SHA256:AES128-SHA256:AES128-SHA:AES256-GCM-SHA384:AES256-SHA256:AES256-SHA:DHE-DSS-AES128-SHA';
	ssl_prefer_server_ciphers on;
{{ end }}
{{ end }}


{{ $worker_processes := or ($.Env.WORKER_PROCESSES) "auto" }}
{{ $max_worker_connections := or ($.Env.MAX_WORKER_CONNECTIONS) "16384" }}
{{ $max_worker_open_files := or ($.Env.MAX_WORKER_OPEN_FILES) "0" }}
{{ $worker_shutdown_timeout := or ($.Env.WORKER_SHUTDOWN_TIMEOUT) "10s" }}
{{ $worker_cpu_affinity := or ($.Env.WORKER_CPU_AFFINITY) "" }}

{{ $enable_multi_accept := or ($.Env.ENABLE_MULTI_ACCEPT) true }}
{{ $enable_pcre_jit := or ($.Env.ENABLE_PCRE_JIT) true }}

daemon off;
user  nginx;
worker_processes  {{ $worker_processes }};

{{ if gt (len $worker_cpu_affinity) 0 }}
worker_cpu_affinity {{ $worker_cpu_affinity }};
{{ end }}

{{ if not (eq $max_worker_open_files "0") }}
worker_rlimit_nofile {{ $max_worker_open_files }};
{{ end }}

{{/* http://nginx.org/en/docs/ngx_core_module.html#worker_shutdown_timeout */}}
{{/* avoid waiting too long during a reload */}}
worker_shutdown_timeout {{ $worker_shutdown_timeout }};

{{ if $enable_pcre_jit }}
pcre_jit on;
{{ end }}

error_log	/var/log/nginx/error.log warn;
pid				/var/run/nginx.pid;

events {
	multi_accept		{{ if $enable_multi_accept }}on{{ else }}off{{ end }};
	worker_connections	{{ $max_worker_connections }};
	use					epoll;
}

http {

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
{{ $enable_ipv6 := eq (or ($.Env.ENABLE_IPV6) "") "true" }}

	server {
		server_name _; # This is just an invalid value which will never trigger on a real hostname.
		listen {{ $httpPort }};
		{{ if $enable_ipv6 }}
		listen [::]:{{ $httpPort }};
		{{ end }}
		access_log /var/log/nginx/access.log vhost;
		return 503;
	}

{{ if (and (exists "/etc/nginx/certs/default.crt") (exists "/etc/nginx/certs/default.key")) }}
	server {
		server_name _; # This is just an invalid value which will never trigger on a real hostname.
		listen {{ $httpsPort }} ssl http2;
		{{ if $enable_ipv6 }}
		listen [::]:{{ $httpsPort }} ssl http2;
		{{ end }}
		access_log /var/log/nginx/access.log vhost;
		return 503;

		ssl_session_cache shared:SSL:50m;
		ssl_session_tickets off;
		ssl_certificate /etc/nginx/certs/default.crt;
		ssl_certificate_key /etc/nginx/certs/default.key;
	}
{{ end }}


{{/* ID of the container this tool is running in */}}
{{ $CurrentContainer := where $ "ID" .Docker.CurrentContainerID | first }}
{{/* Dictionary with upstream definitions.

    $globalUpstreams = {
        "safeUpstreamIdent": {
            "[optionalIPAddress[:optionalPort]@]network": {
                "Comment": "optional upstream comment",
                "Definition": "server 10.0.27.7:5000;",
            }
        }
    }
*/}}
{{ $globalUpstreams := dict }}

{{/*
    $globalHosts = {
        "host1.com" {
            "Locations": {
                "/": {
                    "Upstream": "safeUpstreamIdent",
					"Redirect": { // optional redirect (takes precedence Upstream) //TODO: implement in gen
						"Code": 301, // redirection HTTP code (301 default)
						"Location": "http;//$host$request_uri?myparam=something" // redirection target (can use nginx vars)
					},
					"Proto": "http", // protocol to use for communication with the container service
					"Root": "/var/www/public" // root for the location
                }
            },
			"Default": true, // whether the host is default_host (default false)
			"NetworkAccess": "external", // external (any) or internal (private subnets only)
			"CertName": "", // https TLS cert file name (without .key/.cert suffix)
			"HTTPSMethod": "redirect", // redirect (redir to https), noredirect, nohttp, nohttps
			"SSLPolicy": "", // use non-default SSL policy (allowed TLS ciphers)
			"HSTS": "max-age=31536000", // HSTS header
        }
    }
*/}}
{{ $globalHosts := dict }}

{{/* use Swarm services to generate upstreams and servers */}}
{{ range $serviceID, $service := $.Services }}
    {{ $labels := $service.Labels }}
    {{ $hosts := split (getValue $labels "dg.nginx/host") "," }}
    {{ range $host := $hosts }}
        {{ $upstreamPort := coalesce (getValue $labels "dg.nginx/port") "80" }}

        {{/* get existing or create a new dictionary for this host */}}
        {{ $hostDict := getValue $globalHosts $host dict }}
        {{ setValue $globalHosts $host $hostDict}}

        {{/* get existing or create a new dictionary for the upstream for the host */}}
        {{ $upstreamName := safeIdent $service.Name }}
        {{ $upstreamDict := getValue $globalUpstreams $upstreamName dict }}
        {{ setValue $globalUpstreams $upstreamName $upstreamDict}}

        {{ $canConnectToSvc := false }}
        {{ range $svcNetworkID, $svcNetwork := $service.Networks }}
            {{ range $knownNetwork := $CurrentContainer.Networks }}
                {{ if (and (ne $svcNetwork.Name "ingress") (or (eq $knownNetwork.Name $svcNetwork.Name) (eq $knownNetwork.Name "host"))) }}
                    {{ $canConnectToSvc = true }}
                    {{ $upstreamComment := printf "service %s via %s network" $service.Name $knownNetwork.Name }}
                    {{ $upstreamIP := $svcNetwork.IP }}
                    {{ $upstreamKey := printf "%s:%s@%s" $upstreamIP $upstreamPort $svcNetwork.Name }}
                    {{ $upstreamDef := printf "server %s:%s" $upstreamIP $upstreamPort }}
                    {{ setValue $upstreamDict $upstreamKey (dict "Comment" $upstreamComment "Definition" $upstreamDef) }}
                {{ end }}
            {{ end }}
        {{ end }}

        {{/* propagate the connection problem info to the upstream definition */}}
        {{ if not $canConnectToSvc }}
            {{ $upstreamComment := printf "unable to connect to the service %s" $service.Name }}
            {{ $upstreamDef := "server 127.0.0.1 down" }}
            {{ setValue $upstreamDict $upstreamName (dict "Comment" $upstreamComment "Definition" $upstreamDef) }}
        {{ end }}

        {{/* locations */}}
        {{ $location := coalesce (getValue $labels "dg.nginx/location") "/" }}

        {{/* set host attributes */}}
	    {{ $locationDict := dict "Upstream" $upstreamName }}
	    {{ setValue $hostDict "Locations" (dict $location $locationDict) }}

    {{ end }}
{{ end }}
{{/* original docker-gen behavior - using containers to define virtual hosts */}}
{{ range $host, $containers := groupByMulti $ "Env.VIRTUAL_HOST" "," }}

	{{ $host := trim $host }}
	{{ $upstream_name := safeIdent $host }}

	{{/* (1) get existing or create a new dictionary for the upstream for the host */}}
	{{ $upstreamDict := getValue $globalUpstreams $upstream_name dict }}

	{{ $containerSetDefinesServer := false }}

	{{ range $container := $containers }}
		{{ $addrLen := len $container.Addresses }}

		{{/* skip containers with Swarm service - service labels and virtual IP will be used for configuration of these */}}
		{{ if not $container.Service }}
			{{ $containerSetDefinesServer = true }}

			{{ range $knownNetwork := $CurrentContainer.Networks }}
				{{ range $containerNetwork := $container.Networks }}
					{{ if (and (ne $containerNetwork.Name "ingress") (or (eq $knownNetwork.Name $containerNetwork.Name) (eq $knownNetwork.Name "host"))) }}
						{{ $comment := (printf "can be contacted via %s network" $containerNetwork.Name) }}

						{{/* If only 1 port exposed, use that */}}
						{{ if eq $addrLen 1 }}
							{{ $address := index $container.Addresses 0 }}
							{{ $upstreamIP := "" }}
{{ $upstreamPort := "" }}
{{ $upstreamNet := "" }}
{{ $upstreamComment := "" }}

{{ if $address }}
	{{/* If we got the containers from swarm and this container's port is published to host, use host IP:PORT */}}
	{{ if and $container.Node.ID $address.HostPort }}
		{{ $upstreamComment = printf "%s/%s" $container.Node.Name $container.Name }}
		{{ $upstreamIP = $container.Node.Address.IP }}
		{{ $upstreamPort = $address.HostPort }}

	{{/* If there is no swarm node or the port is not published on host, use container's IP:PORT */}}
	{{ else if $containerNetwork }}
		{{ $upstreamComment = printf "container %s" $container.Name }}
		{{ $upstreamIP = $containerNetwork.IP }}
		{{ $upstreamPort = $address.Port }}
	{{ end }}
{{ else if $containerNetwork }}
	{{ if $containerNetwork.IP }}
		{{ $upstreamComment = coalesce $comment (printf "container %s - network IP is known but the adress or port is not :(" $container.Name) }}
	{{ else }}
		{{ $upstreamComment = coalesce $comment (printf "container %s - no address and no network IP known :(" $container.Name) }}
	{{ end }}
{{ else }}
		{{ $upstreamComment = coalesce $comment (printf "container %s - connection info not available" $container.Name) }}
{{ end }}

{{ $upstreamDef := "" }}
{{ $upstreamKey := "" }}
{{ if and $upstreamIP $upstreamPort }}
	{{ $upstreamDef = printf "server %s:%s" $upstreamIP $upstreamPort }}
	{{ $upstreamKey = printf "%s:%s@%s" $upstreamIP $upstreamPort $containerNetwork.Name }}
{{ else if $upstreamIP }}
	{{ $upstreamDef = printf "server %s down" $upstreamIP $upstreamPort }}
	{{ $upstreamKey = printf "%s@%s" $upstreamIP $containerNetwork.Name }}
{{ else }}
	{{ $upstreamDef = "server 127.0.0.1 down" }}
	{{ $upstreamKey = printf "%s" $containerNetwork.Name }}
{{ end }}

{{ setValue $upstreamDict $upstreamKey (dict "Comment" $upstreamComment "Definition" $upstreamDef) }}
						{{/* If more than one port exposed, use the one matching VIRTUAL_PORT env var, falling back to standard web port 80 */}}
						{{ else }}
							{{ $port := coalesce $container.Env.VIRTUAL_PORT "80" }}
							{{ $address := where $container.Addresses "Port" $port | first }}
							{{ $address := coalesce $address (dict "Port" $port) }}
							{{ $upstreamIP := "" }}
{{ $upstreamPort := "" }}
{{ $upstreamNet := "" }}
{{ $upstreamComment := "" }}

{{ if $address }}
	{{/* If we got the containers from swarm and this container's port is published to host, use host IP:PORT */}}
	{{ if and $container.Node.ID $address.HostPort }}
		{{ $upstreamComment = printf "%s/%s" $container.Node.Name $container.Name }}
		{{ $upstreamIP = $container.Node.Address.IP }}
		{{ $upstreamPort = $address.HostPort }}

	{{/* If there is no swarm node or the port is not published on host, use container's IP:PORT */}}
	{{ else if $containerNetwork }}
		{{ $upstreamComment = printf "container %s" $container.Name }}
		{{ $upstreamIP = $containerNetwork.IP }}
		{{ $upstreamPort = $address.Port }}
	{{ end }}
{{ else if $containerNetwork }}
	{{ if $containerNetwork.IP }}
		{{ $upstreamComment = coalesce $comment (printf "container %s - network IP is known but the adress or port is not :(" $container.Name) }}
	{{ else }}
		{{ $upstreamComment = coalesce $comment (printf "container %s - no address and no network IP known :(" $container.Name) }}
	{{ end }}
{{ else }}
		{{ $upstreamComment = coalesce $comment (printf "container %s - connection info not available" $container.Name) }}
{{ end }}

{{ $upstreamDef := "" }}
{{ $upstreamKey := "" }}
{{ if and $upstreamIP $upstreamPort }}
	{{ $upstreamDef = printf "server %s:%s" $upstreamIP $upstreamPort }}
	{{ $upstreamKey = printf "%s:%s@%s" $upstreamIP $upstreamPort $containerNetwork.Name }}
{{ else if $upstreamIP }}
	{{ $upstreamDef = printf "server %s down" $upstreamIP $upstreamPort }}
	{{ $upstreamKey = printf "%s@%s" $upstreamIP $containerNetwork.Name }}
{{ else }}
	{{ $upstreamDef = "server 127.0.0.1 down" }}
	{{ $upstreamKey = printf "%s" $containerNetwork.Name }}
{{ end }}

{{ setValue $upstreamDict $upstreamKey (dict "Comment" $upstreamComment "Definition" $upstreamDef) }}
						{{ end }}
					{{ else }}
						{{ $address := "" }}
						{{ $comment := (printf "container %s cannot connect to %s network" $container.Name $containerNetwork.Name) }}
						{{ $upstreamIP := "" }}
{{ $upstreamPort := "" }}
{{ $upstreamNet := "" }}
{{ $upstreamComment := "" }}

{{ if $address }}
	{{/* If we got the containers from swarm and this container's port is published to host, use host IP:PORT */}}
	{{ if and $container.Node.ID $address.HostPort }}
		{{ $upstreamComment = printf "%s/%s" $container.Node.Name $container.Name }}
		{{ $upstreamIP = $container.Node.Address.IP }}
		{{ $upstreamPort = $address.HostPort }}

	{{/* If there is no swarm node or the port is not published on host, use container's IP:PORT */}}
	{{ else if $containerNetwork }}
		{{ $upstreamComment = printf "container %s" $container.Name }}
		{{ $upstreamIP = $containerNetwork.IP }}
		{{ $upstreamPort = $address.Port }}
	{{ end }}
{{ else if $containerNetwork }}
	{{ if $containerNetwork.IP }}
		{{ $upstreamComment = coalesce $comment (printf "container %s - network IP is known but the adress or port is not :(" $container.Name) }}
	{{ else }}
		{{ $upstreamComment = coalesce $comment (printf "container %s - no address and no network IP known :(" $container.Name) }}
	{{ end }}
{{ else }}
		{{ $upstreamComment = coalesce $comment (printf "container %s - connection info not available" $container.Name) }}
{{ end }}

{{ $upstreamDef := "" }}
{{ $upstreamKey := "" }}
{{ if and $upstreamIP $upstreamPort }}
	{{ $upstreamDef = printf "server %s:%s" $upstreamIP $upstreamPort }}
	{{ $upstreamKey = printf "%s:%s@%s" $upstreamIP $upstreamPort $containerNetwork.Name }}
{{ else if $upstreamIP }}
	{{ $upstreamDef = printf "server %s down" $upstreamIP $upstreamPort }}
	{{ $upstreamKey = printf "%s@%s" $upstreamIP $containerNetwork.Name }}
{{ else }}
	{{ $upstreamDef = "server 127.0.0.1 down" }}
	{{ $upstreamKey = printf "%s" $containerNetwork.Name }}
{{ end }}

{{ setValue $upstreamDict $upstreamKey (dict "Comment" $upstreamComment "Definition" $upstreamDef) }}
					{{ end }}
				{{ end }}
			{{ end }}
		{{ end }}

	{{ end }}

	{{ if $containerSetDefinesServer }}
	{{/* (2) now that we know the upstream is going to be used, set its upstream dict to the global list of upstreams, also see (1) */}}
	{{ setValue $globalUpstreams $upstream_name $upstreamDict}}

	{{/* set server{ ... } definition with location / { ... } */}}
	


{{/* get existing or create a new dictionary for this host */}}
{{ $hostDict := getValue $globalHosts $host dict }}
{{ setValue $globalHosts $host $hostDict}}



{{/* --- DEFAULT LOCATION --- */}}
{{ $defaultLocationDict := dict "Upstream" $upstream_name }}

{{ $vhostRoot := first (groupByKeys $containers "Env.VIRTUAL_ROOT") }}
{{ if $vhostRoot }}
	{{ setValue $defaultLocationDict "Root" $vhostRoot }}
{{ end }}

{{ $proto := first (groupByKeys $containers "Env.VIRTUAL_PROTO") }}
{{ if $proto }}
	{{ setValue $defaultLocationDict "Proto" $proto }}
{{ end }}




{{/* --- HOST DICT ATTRIBUTES --- */}}
{{ setValue $hostDict "Locations" (dict "/" $defaultLocationDict) }}

{{ $networkAccess := first (groupByKeys $containers "Env.NETWORK_ACCESS") }}
{{ if $networkAccess }}
	{{ setValue $hostDict "NetworkAccess" $networkAccess }}
{{ end }}

{{ $default_host := or ($.Env.DEFAULT_HOST) "" }}
{{ if eq $host $default_host }}
	{{ setValue $hostDict "Default" true}}
{{ end }}

{{ $certName := first (groupByKeys $containers "Env.CERT_NAME") }}
{{ if $certName }}
	{{ setValue $hostDict "CertName" $certName }}
{{ end }}

{{ $httpsMethod := first (groupByKeys $containers "Env.HTTPS_METHOD") }}
{{ if $httpsMethod }}
	{{ setValue $hostDict "HTTPSMethod" $httpsMethod }}
{{ end }}

{{ $sslPolicy := first (groupByKeys $containers "Env.SSL_POLICY") }}
{{ if $sslPolicy }}
	{{ setValue $hostDict "SSLPolicy" $sslPolicy }}
{{ end }}

{{ $hsts := first (groupByKeys $containers "Env.HSTS") }}
{{ if $hsts }}
	{{ setValue $hostDict "HSTS" $hsts }}
{{ end }}

	{{ end }}

{{ end }}
{{ range $upstreamName, $upstreamNets := $globalUpstreams }}
	upstream {{ $upstreamName }} {
{{ range $upstreamNet, $upstream := $upstreamNets }}
		{{ if $upstream.Comment }}# {{ $upstream.Comment }}{{ end }}
		{{ if $upstream.Definition }}{{ $upstream.Definition }};{{ end }}
{{ end }}
	}
{{ end }}
{{ range $host, $hostDict := $globalHosts }}

{{ $default_host := or ($.Env.DEFAULT_HOST) "" }}
{{ $default_server := "" }}
{{ if getValue $hostDict "Default" }}
	{{ $default_server = "default_server" }}
{{ end }}

{{/* Get the VIRTUAL_PROTO defined by containers w/ the same vhost, falling back to "http" */}}
{{ $proto := getValue $hostDict "Proto" "http" }}

{{/* Get the NETWORK_ACCESS defined by containers w/ the same vhost, falling back to "external" */}}
{{ $network_tag := getValue $hostDict "NetworkAccess" "external" }}

{{/* Get the HTTPS_METHOD defined by containers w/ the same vhost, falling back to "redirect" */}}
{{ $https_method := getValue $hostDict "HTTPSMethod" "redirect" }}

{{/* Get the SSL_POLICY defined by containers w/ the same vhost, falling back to empty string (use default) */}}
{{ $ssl_policy := getValue $hostDict "SSLPolicy" "" }}

{{/* Get the HSTS defined by containers w/ the same vhost, falling back to "max-age=31536000" */}}
{{ $hsts := getValue $hostDict "HSTS" "max-age=31536000" }}


{{/* Get the first cert name defined by containers w/ the same vhost */}}
{{ $certName := getValue $hostDict "CertName" }}

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
		listen {{ $httpPort }} {{ $default_server }};
		{{ if $enable_ipv6 }}
		listen [::]:{{ $httpPort }} {{ $default_server }};
		{{ end }}
		access_log /var/log/nginx/access.log vhost;
		return 301 https://$host$request_uri;
	}
{{ end }}

	server {
		server_name {{ $host }};
		listen {{ $httpsPort }} ssl http2 {{ $default_server }};
		{{ if $enable_ipv6 }}
		listen [::]:{{ $httpsPort }} ssl http2 {{ $default_server }};
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

		{{ range $location, $locationDict := getValue $hostDict "Locations" }}
		location {{ $location }} {
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
		}
		{{ end }}
	}

{{ end }}{{/* if $is_https */}}

{{/* HTTP-only server */}}
{{ if or (not $is_https) (eq $https_method "noredirect") }}
	server {
		server_name {{ $host }};
		listen {{ $httpPort }} {{ $default_server }};
		{{ if $enable_ipv6 }}
		listen [::]:{{ $httpPort }} {{ $default_server }};
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

		{{ range $location, $locationDict := getValue $hostDict "Locations" }}
		location {{ $location }} {
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
		}
		{{ end }}
	}

{{/* Block SSL access if no SSL is configured for the host and default certs exist */}}
{{ if (and (not $is_https) (exists "/etc/nginx/certs/default.crt") (exists "/etc/nginx/certs/default.key")) }}
	server {
		server_name {{ $host }};
		listen {{ $httpsPort }} ssl http2 {{ $default_server }};
		{{ if $enable_ipv6 }}
		listen [::]:{{ $httpsPort }} ssl http2 {{ $default_server }};
		{{ end }}
		access_log /var/log/nginx/access.log vhost;
		return 500;

		ssl_certificate /etc/nginx/certs/default.crt;
		ssl_certificate_key /etc/nginx/certs/default.key;
	}
{{ end }}

{{ end }}{{/* if or (not $is_https) (eq $https_method "noredirect") */}}


{{ end }}{{/* range $host, $hostDict := $globalHosts */}}

{{/*
	//!!!!! DEBUG !!!!!
	// upstreams
	{{json $globalUpstreams}}

	//hosts 
	{{json $globalHosts}}
	//!!!!! END DEBUG !!!!!
*/}}

}
