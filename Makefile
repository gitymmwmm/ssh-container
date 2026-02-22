.PHONY: build run

build:
	docker build --build-arg SSH_PORT=8080 -t linux .

run:
	docker run -d --name linux -p 8080:8080 linux