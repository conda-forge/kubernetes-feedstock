#!/usr/bin/env bash

build_linux()
{
    go env

    cmds=(
      cloud-controller-manager
      kube-apiserver
      kube-controller-manager
      kube-proxy
      kube-scheduler
      kubelet
      kubeadm
      kubectl
    )
    make -j${CPU_COUNT} GCFLAGS="-v" ${cmds[@]}

    for cmd in ${cmds[@]}; do
        mv _output/bin/${cmd} $PREFIX/bin
    done
}

build_osx()
{
    make kubectl

    make test WHAT=./pkg/kubectl

    mv _output/bin/kubectl $PREFIX/bin
}

mkdir -p $PREFIX/bin
export GO_TMPDIR=$SRCDIR/tmp

case $(uname -s) in
    "Linux")
        build_linux
        ;;
    "Darwin")
        build_osx
        ;;
esac
