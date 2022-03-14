#!/usr/bin/env bash
set -euf

if [[ "$GOOS" == "darwin" && "$GOARCH" == "arm64" ]]; then
  # Makefile has its own setup for target/platform
  export KUBE_BUILD_PLATFORMS=darwin/arm64
  # Only binaries with host arch go to bin/
  # to replicate go install behavior
  OUTPUT_DIR="local/bin/${KUBE_BUILD_PLATFORMS}"
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
