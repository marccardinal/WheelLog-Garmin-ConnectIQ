using Toybox.Application;
using Toybox.System;
using Toybox.WatchUi;

class IndicatorIcons extends WatchUi.Drawable {

	private var mBluetooth = false;

    function initialize(params) {
		Drawable.initialize(params);

	}

	function setValues(bluetooth) {
		mBluetooth = bluetooth;
	}

	function draw(dc) {
		var halfDCWidth = dc.getWidth() / 2;
		var halfDCHeight = dc.getHeight() / 2;

//		dc.setColor(mBluetooth ? gMonoLightColour : gMonoDarkColour, Graphics.COLOR_TRANSPARENT);
		dc.setColor(mBluetooth ? gThemeColour : gMonoDarkColour, Graphics.COLOR_TRANSPARENT);


		// Bluetooth
		dc.drawText(
			halfDCWidth - 50,
			halfDCHeight,
			gIconsFont,
			"8",
			Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
		);

		dc.setColor(gMonoDarkColour, Graphics.COLOR_TRANSPARENT);

		// Power
		dc.drawText(
			halfDCWidth + 50,
			halfDCHeight,
			gIconsFont,
			"6",
			Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
		);

		// Battery
		dc.drawText(
			halfDCWidth - 50,
			halfDCHeight + 80,
			gIconsFont,
			"9",
			Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
		);

		// Thermometer
		dc.drawText(
			halfDCWidth + 50,
			halfDCHeight + 80,
			gIconsFont,
			"<",
			Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
		);
	}
}