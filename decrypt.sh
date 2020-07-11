#!/bin/bash

set -e

function decrypt() {
    output=$(</dev/stdin)
    encrypted_vars=$(echo "${output}" | grep "\.enc: ")

    while read -r line || [[ -n "$line" ]]; do
	key=$(echo "${line}" | cut -d":" -f1)
	value=$(echo "${line}" | cut -d" " -f2)
	decrypted_value=$(echo "${value}" | openssl enc -d -aes-256-cbc -md md5 -a -A -k "${DECRYPTION_KEY}" || echo "unable to decrypt: ${line}" 1>&2)
	stripped_key=${key//.enc/}
	output=$(echo -e "${output}\n${stripped_key}: ${decrypted_value}")
    done <<< "${encrypted_vars}"

    echo "${output}"
}

decrypt
