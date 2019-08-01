using Toybox.Application;
using Toybox.Communications;
using Toybox.WatchUi;

class WheelLogGarminConnectIQApp extends Application.AppBase {

	var mView;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
    	mView = new WheelLogGarminConnectIQView();

   		return [ mView, new WheelLogGarminConnectIQDelegate() ];
    }
    
    function getView() {
    	return mView;
	}
}

class CommListener extends Communications.ConnectionListener
{
    static var SUCCESS = 0;
    static var FAILURE = 1;

    hidden var mCallback;

    //! Constructor
    //! @param callback The method to call on a result
    function initialize(callback) {
        mCallback = callback;
    }

    //! Call the callback with a result of CommListener.SUCCESS
    function onComplete() {
        mCallback.invoke(SUCCESS);
    }

    //! Call the callback with a result of CommListener.FAILURE
    function onError() {
        mCallback.invoke(FAILURE);
    }
}
