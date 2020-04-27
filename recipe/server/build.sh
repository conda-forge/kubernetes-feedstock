#!/usr/bin/env bash
set -euf

# This comes from k8s
. hack/lib/init.sh

mkdir -p "$PREFIX/bin"
export GO_TMPDIR=$SRC_DIR/tmp
go env

make all WHAT="${KUBE_SERVER_TARGETS[*]}"

for cmd in ${KUBE_SERVER_BINARIES[*]}; do
  cp "_output/bin/${cmd}" "$PREFIX/bin"
done

#
# For some reason the binary patching destroys this file
# In that case, we are better off deleting it.
rm -f "$PREFIX"/bin/apiextensions-apiserver

for cmd in ${KUBE_NODE_BINARIES[*]} ${KUBE_CLIENT_BINARIES[*]}; do
  rm -f "$PREFIX/bin/${cmd}"
done
