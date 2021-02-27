# uvc-gadget

## Finished linux-based firmware package
If you need a fast and maintained linux-based firmware package for your webcam then here is the best place for you - [https://github.com/showmewebcam/showmewebcam](https://github.com/showmewebcam/showmewebcam). 
- linux-based firmware package
- fast boot
- uvc-gadget inside

## DIY place
If you want to build it yourself, then here is a place for you.

## Documentation
[New documentation for uvc-gadget](doc/Readme.md)

## How to use

    Usage: ./uvc-gadget [options]
    
    Available options are
        -b value       Blink X times on startup (b/w 1 and 20 with led0 or GPIO pin if defined)
        -f device      Framebuffer device
        -h             Print this help screen and exit
        -l             Use onboard led0 for streaming status indication
        -n value       Number of Video buffers (b/w 2 and 32)
        -p value       GPIO pin number for streaming status indication
        -r value       Framerate for framebuffer (b/w 1 and 30)
        -u device      UVC Video Output device
        -v device      V4L2 Video Capture device
        -x             show fps information

## Build  

- host:  
    make
- Cross compile:  
    make ARCH=arch CROSS_COMPILE=cross_compiler  
    eg:  
    make ARCH=arm CROSS_COMPILE=arm-hisiv600-linux-  
- or:  
    set ARCH, CROSS_COMPILE, KERNEL_DIR in Makefile

## Change log

- Apply patchset [Bugfixes for UVC gadget test application](https://www.spinics.net/lists/linux-usb/msg99220.html)  

- Apply patchset [UVC gadget test application enhancements](https://www.spinics.net/lists/linux-usb/msg84376.html)  

- Add Readme/.gitignore and documentations  
  Copy linux-3.18.y/drivers/usb/gadget/function/uvc.h into repository, change include path for build

## Initial

- Original [uvc-gadget.git](http://git.ideasonboard.org/uvc-gadget.git)
- Fork(copy) [uvc-gadget.git - wlhe](https://github.com/wlhe/uvc-gadget)
- Fork(copy) [uvc-gadget.git - climberhunt / Dave Hunt](https://github.com/climberhunt/uvc-gadget)
- Fork(copy) [uvc-gadget.git - peterbay / Petr Vavrin](https://github.com/peterbay/uvc-gadget)

## TODO
 * better usb gadget configuration - maybe https://github.com/libusbgx/libusbgx
 * better readme and wiki pages

## Resources

- [Raspberry Pi Zero with Pi Camera as USB Webcam / Dave Hunt](http://www.davidhunt.ie/raspberry-pi-zero-with-pi-camera-as-usb-webcam/)
- [TC35874 to UVC gadget application / Kin Wei Lee](https://github.com/kinweilee/v4l2-mmal-uvc)

