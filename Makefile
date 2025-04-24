#Makefile

# Default values (can be overridden via CLI)
OS ?= ubi8
RUNTIME ?= python
VERSION ?= latest

# Architecture detection (used in shell script)
ARCH := $(shell uname -m)

.PHONY: all help build-python build-conda build-go clean

all: help

help:
	@echo "Usage:"
	@echo "  make build-conda OS=ubi9 VERSION=latest"
	@echo "  make build-python OS=ubi8 VERSION=3.10.10"
	@echo "  make build-go OS=ubi9 VERSION=1.24.2"
	@echo ""
	@echo "Environment variables which are passed as docker arguments:"
	@echo "  OS         - RHEL base (ubi8 or ubi9)"


# Python
build-python:
	@echo "Building Python image with OS=$(OS), VERSION=$(VERSION)"
	@./non_interactive_build.sh --runtime=python --version=$(VERSION) --os=$(OS)

# Conda
build-conda:
	@echo "Building Conda image with OS=$(OS), VERSION=$(VERSION)"
	@./non_interactive_build.sh --runtime=conda --version=$(VERSION) --os=$(OS)

# Go
build-go:
	@echo "Building Go image with OS=$(OS), VERSION=$(VERSION)"
	@./non_interactive_build.sh --runtime=go --version=$(VERSION) --os=$(OS)

clean:
	@echo "Cleaning up generated installer scripts..."
	rm -f Miniconda3-*.sh
