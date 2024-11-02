FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

do_install:append() {
    sed -i 's#/bin/sh#/bin/bash#' ${D}${datadir}/base-passwd/passwd.master
}