all: sidecore-images riscv-ubuntu@latest.cpio amd64-ubuntu@latest.cpio

sidecore-images: main.go
	CGO_ENABLED=0 go build .
	rm -f *.cpio
	
riscv-ubuntu@latest.cpio: 
	docker run -e PWD=/  \
		--mount type=bind,source=/home,target=/home \
		--entrypoint  `pwd`/sidecore-images \
		ubuntu@sha256:f31546bc71659c643837d57f09a161f04e866b59da4f418e064082a756c4c23a \
		/ `pwd`/$@ \
		-one-file-system  -e /tmp \
		> $@

amd64-ubuntu@latest.cpio: 
	docker run -e PWD=/  \
		--mount type=bind,source=/home,target=/home \
		--entrypoint  `pwd`/sidecore-images \
		ubuntu \
		/ `pwd`/$@ \
		-one-file-system  -e /tmp \
		> $@

