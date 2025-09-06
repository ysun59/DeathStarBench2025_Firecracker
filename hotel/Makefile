BASE_APPS = consul jaeger memcached mongodb hotel
BASE_TARGETS = $(addprefix base-,$(BASE_APPS))

.PHONY: build clean network run cpuset stop download-kernel base-all $(BASE_TARGETS)

base-all: $(BASE_TARGETS)

$(BASE_TARGETS): base-%: .built-%

.built-%: $(wildcard base/$*)
	./base/$*/build.sh

build:
	./build.sh

clean:
	./cleanup.sh

network:
	./network.sh

run:
	./firecracker.py prepare-tap-devices
	./run.sh

cpuset:
	./cpuset.sh

stop:
	./stop.sh

download-kernel:
	wget "https://s3.amazonaws.com/spec.ccfc.min/firecracker-ci/v1.12/x86_64/vmlinux-6.1.128"
