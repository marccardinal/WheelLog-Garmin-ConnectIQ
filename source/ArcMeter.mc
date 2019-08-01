using Toybox.Application;
using Toybox.Graphics;
using Toybox.System;
using Toybox.WatchUi;

class ArcMeter extends WatchUi.Drawable {
	private var mCenterX;        // Number or :center
	private var mCenterY;        // Number or :center
	private var mRadius;         // Radius in px
	private var mStrokeActive;   // Stroke size of the active bar
	private var mStrokeInactive; // Stroke size of the inactive bar
	private var mOffsetDegrees;  // Arc rotation offset 0 = 03:00, 90 = 12:00, 180 = 09:00, 270 = 06:00
	private var mArcDegrees;     // Arc span in degrees
	private var mDirection;      // :clockwise or :counter_clockwise
	private var mNumberDisplay;  // Whether or not to display the number representation
	private var mNumberOffsetX;  // Number representation offset from centerX
	private var mNumberOffsetY;  // Number representation offset from centerY
	private var mNumberFont;     // One of Graphics.FONT_* enum value
	private var mNumberUnit;     // Character(s) to append at the end of currentValue

	(:buffered) private var mArcBuffer;      // Bitmap buffer containing the arcs
	private var mBuffersNeedRedraw = true;   // Buffers need to be redrawn on next draw()

	private var mWidth;
	private var mHeight;
	private var mDegreeRange;
	
	private var mCurrentValue;
	private var mMaxValue;

	function initialize(params) {
		Drawable.initialize(params);

		mWidth = System.getDeviceSettings().screenWidth;
		mHeight = System.getDeviceSettings().screenHeight;

		var halfScreenWidth  = (mWidth / 2);
		var halfScreenHeight = (mHeight / 2); 

		mCenterX        = params[:centerX] == :center ? halfScreenWidth : params[:centerX];
		mCenterY        = params[:centerY] == :center ? halfScreenHeight : params[:centerY];
		mRadius         = params[:radius];
		mStrokeActive   = params[:strokeActive];
		mStrokeInactive = params[:strokeInactive];
		mOffsetDegrees  = params[:offsetDegrees];
		mArcDegrees     = params[:arcDegrees];
		mDirection      = params[:direction] == :clockwise ? Graphics.ARC_CLOCKWISE : Graphics.ARC_COUNTER_CLOCKWISE;
		
		mNumberDisplay  = params[:numberDisplay];
		if (params[:numberDisplay]) {
			mNumberOffsetX  = params[:numberOffsetX];
			mNumberOffsetY  = params[:numberOffsetY];
			mNumberFont     = params[:numberFont];
			mNumberUnit     = params[:numberUnit];
		}

		if (mDirection == Graphics.ARC_CLOCKWISE) {
			mArcDegrees = -mArcDegrees;
		}

		mBuffersNeedRedraw = true;
	}

	function setValues(current, max) {
//		System.println("current:" + current + ", max:" + max);
	
		if (max != mMaxValue) {
			mMaxValue = max;
			mBuffersNeedRedraw = true;
		}

		if (current != mCurrentValue) {
			mCurrentValue = current;
			mBuffersNeedRedraw = true;
		}
	}
	
	function draw(dc) {
		if ((Graphics has :BufferedBitmap) && (Graphics.Dc has :setClip)
			&& (System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_ROUND)) {

			drawBuffered(dc);
		
		} else {
			drawUnbuffered(dc);
		}			
	}
	
	(:buffered)
	function drawBuffered(dc) {
		if (!mArcBuffer) {
			mArcBuffer = new Graphics.BufferedBitmap({
				:width => mWidth,
				:height => mHeight,
				:palette => [Graphics.COLOR_TRANSPARENT, gMeterBackgroundColour, gThemeColour]
			});
		}
		var arcBufferDc = mArcBuffer.getDc();
		if (mBuffersNeedRedraw) {
			drawUnbuffered(arcBufferDc);
		}
		dc.drawBitmap(0, 0, arcBufferDc);	
	}
	
	function drawUnbuffered(dc) {
		var pct = mCurrentValue / mMaxValue.toFloat();	
		var end = pct * mArcDegrees;
	
		dc.setColor(gMeterBackgroundColour, Graphics.COLOR_TRANSPARENT);
		dc.clear();
	
		dc.setPenWidth(mStrokeInactive);
		dc.drawArc(mCenterX, mCenterY, mRadius, mDirection, mOffsetDegrees, mOffsetDegrees + mArcDegrees);

		if (mCurrentValue > 0) {
			dc.setColor(gThemeColour, Graphics.COLOR_TRANSPARENT);
			dc.setPenWidth(mStrokeActive);
			dc.drawArc(mCenterX, mCenterY, mRadius, mDirection, mOffsetDegrees, mOffsetDegrees + end);
		}
		
		if (mNumberDisplay) {
			dc.setColor(gMonoLightColour, Graphics.COLOR_TRANSPARENT);
			dc.drawText(
				mCenterX + mNumberOffsetX,
				mCenterY + mNumberOffsetY,
				mNumberFont,
				mCurrentValue + mNumberUnit,
				Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
			);
		}	
	}
}