using Toybox.Application;
using Toybox.System;
using Toybox.WatchUi;

class IndicatorIcons extends WatchUi.Drawable {

	private var mBluetoothOffsetX;
	private var mBluetoothOffsetY;
	private var mBatteryOffsetX;
	private var mBatteryOffsetY;
	private var mTemperatureOffsetX;
	private var mTemperatureOffsetY;
	private var mPowerOffsetX;
	private var mPowerOffsetY;

	private var mBluetooth = false;

    function initialize(params) {
		Drawable.initialize(params);

		mBluetoothOffsetX   = params[:bluetoothOffsetX];
		mBluetoothOffsetY   = params[:bluetoothOffsetY];
		mBatteryOffsetX     = params[:batteryOffsetX];
		mBatteryOffsetY     = params[:batteryOffsetY];
		mTemperatureOffsetX = params[:temperatureOffsetX];
		mTemperatureOffsetY = params[:temperatureOffsetY];
		mPowerOffsetX       = params[:powerOffsetX];
		mPowerOffsetY       = params[:powerOffsetY];
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
			halfDCWidth + mBluetoothOffsetX,
			halfDCHeight + mBluetoothOffsetY,
			gIconsFont,
			"8",
			Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
		);

		dc.setColor(gMonoDarkColour, Graphics.COLOR_TRANSPARENT);

		// Power
		dc.drawText(
			halfDCWidth + mPowerOffsetX,
			halfDCHeight + mPowerOffsetY,
			gIconsFont,
			"6",
			Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
		);

		// Battery
		dc.drawText(
			halfDCWidth + mBatteryOffsetX,
			halfDCHeight + mBatteryOffsetY,
			gIconsFont,
			"9",
			Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
		);

		// Thermometer
		dc.drawText(
			halfDCWidth + mTemperatureOffsetX,
			halfDCHeight + mTemperatureOffsetY,
			gIconsFont,
			"<",
			Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
		);
	}
}