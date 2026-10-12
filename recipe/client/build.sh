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

set -euf

HOST_GOOS="$(go env GOHOSTOS)"
HOST_GOARCH="$(go env GOHOSTARCH)"

if [[ "$GOOS" != "$HOST_GOOS" || "$GOARCH" != "$HOST_GOARCH" ]]; then
  # Cross-compile: Makefile has its own setup for target/platform
  export KUBE_BUILD_PLATFORMS="${GOOS}/${GOARCH}"
  # Only binaries with host arch go to bin/ (replicates go install behavior)
  OUTPUT_DIR="local/bin/${KUBE_BUILD_PLATFORMS}"
  # hack/lib/golang.sh overrides CC on cross-compile from
  # KUBE_${GOOS}_${GOARCH}_CC (default: e.g. aarch64-linux-gnu-gcc,
  # absent from the conda build env). Point it at the conda
  # cross-compiler the activation scripts set up.
  GOOS_GOARCH_UPPER="$(echo "${GOOS}_${GOARCH}" | tr '[:lower:]' '[:upper:]')"
  export "KUBE_${GOOS_GOARCH_UPPER}_CC=${CC}"
else
  OUTPUT_DIR=bin
fi

# This comes from k8s
. hack/lib/init.sh

mkdir -p "$PREFIX"/bin
export GO_TMPDIR=$SRC_DIR/tmp
go env

make all WHAT="${KUBE_CLIENT_TARGETS[*]}"

for cmd in ${KUBE_CLIENT_BINARIES[*]}; do
  cp "_output/${OUTPUT_DIR}/${cmd}" "$PREFIX/bin"
done
