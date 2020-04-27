#!/usr/bin/env bash
set -euf

test -x "${PREFIX}"/bin/kubeadm
kubeadm --help

test -x "${PREFIX}"/bin/kubelet
kubelet --help

test -x "${PREFIX}"/bin/kube-proxy
kube-proxy --help
