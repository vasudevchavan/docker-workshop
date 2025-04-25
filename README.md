# 🚀 docker-workshop

This repository provides sample Dockerfiles and scripts to build various runtime environments including **Conda**, **Python**, and **Golang**.

---


## 🔧 Build Methods


### 1️⃣ Interactive Build using BASH Script

Use `interactive_build.sh` to interactively create the required runtime.

📌 **Example: Building a Conda runtime with the latest Miniconda on UBI9**

```bash
./interactive_build.sh

Please choose RHEL version for your image:
1) RHEL-8
2) RHEL-9
Enter your os_runtime [1-2]: 2

Please choose a runtime to build:
1) Condaruntime
2) Python
3) Go environment
4) Exit
Enter your runtime [1-4]: 1

Please select conda version:
1) Latest
2) Custom version
Enter your choice [1-2]: 1

Preparing Docker image for Condaruntime with ubi9 and conda latest version...
```


### 2️⃣ Non-Interactive Build using Makefile
Builds are triggered using the Makefile and the non_interactive_build.sh script.

📌 Example:
```
make build-python VERSION=3.11.4
```

📘 Help:
```
make help
```

🔄 Usage
```
make build-conda OS=ubi9 VERSION=latest
make build-python OS=ubi8 VERSION=3.10.10
make build-go OS=ubi9 VERSION=1.24.2
Environment variables:
OS         - RHEL base (ubi8 or ubi9)
```
# ✅ Advantages & Disadvantages

|Component	|Description	|Multi-Arch Support|
| --- | --- | --- |
|interactive_build.sh	| Not CI/CD friendly	|❌ Not Supported|
|non_interactive_build.sh	| CI/CD friendly	|❌ Not Supported|
|condaruntime	|Multi-arch not supported	|❌ Not Supported|
|goruntime	| Requires Go source code validation	|✅ Supported|
|pythonruntime	|Requires Python source validation	|✅ Supported|
