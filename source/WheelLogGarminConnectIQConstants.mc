module WheelLogGarminConnectIQConstants {
	enum {
		MESSAGE_TYPE_EUC_DATA = 0,
		MESSAGE_TYPE_PLAY_HORN = 1,
		MESSAGE_TYPE_HTTP_READY = 2,
	}
	
	enum {
	    KEY_MSG_TYPE = -2,
        KEY_MSG_DATA = -1,

        KEY_SPEED         = 0,
        KEY_BATTERY       = 1,
        KEY_TEMPERATURE   = 2,
        KEY_FAN_STATE     = 3,
        KEY_BT_STATE      = 4,
        KEY_VIBE_ALERT    = 5,
        KEY_USE_MPH       = 6,
        KEY_MAX_SPEED     = 7,
        KEY_RIDE_TIME     = 8,
        KEY_DISTANCE     = 9,
        KEY_TOP_SPEED    = 10,
        KEY_READY        = 11,
        KEY_POWER        = 12,
        KEY_ALARM1_SPEED = 13,
        KEY_ALARM2_SPEED = 14,
        KEY_ALARM3_SPEED = 15,
        
        KEY_HTTP_PORT    = 99,
	}
}