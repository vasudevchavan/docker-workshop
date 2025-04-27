# 🚀 docker-workshop

This repository provides sample Dockerfiles and scripts to build various runtime environments including **Conda**, **Python**, and **Golang**.

---

**['Docker bake'](https://docs.docker.com/build/bake/introduction/)**:

Bake is an abstraction for the docker build command that lets you more easily manage your build configuration (CLI flags, environment variables, etc.) in a consistent way for everyone on your team.
Bake is a command built into the Buildx CLI, so as long as you have Buildx installed, you also have access to bake, via the docker buildx bake command.


## 🔧 Build Using Docker bake
📌 Example:
```
docker buildx bake
```

📘 Help:
```
make help
```

🔄 Usage
```
Usage:
=============================================================================
  make                     # builds all groups
  make go                  # builds Go targets only
  make python              # builds Python targets only
  make push_all            # builds all groups and push to registry
  make multiarch_all       # builds multiarch for all and push to registry
=============================================================================
  Environment Variable
  GROUP = [all,go,python,conda]
  PUSH = [true,false]
  DEBUG = [true,false]
  IMAGE = [ubi8,ubi9]
=============================================================================
```
