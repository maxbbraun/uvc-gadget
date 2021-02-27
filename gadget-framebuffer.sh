#!/bin/sh

echo "INFO: --- Gadget framebuffer ---"

if [ $(id -u) -ne 0 ]
then
    echo "Please run as root"
    exit
fi

FB_WIDTH=$(cat /sys/class/graphics/fb0/virtual_size | cut -d, -f1)
FB_HEIGHT=$(cat /sys/class/graphics/fb0/virtual_size | cut -d, -f2)

echo "INFO: Framebuffer width:  ${FB_WIDTH}"
echo "INFO: Framebuffer height: ${FB_HEIGHT}"

# Get configfs mountpoit
CONFIGFS_PATH=$(findmnt -t configfs -n --output=target)

if [ -e "${CONFIGFS_PATH}" ]; then
    echo "INFO: Configfs path: ${CONFIGFS_PATH}"
else
    echo "ERROR: Configfs path is not accessible"
    exit 1
fi

GADGET_PATH="${CONFIGFS_PATH}/usb_gadget/fb_gadget"

echo "INFO: Gadget config path: ${GADGET_PATH}"

mkdir "${GADGET_PATH}"

echo 0x1d6b > "${GADGET_PATH}/idVendor"
echo 0x0104 > "${GADGET_PATH}/idProduct"
echo 0x0100 > "${GADGET_PATH}/bcdDevice"
echo 0x0200 > "${GADGET_PATH}/bcdUSB"

echo 0xEF   > "${GADGET_PATH}/bDeviceClass"
echo 0x02   > "${GADGET_PATH}/bDeviceSubClass"
echo 0x01   > "${GADGET_PATH}/bDeviceProtocol"

mkdir "${GADGET_PATH}/strings/0x409"
echo 100000000d2386db > "${GADGET_PATH}/strings/0x409/serialnumber"
echo "Raspberry"      > "${GADGET_PATH}/strings/0x409/manufacturer"
echo "RPi FB Device"  > "${GADGET_PATH}/strings/0x409/product"

mkdir "${GADGET_PATH}/configs/c.2"
mkdir "${GADGET_PATH}/configs/c.2/strings/0x409"
echo 500   > "${GADGET_PATH}/configs/c.2/MaxPower"
echo "UVC" > "${GADGET_PATH}/configs/c.2/strings/0x409/configuration"

FUNCTIONS_UVC="${GADGET_PATH}/functions/uvc.usb0"

mkdir "${FUNCTIONS_UVC}"
mkdir "${GADGET_PATH}/functions/acm.usb0"

echo 2048 > "${FUNCTIONS_UVC}/streaming_maxpacket"

FRAMEDIR="${FUNCTIONS_UVC}/streaming/uncompressed/u/${FB_WIDTH}x${FB_HEIGHT}p"
mkdir -p "${FRAMEDIR}"

echo $FB_WIDTH  > "${FRAMEDIR}/wWidth"
echo $FB_HEIGHT > "${FRAMEDIR}/wHeight"
echo 1000000    > "${FRAMEDIR}/dwDefaultFrameInterval"
echo $(($FB_WIDTH * $FB_HEIGHT * 80))  > "${FRAMEDIR}/dwMinBitRate"
echo $(($FB_WIDTH * $FB_HEIGHT * 160)) > "${FRAMEDIR}/dwMaxBitRate"
echo $(($FB_WIDTH * $FB_HEIGHT * 2))   > "${FRAMEDIR}/dwMaxVideoFrameBufferSize"
cat <<EOF > "${FRAMEDIR}/dwFrameInterval"
1000000
EOF

echo "INFO: Initialize configs and functions"

mkdir    "${FUNCTIONS_UVC}/streaming/header/h"
mkdir -p "${FUNCTIONS_UVC}/control/header/h"
ln -s    "${FUNCTIONS_UVC}/control/header/h"         "${FUNCTIONS_UVC}/control/class/fs/h"
ln -s    "${FUNCTIONS_UVC}/streaming/uncompressed/u" "${FUNCTIONS_UVC}/streaming/header/h"
ln -s    "${FUNCTIONS_UVC}/streaming/header/h"       "${FUNCTIONS_UVC}/streaming/class/fs"
ln -s    "${FUNCTIONS_UVC}/streaming/header/h"       "${FUNCTIONS_UVC}/streaming/class/hs"
ln -s    "${FUNCTIONS_UVC}"                          "${GADGET_PATH}/configs/c.2/uvc.usb0"
ln -s    "${GADGET_PATH}/functions/acm.usb0"         "${GADGET_PATH}/configs/c.2/acm.usb0"

echo "INFO: Enabling gadget"

udevadm settle -t 5 || :
ls /sys/class/udc > "${GADGET_PATH}/UDC"

echo "INFO: End"
