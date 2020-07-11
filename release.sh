#!/bin/bash

read VERSION
docker build -t navikt/knada-helm:$VERSION .
docker push navikt/knada-helm:$VERIONS
