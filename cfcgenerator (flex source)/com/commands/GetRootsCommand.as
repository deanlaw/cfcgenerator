package com.commands {

	import mx.rpc.IResponder;
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.business.GeneratorServicesDelegate;
	import com.model.ModelLocator;
	import mx.controls.Alert;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import mx.managers.CursorManager;

	public class GetRootsCommand implements Command, IResponder {

		private var model : ModelLocator = ModelLocator.getInstance();
		
		public function execute( cgEvent:CairngormEvent ) : void {
			CursorManager.setBusyCursor();
			var delegate : GeneratorServicesDelegate = new GeneratorServicesDelegate( this );
			delegate.getRootsService();
			}
		
		public function result( rpcEvent : Object ) : void {
			CursorManager.removeBusyCursor();
			model.directories.source = rpcEvent.result as Array;
			CursorManager.removeBusyCursor();
		}
		
		public function fault( rpcEvent : Object ) : void {
			CursorManager.removeBusyCursor();
			// store an error message in the model locator
			// labels, alerts, etc can bind to this to notify the user of errors
			mx.controls.Alert.show("Fault occured in GetRootsCommand.");
			mx.controls.Alert.show(rpcEvent.fault.faultCode);
			mx.controls.Alert.show(rpcEvent.fault.faultString);
		}
	}
}