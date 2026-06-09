.PHONY: all headless gui image
FLAVOR ?= headless
IMAGE := chip-os-armhf

# Local convenience: build both flavors (sequential -- two qemu-emulated arm/v7
# builds on one host just contend for CPU). Real parallelism is in CI, where the
# release workflow fans the flavors out across separate runners (a matrix).
all: headless gui

image:
	docker build --platform linux/arm/v7 -t $(IMAGE) .

# Single-flavor entrypoints (`make headless` / `make gui`) still work standalone;
# they depend on the shared image target so it's built first / only once.
headless gui: image
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
		--rm $(IMAGE) ./build.sh $@
