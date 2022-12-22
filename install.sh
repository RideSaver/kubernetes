helmfile apply -f ./core.helmfile.yaml

./vault_setup.sh

helmfile apply
