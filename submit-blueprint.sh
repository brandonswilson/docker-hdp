# Type must be "single-container" or "multi-container"
TYPE=$1

#BLUEPRINT must name one of the JSON blueprints in examples/blueprints (e.g., core-hdp)
BLUEPRINT=$2

source .env
curl --user admin:admin -H 'X-Requested-By:admin' -X POST $AMBARI_HOST/api/v1/blueprints/${BLUEPRINT} --data-binary "@examples/blueprints/${BLUEPRINT}.json"
curl --user admin:admin -H 'X-Requested-By:admin' -X PUT $AMBARI_HOST/api/v1/stacks/HDP/versions/$HDP_VERSION/operating_systems/$OS/repositories/HDP-${HDP_VERSION} -d '{"Repositories":{"base_url":"'$BASE_URL'", "verify_base_url":true}}'

type=$(cat "examples/hostgroups/$TYPE.json")
type=${type/BLUEPRINT_NAME/$BLUEPRINT}
curl --user admin:admin -H 'X-Requested-By:admin' -X POST $AMBARI_HOST/api/v1/clusters/dev -d "${type}"

