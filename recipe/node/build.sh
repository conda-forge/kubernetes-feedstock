#!/usr/bin/env bash

# hack/lib/init.sh needs bash >=4.2; macOS system bash is 3.2.
# Re-exec under the build-env bash if we were launched with an older one.
if [ "${BASH_VERSINFO[0]:-0}" -lt 4 ] && [ -x "${BUILD_PREFIX}/bin/bash" ]; then
  exec "${BUILD_PREFIX}/bin/bash" "$0" "$@"
fi

# The conda go-cgo compiler activation exports CONDA_GO_COMPILER=1, which makes
# the go tool default GOBIN to $PREFIX/bin and GOPATH to $SRC_DIR/gopath. The
# Kubernetes build sets its own GOPATH and expects binaries under _output/, so
# clear it. This replaces the former hack/lib/golang.sh source patch, whose
# context no longer exists upstream and which rattler-build only applied by fuzz.
unset CONDA_GO_COMPILER

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
