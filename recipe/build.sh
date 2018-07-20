#!/usr/bin/env bash

build_linux()
{
    make hyperkube

    mv _output/bin/hyperkube $PREFIX/bin
    pushd $PREFIX/bin
    ./hyperkube  --make-symlinks

    popd
}

build_osx()
{
    make kubectl

    make test WHAT=./pkg/kubectl

    mv _output/bin/kubectl $PREFIX/bin
}

mkdir -p $PREFIX/bin
case $(uname -s) in
    "Linux")
        build_linux
        ;;
    "Darwin")
        build_osx
        ;;
esac
