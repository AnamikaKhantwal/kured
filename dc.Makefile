.DEFAULT: all
.PHONY: 

DH_ORG=weaveworks
VERSION=1.6.1-dc
SUDO=$(shell docker info >/dev/null 2>&1 || echo "sudo -E")

all: image

clean:
	rm -f cmd/kured/kured
	rm -rf ./build

godeps=$(shell go list -f '{{join .Deps "\n"}}' $1 | grep -v /vendor/ | xargs go list -f '{{if not .Standard}}{{ $$dep := . }}{{range .GoFiles}}{{$$dep.Dir}}/{{.}} {{end}}{{end}}')

DEPS=$(call godeps,./cmd/kured)

cmd/kured/kured: $(DEPS)
cmd/kured/kured: cmd/kured/*.go
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags "-X main.version=$(VERSION)" -o $@ cmd/kured/*.go

build/.image.done: dc.Dockerfile cmd/kured/kured
	mkdir -p build
	cp $^ build
	$(SUDO) docker build -t docker-hub-remote.dr.corp.adobe.com/$(DH_ORG)/kured -f dc.Dockerfile ./build
	$(SUDO) docker tag docker-hub-remote.dr.corp.adobe.com/$(DH_ORG)/kured docker-hub-remote.dr.corp.adobe.com/$(DH_ORG)/kured:$(VERSION)
	touch $@

image: build/.image.done
