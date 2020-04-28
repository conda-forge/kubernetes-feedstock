#!/usr/bin/env bash
set -euf

# This comes from k8s
. hack/lib/init.sh

mkdir -p "$PREFIX"/bin
export GO_TMPDIR=$SRC_DIR/tmp
go env

make all WHAT="${KUBE_CLIENT_TARGETS[*]}"

for cmd in ${KUBE_CLIENT_BINARIES[*]}; do
  cp "_output/bin/${cmd}" "$PREFIX/bin"
done
