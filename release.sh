#!/bin/bash

read VERSION
docker build --no-cache -t navikt/knada-helm:$VERSION .
docker push navikt/knada-helm:$VERSION
