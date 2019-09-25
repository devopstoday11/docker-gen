{{ define "upstream" }}
{{ if .Comment }}
		# {{ .Comment }}
{{ end }}
{{ if .Address }}
	{{/* If we got the containers from swarm and this container's port is published to host, use host IP:PORT */}}
	{{ if and .Container.Node.ID .Address.HostPort }}
		# {{ .Container.Node.Name }}/{{ .Container.Name }}
		server {{ .Container.Node.Address.IP }}:{{ .Address.HostPort }};
	{{/* If there is no swarm node or the port is not published on host, use container's IP:PORT */}}
	{{ else if .Network }}
		# {{ .Container.Name }}
		server {{ .Network.IP }}:{{ .Address.Port }};
	{{ end }}
{{ else if .Network }}
		# {{ .Container.Name }}
	{{ if .Network.IP }}
		{{ if not .Comment }}
		# network IP is known but the adress or port is not :(
		{{ end }}
		server {{ .Network.IP }} down;
	{{ else }}
		{{ if not .Comment }}
		# no address and no network IP known
		{{ end }}
		server 127.0.0.1 down;
	{{ end }}
{{ else }}
		{{ if not .Comment }}
		# no connection info available
		{{ end }}
		server 127.0.0.1 down;
{{ end }}

{{ end }}
