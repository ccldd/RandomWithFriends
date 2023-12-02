#!/bin/env bash

REGION=$1
shift

terraform -chdir=terraform/${REGION} ${@}