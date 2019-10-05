build-hello-world:
	@docker build -t bryanl/k8st-hello-world -f cmd/hello-world/Dockerfile .

push-hello-world:
	@docker push bryanl/k8st-hello-world

build-tempermental:
	@docker build -t bryanl/k8st-tempermental -f cmd/tempermental/Dockerfile .

push-tempermental:
	@docker push bryanl/k8st-tempermental
