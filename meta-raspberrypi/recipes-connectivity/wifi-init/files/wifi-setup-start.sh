#!/bin/sh

# WiFi Setup - Startup Script
# Ensure that we have a valid WiFi interface (wlan0) and driver loaded

LOG_FILE="/var/log/wifi-setup.log"

# Function to log messages
log_message() {
    echo "$(date) - $1" >> $LOG_FILE
}

log_message "Starting WiFi setup script."

# Check if the wpa_supplicant service is installed
if ! command -v wpa_supplicant >/dev/null 2>&1; then
    log_message "ERROR: wpa_supplicant is not installed."
    exit 1
fi

# Check if wlan0 interface is available
if ! ifconfig wlan0 >/dev/null 2>&1; then
    log_message "ERROR: wlan0 interface not found."
    exit 1
fi

log_message "wlan0 interface found."

# Check if the driver for wlan0 is loaded
DRIVER=$(iw dev wlan0 info | grep "interface" | awk '{print $2}')
if [ -z "$DRIVER" ]; then
    log_message "ERROR: No driver loaded for wlan0."
    exit 1
fi

log_message "Driver $DRIVER loaded for wlan0."

# Check if WPA Supplicant config file exists
if [ ! -f /etc/wifi/wpa_supplicant.conf ]; then
    log_message "ERROR: WPA Supplicant configuration file not found at /etc/wifi/wpa_supplicant.conf."
    exit 1
fi

# Bringing up wlan0 with the WPA Supplicant configuration
log_message "Bringing up wlan0 using WPA Supplicant."
if ! wpa_supplicant -B -i wlan0 -c /etc/wifi/wpa_supplicant.conf; then
    log_message "ERROR: Failed to start wpa_supplicant."
    exit 1
fi

# Wait for a few seconds to ensure wlan0 connects properly
sleep 10

# Check if wlan0 has obtained an IP address
if ! ifconfig wlan0 | grep "inet " >/dev/null 2>&1; then
    log_message "ERROR: wlan0 did not obtain an IP address."
    exit 1
fi

log_message "WiFi setup completed successfully. wlan0 is connected."
exit 0

