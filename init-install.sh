#!/bin/bash

set -e

usage() {
    cat <<EOF
Usage: $0 <environment> <action>
Example: $0 <dev|prod> <lint|diff|sync>
EOF
}

if [[ $# != 2 ]]; then
    usage
    exit 1
fi

DIRECTORY=$(dirname "$0")

cd "${DIRECTORY}" || exit 1


installed() {
    type "$1" &> /dev/null
}
ensure_set() {
    ENV_NAME=$1
    if [ -z "$(printf '%s\n' "${!ENV_NAME}")" ]; then
        echo "Missing variable: $1"
        usage
        exit 1
    fi
}
prompt() {
    ENV_NAME=$1
    TEXT="Enter a value for $ENV_NAME"
    DEFAULT=$(printf '%s\n' "${!ENV_NAME}")
    if [ -n "$DEFAULT" ]; then
        TEXT="$TEXT [$DEFAULT]"
    fi
    TEXT="$TEXT: "
    echo $TEXT
    read VALUE
    if [ -z "$VALUE" ]; then
        if [ -n "$DEFAULT" ]; then
            VALUE=$DEFAULT
        else
            echo "Value for $ENV_NAME is REQUIRED"
            prompt $ENV_NAME
        fi
    fi
    echo "Setting $ENV_NAME=$VALUE"
    echo
    export $ENV_NAME=$VALUE
}

kubectl version

installed helmfile
installed helm

for env in $(cat ./environments/$1.yaml.gotmpl | grep '{{ env' | awk -F'"' '{print $2}'); do
    [ -z ${!env} ] && ensure_set $env
done

helmfile -e $1 deps

case "$2" in
    lint)
    echo "=== lint ===="
    helmfile -e $1 lint
    ;;
    diff)
    echo "=== diff ===="
    helmfile -e $1 diff
    ;;
    sync)
    echo "=== sync ===="
    helmfile -e $1 --selector depend_on_others!=true sync
    helmfile -e $1 --selector depend_on_others=true sync
    ;;
    *)
    usage
    exit 1
    ;;
esac

for ns in $(cat namespaces.values | grep "name:" | awk -F":" '{print $2}' | tr '"' ' '); do
    kubectl create ns $ns || true
done
