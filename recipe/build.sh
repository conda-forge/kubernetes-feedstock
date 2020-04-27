#!/usr/bin/env bash

build_linux()
{
    go env

    make all WHAT=cmd/hyperkube GCFLAGS="-v"

    mv _output/bin/hyperkube $PREFIX/bin
    pushd $PREFIX/bin

    exes=(kube-apiserver kube-controller-manager kube-proxy kube-scheduler kubectl kubelet)
    for exe in ${exes[@]}; do
        ln -s ./hyperkube $exe
    done

    popd
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
