#!/usr/bin/env bash
set -eufx

# This comes from k8s
. hack/lib/init.sh

mkdir -p "$PREFIX"/bin
export GO_TMPDIR=$SRC_DIR/tmp
go env

make all WHAT="${KUBE_NODE_TARGETS[*]}"

for cmd in ${KUBE_NODE_BINARIES[*]}; do
  cp "_output/bin/${cmd}" "$PREFIX/bin"
done
