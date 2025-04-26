#Makefile

.PHONY: all go python conda clean
# Default target
all:
	docker buildx bake all
go:
	docker buildx bake gobuild
python:
	docker buildx bake pythonbuild
conda:
	docker buildx bake condabuild --push
push_individual:
	docker buildx bake all --push
multiarch_all:
	docker buildx bake multiarch --push
help:
	@echo "Usage:"
	@echo "  make                     # builds all groups"
	@echo "  make go                  # builds Go targets only"
	@echo "  make python              # builds Python targets only"
	@echo "  make push_individual     # builds all groups and push to registry"
	@echo "  make multiarch_all       # builds multiarch for all and push to registry"
	@echo ""




# Same Makefile with Arguments
# Default values (can be overridden at runtime)
# GROUP = ["go","python","conda"]
# PUSH = ["true","false"]
# DEBUG = ["true","false"]
# IMAGE = ["ubi8","ubi9"]
#
GROUP      ?= all
PUSH       ?= false
DEBUG      ?= false
IMAGE      ?= ubi9
GO_VERSION ?= 1.24.2
PYTHON_VERSION ?= 3.10.10
CONDA_VERSION  ?= latest

# Common args passed to bake
BAKE_ARGS = --set *.args.IMAGE=$(IMAGE) \
            --set gobase.args.GO_VERSION=$(GO_VERSION) \
            --set pythonbase.args.PYTHON_VERSION=$(PYTHON_VERSION) \
            --set condabase.args.CONDA_VERSION=$(CONDA_VERSION)

# Conditional options
ifeq ($(PUSH),true)
	BAKE_ARGS += --push
endif
ifeq ($(DEBUG),true)
	BAKE_ARGS += --progress=plain --no-cache
endif

bake:
	docker buildx bake $(GROUP) $(BAKE_ARGS)
push:
	@$(MAKE) bake PUSH=true
debug:
	@$(MAKE) bake DEBUG=true

clean:
	docker builder prune -f
