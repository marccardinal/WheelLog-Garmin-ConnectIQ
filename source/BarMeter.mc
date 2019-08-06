using Toybox.Application;
using Toybox.Graphics;
using Toybox.System;
using Toybox.WatchUi;

class BarMeter extends WatchUi.Drawable {
	private var mCenterX;        // Number or :center
	private var mCenterY;        // Number or :center
	private var mOffsetX;		 // Offset the bar by this amount
	private var mOffsetY;		 // Offset the bar by this amount
	private var mStrokeActive;   // Stroke size of the active bar
	private var mStrokeInactive; // Stroke size of the inactive bar
	private var mDirection;      // :n, :s, :w:, :e
	private var mLength;         // The overall length of the bar
	private var mNumberDisplay;  // Whether or not to display the number representation
	private var mNumberOffsetX;  // Number representation offset from centerX
	private var mNumberOffsetY;  // Number representation offset from centerY
	private var mNumberFont;     // One of Graphics.FONT_* enum value
	private var mNumberUnit;     // Character(s) to append at the end of currentValue

	(:buffered) private var mBarBuffer;      // Bitmap buffer containing the bars
	private var mBuffersNeedRedraw = true;   // Buffers need to be redrawn on next draw()

	private var mWidth;
	private var mHeight;
	
	private var mX1;
	private var mX2;
	private var mY1;
	private var mY2;
	
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
		mOffsetX        = params[:offsetX];
		mOffsetY        = params[:offsetY];
		mStrokeActive   = params[:strokeActive];
		mStrokeInactive = params[:strokeInactive];	
		mDirection      = params[:direction];
		mLength         = params[:length];
		
		var halfLength = mLength / 2;
		
		// [x,y]1 == start point, [x,y]2 == end point
		if (mDirection == :n) { // toward north (up)
			mX1 = mCenterX;
			mX2 = mCenterX;
			mY1 = mCenterY + halfLength;
			mY2 = mCenterY - halfLength;
		} else if (mDirection == :s) { // toward south (down)
			mX1 = mCenterX;
			mX2 = mCenterX;
			mY1 = mCenterY - halfLength;
			mY2 = mCenterY + halfLength;
		} else if (mDirection == :w) { // Toward west (left)
			mX1 = mCenterX + halfLength;
			mX2 = mCenterX - halfLength;
			mY1 = mCenterY;
			mY2 = mCenterY;
		} else if (mDirection == :e) { // Toward east (right)
			mX1 = mCenterX - halfLength;
			mX2 = mCenterX + halfLength;
			mY1 = mCenterY;
			mY2 = mCenterY;
		}
		
		mX1 += mOffsetX;
		mX2 += mOffsetX;
		mY1 += mOffsetY;
		mY2 += mOffsetY;
		
		mNumberDisplay  = params[:numberDisplay];
		if (params[:numberDisplay]) {
			mNumberOffsetX  = params[:numberOffsetX];
			mNumberOffsetY  = params[:numberOffsetY];
			mNumberFont     = params[:numberFont];
			mNumberUnit     = params[:numberUnit];
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

//			drawBuffered(dc); // TODO: troubleshoot f5x+ with buffers or palettes?
			drawUnbuffered(dc);
		} else {
			drawUnbuffered(dc);
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
	
	(:buffered)
	function drawBuffered(dc) {
		if (mBarBuffer == null) {
			mBarBuffer = new Graphics.BufferedBitmap({
				:width => mWidth,
				:height => mHeight,
				:palette => [Graphics.COLOR_TRANSPARENT, gMeterBackgroundColour, gThemeColour]
			});
		}
		var barBufferDc = mBarBuffer.getDc();
		if (mBuffersNeedRedraw) {
			drawUnbuffered(barBufferDc);
		}
		dc.drawBitmap(0, 0, barBufferDc);	
	}
	
	function drawUnbuffered(dc) {
		var pct = mCurrentValue / mMaxValue.toFloat();	
		var end = pct * mLength;
	
		dc.setColor(gMeterBackgroundColour, Graphics.COLOR_TRANSPARENT);
		dc.clear();
	
		dc.setPenWidth(mStrokeInactive);
		dc.drawLine(mX1, mY1, mX2, mY2);

		if (mCurrentValue > 0) {
			dc.setColor(gThemeColour, Graphics.COLOR_TRANSPARENT);
			dc.setPenWidth(mStrokeActive);
			dc.drawLine(mX1, mY1, mX1 + pct * (mX2 - mX1), mY1 + pct * (mY2 - mY1));
		}		
	}
}