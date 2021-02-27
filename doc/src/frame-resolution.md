# Frame resolutions and formats

Uvc-gadget supports two formats for video transfer - uncompressed format **YUV** and compressed format **MJPEG**.

## YUV - uncompressed format
 * average transmission rate of 16 bits per pixel (2 bytes)
 * luma component (Y′) and two chrominance components, called U (blue projection) and V (red projection)
 * shares U and V values between two pixels
 * big stream payload = lower framerate
 * good image quality

## MJPEG - compressed format
 * each video frame is compressed separately as a JPEG image
 * smaller stream payload = higher framerate
 * acceptable image quality - a little bit of noise and compression artifacts

## Resolutions
 * it is usually quoted as width × height, with the units in pixels
 * can have a different aspect ratio

|width|height|aspect ratio|standard|
|:----|:-----|:-----------|:-------|
|640|360|16:9|nHD|
|640|480|4:3|VGA|
|800|600|4:3|SVGA|
|1024|768|4:3|XGA|
|1280|720|16:9|WXGA-H|
|1280|960|16:9|WXGA+|
|1440|1080|4:3|HDV 1080i|
|1536|864|16:9|N/A|
|1600|900|16:9|HD+|
|1600|1200|4:3|UXGA|
|1920|1080|16:9|FHD|

## Frame intervals
 * interval between video image frames (in 100ns units)
 * 30 fps = 1 / 30 * 10 000 000 = 333 333
 * 25 fps = 1 / 25 * 10 000 000 = 400 000
 * 15 fps = 1 / 15 * 10 000 000 = 666 666

## Configuration
Resolutions and frame formats are written to configfs and these arguments are used:

Path inside configfs */uvc.usb0/streaming/mjpeg/m/1080p

|parameter|sample value|description|
|:--------|:-----------|:----------|
|bmCapabilities||still image support, fixed frame-rate support<br>we use default value|
|dwDefaultFrameInterval|333333|the frame interval the device would like to use as default|
|dwFrameInterval|333333<br>400000<br>666666|indicates how frame interval can be programmed<br>a number of values separated by newline can be specified|
|dwMaxVideoFrameBufferSize|width * height * 2|the maximum number of bytes the compressor will produce for a video frame or still image|
|dwMinBitRate|width * height * 80|the minimum bit rate at the longest frame interval in bps|
|dwMaxBitRate|width * height * 160|the maximum bit rate at the shortest frame interval in bps|
|wWidth|1920|width of decoded bitmap frame in px|
|wHeight|1080|height of decoded bitmap frame in px|

## Resources
 * [YUV - Wikipedia](https://en.wikipedia.org/wiki/YUV)
 * [Motion JPEG - Wikipedia](https://en.wikipedia.org/wiki/Motion_JPEG)
 * [Compression artifact](https://en.wikipedia.org/wiki/Compression_artifact)
 * [Display resolution](https://en.wikipedia.org/wiki/Display_resolution)
 * [List of common resolutions](https://en.wikipedia.org/wiki/List_of_common_resolutions)
