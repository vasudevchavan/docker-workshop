#!/bin/bash

#===================================================================================
#
# FILE: interactive_build.sh
#
# USAGE: interactive_build.sh
#
# DESCRIPTION: Provides docker images for Conda,Python & Go runtime on different UBI8 & UBI9
#              this code works on x86_64 , Arm64 , ppc64le and S390x 
# The default starting directory is the current directory.
# Don’t descend directories on other filesystems.
#===================================================================================



# capture variable required to get payload based on architecture.
# changes are needed for conda,go payload.
function getArch() {
    # capture architecture and use this variable as input as argument for docker build.
    # in case of uname -m = amd64 we replace it to x86_64 and similarly for arm64
    condaArch=$(uname -m | sed -e 's/amd64/x86_64/' -e 's/arm64/aarch64/')
    golangArch=$(uname -m | sed -e 's/amd64/x86_64/')
}

function downloadCondaInstallScript() {
    getArch
    # conda install file format for reference.
    # latest                             ||            specific version
    # Miniconda3-latest-Linux-x86_64.sh  || Miniconda3-py311_25.1.1-0-Linux-x86_64.s 
    # Miniconda3-latest-Linux-s390x.sh   || Miniconda3-py311_25.1.1-0-Linux-s390x.sh  
    # Miniconda3-latest-Linux-ppc64le.sh || Miniconda3-py311_25.1.1-0-Linux-ppc64le.sh
    # Miniconda3-latest-Linux-aarch64.sh || Miniconda3-py311_25.1.1-0-Linux-aarch64.sh
    condaVersion=$1
    base_url="https://repo.anaconda.com/miniconda/"
    condaInstallFile=$(wget -qO- "$base_url" | \
        grep -o 'href="[^"]\+\.sh"' | \
        sed 's/^href="//; s/"$//' | \
        grep -i "${condaVersion}-Linux-${condaArch}" | head -n 1)

    if [[ -z "$condaInstallFile" ]]; then
        echo "Conda installer not found for version $condaVersion and arch $condaArch"
        exit 1
    fi

    echo "Downloading Linux installer: ${base_url}${condaInstallFile}"
    wget "${base_url}${condaInstallFile}"
    # Rename if needed
    if [ "$condaInstallFile" != "Miniconda3-${condaVersion}.sh" ]; then
        mv "$condaInstallFile" "Miniconda3-${condaVersion}.sh"
        condaInstallFile="Miniconda3-${condaVersion}.sh"
    fi
}


function condaImageBuild() {
    downloadCondaInstallScript $1
    podman build -t condaruntime:$1 --build-arg IMAGE=$2 --build-arg CONDAINSTALLFILE=${condaInstallFile} . -f condaruntime
}


function goImageBuild() {
    getArch
    echo $golangArch
    podman build -t goruntime:$1 --build-arg IMAGE=$2 --build-arg GO_VERSION=$1 --build-arg GOLANGARCH=${golangArch} . -f goruntime
}

function pythonImageBuild() {
    P_SHORT_PYTHON_VERSION=$(echo $1 | cut -d "." -f 1,2)
    podman build -t pythonruntime:$1 --build-arg IMAGE=$2 --build-arg PYTHON_VERSION=$1  --build-arg SHORT_PYTHON_VERSION=${P_SHORT_PYTHON_VERSION} . -f pythonruntime
}


# Main program starts from here

echo "Please choose RHEL version for your $runtime:"
echo "1) RHEL-8"
echo "2) RHEL-9"
read -p "Enter your os_runtime [1-2]: " os_system

case $os_system in
    1)
        os_system=ubi8
        ;;
    2)
        os_system=ubi9
        ;;
    *)
        echo "Invalid choice. Please run the script again."
        exit 1
        ;;
esac

echo "Please choose an option for the container needed:"
echo "1) Condaruntime"
echo "2) Python"
echo "3) Go environment"
echo "4) Exit"

read -p "Enter your runtime [1-4]: " runtime

case $runtime in
    1)
        runtime="Condaruntime"
        echo "Please select conda version"
        echo "1) Latest"
        echo "2) Custom version"
        read -p "Enter your runtime [1-2]: " condaver
        case $condaver in
            1)
                version="latest"
                ;;
            2)
                read -p "Enter the desired Conda version (e.g., py311_25.1.1-0): " version
                ;;
        esac
        echo "Preparing Docker image for $runtime with $os_system with conda $version version"
        condaImageBuild $version $os_system
        ;;
    2)
        runtime="Python"
        echo "Please select Python version"
        echo "1) Latest"
        echo "2) Custom version"
        read -p "Enter your runtime [1-2]: " pyversion
        case $pyversion in
            1)
                version="3.10.10"
                ;;
            2)
                read -p "Enter the desired Python version (e.g., 3.10.10): " version
                ;;
        esac
        echo "Preparing Docker image for $runtime on $os_system with python $version version"
        pythonImageBuild $version $os_system
        ;;
    3)
        runtime="Go"
        echo "Please select golang version"
        echo "1) Latest"
        echo "2) Custom version"
        read -p "Enter your runtime [1-2]: " goversion
        case $goversion in
            1)
                version="1.24.2"
                ;;
            *)
                read -p "Enter the desired Go version (e.g., 1.24.2): " version
                ;;
        esac
        echo "Preparing Docker image for $runtime with $os_system with $version"
        goImageBuild $version $os_system
        ;;
    4)
        echo "Goodbye!"
        exit 0
        ;;
    *)
        echo "Invalid choice. Please run the script again."
        exit 1
        ;;
esac
