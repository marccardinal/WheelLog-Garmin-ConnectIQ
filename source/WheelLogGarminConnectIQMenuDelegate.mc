using Toybox.WatchUi;
using Toybox.System;

class WheelLogGarminConnectIQMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if (item == :item_1) {
            testData();
        } else if (item == :item_2) {
            System.println("item 2");
        }
    }

	function testData() {
		var message = {
			WheelLogGarminConnectIQConstants.KEY_MSG_TYPE => WheelLogGarminConnectIQConstants.MESSAGE_TYPE_EUC_DATA,
			WheelLogGarminConnectIQConstants.KEY_MSG_DATA => {
				WheelLogGarminConnectIQConstants.KEY_SPEED => 22,
				WheelLogGarminConnectIQConstants.KEY_BATTERY => 78,
				WheelLogGarminConnectIQConstants.KEY_TEMPERATURE => 32,
				WheelLogGarminConnectIQConstants.KEY_BT_STATE => true,
				WheelLogGarminConnectIQConstants.KEY_POWER => 10,
			}
		};
		
		Application.getApp().getView().parseMessage(message);
		WatchUi.requestUpdate();
	}
}