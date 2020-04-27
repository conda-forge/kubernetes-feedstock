#!/usr/bin/env bash
set -euf

test -x "${PREFIX}"/bin/kube-apiserver
kube-apiserver --help

test -x "${PREFIX}"/bin/kube-controller-manager
kube-controller-manager --help

test -x "${PREFIX}"/bin/kube-scheduler
kube-scheduler --help

test -x "${PREFIX}"/bin/mounter

test -x "${PREFIX}"/bin/apiextensions-apiserver
apiextensions-apiserver --help

