#!/bin/sh

CONFIG_PATH="/data/options.json"
N8N_PATH="/data/n8n"

mkdir -p "${N8N_PATH}/.n8n"

export N8N_PROTOCOL="$(jq --raw-output '.protocol // empty' $CONFIG_PATH)"
export VUE_APP_URL_BASE_API="$(jq --raw-output '.base_url // empty' $CONFIG_PATH)"
export GENERIC_TIMEZONE="$(jq --raw-output '.timezone // empty' $CONFIG_PATH)"
export N8N_SSL_CERT="/ssl/$(jq --raw-output '.certfile // empty' $CONFIG_PATH)"
export N8N_SSL_KEY="/ssl/$(jq --raw-output '.keyfile // empty' $CONFIG_PATH)"
export N8N_USER_FOLDER="${N8N_PATH}"

if [ -d ${N8N_PATH} ] ; then
  chmod o+rx ${N8N_PATH}
  chown -R node ${N8N_PATH}/.n8n
  ln -s ${N8N_PATH}/.n8n /home/node/
fi

chown -R node /home/node

if [ "$#" -gt 0 ]; then
  exec su-exec node "$@"
else
  exec su-exec node n8n
fi
