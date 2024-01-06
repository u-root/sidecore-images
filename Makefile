all: sidecore-images \
	riscv64-ubuntu@latest.cpio \
	riscv64-alpine@latest.cpio \
	amd64-ubuntu@latest.cpio \
	arm32v6-alpine@latest.cpio \
	arm32v5-debian@latest.cpio.gz \
	riscv64-alpine@latest.cpio.gz \
	arm32v5-navikey-raspbian-buster@latest.cpio.gz \
	arm32v7-ubuntu@latest.cpio.gz \

uncompress:
	gunzip -f -k *.gz

sidecore-images: main.go
	CGO_ENABLED=0 go build .
	rm -f *.cpio
	
riscv64-ubuntu@latest.cpio:
	docker run -e PWD=/  \
		--mount type=bind,source=/home,target=/home \
		--entrypoint  `pwd`/sidecore-images \
		ubuntu@sha256:f31546bc71659c643837d57f09a161f04e866b59da4f418e064082a756c4c23a \
		/ `pwd`/$@ \
		-one-file-system  -e /tmp \
		> $@

riscv64-alpine@latest.cpio:
	docker run -e PWD=/  \
		--mount type=bind,source=/home,target=/home \
		--entrypoint  `pwd`/sidecore-images \
		riscv64/alpine:20230901 \
		/ `pwd`/$@ \
		-one-file-system  -e /tmp \
		> $@

riscv64-alpine@latest.cpio.gz: riscv64-alpine@latest.cpio
	gzip -f $<

amd64-ubuntu@latest.cpio:
	docker run -e PWD=/  \
		--mount type=bind,source=/home,target=/home \
		--entrypoint  `pwd`/sidecore-images \
		ubuntu \
		/ `pwd`/$@ \
		-one-file-system  -e /tmp \
		> $@

arm32v6-alpine@latest.cpio:
	docker run -e PWD=/  \
		--mount type=bind,source=/home,target=/home \
		--entrypoint  `pwd`/sidecore-images \
		arm32v6/alpine \
		/ `pwd`/$@ \
		-one-file-system  -e /tmp \
		> $@

arm32v7-ubuntu@latest.cpio:
	docker run -e PWD=/  \
		--mount type=bind,source=/home,target=/home \
		--entrypoint  `pwd`/sidecore-images \
		arm32v7/ubuntu \
		/ `pwd`/$@ \
		-one-file-system  -e /tmp \
		> $@

arm32v7-ubuntu@latest.cpio.gz: arm32v7-ubuntu@latest.cpio
	gzip -f $<

arm32v5-debian@latest.cpio:
	docker run -e PWD=/  \
		--mount type=bind,source=/home,target=/home \
		--entrypoint  `pwd`/sidecore-images \
		arm32v5/debian \
		/ `pwd`/$@ \
		-one-file-system  -e /tmp \
		> $@

arm32v5-debian@latest.cpio.gz: arm32v5-debian@latest.cpio
	gzip -f $<

arm32v5-navikey-raspbian-buster@latest.cpio:
	docker run -e PWD=/  \
		--mount type=bind,source=/home,target=/home \
		--entrypoint  `pwd`/sidecore-images \
		navikey/raspbian-buster:latest \
		/ `pwd`/$@ \
		-one-file-system  -e /tmp \
		> $@

arm32v5-navikey-raspbian-buster@latest.cpio.gz: arm32v5-navikey-raspbian-buster@latest.cpio
	gzip -f $<
