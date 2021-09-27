.PHONY: 

DH_ORG=weaveworks
VERSION=1.6.1-dc

build.docker:
	docker build -t docker-hub-remote.dr.corp.adobe.com/$(DH_ORG)/kured -f dc.Dockerfile ./build
	docker tag docker-hub-remote.dr.corp.adobe.com/$(DH_ORG)/kured docker-hub-remote.dr.corp.adobe.com/$(DH_ORG)/kured:$(VERSION)
