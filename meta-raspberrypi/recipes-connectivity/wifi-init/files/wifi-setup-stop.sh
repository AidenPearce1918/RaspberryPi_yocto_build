#!/bin/sh

# WiFi Setup - Shutdown Script
# Ensure wlan0 is brought down correctly and clean up WiFi configurations

LOG_FILE="/var/log/wifi-setup.log"

# Function to log messages
log_message() {
    echo "$(date) - $1" >> $LOG_FILE
}

log_message "Starting WiFi shutdown script."

# Check if wlan0 is up
if ifconfig wlan0 >/dev/null 2>&1; then
    log_message "Bringing down wlan0 interface."
    if ! ifconfig wlan0 down; then
        log_message "ERROR: Failed to bring down wlan0."
        exit 1
    fi
    log_message "wlan0 brought down successfully."
else
    log_message "ERROR: wlan0 interface is not active."
    exit 1
fi

# Optionally, stop wpa_supplicant if it is running
if pidof wpa_supplicant >/dev/null; then
    log_message "Stopping wpa_supplicant."
    if ! killall wpa_supplicant; then
        log_message "ERROR: Failed to stop wpa_supplicant."
        exit 1
    fi
    log_message "wpa_supplicant stopped."
else
    log_message "wpa_supplicant not running."
fi

log_message "WiFi shutdown completed."
exit 0
