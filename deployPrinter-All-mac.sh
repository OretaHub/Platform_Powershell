#!/bin/bash

# Define variables
PKG_URL="https://stgoretamgmt.blob.core.windows.net/sentinelonemsi/DriverV350.pkg"
PKG_FILE="$HOME/Downloads/DriverV350.pkg"
DRIVER_PATH="/Library/Printers/PPDs/Contents/Resources/FF APGPD01 V300 PS EN"

# Array of printer URIs and corresponding names
PRINTER_URIS=(
    "lpd://rchprn03f/lpr_print"
    "lpd://rchprn03f/lpr_hold"
    "lpd://rchprn04f/lpr_print"
    "lpd://rchprn04f/lpr_hold"
    "lpd://rchprn04f/A4BookletL"
    "lpd://rchprn04f/A4BookletP"
    "lpd://rchprn03f/A4BookletL"
    "lpd://rchprn03f/A4BookletP"
)
PRINTER_NAMES=(
    "RCHPRN03F_PRINT"
    "RCHPRN03F_HOLD"
    "RCHPRN04F_PRINT"
    "RCHPRN04F_HOLD"
    "RCHPRN04F_A4BOOKLET_L"
    "RCHPRN04F_A4BOOKLET_P"
    "RCHPRN03F_A4BOOKLET_L"
    "RCHPRN03F_A4BOOKLET_P"
)

# Download the .pkg file to Downloads directory
curl -o "$PKG_FILE" -L "$PKG_URL"

# Install the .pkg file
installer -pkg "$PKG_FILE" -target /

# Install the printers using lpadmin command
for ((i=0; i<${#PRINTER_URIS[@]}; i++)); do
    lpadmin -p "${PRINTER_NAMES[i]}" -E -v "${PRINTER_URIS[i]}" -P "/Library/Printers/PPDs/Contents/Resources/FF APGPD01 V300 PS EN" 
    # Check if printer added successfully
    if [ $? -eq 0 ]; then
        echo "Printer ${PRINTER_NAMES[i]} added successfully."
    else
        echo "Failed to add printer ${PRINTER_NAMES[i]}."
    fi
done
