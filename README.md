# RideSaver kubernetes
This holds the main files to run RideSaver on Kubernetes, including external software configurations.

## Installing RideSaver on Kubernetes

### Prerequisites
1. [Helm](helm.sh)
2. A kubernetes cluster

### Hardware requirements
16 GB of RAM
4 cores

### Installing
1. `helm repo add ridesaver https://RideSaver.github.com/kubernetes`
2. `helm repo update`
3. `helm install RideSaver`
