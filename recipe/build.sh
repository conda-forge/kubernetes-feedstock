#!/usr/bin/env bash

build_linux()
{
    make hyperkube kubefed

    make test WHAT=./federation/pkg/kubefed

    mv _output/bin/{hyperkube,kubefed} $PREFIX/bin
    pushd $PREFIX/bin
    ./hyperkube  --make-symlinks

    # Make the binary names conform to the ones upstream
    for i in aggregator apiserver controller-manager proxy scheduler ; do
        mv $i kube-$i
    done

    popd
}

build_osx()
{
    make kubectl kubefed

    make test WHAT=./pkg/kubectl
    make test WHAT=./federation/pkg/kubefed

    mv _output/bin/{kubectl,kubefed} $PREFIX/bin
}

case $(uname -s) in
    "Linux")
        build_linux
        ;;
    "Darwin")
        build_osx
        ;;
esac
