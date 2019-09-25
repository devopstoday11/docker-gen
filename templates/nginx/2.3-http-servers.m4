{{ $enable_ipv6 := eq (or ($.Env.ENABLE_IPV6) "") "true" }}

include(2.3.1-http-default-server.m4)

{{/* ID of the container this tool is running in */}}
{{ $CurrentContainer := where $ "ID" .Docker.CurrentContainerID | first }}
{{/* Dictionary with upstream definitions.

    upstreams = {
        "safeUpstreamIdent": {
            "<IPAddress[:optionalPort]>": "commented upstream definition, e.g.: server 10.0.27.7:5000;",
        }
    }
*/}}
{{ $upstreams := dict }}

{{/*
    hosts = [{
        hosts: ["host1.com", "host2.com"]
        locations: {
            "/": {
                "upstream": "safeUpstreamIdent"
            }
        }
    }]
*/}}
{{ $hosts := array }}


{{ range $host, $containers := groupByMulti $ "Env.VIRTUAL_HOST" "," }}

    {{ $host := trim $host }}
    {{ $is_regexp := hasPrefix "~" $host }}
    {{ $upstream_name := when $is_regexp (safeIdent $host) $host }}

include(2.3.2-http-upstream.m4)

{{ end }}