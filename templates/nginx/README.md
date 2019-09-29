# docker-ingress-nginx

## Docker-Gen Environmental Params

### Original

- DEFAULT_HOST

### New ones

#### Core Opts

- HTTP_PORT (default 80): HTTP listening port
- HTTPS_PORT (default 442): HTTPS listening port
- WORKER_PROCESSES (default "auto"): Number of Nginx worker threads
- MAX_WORKER_CONNECTIONS (default "16384"): Maximum number of simultaneous all connections that can be opened by a worker process (incl. client and proxy connections). 
- WORKER_SHUTDOWN_TIMEOUT (default "10s"): Configures a timeout for a graceful shutdown of worker processes. When the time expires, nginx will try to close all the connections currently open to facilitate shutdown.
- WORKER_CPU_AFFINITY (default ""): Binds worker processes to the sets of CPUs. Each CPU set is represented by a bitmask of allowed CPUs
- MAX_WORKER_OPEN_FILES (default 0): The limit on the maximum number of open files (RLIMIT_NOFILE) for worker processes. Used to increase the limit without restarting the main process. Default of 0 means unset.
- ENABLE_MULTI_ACCEPT (default true): If multi_accept is disabled, a worker process will accept one new connection at a time. Otherwise, a worker process will accept all new connections at a time.
- ENABLE_PCRE_JIT (default true): Enables the use of “just-in-time compilation” (PCRE JIT) for the regular expressions known by the time of configuration parsing. PCRE JIT can speed up processing of regular expressions significantly.

## Docker-Gen template functions

- *`closest $array $value`*: Returns the longest matching substring in `$array` that matches `$value`
- *`coalesce ...`*: Returns the first non-nil argument.
- *`contains $map $key`*: Returns `true` if `$map` contains `$key`. Takes maps from `string` to `string`.
- *`dict $key $value ...`*: Creates a map from a list of pairs. Each `$key` value must be a `string`, but the `$value` can be any type (or `nil`). Useful for passing more than one value as a pipeline context to subtemplates.
- *`dir $path`*: Returns an array of filenames in the specified `$path`.
- *`exists $path`*: Returns `true` if `$path` refers to an existing file or directory. Takes a string.
- *`first $array`*: Returns the first value of an array or nil if the arry is nil or empty.
- *`groupBy $containers $fieldPath`*: Groups an array of `RuntimeContainer` instances based on the values of a field path expression `$fieldPath`. A field path expression is a dot-delimited list of map keys or struct member names specifying the path from container to a nested value, which must be a string. Returns a map from the value of the field path expression to an array of containers having that value. Containers that do not have a value for the field path in question are omitted.
- *`groupByKeys $containers $fieldPath`*: Returns the same as `groupBy` but only returns the keys of the map.
- *`groupByMulti $containers $fieldPath $sep`*: Like `groupBy`, but the string value specified by `$fieldPath` is first split by `$sep` into a list of strings. A container whose `$fieldPath` value contains a list of strings will show up in the map output under each of those strings.
- *`groupByLabel $containers $label`*: Returns the same as `groupBy` but grouping by the given label's value.
- *`hasPrefix $prefix $string`*: Returns whether `$prefix` is a prefix of `$string`.
- *`hasSuffix $suffix $string`*: Returns whether `$suffix` is a suffix of `$string`.
- *`intersect $slice1 $slice2`*: Returns the strings that exist in both string slices.
- *`json $value`*: Returns the JSON representation of `$value` as a `string`.
- *`keys $map`*: Returns the keys from `$map`. If `$map` is `nil`, a `nil` is returned. If `$map` is not a `map`, an error will be thrown.
- *`last $array`*: Returns the last value of an array.
- *`parseBool $string`*: parseBool returns the boolean value represented by the string. It accepts 1, t, T, TRUE, true, True, 0, f, F, FALSE, false, False. Any other value returns an error. Alias for [`strconv.ParseBool`](http://golang.org/pkg/strconv/#ParseBool) 
- *`replace $string $old $new $count`*: Replaces up to `$count` occurences of `$old` with `$new` in `$string`. Alias for [`strings.Replace`](http://golang.org/pkg/strings/#Replace)
- *`sha1 $string`*: Returns the hexadecimal representation of the SHA1 hash of `$string`.
- *`split $string $sep`*: Splits `$string` into a slice of substrings delimited by `$sep`. Alias for [`strings.Split`](http://golang.org/pkg/strings/#Split)
- *`splitN $string $sep $count`*: Splits `$string` into a slice of substrings delimited by `$sep`, with number of substrings returned determined by `$count`. Alias for [`strings.SplitN`](https://golang.org/pkg/strings/#SplitN)
- *`trimPrefix $prefix $string`*: If `$prefix` is a prefix of `$string`, return `$string` with `$prefix` trimmed from the beginning. Otherwise, return `$string` unchanged.
- *`trimSuffix $suffix $string`*: If `$suffix` is a suffix of `$string`, return `$string` with `$suffix` trimmed from the end. Otherwise, return `$string` unchanged.
- *`trim $string`*: Removes whitespace from both sides of `$string`.
- *`when $condition $trueValue $falseValue`*: Returns the `$trueValue` when the `$condition` is `true` and the `$falseValue` otherwise
- *`where $items $fieldPath $value`*: Filters an array or slice based on the values of a field path expression `$fieldPath`. A field path expression is a dot-delimited list of map keys or struct member names specifying the path from container to a nested value. Returns an array of items having that value.
- *`whereNot $items $fieldPath $value`*: Filters an array or slice based on the values of a field path expression `$fieldPath`. A field path expression is a dot-delimited list of map keys or struct member names specifying the path from container to a nested value. Returns an array of items **not** having that value.
- *`whereExist $items $fieldPath`*: Like `where`, but returns only items where `$fieldPath` exists (is not nil).
- *`whereNotExist $items $fieldPath`*: Like `where`, but returns only items where `$fieldPath` does not exist (is nil).
- *`whereAny $items $fieldPath $sep $values`*: Like `where`, but the string value specified by `$fieldPath` is first split by `$sep` into a list of strings. The comparison value is a string slice with possible matches. Returns items which OR intersect these values.
- *`whereAll $items $fieldPath $sep $values`*: Like `whereAny`, except all `$values` must exist in the `$fieldPath`.
- *`whereLabelExists $containers $label`*: Filters a slice of containers based on the existence of the label `$label`.
- *`whereLabelDoesNotExist $containers $label`*: Filters a slice of containers based on the non-existence of the label `$label`.
- *`whereLabelValueMatches $containers $label $pattern`*: Filters a slice of containers based on the existence of the label `$label` with values matching the regular expression `$pattern`.
