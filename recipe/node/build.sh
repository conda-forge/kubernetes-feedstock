#!/usr/bin/env bash
set -eufx

# This comes from k8s
. hack/lib/init.sh

mkdir -p "$PREFIX"/bin
export GO_TMPDIR=$SRC_DIR/tmp
go env

targets="${KUBE_NODE_TARGETS[*]}"

make all WHAT="${targets}"

binaries="${KUBE_NODE_BINARIES[*]}"
for cmd in ${binaries}; do
  cp _output/bin/"${cmd}" "$PREFIX"/bin
  readelf -d "$PREFIX"/bin/"${cmd}"
done
