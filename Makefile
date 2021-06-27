# https://github.com/roboll/helmfile/releases/tag/v0.139.9
HELM_IMAGE ?= quay.io/roboll/helmfile:helm3-v0.139.9
ENV ?= dev

lint:
	docker run -i --env-file .env -v ${PWD}:/code -v $(HOME)/.kube/config:/root/.kube/config --rm $(HELM_IMAGE) /code/init-install.sh $(ENV) lint

diff:
	docker run -i --env-file .env -v ${PWD}:/code -v $(HOME)/.kube/config:/root/.kube/config --rm $(HELM_IMAGE) /code/init-install.sh $(ENV) diff

sync:
	docker run -i --env-file .env -v ${PWD}:/code -v $(HOME)/.kube/config:/root/.kube/config --rm $(HELM_IMAGE) /code/init-install.sh $(ENV) sync

cli:
	docker run -it --env-file .env -v ${PWD}:/code -v $(HOME)/.kube/config:/root/.kube/config --rm $(HELM_IMAGE) bash
