package dockergen

import (
	"errors"
	"strings"
	"time"

	docker "github.com/fsouza/go-dockerclient"
)

// Config represents the schema of a single config element
type Config struct {
	Template         string
	Dest             string
	Watch            bool
	Wait             *Wait
	NotifyCmd        string
	NotifyOutput     bool
	NotifyContainers map[string]docker.Signal
	NotifyServices   map[string]docker.Signal
	OnlyExposed      bool
	OnlyPublished    bool
	IncludeStopped   bool
	Interval         int
	KeepBlankLines   bool
}

// ConfigFile represents the schema of the config file
type ConfigFile struct {
	Config []Config
}

// FilterWatches returns only configs with watchers
func (c *ConfigFile) FilterWatches() ConfigFile {
	configWithWatches := []Config{}

	for _, config := range c.Config {
		if config.Watch {
			configWithWatches = append(configWithWatches, config)
		}
	}
	return ConfigFile{
		Config: configWithWatches,
	}
}

// Wait duration specification
type Wait struct {
	Min time.Duration
	Max time.Duration
}

// UnmarshalText unmarhals the object from bytes
func (w *Wait) UnmarshalText(text []byte) error {
	wait, err := ParseWait(string(text))
	if err == nil {
		w.Min, w.Max = wait.Min, wait.Max
	}
	return err
}

// ParseWait parses the wait duration
func ParseWait(s string) (*Wait, error) {
	if len(strings.TrimSpace(s)) < 1 {
		return &Wait{0, 0}, nil
	}

	parts := strings.Split(s, ":")

	var (
		min time.Duration
		max time.Duration
		err error
	)
	min, err = time.ParseDuration(strings.TrimSpace(parts[0]))
	if err != nil {
		return nil, err
	}
	if len(parts) > 1 {
		max, err = time.ParseDuration(strings.TrimSpace(parts[1]))
		if err != nil {
			return nil, err
		}
		if max < min {
			return nil, errors.New("Invalid wait interval: max must be larger than min")
		}
	} else {
		max = 4 * min
	}

	return &Wait{min, max}, nil
}
