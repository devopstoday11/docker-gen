module github.com/k3a/docker-gen

go 1.12

require (
	github.com/BurntSushi/toml v0.0.0-20150501104042-056c9bc7be71
	github.com/docker/docker v0.0.0-20171014114940-f2afa2623594
	github.com/docker/go-units v0.3.2
	github.com/fsouza/go-dockerclient v0.0.0-20171009031830-d2a6d0596004
	github.com/gorilla/mux v0.0.0-20160718151158-d391bea3118c
	github.com/jwilder/docker-gen v0.0.0-00010101000000-000000000000
	golang.org/x/net v0.0.0-20171004034648-a04bdaca5b32
)

//replace github.com/jwilder/docker-gen => github.com/k3a/docker-gen v0.0.0-20181026015631-4edc190faa34
replace github.com/jwilder/docker-gen => ./
