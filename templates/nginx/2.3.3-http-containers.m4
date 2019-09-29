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
							include(2.3.3.1-containers-upstream.m4)
						{{/* If more than one port exposed, use the one matching VIRTUAL_PORT env var, falling back to standard web port 80 */}}
						{{ else }}
							{{ $port := coalesce $container.Env.VIRTUAL_PORT "80" }}
							{{ $address := where $container.Addresses "Port" $port | first }}
							{{ $address := coalesce $address (dict "Port" $port) }}
							include(2.3.3.1-containers-upstream.m4)
						{{ end }}
					{{ else }}
						{{ $address := "" }}
						{{ $comment := (printf "container %s cannot connect to %s network" $container.Name $containerNetwork.Name) }}
						include(2.3.3.1-containers-upstream.m4)
					{{ end }}
				{{ end }}
			{{ end }}
		{{ end }}

	{{ end }}

	{{ if $containerSetDefinesServer }}
	{{/* (2) now that we know the upstream is going to be used, set its upstream dict to the global list of upstreams, also see (1) */}}
	{{ setValue $globalUpstreams $upstream_name $upstreamDict}}

	{{/* set server{ ... } definition with location / { ... } */}}
	include(2.3.3.2-containers-host.m4)
	{{ end }}

{{ end }}