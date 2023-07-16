all: riscv-ubuntu@latest.squashfs

riscv-ubuntu@latest.squashfs: 
	docker run -e PWD=/  \
		--mount type=bind,source=/home,target=/home \
		--entrypoint  `which mksquashfs` \
		ubuntu@sha256:f31546bc71659c643837d57f09a161f04e866b59da4f418e064082a756c4c23a \
		/ `pwd`/$@ \
		-one-file-system  -e /tmp

