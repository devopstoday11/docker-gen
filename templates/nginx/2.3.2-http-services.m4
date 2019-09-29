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

        {{ range $svcNetworkID, $svcNetwork := $service.Networks }}
            {{ range $knownNetwork := $CurrentContainer.Networks }}
                {{ if (and (ne $svcNetwork.Name "ingress") (or (eq $knownNetwork.Name $svcNetwork.Name) (eq $knownNetwork.Name "host"))) }}
                    {{ $upstreamComment := printf "service %s via %s network" $service.Name $knownNetwork.Name }}
                    {{ $upstreamIP := $svcNetwork.IP }}
                    {{ $upstreamKey := printf "%s:%s@%s" $upstreamIP $upstreamPort $svcNetwork.Name }}
                    {{ $upstreamDef := printf "server %s:%s" $upstreamIP $upstreamPort }}
                    {{ setValue $upstreamDict $upstreamKey (dict "Comment" $upstreamComment "Definition" $upstreamDef) }}
                {{ else }}
                    {{/* TODO: cannot connect to the service */}}
                {{ end }}
            {{ end }}
        {{ end }}

        {{/* locations */}}
        {{ $location := coalesce (getValue $labels "dg.nginx/location") "/" }}

        {{/* set host attributes */}}
	    {{ $locationDict := dict "Upstream" $upstreamName }}
	    {{ setValue $hostDict "Locations" (dict $location $locationDict) }}

    {{ end }}
{{ end }}