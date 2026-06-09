.PHONY: all headless gui
FLAVOR ?= headless

all: headless gui
	echo "ok"

headless:
	FLAVOR=headless $(MAKE) flavor

gui:
	FLAVOR=gui $(MAKE) flavor

flavor:
	docker build --platform linux/arm/v7 -t chip-os-armhf .
	docker run \
		--platform linux/arm/v7 \
		--privileged \
		-e HOST_UID=$$(id -u) \
		-e HOST_GID=$$(id -g) \
		-v /dev:/dev \
		-v /proc:/proc \
		-v /sys:/sys \
		-v $$PWD:/build \
		-w /build \
		--rm chip-os-armhf ./build.sh $(FLAVOR)
