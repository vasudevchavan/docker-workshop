group "all" {
  targets = ["gobuild","pythonbuild","condabuild"]
}

group "multiarch" {
  targets = ["go-multiarch","python-multiarch"]
}

target "go-multiarch" {
  inherits = ["gobuilder-amd64", "gobuilder-arm64", "gobuilder-s390x"]
  platforms = ["linux/amd64", "linux/arm64", "linux/s390x"]
  tags = ["vasudevdchavan/go-builder:latest"]
}

target "python-multiarch" {
  inherits = ["python-amd64", "python-arm64","python-s390x"]
  platforms = ["linux/amd64", "linux/arm64", "linux/s390x"]
  tags = ["vasudevdchavan/python-builder:latest"]
}

target "conda-multiarch" {
  inherits = ["conda-amd64", "conda-arm64"]
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["vasudevdchavan/conda-builder:latest"]
}


group "gobuild" {
  targets = ["gobuilder-amd64", "gobuilder-arm64","gobuilder-s390x"]
}


target "gobase" {
  context = "."
  dockerfile = "goruntime"
  args = {
    IMAGE = "ubi9"
    GO_VERSION = "1.24.2"
  }
}

target "gobuilder-amd64" {
  inherits = ["gobase"]
  platforms = ["linux/amd64"]
  args = {
    TARGETARCH = "amd64"
  }
  tags = ["go-builder:amd64"]
}

target "gobuilder-arm64" {
  inherits = ["gobase"]
  platforms = ["linux/arm64"]
  args = {
    TARGETARCH = "arm64"
  }
  tags = ["go-builder:arm64"]
}

target "gobuilder-s390x" {
  inherits = ["gobase"]
  platforms = ["linux/s390x"]
  args = {
    TARGETARCH = "s390x"
  }
  tags = ["go-builder:s390x"]
}



group "pythonbuild" {
  targets = ["python-amd64", "python-arm64","python-s390x"]
}


target "pythonbase" {
  context = "."
  dockerfile = "pythonruntime"
  args = {
    IMAGE = "ubi9"
    PYTHON_VERSION = "3.10.10"
  }
}

target "python-amd64" {
  inherits = ["pythonbase"]
  platforms = ["linux/amd64"]
  args = {
    TARGETARCH = "amd64"
  }
  tags = ["python-builder:amd64"]
}

target "python-arm64" {
  inherits = ["pythonbase"]
  platforms = ["linux/arm64"]
  args = {
    TARGETARCH = "arm64"
  }
  tags = ["python-builder:arm64"]
}

target "python-s390x" {
  inherits = ["pythonbase"]
  platforms = ["linux/s390x"]
  args = {
    TARGETARCH = "s390x"
  }
  tags = ["python-builder:s390x"]
}


group "condabuild" {
  targets = ["conda-amd64", "conda-arm64","conda-s390x"]
}

target "condabase" {
  context = "."
  dockerfile = "condaruntime"
  args = {
    IMAGE = "ubi9"
    CONDA_VERSION = "latest"
  }
}

target "conda-amd64" {
  inherits = ["condabase"]
  platforms = ["linux/amd64"]
  args = {
    TARGETARCH = "x86_64"
  }
  tags = ["vasudevdchavan/conda-builder:amd64"]
}

target "conda-arm64" {
  inherits = ["condabase"]
  platforms = ["linux/arm64"]
  args = {
    TARGETARCH = "aarch64"
  }
  tags = ["vasudevdchavan/conda-builder:arm64"]
}

target "conda-s390x" {
  inherits = ["condabase"]
  platforms = ["linux/s390x"]
  args = {
    TARGETARCH = "s390x"
  }
  tags = ["vasudevdchavan/conda-builder:s390x"]
}
