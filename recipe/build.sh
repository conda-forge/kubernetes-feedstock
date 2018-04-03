#!/usr/bin/env bash

make_goroot_read_only()
{
    find $PREFIX/go -type d -exec chmod 555 {} \;
}

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

make_goroot_read_only

case $(uname -s) in
    "Linux")
        build_linux
        ;;
    "Darwin")
        build_osx
        ;;
esac
