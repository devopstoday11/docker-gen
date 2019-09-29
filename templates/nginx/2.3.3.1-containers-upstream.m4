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