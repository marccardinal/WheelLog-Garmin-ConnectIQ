using Toybox.Communications;
using Toybox.WatchUi;

class WheelLogGarminConnectIQDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new WheelLogGarminConnectIQMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }
    
    function onSelect() {
		var message = {
			WheelLogGarminConnectIQConstants.KEY_MSG_TYPE => WheelLogGarminConnectIQConstants.MESSAGE_TYPE_PLAY_HORN,
        };
        Communications.transmit(message, null, new CommListener(method(:onTransmitComplete)));    
    }
    
    function onTransmitComplete(status) {
    	if (status == CommListener.SUCCESS) {
    		// ...
    	}
    }
}
