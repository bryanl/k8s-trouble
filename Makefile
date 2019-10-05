build-hello-world:
	@docker build -t bryanl/k8st-hello-world -f cmd/hello-world/Dockerfile .
