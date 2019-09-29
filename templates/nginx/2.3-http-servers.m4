{{ $enable_ipv6 := eq (or ($.Env.ENABLE_IPV6) "") "true" }}

include(2.3.1-http-default-server.m4)

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

include(2.3.2-http-services.m4)
include(2.3.3-http-containers.m4)
include(2.3.4-upstreams.m4)
include(2.3.5-servers.m4)

{{/*
	//!!!!! DEBUG !!!!!
	// upstreams
	{{json $globalUpstreams}}

	//hosts 
	{{json $globalHosts}}
	//!!!!! END DEBUG !!!!!
*/}}