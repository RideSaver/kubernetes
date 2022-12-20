$pgp = ""
$url = "ride-saver.online"
$vault = "vault.ride-saver"
while getopts pgp:w:v: flag
do
    case "${flag}" in
        pgp) PGP_KEY=${OPTARG};;
        w) url=${OPTARG};;
        v) vault=${OPTARG};;
    esac
done

RECOVERY_KEYS = `kubectl exec vault-0 -- vault operator init -recovery-shares=7 -recovery-threshold=4 -format=json`
echo $RECOVERY_KEYS
