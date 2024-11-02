OPENBLAS_SRC = "${WORKDIR}/../../openblas/0.3.28/git"

do_install_ptest () {
    rsync -a ${B}/TESTING ${D}${PTEST_PATH} \
          --exclude CMakeFiles \
          --exclude cmake_install.cmake \
          --exclude Makefile

    # Copy BLAS from openblas
    rsync -a ${OPENBLAS_SRC}/lapack-netlib/BLAS ${D}${PTEST_PATH}/BLAS \
          --exclude CMakeFiles \
          --exclude cmake_install.cmake \
          --exclude Makefile

    rsync -a ${B}/LAPACKE ${D}${PTEST_PATH} \
          --exclude CMakeFiles \
          --exclude cmake_install.cmake \
          --exclude Makefile

    cp -r ${B}/bin ${D}${PTEST_PATH}
    cp -r ${B}/lapack_testing.py ${D}${PTEST_PATH}
    cp ${B}/CTestTestfile.cmake ${D}${PTEST_PATH}

    # Ensure target directories exist
    mkdir -p ${D}${PTEST_PATH}/TESTING
    mkdir -p ${D}${PTEST_PATH}/BLAS/TESTING

    # Copy .in files from appropriate locations
    cp ${S}/TESTING/*.in ${S}/TESTING/runtest.cmake ${D}${PTEST_PATH}/TESTING
    cp ${OPENBLAS_SRC}/lapack-netlib/BLAS/TESTING/*.in ${D}${PTEST_PATH}/BLAS/TESTING

    # Update paths in configuration files
    sed -i -e 's#${B}#${PTEST_PATH}#g' $(find ${D}${PTEST_PATH} -name CTestTestfile.cmake)
    sed -i -e 's#${S}#${PTEST_PATH}#g' $(find ${D}${PTEST_PATH} -name CTestTestfile.cmake)
    sed -i -e 's#${RECIPE_SYSROOT_NATIVE}##g' $(find ${D}${PTEST_PATH} -name CTestTestfile.cmake)
    sed -i -e 's#${PYTHON}#/usr/bin/python3#g' $(find ${D}${PTEST_PATH} -name CTestTestfile.cmake)
    sed -i -e 's#${WORKDIR}##g' $(find ${D}${PTEST_PATH} -name CTestTestfile.cmake)
}
