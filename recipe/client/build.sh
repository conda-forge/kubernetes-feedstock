#!/usr/bin/env bash
set -euf

# This comes from k8s
. hack/lib/init.sh

mkdir -p "$PREFIX"/bin
export GO_TMPDIR=$SRC_DIR/tmp
go env

targets="${KUBE_CLIENT_TARGETS[*]}"

make all WHAT="${targets}"

binaries="${KUBE_CLIENT_BINARIES[*]}"
for cmd in ${binaries}; do
  cp _output/bin/"${cmd}" "$PREFIX"/bin
  readelf -d "$PREFIX"/bin/"${cmd}"
done
