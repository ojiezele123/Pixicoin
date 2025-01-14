# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: pxc android ios pxc-cross swarm evm all test clean
.PHONY: pxc-linux pxc-linux-386 pxc-linux-amd64 pxc-linux-mips64 pxc-linux-mips64le
.PHONY: pxc-linux-arm pxc-linux-arm-5 pxc-linux-arm-6 pxc-linux-arm-7 pxc-linux-arm64
.PHONY: pxc-darwin pxc-darwin-386 pxc-darwin-amd64
.PHONY: pxc-windows pxc-windows-386 pxc-windows-amd64

GOBIN = $(shell pwd)/build/bin
GO ?= latest

pxc:
	build/env.sh go run build/ci.go install ./cmd/pxc
	@echo "Done building."
	@echo "Run \"$(GOBIN)/pxc\" to launch pxc."

swarm:
	build/env.sh go run build/ci.go install ./cmd/swarm
	@echo "Done building."
	@echo "Run \"$(GOBIN)/swarm\" to launch swarm."

all:
	build/env.sh go run build/ci.go install

android:
	build/env.sh go run build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/pxc.aar\" to use the library."

ios:
	build/env.sh go run build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/pxc.framework\" to use the library."

test: all
	build/env.sh go run build/ci.go test

clean:
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# The devtools target installs tools required for 'go generate'.
# You need to put $GOBIN (or $GOPATH/bin) in your PATH to use 'go generate'.

devtools:
	env GOBIN= go get -u golang.org/x/tools/cmd/stringer
	env GOBIN= go get -u github.com/jteeuwen/go-bindata/go-bindata
	env GOBIN= go get -u github.com/fjl/gencodec
	env GOBIN= go install ./cmd/abigen

# Cross Compilation Targets (xgo)

pxc-cross: pxc-linux pxc-darwin pxc-windows pxc-android pxc-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/pxc-*

pxc-linux: pxc-linux-386 pxc-linux-amd64 pxc-linux-arm pxc-linux-mips64 pxc-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/pxc-linux-*

pxc-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/pxc
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/pxc-linux-* | grep 386

pxc-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/pxc
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/pxc-linux-* | grep amd64

pxc-linux-arm: pxc-linux-arm-5 pxc-linux-arm-6 pxc-linux-arm-7 pxc-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/pxc-linux-* | grep arm

pxc-linux-arm-5:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/pxc
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/pxc-linux-* | grep arm-5

pxc-linux-arm-6:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/pxc
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/pxc-linux-* | grep arm-6

pxc-linux-arm-7:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/pxc
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/pxc-linux-* | grep arm-7

pxc-linux-arm64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/pxc
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/pxc-linux-* | grep arm64

pxc-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/pxc
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/pxc-linux-* | grep mips

pxc-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/pxc
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/pxc-linux-* | grep mipsle

pxc-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/pxc
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/pxc-linux-* | grep mips64

pxc-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/pxc
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/pxc-linux-* | grep mips64le

pxc-darwin: pxc-darwin-386 pxc-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/pxc-darwin-*

pxc-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/pxc
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/pxc-darwin-* | grep 386

pxc-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/pxc
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/pxc-darwin-* | grep amd64

pxc-windows: pxc-windows-386 pxc-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/pxc-windows-*

pxc-windows-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/pxc
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/pxc-windows-* | grep 386

pxc-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/pxc
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/pxc-windows-* | grep amd64
