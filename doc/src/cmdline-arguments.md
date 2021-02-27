# Command line arguments

## Available options are

|argument|value|description|
|:-------|:----|:----------|
|**-b**|**\<value\>**|**Blink X times on startup**<br>(b/w 1 and 20 with led0 or GPIO pin if defined)|
|**-f**|**\<device\>**|**Framebuffer device**<br>Input device: /dev/fb0|
|**-h**||**Print help screen and exit**|
|**-l**||**Use onboard led0 for streaming status indication**|
|**-n**|**\<buffers\>**|**Number of Video buffers**<br>(b/w 2 and 32)|
|**-p**|**\<pin_number\>**|**GPIO pin number for streaming status indication**|
|**-r**|**\<fps\>**|**Framerate for framebuffer**<br>(b/w 1 and 30)|
|**-u**|**\<device\>**|**UVC Video Output device**<br>Output device: /dev/video1|
|**-v**|**\<device\>**|**V4L2 Video Capture device**<br>Input device: /dev/video0|
|**-x**||**Show fps information**|


## Resources
[Raspberry Pi GPIO](https://www.raspberrypi.org/documentation/usage/gpio/)


## Differences from the original version of uvc-gadget

### New arguments - described above

    * -b
    * -f
    * -l
    * -p
    * -r
    * -x

### Removed arguments

 * -b - Use bulk mode
    - unused feature

 * -d - Do not use any real V4L2 capture device
    - unused feature

 * -f - Select frame format
    - frame format is removed from uvc-gadget.c and now is obtained from configfs and host computer

 * -i - MJPEG image
    - removed during code cleanup and simplification

 * -m - Streaming mult for ISOC (b/w 0 and 2)
    - unnecessary for new version - dwMaxPayloadTransferSize is set to streaming_maxpacket value

 * -o - Select UVC IO method
    - unnecessary for new version - input device always use MMAP and UVC device use USER_PTR

 * -r - Select frame resolution
    - frame resolution is removed from uvc-gadget.c and now is obtained from configfs and host computer

 * -s - Select USB bus speed (b/w 0 and 2)
    - unnecessary for new version - dwMaxPayloadTransferSize is set to streaming_maxpacket value

 * -t - Streaming burst (b/w 0 and 15)
    - unnecessary for new version - dwMaxPayloadTransferSize is set to streaming_maxpacket value

