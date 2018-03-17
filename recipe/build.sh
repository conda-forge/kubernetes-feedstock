#!/usr/bin/env bash

build_linux()
{
    make -j $CPU_COUNT hyperkube
    mv _output/bin/hyperkube $PREFIX/bin

    cd $PREFIX/bin
    ./hyperkube  --make-symlinks
}

build_osx()
{
    make -j $CPU_COUNT kubectl kubefed

    make test WHAT=./pkg/kubectl
    make test WHAT=./federation/pkg/kubefed

    mv _output/bin/kubectl $PREFIX/bin
    mv _output/bin/kubefed $PREFIX/bin
}

case $(uname -s) in
    "Linux")
        build_linux
        ;;
    "Darwin")
        build_osx
        ;;
esac
