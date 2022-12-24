set -e
read -p "GitHub Username: " username
read -p "GitHub Token: " token
kubectl create secret docker-registry ghcr-token --docker-username=$username --docker-password=$token

helmfile apply -f ./core.helmfile.yaml

sleep 20 # Wait for nginx-ingress to be *fully* ready, otherwise webhook gets wonky

helmfile apply
