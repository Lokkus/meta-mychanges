FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://fix-numpy-paths.patch;striplevel=0"

EXTRA_OEMESON += "-DNUMPY_INCLUDEDIR=${STAGING_LIBDIR}/${PYTHON_DIR}/site-packages/numpy/core/include \
                  -DNUMPY_LIBDIR=${STAGING_LIBDIR}/${PYTHON_DIR}/site-packages/numpy/core/lib"