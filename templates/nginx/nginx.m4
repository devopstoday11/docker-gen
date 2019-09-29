changequote([[,]])

{{ $httpPort := or ($.Env.HTTP_PORT) "80" }}
{{ $httpsPort := or ($.Env.HTTPS_PORT) "443" }}

include(def/ssl_policy.m4)

include(1-global.m4)

include(2-http.m4)
