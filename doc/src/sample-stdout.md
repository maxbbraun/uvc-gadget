# Sample stdout from uvc-gadget

[Back to documentation](../Readme.md)

Configuration obtained from configfs - formats with resolutions, USB streaming parameters

```
CONFIGFS: Initial path: /sys/kernel/config/usb_gadget
CONFIGFS: UVC: format: 1, frame: 10, resolution: 1600x1200, frame_interval: 333333,  bitrate: [153600000, 307200000]
CONFIGFS: UVC: format: 1, frame: 9, resolution: 1600x900, frame_interval: 333333,  bitrate: [115200000, 230400000]
CONFIGFS: UVC: format: 1, frame: 8, resolution: 1536x864, frame_interval: 333333,  bitrate: [106168320, 212336640]
CONFIGFS: UVC: format: 1, frame: 7, resolution: 1920x1080, frame_interval: 333333,  bitrate: [165888000, 331776000]
CONFIGFS: UVC: format: 1, frame: 6, resolution: 1280x960, frame_interval: 333333,  bitrate: [98304000, 196608000]
CONFIGFS: UVC: format: 1, frame: 5, resolution: 1280x720, frame_interval: 333333,  bitrate: [73728000, 147456000]
CONFIGFS: UVC: format: 1, frame: 4, resolution: 1024x768, frame_interval: 333333,  bitrate: [62914560, 125829120]
CONFIGFS: UVC: format: 1, frame: 3, resolution: 800x600, frame_interval: 333333,  bitrate: [38400000, 76800000]
CONFIGFS: UVC: format: 1, frame: 2, resolution: 640x480, frame_interval: 333333,  bitrate: [24576000, 49152000]
CONFIGFS: UVC: format: 1, frame: 1, resolution: 640x360, frame_interval: 333333,  bitrate: [18432000, 36864000]
CONFIGFS: STREAMING maxburst: 0
CONFIGFS: STREAMING maxpacket: 1023
CONFIGFS: STREAMING interval: 1
```

Internal settings based on commandline arguments

```
SETTINGS: Number of buffers requested: 2
SETTINGS: Show FPS: ENABLED
SETTINGS: IO method requested: USER_PTR
SETTINGS: GPIO pin for streaming status: not set
SETTINGS: Onboard led0 used for streaming status: DISABLED
SETTINGS: UVC device name: /dev/video1
SETTINGS: V4L2 device name: /dev/video0
```

Video devices initialization

```
DEVICE_UVC: Opening /dev/video1 device
DEVICE_UVC: Device is 20980000.usb on bus gadget
DEVICE_V4L2: Opening /dev/video0 device
DEVICE_V4L2: Device is mmal service 16.1 on bus platform:bcm2835-v4l2
```

Information about highest frame resolution for connected camera module

```
DEVICE_V4L2: Getting highest frame size: YUYV 4056x3040
DEVICE_V4L2: Getting highest frame size: MJPG 4056x3040
```

Available video controls for V4L2 Video Capture device and mapping between UVC and V4L2 controls

```
V4L2: Supported control Brightness (V4L2_CID_BRIGHTNESS = UVC_PU_BRIGHTNESS_CONTROL)
V4L2:   V4L2: min: 0, max: 100, step: 1, default: 50, value: 62
V4L2:   UVC: min: 0, max: 100, step: 1, default: 50, value: 62
V4L2: Supported control Contrast (V4L2_CID_CONTRAST = UVC_PU_CONTRAST_CONTROL)
V4L2:   V4L2: min: -100, max: 100, step: 1, default: 0, value: 20
V4L2:   UVC: min: 0, max: 200, step: 1, default: 100, value: 120
V4L2: Supported control Saturation (V4L2_CID_SATURATION = UVC_PU_SATURATION_CONTROL)
V4L2:   V4L2: min: -100, max: 100, step: 1, default: 0, value: 0
V4L2:   UVC: min: 0, max: 200, step: 1, default: 100, value: 100
V4L2: Supported control Red Balance (V4L2_CID_RED_BALANCE + V4L2_CID_BLUE_BALANCE = UVC_PU_WHITE_BALANCE_COMPONENT_CONTROL)
V4L2:   V4L2: min: 1, max: 7999, step: 1, default: 1000, value: 1000
V4L2:   UVC: min: 0, max: 7998, step: 1, default: 999, value: 999
V4L2: Supported control Power Line Frequency (V4L2_CID_POWER_LINE_FREQUENCY = UVC_PU_POWER_LINE_FREQUENCY_CONTROL)
V4L2:   V4L2: min: 0, max: 3, step: 1, default: 1, value: 1
V4L2:   UVC: min: 0, max: 3, step: 1, default: 1, value: 1
V4L2: Supported control Sharpness (V4L2_CID_SHARPNESS = UVC_PU_SHARPNESS_CONTROL)
V4L2:   V4L2: min: -100, max: 100, step: 1, default: 0, value: 0
V4L2:   UVC: min: 0, max: 200, step: 1, default: 100, value: 100
V4L2: Supported control Auto Exposure (V4L2_CID_EXPOSURE_AUTO = UVC_CT_AE_MODE_CONTROL)
V4L2:   V4L2: min: 0, max: 3, step: 1, default: 0, value: 0
V4L2:   UVC: min: 0, max: 3, step: 1, default: 0, value: 0
V4L2: Supported control Exposure Time, Absolute (V4L2_CID_EXPOSURE_ABSOLUTE = UVC_CT_EXPOSURE_TIME_ABSOLUTE_CONTROL)
V4L2:   V4L2: min: 1, max: 10000, step: 1, default: 1000, value: 1000
V4L2:   UVC: min: 0, max: 9999, step: 1, default: 999, value: 999
V4L2: Supported control Exposure, Dynamic Framerate (V4L2_CID_EXPOSURE_AUTO_PRIORITY = UVC_CT_AE_PRIORITY_CONTROL)
V4L2:   V4L2: min: 0, max: 1, step: 1, default: 0, value: 0
V4L2:   UVC: min: 0, max: 1, step: 1, default: 0, value: 0
```

Initialization for internal PROBE/COMMIT structures

```
UVC: Streaming control: action: INIT
FRAME: format: 1, frame: 1, resolution: 640x360, frame_interval: 333333,  bitrate: [18432000, 36864000]
DUMP: uvc_streaming_control: format: 1, frame: 1, frame interval: 333333
UVC: Streaming control: action: INIT
FRAME: format: 1, frame: 1, resolution: 640x360, frame_interval: 333333,  bitrate: [18432000, 36864000]
DUMP: uvc_streaming_control: format: 1, frame: 1, frame interval: 333333
```

Host computer querying available video controls

```
UVC: INPUT_TERMINAL - GET_INFO - UVC_CT_EXPOSURE_TIME_ABSOLUTE_CONTROL
UVC: INPUT_TERMINAL - GET_MIN - UVC_CT_EXPOSURE_TIME_ABSOLUTE_CONTROL
UVC: INPUT_TERMINAL - GET_MAX - UVC_CT_EXPOSURE_TIME_ABSOLUTE_CONTROL
UVC: INPUT_TERMINAL - GET_RES - UVC_CT_EXPOSURE_TIME_ABSOLUTE_CONTROL
UVC: INPUT_TERMINAL - GET_DEF - UVC_CT_EXPOSURE_TIME_ABSOLUTE_CONTROL
UVC: INPUT_TERMINAL - GET_MIN - UVC_CT_EXPOSURE_TIME_ABSOLUTE_CONTROL
UVC: INPUT_TERMINAL - GET_MAX - UVC_CT_EXPOSURE_TIME_ABSOLUTE_CONTROL
UVC: INPUT_TERMINAL - GET_RES - UVC_CT_EXPOSURE_TIME_ABSOLUTE_CONTROL
UVC: INPUT_TERMINAL - GET_INFO - UVC_CT_IRIS_ABSOLUTE_CONTROL - DISABLED
UVC: PROCESSING_UNIT - GET_INFO - UVC_PU_BRIGHTNESS_CONTROL
UVC: PROCESSING_UNIT - GET_MIN - UVC_PU_BRIGHTNESS_CONTROL
UVC: PROCESSING_UNIT - GET_MAX - UVC_PU_BRIGHTNESS_CONTROL
UVC: PROCESSING_UNIT - GET_RES - UVC_PU_BRIGHTNESS_CONTROL
UVC: PROCESSING_UNIT - GET_DEF - UVC_PU_BRIGHTNESS_CONTROL
UVC: PROCESSING_UNIT - GET_INFO - UVC_PU_GAMMA_CONTROL - DISABLED
UVC: PROCESSING_UNIT - GET_CUR - UVC_PU_BRIGHTNESS_CONTROL
UVC: PROCESSING_UNIT - GET_CUR - UVC_PU_BRIGHTNESS_CONTROL
UVC: PROCESSING_UNIT - GET_CUR - UVC_PU_BRIGHTNESS_CONTROL
```

Host computer querying available video formats (format and frame number correspond to settings in configfs)

```
UVC: Streaming request CS: PROBE, REQ: GET_CUR
UVC: Streaming request CS: PROBE, REQ: SET_CUR
UVC: Control PROBE, length: 26
UVC: Streaming control: action: SET, format: 1, frame: 3
FRAME: format: 1, frame: 3, resolution: 800x600, frame_interval: 333333,  bitrate: [38400000, 76800000]
DUMP: uvc_streaming_control: format: 1, frame: 3, frame interval: 333333
UVC: Streaming request CS: PROBE, REQ: GET_CUR
UVC: Streaming request CS: PROBE, REQ: GET_MAX
UVC: Streaming control: action: GET MAX
FRAME: format: 1, frame: 10, resolution: 1600x1200, frame_interval: 333333,  bitrate: [153600000, 307200000]
DUMP: uvc_streaming_control: format: 1, frame: 10, frame interval: 333333
UVC: Streaming request CS: PROBE, REQ: GET_MIN
UVC: Streaming control: action: GET MIN
FRAME: format: 1, frame: 1, resolution: 640x360, frame_interval: 333333,  bitrate: [18432000, 36864000]
DUMP: uvc_streaming_control: format: 1, frame: 1, frame interval: 333333
UVC: Streaming request CS: PROBE, REQ: SET_CUR
UVC: Control PROBE, length: 26
UVC: Streaming control: action: SET, format: 1, frame: 3
FRAME: format: 1, frame: 3, resolution: 800x600, frame_interval: 333333,  bitrate: [38400000, 76800000]
DUMP: uvc_streaming_control: format: 1, frame: 3, frame interval: 333333
UVC: Streaming request CS: PROBE, REQ: GET_CUR
UVC: Streaming request CS: COMMIT, REQ: SET_CUR
UVC: Control COMMIT, length: 26
UVC: Streaming control: action: SET, format: 1, frame: 3
FRAME: format: 1, frame: 3, resolution: 800x600, frame_interval: 333333,  bitrate: [38400000, 76800000]
DUMP: uvc_streaming_control: format: 1, frame: 3, frame interval: 333333
```

Applying of the selected resolution from COMMIT request (COMMIT request is few lines above)

```
DEVICE_V4L2: Setting format to: YUYV 800x600
DEVICE_V4L2: Getting current format: YUYV 800x600
```

Initialization of buffers

```
DEVICE_V4L2: Buffer 0 mapped at address 0xb6d23000, length 972800.
DEVICE_V4L2: Buffer 1 mapped at address 0xb6c35000, length 972800.
DEVICE_V4L2: 2 buffers allocated.
DEVICE_UVC: 2 buffers allocated.
```

Initialization of video streaming

```
DEVICE_V4L2: STREAM ON success
DEVICE_UVC: STREAM ON success
```
