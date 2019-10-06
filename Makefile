build-hello-world:
	@docker build -t bryanl/k8st-hello-world -f cmd/hello-world/Dockerfile .

push-hello-world:
	@docker push bryanl/k8st-hello-world

build-temperamental:
	@docker build -t bryanl/k8st-temperamental -f cmd/temperamental/Dockerfile .

push-temperamental:
	@docker push bryanl/k8st-temperamental
