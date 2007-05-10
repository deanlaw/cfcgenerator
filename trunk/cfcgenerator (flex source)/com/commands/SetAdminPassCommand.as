package com.commands {

	import mx.rpc.IResponder;
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.business.GeneratorServicesDelegate;
	import com.model.ModelLocator;
	import mx.controls.Alert;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.control.SetAdminPassEvent;
	import com.control.GetDatasourcesEvent;
	import flash.events.Event;
	import mx.utils.UIDUtil;
	import mx.managers.CursorManager;

	public class SetAdminPassCommand implements Command, IResponder {

		private var model : ModelLocator = ModelLocator.getInstance();
		
		public function execute( cgEvent:CairngormEvent ) : void {
			var delegate : GeneratorServicesDelegate = new GeneratorServicesDelegate( this );
			var setAdminPassEvent : SetAdminPassEvent = SetAdminPassEvent( cgEvent );
			delegate.setAdminPassword(setAdminPassEvent.adminPass);
			}
		
		public function result( rpcEvent : Object ) : void {
			var success:String = rpcEvent.result;
			if (success == "true") {
				var event : GetDatasourcesEvent = new GetDatasourcesEvent();
  				CairngormEventDispatcher.getInstance().dispatchEvent( event );
  			}
  			else {
  				CursorManager.removeBusyCursor();
  				Alert.show("Admin Login Failed","Login Failed",Alert.OK,null,alertHandler);
  			}
		}
		
		private function alertHandler(event:Event):void {
			model.reloadAdminPassPopup = UIDUtil.createUID();
		}
		
		public function fault( rpcEvent : Object ) : void {
			// store an error message in the model locator
			// labels, alerts, etc can bind to this to notify the user of errors
			mx.controls.Alert.show("Fault occured in SetAdminPassCommand.");
			mx.controls.Alert.show(rpcEvent.fault.faultCode);
			mx.controls.Alert.show(rpcEvent.fault.faultString);
		}
	}
}