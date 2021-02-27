#!/bin/sh

echo "INFO: --- Gadget check ---"

# Get configfs mountpoit
CONFIGFS_PATH=$(findmnt -t configfs -n --output=target)

if [ -e "${CONFIGFS_PATH}" ]; then
    echo "INFO: Configfs path:        ${CONFIGFS_PATH}"
else
    echo "ERROR: Configfs path:       NOT FOUND"
fi

LIBCOMPOSITE_STATE=$(grep "^libcomposite" /proc/modules)
if [ -z "${LIBCOMPOSITE_STATE}" ]; then
    echo "ERROR: libcomposite module: NOT FOUND"
else
    echo "INFO: libcomposite module:  ${LIBCOMPOSITE_STATE}"
fi

DWC2_STATE=$(grep "^dwc2" /proc/modules)
if [ -z "${DWC2_STATE}" ]; then
    echo "ERROR: dwc2 module:         NOT FOUND"
else
    echo "INFO: dwc2 module:          ${DWC2_STATE}"
fi

GADGET_DIRECTORY=$(ls -t "${CONFIGFS_PATH}/usb_gadget/" | head -n 1)
GADGET_PATH="${CONFIGFS_PATH}/usb_gadget/${GADGET_DIRECTORY}"
if [ -z "${GADGET_DIRECTORY}" ] || [ -z "${GADGET_PATH}" ]; then
    echo "INFO: Gadget path:          NOT FOUND"
    exit 1;
else
    echo "INFO: Gadget path:          ${GADGET_PATH}"
fi

UDC_INTERFACE=$(ls /sys/class/udc)
if [ -z "${UDC_INTERFACE}" ]; then
    echo "ERROR: UDC interface:       NOT FOUND"
else
    echo "INFO: UDC interface:        ${UDC_INTERFACE}"
fi

if [ -e "/sys/class/udc/$UDC_INTERFACE/uevent" ]; then
    . "/sys/class/udc/$UDC_INTERFACE/uevent"

    if [ -z "${USB_UDC_DRIVER}" ]; then
        echo "ERROR: USB UDC driver:      DISABLED"
        exit 1
    else
        echo "INFO: USB UDC driver:       ${USB_UDC_DRIVER}"
    fi
fi

GADGET_FUNCTIONS_PATH="${GADGET_PATH}/functions"
GADGET_CONFIGS_DIRECTORY=$(ls -t "${GADGET_PATH}/configs/" | head -n 1)
GADGET_CONFIGS_PATH="${GADGET_PATH}/configs/${GADGET_CONFIGS_DIRECTORY}"

find "${GADGET_CONFIGS_PATH}" -maxdepth 1 -mindepth 1 -type l | while read DIR
do
    echo "INFO: Gadget configs:       ${DIR}"
done

find "${GADGET_FUNCTIONS_PATH}" -maxdepth 1 -mindepth 1 -type d | while read DIR
do
    echo "INFO: Gadget function:      ${DIR}"
done

find "${GADGET_FUNCTIONS_PATH}" -maxdepth 1 -mindepth 1 -type d | while read FUNCTION_DIR
do
    if [ -e "${FUNCTION_DIR}/streaming" ]; then
        if [ -e "${FUNCTION_DIR}/streaming/uncompressed" ]; then
            UNCOMPRESSED=$(find "${FUNCTION_DIR}/streaming/uncompressed/" -maxdepth 1 -mindepth 1 -type d)
            if [ -e "${UNCOMPRESSED}" ]; then
                find "${UNCOMPRESSED}" -maxdepth 1 -mindepth 1 -type d | while read DIR
                do
                    echo "INFO: UVC streaming format: ${DIR}"
                done
            fi
        fi
        
        if [ -e "${FUNCTION_DIR}/streaming/mjpeg" ]; then
            MJPEG=$(find "${FUNCTION_DIR}/streaming/mjpeg/" -maxdepth 1 -mindepth 1 -type d)
            if [ -e "${MJPEG}" ]; then
                find "${MJPEG}" -maxdepth 1 -mindepth 1 -type d | while read DIR
                do
                    echo "INFO: UVC streaming format: ${DIR}"
                done
            fi
        fi
    fi
done
