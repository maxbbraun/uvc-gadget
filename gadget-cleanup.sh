#!/bin/sh

echo "INFO: --- Gadget cleanup ---"

if [ $(id -u) -ne 0 ]
then
    echo "Please run as root"
    exit
fi

# Get configfs mountpoit
CONFIGFS_PATH=$(findmnt -t configfs -n --output=target)

if [ -e "${CONFIGFS_PATH}" ]; then
    echo "INFO: Configfs path: ${CONFIGFS_PATH}"
else
    echo "ERROR: Configfs path is not accessible"
fi

# Prepare paths and disable UDC if enabled
UDC_INTERFACE=$(ls /sys/class/udc)
GADGET_DIRECTORY=$(ls -t "${CONFIGFS_PATH}/usb_gadget/" | head -n 1)

if [ -e "/sys/class/udc/$UDC_INTERFACE/uevent" ]; then
    . "/sys/class/udc/$UDC_INTERFACE/uevent"

    if [ -z "${USB_UDC_DRIVER}" ]; then
        echo "INFO: UDC is disabled"
    else
        echo "INFO: USB UDC Driver: ${USB_UDC_DRIVER}"
        echo "INFO: UDC is enabled, lets disable it"
        GADGET_DIRECTORY="${USB_UDC_DRIVER}"

        if [ -e "${CONFIGFS_PATH}/usb_gadget/${USB_UDC_DRIVER}/UDC" ]; then
            echo "INFO: Disable UDC"
            echo "" > "${CONFIGFS_PATH}/usb_gadget/${USB_UDC_DRIVER}/UDC"
        fi
    fi
fi

if [ -z "${GADGET_DIRECTORY}" ]; then
    echo "INFO: Gadget directory not found - nothing to do"
    exit 0
fi

# Prepare gadget config path
GADGET_PATH="${CONFIGFS_PATH}/usb_gadget/${GADGET_DIRECTORY}"

if [ -e "${GADGET_PATH}" ]; then
    echo "INFO: Gadget config path: ${GADGET_PATH}"
else
    echo "INFO: Gadget config path not found - nothing to do"
    exit 0
fi

GADGET_FUNCTIONS_PATH="${GADGET_PATH}/functions"
GADGET_CONFIGS_DIRECTORY=$(ls -t "${GADGET_PATH}/configs/" | head -n 1)
GADGET_CONFIGS_PATH="${GADGET_PATH}/configs/${GADGET_CONFIGS_DIRECTORY}"

# Unlink configs
find "${GADGET_CONFIGS_PATH}" -maxdepth 1 -mindepth 1 -type l | while read DIR
do
    echo "INFO: Unlink gadget configs: ${DIR}"
    unlink "${DIR}"
done

# Unlink functions
find "${GADGET_FUNCTIONS_PATH}" -maxdepth 10 -mindepth 1 -type l | while read DIR
do
    echo "INFO: Unlink gadget functions: ${DIR}"
    unlink "${DIR}"
done

if [ -e "${GADGET_PATH}/strings/0x409"   ]; then
    echo "INFO: Remove gadget strings: ${GADGET_PATH}/strings/0x409"
    rmdir "${GADGET_PATH}/strings/0x409"
fi

if [ -e "${GADGET_CONFIGS_PATH}/strings/0x409" ]; then
    echo "INFO: Remove configs strings: ${GADGET_CONFIGS_PATH}/strings/0x409"
    rmdir  "${GADGET_CONFIGS_PATH}/strings/0x409"
fi

find "${GADGET_FUNCTIONS_PATH}" -maxdepth 1 -mindepth 1 -type d | while read FUNCTION_DIR
do
    # Cleanup UVC
    if [ -e "${FUNCTION_DIR}/streaming" ]; then
        # Cleanup UVC functions streaming uncompressed
        if [ -e "${FUNCTION_DIR}/streaming/uncompressed" ]; then
            UNCOMPRESSED=$(find "${FUNCTION_DIR}/streaming/uncompressed/" -maxdepth 1 -mindepth 1 -type d)
            if [ -e "${UNCOMPRESSED}" ]; then
                find "${UNCOMPRESSED}" -maxdepth 1 -mindepth 1 -type d | while read DIR
                do
                    echo "INFO: UVC Remove uncompressed streaming frame format: ${DIR}"
                    rmdir "${DIR}"
                done

                echo "INFO: UVC Remove uncompressed format: ${UNCOMPRESSED}"
                rmdir "${UNCOMPRESSED}"
            fi
        fi
        
        # Cleanup UVC functions streaming mjpeg
        if [ -e "${FUNCTION_DIR}/streaming/mjpeg" ]; then
            MJPEG=$(find "${FUNCTION_DIR}/streaming/mjpeg/" -maxdepth 1 -mindepth 1 -type d)
            if [ -e "${MJPEG}" ]; then
                find "${MJPEG}" -maxdepth 1 -mindepth 1 -type d | while read DIR
                do
                    echo "INFO: UVC Remove mjpeg streaming frame format: ${DIR}"
                    rmdir "${DIR}"
                done

                echo "INFO: UVC Remove mjpeg format: ${MJPEG}"
                rmdir "${MJPEG}"
            fi
        fi
    fi
done

# Remove header settings
find "${GADGET_PATH}" -path "*/header/*" -type d | while read HEADER_DIR
do
    echo "INFO: Remove gadget header settings: ${HEADER_DIR}"
    rmdir "${HEADER_DIR}"
done

find "${GADGET_FUNCTIONS_PATH}" -maxdepth 1 -mindepth 1 -type d | while read FUNCTION_DIR
do
    echo "INFO: Remove functions: ${FUNCTION_DIR}"
    rmdir "${FUNCTION_DIR}"
done

if [ -e "${GADGET_CONFIGS_PATH}" ]; then
    echo "INFO: Remove configs: ${GADGET_CONFIGS_PATH}"
    rmdir "${GADGET_CONFIGS_PATH}"
fi

if [ -e "${GADGET_PATH}" ]; then
    echo "INFO: Remove gadget directory: ${GADGET_CONFIGS_PATH}"
    rmdir "${GADGET_PATH}"
fi

if [ -e "${GADGET_PATH}" ]; then
    echo "ERROR: USB gadget cleanup failed"
else
    echo "INFO: USB gadget cleaned up"
fi
