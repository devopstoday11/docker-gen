{{ $worker_processes := or ($.Env.WORKER_PROCESSES) "auto" }}
{{ $max_worker_connections := or ($.Env.MAX_WORKER_CONNECTIONS) "16384" }}
{{ $max_worker_open_files := or ($.Env.MAX_WORKER_OPEN_FILES) "0" }}
{{ $worker_shutdown_timeout := or ($.Env.WORKER_SHUTDOWN_TIMEOUT) "10s" }}
{{ $worker_cpu_affinity := or ($.Env.WORKER_CPU_AFFINITY) "" }}

{{ $enable_multi_accept := or ($.Env.ENABLE_MULTI_ACCEPT) true }}
{{ $enable_pcre_jit := or ($.Env.ENABLE_PCRE_JIT) true }}

daemon off;
user  nginx;
worker_processes  {{ $worker_processes }};

{{ if gt (len $worker_cpu_affinity) 0 }}
worker_cpu_affinity {{ $worker_cpu_affinity }};
{{ end }}

{{ if not (eq $max_worker_open_files "0") }}
worker_rlimit_nofile {{ $max_worker_open_files }};
{{ end }}

{{/* http://nginx.org/en/docs/ngx_core_module.html#worker_shutdown_timeout */}}
{{/* avoid waiting too long during a reload */}}
worker_shutdown_timeout {{ $worker_shutdown_timeout }};

{{ if $enable_pcre_jit }}
pcre_jit on;
{{ end }}

error_log	/var/log/nginx/error.log warn;
pid				/var/run/nginx.pid;

events {
	multi_accept		{{ if $enable_multi_accept }}on{{ else }}off{{ end }};
	worker_connections	{{ $max_worker_connections }};
	use					epoll;
}