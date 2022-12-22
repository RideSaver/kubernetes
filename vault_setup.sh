PGP_KEY=""
URL="ride-saver.online"
VAULT="vault.ride-saver"

SHORT=k:,u:,v
LONG=pgp_key:,url:,vault
OPTS=$(getopt -a --options $SHORT --longoptions $LONG -- "$@")


eval set -- "$OPTS"

while :
do
  case "$1" in
    -c | --city1 )
      city1="$2"
      shift 2
      ;;
    -d | --city2 )
      city2="$2"
      shift 2
      ;;
    -h | --help)
      "This is a weather script"
      exit 2
      ;;
    --)
      shift;
      break
      ;;
    *)
      echo "Unexpected option: $1"
      ;;
  esac
done
kubectl wait --for=jsonpath='{.status.phase}'=Running pod/vault-0 --namespace core

RECOVERY_KEYS=`kubectl exec vault-0 --namespace core -- vault operator init -key-shares=3 -key-threshold=2 -format=json`
echo $RECOVERY_KEYS

KEY_COUNT=`echo $RECOVERY_KEYS | jq .unseal_threshold`

for key in `echo $RECOVERY_KEYS | jq -r .unseal_keys_hex[]`
do
    kubectl exec vault-0 --namespace core -- vault operator unseal $key
done

ROOT_TOKEN=`echo $RECOVERY_KEYS | jq .root_token`
kubectl exec vault-0 --namespace core -- vault login $(echo $RECOVERY_KEYS | jq -r .root_token)

kubectl exec vault-0 --namespace core -i -- /bin/sh << EOL
vault auth enable kubernetes
vault write auth/kubernetes/config \
    kubernetes_host="https://\$KUBERNETES_PORT_443_TCP_ADDR:443"

vault write auth/kubernetes/role/ridesaver-core-admin \
  bound_service_account_names=ridesaver-core-admin \
  bound_service_account_namespaces=core \
  policies=root \
  ttl=20m
exit
EOL

echo $RECOVERY_KEYS > ./.vault_keys.json
