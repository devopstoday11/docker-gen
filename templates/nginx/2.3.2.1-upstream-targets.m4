{{ range $container := $containers }}
	{{ if $container.Service }}
		{{ range $knownNetwork := $CurrentContainer.Networks }}
			{{ range $swarmSvcNetwork := $container.Service.Networks }}
				{{ if (and (ne $swarmSvcNetwork.Name "ingress") (or (eq $knownNetwork.Name $swarmSvcNetwork.Name) (eq $knownNetwork.Name "host"))) }}
					{{ $comment := (printf "Swarm service \"%s\" can be contacted via \"%s\" network" $container.Service.Name $swarmSvcNetwork.Name) }}
					{{ $port := coalesce $container.Env.VIRTUAL_PORT "80" }}
					{{ $address := (dict "Port" $port) }}
					{{ template "upstream" (dict "Container" $container "Address" $address "Network" $swarmSvcNetwork "Comment" $comment) }}
				{{ else }}
					{{ $comment := (printf "Cannot connect to network \"%s\" of swarm service \"%s\"" $swarmSvcNetwork.Name $container.Service.Name) }}
					{{ template "upstream" (dict "Comment" $comment) }}
				{{ end }}
			{{ end }}
		{{ end }}
	{{ else }}
		{{ $addrLen := len $container.Addresses }}

		{{ range $knownNetwork := $CurrentContainer.Networks }}
			{{ range $containerNetwork := $container.Networks }}
				{{ if (and (ne $containerNetwork.Name "ingress") (or (eq $knownNetwork.Name $containerNetwork.Name) (eq $knownNetwork.Name "host"))) }}
					{{ $comment := (printf "Can be contacted via \"%s\" network" $containerNetwork.Name) }}

					{{/* If only 1 port exposed, use that */}}
					{{ if eq $addrLen 1 }}
						{{ $address := index $container.Addresses 0 }}
						{{ template "upstream" (dict "Container" $container "Address" $address "Network" $containerNetwork "Comment" $comment) }}
					{{/* If more than one port exposed, use the one matching VIRTUAL_PORT env var, falling back to standard web port 80 */}}
					{{ else }}
						{{ $port := coalesce $container.Env.VIRTUAL_PORT "80" }}
						{{ $address := where $container.Addresses "Port" $port | first }}
						{{ $address := coalesce $address (dict "Port" $port) }}
						{{ template "upstream" (dict "Container" $container "Address" $address "Network" $containerNetwork "Comment" $comment) }}
					{{ end }}
				{{ else }}
					{{ $comment := (printf "Cannot connect to \"%s\" network of this container" $containerNetwork.Name) }}
					{{ template "upstream" (dict "Comment" $comment) }}
				{{ end }}
			{{ end }}
		{{ end }}
	{{ end }}
{{ end }}