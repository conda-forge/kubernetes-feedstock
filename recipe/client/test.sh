#!/usr/bin/env bash
set -euf

test -x "${PREFIX}"/bin/kubectl
kubectl --help