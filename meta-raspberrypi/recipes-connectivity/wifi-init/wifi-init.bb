DESCRIPTION = "WiFi Setup Scripts for Boot and Shutdown with WPA Supplicant"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

PR = "r0"

# Runtime dependencies, including wpa_supplicant
RDEPENDS_${PN} = "ifupdown wpa_supplicant"

# Define the source URI for the files to be copied into the image
SRC_URI = "file://wifi-setup-start.sh \
           file://wifi-setup-stop.sh \
           file://wpa_supplicant.conf"

# This function installs the scripts and config files
do_install() {
    # Create directories for init scripts and configuration files
    install -d ${D}${sysconfdir}/init.d
    install -d ${D}${sysconfdir}/rcS.d
    install -d ${D}${sysconfdir}/rcK.d
    install -d ${D}${sysconfdir}/wifi

    # Install the start and stop scripts into init.d
    install -m 0755 ${WORKDIR}/wifi-setup-start.sh  ${D}${sysconfdir}/init.d/
    install -m 0755 ${WORKDIR}/wifi-setup-stop.sh   ${D}${sysconfdir}/init.d/

    # Install the WPA Supplicant configuration file to /etc/wifi/
    install -m 0644 ${WORKDIR}/wpa_supplicant.conf  ${D}${sysconfdir}/wifi/

    # Create symbolic links in the runlevel directories for startup and shutdown scripts
    ln -sf ../init.d/wifi-setup-start.sh  ${D}${sysconfdir}/rcS.d/S90wifi-setup-start
    ln -sf ../init.d/wifi-setup-stop.sh   ${D}${sysconfdir}/rcK.d/K90wifi-setup-stop
}
