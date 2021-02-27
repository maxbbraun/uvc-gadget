# USB gadget with UVC camera - configfs

/ UNDER CONSTRUCTION /

## USB gadget configuration bash script

**multi-gadget.sh**

``` bash
# path for usb gadget inside configfs
GADGET_PATH=/sys/kernel/config/usb_gadget/pi4

# create main path for usb gadget
mkdir $GADGET_PATH

# vendor ID / 0x1d6b - Linux Foundation
echo 0x1d6b > $GADGET_PATH/idVendor

# product ID / 0x0104 - Multifunction Composite Gadget
echo 0x0104 > $GADGET_PATH/idProduct

# bcd device release number / 0x0100 - USB Device version
echo 0x0100 > $GADGET_PATH/bcdDevice

# bcd USB specification version number / 0x0200 - USB 2.0
echo 0x0200 > $GADGET_PATH/bcdUSB

# USB device class code / 0xEF - Miscellaneous
echo 0xEF > $GADGET_PATH/bDeviceClass

# USB device subclass code / 0x02 - Interface Association Descriptor.
echo 0x02 > $GADGET_PATH/bDeviceSubClass

# USB device protocol code / 0x01 - Interface Association Descriptor.
echo 0x01 > $GADGET_PATH/bDeviceProtocol

# This group contains subdirectories for language-specific strings for this gadget.
mkdir $GADGET_PATH/strings/0x409

# gadget's serial number (string) / SerialNumber string
echo 100000000d2386db > $GADGET_PATH/strings/0x409/serialnumber

# gadget's manufacturer description / USB Manufacturer string
echo "Raspberry" > $GADGET_PATH/strings/0x409/manufacturer

# gadget's product description / Product string
echo "PI4 USB Device" > $GADGET_PATH/strings/0x409/product

# This group contains a USB gadget's configurations
mkdir $GADGET_PATH/configs/c.2

# english string / 0x409 
mkdir $GADGET_PATH/configs/c.2/strings/0x409

# maximum power consumption from the bus / 500 mA
echo 500 > $GADGET_PATH/configs/c.2/MaxPower

# UVC
echo "UVC" > $GADGET_PATH/configs/c.2/strings/0x409/configuration

# gadget functions for device UVC
mkdir $GADGET_PATH/functions/uvc.usb0

# gadget functions for device ACM
mkdir $GADGET_PATH/functions/acm.usb0

#
mkdir -p $GADGET_PATH/functions/uvc.usb0/control/header/h

# symlink for full speed control class descriptors
ln -s $GADGET_PATH/functions/uvc.usb0/control/header/h $GADGET_PATH/functions/uvc.usb0/control/class/fs/h

# function for frame descriptors
config_frame () {
  FORMAT=$1
  NAME=$2
  WIDTH=$3
  HEIGHT=$4

  # create path for frame descriptor
  framedir=$GADGET_PATH/functions/uvc.usb0/streaming/$FORMAT/$NAME/${HEIGHT}p
  mkdir -p $framedir

  # width of decoded bitmam frame in px
  echo $WIDTH > $framedir/wWidth
  
  # height of decoded bitmap frame in px
  echo $HEIGHT > $framedir/wHeight
  
  # the frame interval the device would like to use as default
  echo 333333 > $framedir/dwDefaultFrameInterval
  
  # the minimum bit rate at the longest frame interval in bps
  echo $(($WIDTH * $HEIGHT * 80)) > $framedir/dwMinBitRate
  
  # the maximum bit rate at the shortest frame interval in bps
  echo $(($WIDTH * $HEIGHT * 160)) > $framedir/dwMaxBitRate
  
  # he maximum number of bytes the compressor will produce for a video frame or still image
  echo $(($WIDTH * $HEIGHT * 2)) > $framedir/dwMaxVideoFrameBufferSize
  
  # indicates how frame interval can be programmed; a number of values separated by newline can be specified
  cat <<EOF > $framedir/dwFrameInterval
333333
400000
666666
EOF
}

# create frame descriptors for MJPEG format and selected resolutions
config_frame mjpeg m 640 360
config_frame mjpeg m 640 480
config_frame mjpeg m 800 600
config_frame mjpeg m 1024 768
config_frame mjpeg m 1280 720
config_frame mjpeg m 1280 960
config_frame mjpeg m 1440 1080
config_frame mjpeg m 1536 864
config_frame mjpeg m 1600 900
config_frame mjpeg m 1600 1200
config_frame mjpeg m 1920 1080

# you can create frame descriptors for YUYV format and selected resolutions
# config_frame uncompressed u 1920 1080

# Specific streaming header descriptors
mkdir $GADGET_PATH/functions/uvc.usb0/streaming/header/h

# symlink to - MJPEG format descriptors
cd $GADGET_PATH/functions/uvc.usb0/streaming/header/h
ln -s ../../mjpeg/m
# ln -s ../../uncompressed/u

# symlink to - Full speed streaming class descriptors
cd ../../class/fs
ln -s ../../header/h

# symlink to - High speed streaming class descriptors
cd ../../class/hs
ln -s ../../header/h

# symlink for UVC functions
ln -s $GADGET_PATH/functions/uvc.usb0 $GADGET_PATH/configs/c.2/uvc.usb0

# symlink for ACM function
ln -s $GADGET_PATH/functions/acm.usb0 $GADGET_PATH/configs/c.2/acm.usb0

# Watches the udev event queue, and exits if all current events are handled with timeout = 5 sec.
udevadm settle -t 5 || :

# Enabling the gadget
ls /sys/class/udc > $GADGET_PATH/UDC

```

## Tree of USB gadget configuration with description

```
/sys/kernel/config/usb_gadget/
└─ pi4
  ├─ bcdDevice                                  bcd device release number / 0x0100 - USB Device version
  ├─ bcdUSB                                     bcd USB specification version number / 0x0200 - USB 2.0
  ├─ bDeviceClass                               USB device class code / 0xEF - Miscellaneous
  ├─ bDeviceProtocol                            USB device protocol code / 0x01 - Interface Association Descriptor.
  ├─ bDeviceSubClass                            USB device subclass code / 0x02 - Interface Association Descriptor.
  ├─ bMaxPacketSize0                            maximum endpoint 0 packet size
  ├─ idProduct                                  product ID / 0x0104 - Multifunction Composite Gadget
  ├─ idVendor                                   vendor ID / 0x1d6b - Linux Foundation
  ├─ os_desc                                    This group contains "OS String" extension handling attributes.    
  │ ├─ b_vendor_code                            one-byte value used for custom per-device and per-interface requests    
  │ ├─ qw_sign                                  an identifier to be reported as "OS String" proper    
  │ └─ use                                      flag turning "OS Desctiptors" support on/off    
  ├─ strings                                    This group contains subdirectories for language-specific strings for this gadget.    
  │ └─ 0x409
  │   ├─ manufacturer                           gadget's manufacturer description / USB Manufacturer string
  │   ├─ product                                gadget's product description / Product string
  │   └─ serialnumber                           gadget's serial number (string) / SerialNumber string
  ├─ UDC                                        bind a gadget to UDC/unbind a gadget;
  │                                               write UDC's name found in /sys/class/udc/* to bind a  gadget
  │                                               empty string "" to unbind.  
  ├─ configs                                    This group contains a USB gadget's configurations    
  │ └─ c.2        
  │   ├─ acm.usb0 -> /sys/kernel/config/usb_gadget/pi4/functions/acm.usb0        
  │   ├─ bmAttributes                           configuration characteristics    
  │   ├─ MaxPower                               maximum power consumption from the bus / 500  
  │   ├─ strings
  │   │ └─ 0x409
  │   │   └─ configuration                      UVC  
  │   └─ uvc.usb0 -> /sys/kernel/config/usb_gadget/pi4/functions/uvc.usb0        
  └─ functions
    ├─ acm.usb0
    │ └─ port_num
    └─ uvc.usb0
      ├─ control
      │ ├─ bInterfaceNumber                 RO  USB interface number for this streaming interface    
      │ ├─ class                                Class descriptors    
      │ │ ├─ fs                                 Full speed control class descriptors    
      │ │ │ └─ h -> /sys/kernel/config/usb_gadget/pi4/functions/uvc.usb0/control/header/h        
      │ │ └─ ss                                 Super speed control class descriptors    
      │ ├─ header                               Control header descriptors    
      │ │ └─ h                                  Specific control header descriptors    
      │ │   ├─ bcdUVC
      │ │   └─ dwClockFrequency
      │ ├─ processing                           Processing unit descriptors    
      │ │ └─ default                            Default processing unit descriptors    
      │ │   ├─ bmControls                   RO  bitmap specifying which controls are supported for the video stream    
      │ │   ├─ bSourceID                    RO  id of the terminal to which this unit is connected    
      │ │   ├─ bUnitID                      RO  a non-zero id of this unit    
      │ │   ├─ iProcessing                  RO  index of string descriptor    
      │ │   └─ wMaxMultiplier               RO  maximum digital magnification x100    
      │ └─ terminal                             Terminal descriptors    
      │   ├─ camera                             Camera terminal descriptors    
      │   │ └─ default                          Default camera terminal descriptors    
      │   │   ├─ bAssocTerminal             RO  id of the output terminal to which this terminal is connected    
      │   │   ├─ bmControls                 RO  bitmap specifying which controls are supported for the video stream    
      │   │   ├─ bTerminalID                RO  a non-zero id of this terminal    
      │   │   ├─ iTerminal                  RO  index of string descriptor    
      │   │   ├─ wObjectiveFocalLengthMax   RO  the value of Lmax    
      │   │   ├─ wObjectiveFocalLengthMin   RO  the value of Lmin    
      │   │   ├─ wOcularFocalLength         RO  the value of Locular    
      │   │   └─ wTerminalType              RO  terminal type    
      │   └─ output                             Output terminal descriptors    
      │     └─ default                          Default output terminal descriptors    
      │       ├─ bAssocTerminal             RO  id of the input terminal to which this output terminal is associated    
      │       ├─ bSourceID                  RO  id of the terminal to which this terminal is connected    
      │       ├─ bTerminalID                RO  a non-zero id of this terminal    
      │       ├─ iTerminal                  RO  index of string descriptor    
      │       └─ wTerminalType              RO  terminal type    
      ├─ streaming_interval                     1..16  1  
      ├─ streaming_maxburst                     0..15 (ss only)  0  
      ├─ streaming_maxpacket                    1..1023 (fs), 1..3072 (hs/ss)  1023  
      └─ streaming                              Streaming descriptors    
        ├─ bInterfaceNumber                 RO  USB interface number for this streaming interface    
        ├─ class                                Streaming class descriptors    
        │ ├─ fs                                 Full speed streaming class descriptors    
        │ │ └─ h -> /sys/kernel/config/usb_gadget/pi4/functions/uvc.usb0/streaming/header/h        
        │ ├─ hs                                 High speed streaming class descriptors    
        │ │ └─ h -> /sys/kernel/config/usb_gadget/pi4/functions/uvc.usb0/streaming/header/h        
        │ └─ ss                                  Super speed streaming class descriptors    
        ├─ color_matching                        Color matching descriptors    
        │ └─ default                            Default color matching descriptors    
        │   ├─ bColorPrimaries              RO  color primaries and the reference white    
        │   ├─ bMatrixCoefficients          RO  matrix used to compute luma and chroma values from the color primaries    
        │   └─ bTransferCharacteristics     RO  optoelectronic transfer characteristic of the source picutre, also called the gamma on    
        ├─ header                               Streaming header descriptors    
        │ └─ h                                  Specific streaming header descriptors    
        │   ├─ bmInfo                       RO  capabilities of this video streaming interface    
        │   ├─ bStillCaptureMethod          RO  method of still image caputre supported    
        │   ├─ bTerminalLink                RO  id of the output terminal to which the video endpoint of this interface is connected    
        │   ├─ bTriggerSupport              RO  flag specifying if hardware triggering is supported    
        │   ├─ bTriggerUsage                RO  how the host software will respond to a hardware trigger interrupt event    
        │   └─ m -> /sys/kernel/config/usb_gadget/pi4/functions/uvc.usb0/streaming/mjpeg/m        
        ├─ mjpeg                                MJPEG format descriptors    
        │ └─ m                                  Specific MJPEG format descriptors    
        │   ├─ bAspectRatioX                RO  the X dimension of the picture aspect ratio    
        │   ├─ bAspectRatioY                RO  the Y dimension of the picture aspect ratio    
        │   ├─ bDefaultFrameIndex               optimum frame index for this stream    
        │   ├─ bFormatIndex                 RO  unique id for this format descriptor; only defined after parent header is linked into the streaming class  
        │   ├─ bmaControls                      this format's data for bmaControls in the streaming header    
        │   ├─ bmFlags                      RO  characteristics of this format    
        │   ├─ bmInterfaceFlags             RO  specifies interlace information    
        │   └─ 1080p                            Specific MJPEG frame descriptors    
        │     ├─ bFrameIndex                RO  unique id for this framedescriptor; only defined after parent format is linked into the streaming header    
        │     ├─ bmCapabilities                 still image support, fixed frame-rate support    
        │     ├─ dwDefaultFrameInterval         the frame interval the device would like to use as default    
        │     ├─ dwFrameInterval                indicates how frame interval can be programmed; a number of values separated by newline can be specified    
        │     ├─ dwMaxBitRate                   the maximum bit rate at the shortest frame interval in bps    
        │     ├─ dwMaxVideoFrameBufferSize      the maximum number of bytes the compressor will produce for a video frame or still image  
        │     ├─ dwMinBitRate                   the minimum bit rate at the longest frame interval in bps    
        │     ├─ wHeight                        height of decoded bitmap frame in px     
        │     └─ wWidth                         width of decoded bitmam frame in px    
        └─ uncompressed                         Uncompressed format descriptors    
          └─ u                                  Specific uncompressed format descriptors    
            ├─ bAspectRatioX                RO  the X dimension of the picture aspect ratio    
            ├─ bAspectRatioY                RO  the Y dimension of the picture aspect ratio    
            ├─ bBitsPerPixel                    number of bits per pixel used to specify color in the decoded video frame    
            ├─ bDefaultFrameIndex               optimum frame index for this stream    
            ├─ bFormatIndex                 RO  unique id for this format descriptor; only defined after parent header is linked into the streaming   
            ├─ bmaControls                      this format's data for bmaControls in the streaming header    
            ├─ bmInterfaceFlags                 specifies interlace information, read-only    
            ├─ guidFormat                       globally unique id used to identify stream-encoding format    
            └─ 1200p                            Specific uncompressed frame descriptors    
              ├─ bFrameIndex                RO  unique id for this framedescriptor; only defined after parent format is linked into the streaming header    
              ├─ bmCapabilities                 still image support, fixed frame-rate support    
              ├─ dwDefaultFrameInterval         the frame interval the device would like to use as default    
              ├─ dwFrameInterval                indicates how frame interval can be programmed; a number of values separated by newline can be specified    
              ├─ dwMaxBitRate                   the maximum bit rate at the shortest frame interval in bps    
              ├─ dwMaxVideoFrameBufferSize      the maximum number of bytes the compressor will produce for a video frame or still image    
              ├─ dwMinBitRate                   the minimum bit rate at the longest frame interval in bps    
              ├─ wHeight                        height of decoded bitmap frame in px    
              └─ wWidth                         width of decoded bitmap frame in px    
```

## Resources
 * [Linux USB gadget configured through configfs](https://www.kernel.org/doc/Documentation/usb/gadget_configfs.txt)
 * [Platform DesignWare HS OTG USB 2.0 controller](https://github.com/raspberrypi/linux/blob/rpi-5.4.y/Documentation/devicetree/bindings/usb/dwc2.txt)
 * [configfs-usb-gadget-uvc](https://www.kernel.org/doc/Documentation/ABI/testing/configfs-usb-gadget-uvc)
 * [configfs-usb-gadget-acm](https://www.kernel.org/doc/Documentation/ABI/testing/configfs-usb-gadget-acm)
