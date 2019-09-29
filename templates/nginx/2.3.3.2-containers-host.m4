


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
