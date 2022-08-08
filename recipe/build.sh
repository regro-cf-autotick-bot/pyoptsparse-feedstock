#!/bin/bash

set -eox pipefail

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PREFIX/lib/pkgconfig:$BUILD_PREFIX/lib/pkgconfig

EXTRA_FLAGS=""
NP_INC="${SP_DIR}/numpy/core/include/"
echo "PYTHON TARGET=${PYTHON}"

if [[ $CONDA_BUILD_CROSS_COMPILATION == "1" ]]; then
  # Add pkg-config to cross-file binaries since meson will disable it
  # See https://github.com/mesonbuild/meson/issues/7276
  echo "[binaries]" >> $BUILD_PREFIX/meson_cross_file.txt
  echo "pkg-config = '$(which pkg-config)'" >> "$BUILD_PREFIX"/meson_cross_file.txt
  # Use Meson cross-file flag to enable cross compilation
  EXTRA_FLAGS="--cross-file $BUILD_PREFIX/meson_cross_file.txt"
  NP_INC=""
fi

export PKG_CONFIG=$(which pkg-config)

cd "${SRC_DIR}"
export MESON_ARGS="-Dipopt_dir=${PREFIX} -Dincdir_numpy=${NP_INC} -Dpython_target=${PYTHON} ${EXTRA_FLAGS}"
python -m build -n -x .
pip install --prefix "${PREFIX}" --no-deps --no-index --find-links dist pyoptsparse
