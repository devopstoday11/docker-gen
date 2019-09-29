package dockergen

import (
	"bufio"
	"encoding/json"
	"os"
	"regexp"
	"sync"

	docker "github.com/fsouza/go-dockerclient"
)

var (
	mu         sync.RWMutex
	dockerInfo Docker
	dockerEnv  *docker.Env
	services   Services
)

// Context sent to template generation
type Context []*RuntimeContainer

// Services from Docker Swarm
type Services map[string]*Service

// Strings returns JSON human-readable representation of the context
func (c *Context) String() string {
	obj := map[string]interface{}{
		".":         c,
		".Env":      c.Env(),
		".Docker":   c.Docker(),
		".Services": c.Services(),
	}

	byts, _ := json.MarshalIndent(obj, "", "  ")
	return string(byts)
}

// Env returns environmental variables of the generator
func (c *Context) Env() map[string]string {
	return splitKeyValueSlice(os.Environ())
}

// Docker returns info of the running Docker daemon
func (c *Context) Docker() Docker {
	mu.RLock()
	defer mu.RUnlock()

	return dockerInfo
}

// Services returns currently known Swarm services
func (c *Context) Services() Services {
	mu.RLock()
	defer mu.RUnlock()

	return services
}

func setServerInfo(d *docker.DockerInfo) {
	mu.Lock()
	defer mu.Unlock()

	dockerInfo = Docker{
		Name:               d.Name,
		NumContainers:      d.Containers,
		NumImages:          d.Images,
		Version:            dockerEnv.Get("Version"),
		ApiVersion:         dockerEnv.Get("ApiVersion"),
		GoVersion:          dockerEnv.Get("GoVersion"),
		OperatingSystem:    dockerEnv.Get("Os"),
		Architecture:       dockerEnv.Get("Arch"),
		CurrentContainerID: GetCurrentContainerID(),
	}
}

func setDockerEnv(d *docker.Env) {
	mu.Lock()
	defer mu.Unlock()

	dockerEnv = d
}

func setServices(s Services) {
	mu.Lock()
	defer mu.Unlock()

	services = s
}

// Address is IP address and port
type Address struct {
	IP           string
	IP6LinkLocal string
	IP6Global    string
	Port         string
	HostPort     string
	Proto        string
	HostIP       string
}

// Network info
type Network struct {
	IP                  string
	Name                string
	Gateway             string
	EndpointID          string
	IPv6Gateway         string
	GlobalIPv6Address   string
	MacAddress          string
	GlobalIPv6PrefixLen int
	IPPrefixLen         int
}

// Volume info
type Volume struct {
	Path      string
	HostPath  string
	ReadWrite bool
}

// State holds container state
type State struct {
	Running bool
}

// RuntimeContainer holds info about a container
type RuntimeContainer struct {
	ID           string
	Addresses    []Address
	Networks     []Network
	Gateway      string
	Name         string
	Hostname     string
	Image        DockerImage
	Env          map[string]string
	Volumes      map[string]Volume
	Node         Node
	Service      *Service
	Labels       map[string]string
	IP           string
	IP6LinkLocal string
	IP6Global    string
	Mounts       []Mount
	State        State
}

// Equals returns true if the specified container represents the same container
func (r *RuntimeContainer) Equals(o RuntimeContainer) bool {
	return r.ID == o.ID && r.Image == o.Image
}

// PublishedAddresses returns the list of published addresses
func (r *RuntimeContainer) PublishedAddresses() []Address {
	mapped := []Address{}
	for _, address := range r.Addresses {
		if address.HostPort != "" {
			mapped = append(mapped, address)
		}
	}
	return mapped
}

// Service is a Docker Swarm service
type Service struct {
	ID       string
	Name     string
	Labels   map[string]string
	Networks map[string]ServiceNetwork
}

// DockerImage is a Docker image with repo and tag
type DockerImage struct {
	Registry   string
	Repository string
	Tag        string
}

func (i *DockerImage) String() string {
	ret := i.Repository
	if i.Registry != "" {
		ret = i.Registry + "/" + i.Repository
	}
	if i.Tag != "" {
		ret = ret + ":" + i.Tag
	}
	return ret
}

// Node is a Swarm node
type Node struct {
	ID      string
	Name    string
	Address Address
}

// ServiceNetwork holds network info of a Swarm service
type ServiceNetwork struct {
	IP     string
	Name   string
	Scope  string
	Driver string
}

// Mount info
type Mount struct {
	Name        string
	Source      string
	Destination string
	Driver      string
	Mode        string
	RW          bool
}

// Docker info
type Docker struct {
	Name               string
	NumContainers      int
	NumImages          int
	Version            string
	ApiVersion         string
	GoVersion          string
	OperatingSystem    string
	Architecture       string
	CurrentContainerID string
}

// GetCurrentContainerID returns the Docker container ID of the container
//  the generator is running in or an empty string if it is not running in a container.
func GetCurrentContainerID() string {
	file, err := os.Open("/proc/self/cgroup")

	if err != nil {
		return ""
	}

	reader := bufio.NewReader(file)
	scanner := bufio.NewScanner(reader)
	scanner.Split(bufio.ScanLines)

	for scanner.Scan() {
		_, lines, err := bufio.ScanLines([]byte(scanner.Text()), true)
		if err == nil {
			strLines := string(lines)
			if id := matchDockerCurrentContainerID(strLines); id != "" {
				return id
			} else if id := matchECSCurrentContainerID(strLines); id != "" {
				return id
			}
		}
	}

	return ""
}

func matchDockerCurrentContainerID(lines string) string {
	regex := "/docker[/-]([[:alnum:]]{64})(\\.scope)?$"
	re := regexp.MustCompilePOSIX(regex)

	if re.MatchString(lines) {
		submatches := re.FindStringSubmatch(string(lines))
		containerID := submatches[1]

		return containerID
	}
	return ""
}

func matchECSCurrentContainerID(lines string) string {
	regex := "/ecs\\/[^\\/]+\\/(.+)$"
	re := regexp.MustCompilePOSIX(regex)

	if re.MatchString(string(lines)) {
		submatches := re.FindStringSubmatch(string(lines))
		containerID := submatches[1]

		return containerID
	}

	return ""
}
