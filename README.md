#docker-workshop
This Repo will provide sample docker file which can be used to build Conda , Python and Golang runtimes.


First way of building images using BASH script.

./interactive_build.sh script is used to create required runtime.

Example:

We are considering an example of Conda runtime with latest version of miniconda on a UBI9 image.

./interactive_build.sh

Please choose RHEL version for your :
1) RHEL-8
2) RHEL-9
Enter your os_runtime [1-2]: 2

Please choose an option for the container needed:
1) Condaruntime
2) Python
3) Go environment
4) Exit
Enter your runtime [1-4]: 1

Please select conda version
1) Latest
2) Custom version

Please select conda version
1) Latest
2) Custom version
Enter your runtime [1-2]: 1

Preparing Docker image for Condaruntime with ubi9 and conda latest version



#===================================================================================

Second way of building images using Make commands and this uses non_interactive_build.sh script

Example:
make build-python VERSION=3.11.4


User make help for more details:

make help
Usage:
  make build-conda OS=ubi9 VERSION=latest
  make build-python OS=ubi8 VERSION=3.10.10
  make build-go OS=ubi9 VERSION=1.24.2

Environment variables:
  OS         - RHEL base (ubi8 or ubi9)

