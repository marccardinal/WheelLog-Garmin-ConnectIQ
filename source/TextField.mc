using Toybox.Application;
using Toybox.System;
using Toybox.WatchUi;

class TextField extends WatchUi.Drawable {

	var mText;
	var mCenterX;
	var mCenterY;
	var mFont;

    function initialize(params) {
		Drawable.initialize(params);

		var width = System.getDeviceSettings().screenWidth;
		var height = System.getDeviceSettings().screenHeight;

		var halfScreenWidth  = (width / 2);
		var halfScreenHeight = (height / 2); 

		mText     = params[:text];
		mCenterX  = params[:centerX] == :center ? halfScreenWidth : params[:centerX];
		mCenterY  = params[:centerY] == :center ? halfScreenHeight : params[:centerY];
		mCenterX += params[:adjustX];
		mCenterY += params[:adjustY];
		mFont     = params[:font];
	}

	function draw(dc) {
		dc.setColor(gMonoDarkColour, Graphics.COLOR_TRANSPARENT);
		dc.drawText(
			mCenterX,
			mCenterY,
			mFont,
			mText,
			Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
		);
	}
}