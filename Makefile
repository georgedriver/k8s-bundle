HELM_IMAGE ?= quay.io/roboll/helmfile@sha256:4d6b36aede7fc821e444beb8643c2d8c4e321f4422db05d82738d55ea9af287f
ENV ?= dev

lint:
	docker run -i --env-file .env -v ${PWD}:/code -v $(HOME)/.kube/config:/root/.kube/config --rm $(HELM_IMAGE) /code/init-install.sh $(ENV) lint

diff:
	docker run -i --env-file .env -v ${PWD}:/code -v $(HOME)/.kube/config:/root/.kube/config --rm $(HELM_IMAGE) /code/init-install.sh $(ENV) diff

sync:
	docker run -i --env-file .env -v ${PWD}:/code -v $(HOME)/.kube/config:/root/.kube/config --rm $(HELM_IMAGE) /code/init-install.sh $(ENV) sync

cli:
	docker run -it --env-file .env -v ${PWD}:/code -v $(HOME)/.kube/config:/root/.kube/config --rm $(HELM_IMAGE) bash
