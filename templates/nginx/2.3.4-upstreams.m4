{{ range $upstreamName, $upstreamNets := $globalUpstreams }}
	upstream {{ $upstreamName }} {
{{ range $upstreamNet, $upstream := $upstreamNets }}
		{{ if $upstream.Comment }}# {{ $upstream.Comment }}{{ end }}
		{{ if $upstream.Definition }}{{ $upstream.Definition }};{{ end }}
{{ end }}
	}
{{ end }}