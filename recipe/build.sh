#!/usr/bin/env bash

build_linux()
{
    CGO_LDFLAGS="-Wl,-O2 -Wl,--sort-common -Wl,--as-needed -Wl,-z,relro -Wl,-z,now -Wl,--disable-new-dtags -Wl,--gc-sections"
    CGO_LDFLAGS=${CGO_LDFLAGS/-Wl,-O2/}
    CGO_LDFLAGS=${CGO_LDFLAGS/-Wl,--sort-common/}
    CGO_LDFLAGS=${CGO_LDFLAGS/-Wl,--as-needed/}
    CGO_LDFLAGS=${CGO_LDFLAGS/-Wl,-z,relro/}
    CGO_LDFLAGS=${CGO_LDFLAGS/-Wl,-z,now/}
    CGO_LDFLAGS=${CGO_LDFLAGS/-Wl,--disable-new-dtags/}
    CGO_LDFLAGS=${CGO_LDFLAGS/-Wl,--gc-sections/}

    export CGO_LDFLAGS
    go env

    make all WHAT=cmd/hyperkube GCFLAGS="-v"

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
pushd k8s.io/kubernetes
export GO_TMPDIR=$SRCDIR/tmp

case $(uname -s) in
    "Linux")
        build_linux
        ;;
    "Darwin")
        build_osx
        ;;
esac
