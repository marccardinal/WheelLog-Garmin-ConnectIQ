using Toybox.Application;
using Toybox.Communications;
using Toybox.Graphics;
using Toybox.Lang;
using Toybox.Timer;
using Toybox.WatchUi;

var gThemeColour;
var gBackgroundColour;
var gMeterBackgroundColour;
var gMonoLightColour;
var gMonoDarkColour;
var gHoursColour;
var gMinutesColour;

var gNormalFont;
var gIconsFont;

var partialUpdatesAllowed = true;

const INTEGER_FORMAT = "%d";

class WheelLogGarminConnectIQView extends WatchUi.View {

	private var mSpeed = 0;
	private var mBattery = 0;
	private var mTemperature = 0;
	private var mBluetooth = false;
	private var mPower = 0;
	
	private var mTimer;

	// Cache references to drawables immediately after layout, to avoid expensive findDrawableById() calls in onUpdate();
	private var mDrawables = {};

    function initialize() {
    	mTimer = new Timer.Timer();
    	Communications.setMailboxListener(method(:onMail));   	
    
        View.initialize();
        
        updateFonts();
        updateThemeColours();
        updateHoursMinutesColours();
    }

	function onMail(mailIter) {
		var mail;
		mail = mailIter.next();
		Communications.emptyMailbox();
		
		if (mail != null) {
			if (mail instanceof Lang.Dictionary) {
				parseMessage(mail);
			}
		}
		
		WatchUi.requestUpdate();
	}

	function parseMessage(message) {
		var type = message.get(WheelLogGarminConnectIQConstants.KEY_MSG_TYPE);
		var data = message.get(WheelLogGarminConnectIQConstants.KEY_MSG_DATA);
		
		if (type == null or data == null) {
			return;
		}
		
		if (type == WheelLogGarminConnectIQConstants.MESSAGE_TYPE_EUC_DATA) {
			mSpeed       = data.get(WheelLogGarminConnectIQConstants.KEY_SPEED);
			mBattery     = data.get(WheelLogGarminConnectIQConstants.KEY_BATTERY);
			mTemperature = data.get(WheelLogGarminConnectIQConstants.KEY_TEMPERATURE);
			mBluetooth   = data.get(WheelLogGarminConnectIQConstants.KEY_BT_STATE);
			mPower       = data.get(WheelLogGarminConnectIQConstants.KEY_POWER).abs();
		}
	}

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
        
        cacheDrawables();
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    	mTimer.start(method(:onTimer), 5000, true);
    }

    // Update the view
    function onUpdate(dc) {
        updateArcMeters();

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

	function onTimer() {
		WatchUi.requestUpdate();
	}

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    	mTimer.stop();
    }
       
    function updateFonts() {
		gIconsFont = WatchUi.loadResource(Rez.Fonts.IconsFont);
		gNormalFont = WatchUi.loadResource(Rez.Fonts.NormalFont);
    }

	function updateThemeColours() {
		var theme = Application.getApp().getProperty("theme");

		// Theme-specific colours.
		gThemeColour = [
			Graphics.COLOR_BLUE,     // THEME_BLUE_DARK
			Graphics.COLOR_PINK,     // THEME_PINK_DARK
			Graphics.COLOR_GREEN,    // THEME_GREEN_DARK
			Graphics.COLOR_DK_GRAY,  // THEME_MONO_LIGHT
			0x55AAFF,                // THEME_CORNFLOWER_BLUE_DARK
			0xFFFFAA,                // THEME_LEMON_CREAM_DARK
			Graphics.COLOR_ORANGE,   // THEME_DAYGLO_ORANGE_DARK
			Graphics.COLOR_RED,      // THEME_RED_DARK
			Graphics.COLOR_WHITE,    // THEME_MONO_DARK
			Graphics.COLOR_DK_BLUE,  // THEME_BLUE_LIGHT
			Graphics.COLOR_DK_GREEN, // THEME_GREEN_LIGHT
			Graphics.COLOR_DK_RED,   // THEME_RED_LIGHT
			0xFFFF00,                // THEME_VIVID_YELLOW_DARK
			Graphics.COLOR_ORANGE,   // THEME_DAYGLO_ORANGE_LIGHT
			Graphics.COLOR_YELLOW    // THEME_CORN_YELLOW_DARK
		][theme];

		// Light/dark-specific colours.
		var lightFlags = [
			false, // THEME_BLUE_DARK
			false, // THEME_PINK_DARK
			false, // THEME_GREEN_DARK
			true,  // THEME_MONO_LIGHT
			false, // THEME_CORNFLOWER_BLUE_DARK
			false, // THEME_LEMON_CREAM_DARK
			false, // THEME_DAYGLO_ORANGE_DARK
			false, // THEME_RED_DARK
			false, // THEME_MONO_DARK
			true,  // THEME_BLUE_LIGHT
			true,  // THEME_GREEN_LIGHT
			true,  // THEME_RED_LIGHT
			false, // THEME_VIVID_YELLOW_DARK
			true,  // THEME_DAYGLO_ORANGE_LIGHT
			false, // THEME_CORN_YELLOW_DARK
		];
		if (lightFlags[theme]) {
			gMonoLightColour = Graphics.COLOR_BLACK;
			gMonoDarkColour = Graphics.COLOR_DK_GRAY;
			
			gMeterBackgroundColour = Graphics.COLOR_LT_GRAY;
			gBackgroundColour = Graphics.COLOR_WHITE;
		} else {
			gMonoLightColour = Graphics.COLOR_WHITE;
			gMonoDarkColour = Graphics.COLOR_LT_GRAY;

			gMeterBackgroundColour = Graphics.COLOR_DK_GRAY;
			gBackgroundColour = Graphics.COLOR_BLACK;
		}
	}

	function updateHoursMinutesColours() {
		var overrideColours = [
			gThemeColour,     // FROM_THEME
			gMonoLightColour, // MONO_HIGHLIGHT
			gMonoDarkColour   // MONO
		];

		gHoursColour = overrideColours[Application.getApp().getProperty("hoursColourOverride")];
		gMinutesColour = overrideColours[Application.getApp().getProperty("minutesColourOverride")];
	}


	function cacheDrawables() {
		mDrawables[:TimeDisplay]      = View.findDrawableById("TimeDisplay");
		mDrawables[:SpeedMeter]       = View.findDrawableById("SpeedMeter");
		mDrawables[:BatteryMeter]     = View.findDrawableById("BatteryMeter");
		mDrawables[:TemperatureMeter] = View.findDrawableById("TemperatureMeter");
		mDrawables[:PowerMeter]       = View.findDrawableById("PowerMeter");
		mDrawables[:IndicatorIcons]   = View.findDrawableById("IndicatorIcons");
	}

	function updateArcMeters() {
		mDrawables[:SpeedMeter].setValues(mSpeed, 40);	
		mDrawables[:BatteryMeter].setValues(mBattery, 100);
		mDrawables[:TemperatureMeter].setValues(mTemperature, 80);
		mDrawables[:PowerMeter].setValues(mPower, 30);
		mDrawables[:IndicatorIcons].setValues(mBluetooth);
	}
}
