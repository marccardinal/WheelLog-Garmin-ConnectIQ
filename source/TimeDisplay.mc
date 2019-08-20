using Toybox.Application;
using Toybox.System;
using Toybox.WatchUi;

class TimeDisplay extends WatchUi.Drawable {

	var mAdjustY;
	var mTimeFont;

    function initialize(params) {
		Drawable.initialize(params);

		mAdjustY = params[:adjustY] == null ? 0 : params[:adjustY];
		mTimeFont = params[:timeFont] == null ? Graphics.FONT_TINY : params[:timeFont];		
	}

	function draw(dc) {
		drawHoursMinutes(dc);
	}

	function drawHoursMinutes(dc) {
		var clockTime = System.getClockTime();
		var formattedTime = getFormattedTime(clockTime.hour, clockTime.min);
		formattedTime[:amPm] = formattedTime[:amPm];

		var hours = formattedTime[:hour];
		var minutes = formattedTime[:min];
		var amPmText = formattedTime[:amPm];

		var halfDCWidth = dc.getWidth() / 2;
		var halfDCHeight = (dc.getHeight() / 2) + mAdjustY;

		dc.setColor(gMonoDarkColour, Graphics.COLOR_TRANSPARENT);
		dc.drawText(
			halfDCWidth,
			halfDCHeight,
			mTimeFont,
			hours + ":" + minutes + amPmText,
			Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
		);
	}
	
	// Return a formatted time dictionary that respects is24Hour and HideHoursLeadingZero settings.
	// - hour: 0-23.
	// - min:  0-59.
	function getFormattedTime(hour, min) {
		var amPm = "";

		if (!System.getDeviceSettings().is24Hour) {

			// Ensure noon is shown as PM.
			var isPm = (hour >= 12);
			if (isPm) {
				// But ensure noon is shown as 12, not 00.
				if (hour > 12) {
					hour = hour - 12;
				}
				amPm = "p";
			} else {
				// Ensure midnight is shown as 12, not 00.
				if (hour == 0) {
					hour = 12;
				}
				amPm = "a";
			}
		}

		// If in 12-hour mode with Hide Hours Leading Zero set, hide leading zero. Otherwise, show leading zero.
		// Setting now applies to both 12- and 24-hour modes.
		hour = hour.format(Application.getApp().getProperty("hideHoursLeadingZero") ? INTEGER_FORMAT : "%02d");

		return {
			:hour => hour,
			:min => min.format("%02d"),
			:amPm => amPm
		};
	}
}