#!/bin/bash

POSTFIX_RELEASE_NAME=""

shopt -s globstar nullglob
for file_path in /mustache/configs/*.yaml
do
    base_file=$(basename "$file_path")
    echo "Creating config for ${base_file}"
    file=$(cat /mustache/shared.yaml "$file_path" | decrypt)
    echo "$file" | mustache - /mustache/template.mustache > "/out/$base_file"

    if [ -z "${RELEASE_NAME}" ]; then
	release="jupyterhub-$(yq r "$file_path" ingress)"
    else
	release="$(RELEASE_NAME)"
    fi

    namespace=$(yq r "$file_path" namespace)
    echo "Installing ${release} in ${namespace}"

    helm upgrade --install "$release" "/${CHART}.tgz" \
	 --namespace "$namespace" \
	 --values "/out/$base_file"
done
