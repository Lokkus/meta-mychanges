Modifications to python3-scipy Package for Yocto on Raspberry Pi 3
Project Purpose
This project documents modifications introduced to enable the compilation of the python3-scipy package in the Yocto environment for Raspberry Pi 3. These changes address build errors related to recognizing the file format of numpy libraries, specifically the error /libnpymath.a: error adding symbols: file format not recognized. These issues arose from incorrect library paths during the linking process, particularly in the context of cross-compilation.

Changes Made in the Project
1. Added Patch Files
Patch fix-numpy-paths.patch
This patch was created to fix the library paths for numpy in the meson.build file. In the default settings, scipy attempts to detect the location of numpy using scripts run on the host machine, which did not work for cross-compilation and caused errors in recognizing file formats (file format not recognized). This patch replaces these scripts with the correct paths in Yocto's sysroot, enabling the compiler to locate numpy libraries correctly.

Changes introduced in this patch:

Used get_option('NUMPY_INCLUDEDIR') and get_option('NUMPY_LIBDIR') instead of dynamically detecting the numpy location, allowing the libraries to be found correctly during cross-compilation.
Updated npymath_path and npyrandom_path to point to the sysroot location, ensuring proper linking.
Patch scipy-1.11.4-fix-with-Yocto.patch
This patch modifies the pyproject.toml file, removing strict version dependencies for pybind11 and pythran. The original scipy version required specific versions of these libraries, which caused conflicts with versions available in Yocto. This change allows for greater version flexibility and compatibility with Yocto.

Changes introduced in this patch:

Removed version restrictions for pybind11 and pythran, allowing different versions to be used during compilation in Yocto.
2. Update to python3-scipy.bb File
The recipe (python3-scipy.bb) was modified as follows:

Added dependencies to DEPENDS to include numpy, pybind11, pythran, and lapack, which are required for successful scipy compilation.
Allowed the choice of openblas or lapack as providers for BLAS and LAPACK, adding flexibility in configuration.
Set NUMPY_INCLUDEDIR and NUMPY_LIBDIR values in EXTRA_OEMESON, allowing Yocto to locate the necessary numpy headers and libraries.
Extended the recipe with native and nativesdk options to enable compilation in different Yocto environments.
3. Issues and Solutions
Primary Reasons for the Changes
Error /libnpymath.a: error adding symbols: file format not recognized
The main issue was incorrect library paths for numpy, leading to errors during linking (file format not recognized). The fix-numpy-paths.patch patch resolves this problem by setting the correct library paths in the sysroot.

Version dependencies for pybind11 and pythran
The original scipy settings required specific versions of pybind11 and pythran, which conflicted with Yocto. The scipy-1.11.4-fix-with-Yocto.patch patch removes these restrictions, enabling greater compatibility.

Managing Patches with quilt
To manage patches, quilt was used, allowing precise control over the patch order. The fix-numpy-paths.patch needed to be applied after scipy-1.11.4-fix-with-Yocto.patch, ensuring no conflicts and correct functionality.

Installation Instructions
Copy the recipes-python/scipy folder to the appropriate layer in Yocto.

Ensure that SRC_URI points to the location of both patches.

Run the package build:

bash
Skopiuj kod
bitbake python3-scipy
After the build completes, verify that the package is correctly included in the system image.


