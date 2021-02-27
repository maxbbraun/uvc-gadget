# Video controls

## Enabling extended set of video control
!!! **After applying all changes we must compile new kernel.** [Kernel building](https://www.raspberrypi.org/documentation/linux/kernel/building.md)

By default is enabled only brightness video control.

For enabling more video controls is a need to change some values in kernel driver source for UVC gadget function.

These settings are located in file [drivers/usb/gadget/function/f_uvc.c](https://github.com/raspberrypi/linux/blob/rpi-5.4.y/drivers/usb/gadget/function/f_uvc.c#L793)

And a value of **bmControls** field must be changed.

### Default values
``` c
	cd = &opts->uvc_camera_terminal;
	cd->bLength                     = UVC_DT_CAMERA_TERMINAL_SIZE(3);
	cd->bDescriptorType             = USB_DT_CS_INTERFACE;
	cd->bDescriptorSubType          = UVC_VC_INPUT_TERMINAL;
	cd->bTerminalID                 = 1;
	cd->wTerminalType               = cpu_to_le16(0x0201);
	cd->bAssocTerminal              = 0;
	cd->iTerminal                   = 0;
	cd->wObjectiveFocalLengthMin    = cpu_to_le16(0);
	cd->wObjectiveFocalLengthMax    = cpu_to_le16(0);
	cd->wOcularFocalLength          = cpu_to_le16(0);
	cd->bControlSize                = 3;
	cd->bmControls[0]               = 2;
	cd->bmControls[1]               = 0;
	cd->bmControls[2]               = 0;

	pd = &opts->uvc_processing;
	pd->bLength                     = UVC_DT_PROCESSING_UNIT_SIZE(2);
	pd->bDescriptorType             = USB_DT_CS_INTERFACE;
	pd->bDescriptorSubType          = UVC_VC_PROCESSING_UNIT;
	pd->bUnitID                     = 2;
	pd->bSourceID                   = 1;
	pd->wMaxMultiplier              = cpu_to_le16(16*1024);
	pd->bControlSize                = 2;
	pd->bmControls[0]               = 1;
	pd->bmControls[1]               = 0;
	pd->iProcessing                 = 0;
```

### Available settings for **UVC_VC_INPUT_TERMINAL**
*source: USB Device Class Definition for Video Devices, Revision 1.1*

Field bmControls is a bitmap type.
A bit set to 1 indicates that the mentioned Control is supported for the video stream.

|bit|control|
|:--|:------|
|D0|Scanning Mode|
|D1|Auto-Exposure Mode|
|D2|Auto-Exposure Priority|
|D3|Exposure Time (Absolute)|
|D4|Exposure Time (Relative)|
|D5|Focus (Absolute)|
|D6|Focus (Relative)|
|D7|Iris (Absolute)|
|D8|Iris (Relative)|
|D9|Zoom (Absolute)|
|D10|Zoom (Relative)|
|D11|PanTilt (Absolute)|
|D12|PanTilt (Relative)|
|D13|Roll (Absolute)|
|D14|Roll (Relative)|
|D15|Reserved|
|D16|Reserved|
|D17|Focus, Auto|
|D18|Privacy|
|D19..(n*8-1)|Reserved, set to zero|

### Available settings for **UVC_VC_PROCESSING_UNIT**
*source: USB Device Class Definition for Video Devices, Revision 1.1*

Field bmControls is a bitmap type.

A bit set to 1 indicates that the mentioned Control is supported for the video stream.

|bit|control|
|:--|:------|
|D0|Brightness|
|D1|Contrast|
|D2|Hue|
|D3|Saturation|
|D4|Sharpness|
|D5|Gamma|
|D6|White Balance Temperature|
|D7|White Balance Component|
|D8|Backlight Compensation|
|D9|Gain|
|D10|Power Line Frequency|
|D11|Hue, Auto|
|D12|White Balance Temperature, Auto|
|D13|White Balance Component, Auto|
|D14|Digital Multiplier|
|D15|Digital Multiplier Limit|
|D16|Analog Video Standard|
|D17|Analog Video Lock Status|
|D18..(n*8-1)|Reserved. Set to zero.|

## Enabling more video controls
**We should only turn on controls for which we have mapping between UVC and V4L2.**

|bit|bit value|control|
|:--|:--------|:------|
|D0|1|Brightness|
|D1|1|Contrast|
|D2|1|Hue|
|D3|1|Saturation|
|D4|1|Sharpness|
|D5|1|Gamma|
|D6|1|White Balance Temperature|
|D7|1|White Balance Component|
|pd->bmControls[0]| = 255||

|bit|bit value|control|
|:--|:--------|:------|
|D8|0|Backlight Compensation|
|D9|1|Gain|
|D10|1|Power Line Frequency|
|D11|0|Hue, Auto|
|D12|0|White Balance Temperature, Auto|
|D13|0|White Balance Component, Auto|
|D14|0|Digital Multiplier|
|D15|0|Digital Multiplier Limit|
|pd->bmControls[1]| = 6||

``` c
	pd = &opts->uvc_processing;
	pd->bLength                     = UVC_DT_PROCESSING_UNIT_SIZE(2);
	pd->bDescriptorType             = USB_DT_CS_INTERFACE;
	pd->bDescriptorSubType          = UVC_VC_PROCESSING_UNIT;
	pd->bUnitID                     = 2;
	pd->bSourceID                   = 1;
	pd->wMaxMultiplier              = cpu_to_le16(16*1024);
	pd->bControlSize                = 2;
	pd->bmControls[0]               = 255; // changed
	pd->bmControls[1]               = 6; // changed
	pd->iProcessing                 = 0;
```

## Linux video controls mapping
 * [UVC - include/uapi/linux/usb/video.h](https://github.com/raspberrypi/linux/blob/rpi-5.4.y/include/uapi/linux/usb/video.h#L111)
 * [V4L2 - include/uapi/linux/v4l2-controls.h](https://github.com/raspberrypi/linux/blob/rpi-5.4.y/include/uapi/linux/v4l2-controls.h#L74)

## Mapping between UVC and V4L2 controls
* defined in file [uvc-gadget.h](../../uvc-gadget.h)

|UVC control|V4L2 control|
|:----------|:-----------|
|UVC_PU_BRIGHTNESS_CONTROL|V4L2_CID_BRIGHTNESS|
|UVC_PU_CONTRAST_CONTROL|V4L2_CID_CONTRAST|
|UVC_PU_GAIN_CONTROL|V4L2_CID_GAIN|
|UVC_PU_POWER_LINE_FREQUENCY_CONTROL|V4L2_CID_POWER_LINE_FREQUENCY|
|UVC_PU_HUE_CONTROL|V4L2_CID_HUE|
|UVC_PU_SATURATION_CONTROL|V4L2_CID_SATURATION|
|UVC_PU_SHARPNESS_CONTROL|V4L2_CID_SHARPNESS|
|UVC_PU_GAMMA_CONTROL|V4L2_CID_GAMMA|
|UVC_PU_WHITE_BALANCE_TEMPERATURE_CONTROL|V4L2_CID_WHITE_BALANCE_TEMPERATURE|
|UVC_PU_WHITE_BALANCE_COMPONENT_CONTROL|V4L2_CID_RED_BALANCE + V4L2_CID_BLUE_BALANCE|
|UVC_PU_WHITE_BALANCE_COMPONENT_AUTO_CONTROL|V4L2_CID_AUTO_WHITE_BALANCE|
|UVC_PU_HUE_AUTO_CONTROL|V4L2_CID_HUE_AUTO|
|UVC_CT_AE_MODE_CONTROL|V4L2_CID_EXPOSURE_AUTO|
|UVC_CT_AE_PRIORITY_CONTROL|V4L2_CID_EXPOSURE_AUTO_PRIORITY|



