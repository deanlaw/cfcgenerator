package com.commands {

	import mx.rpc.IResponder;
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.business.GeneratorServicesDelegate;
	import com.model.ModelLocator;
	import mx.controls.Alert;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.control.GetTablesEvent;
	import mx.managers.CursorManager;

	public class GetDatasourcesCommand implements Command, IResponder {

		private var model : ModelLocator = ModelLocator.getInstance();
		
		public function execute( cgEvent:CairngormEvent ) : void {
			var delegate : GeneratorServicesDelegate = new GeneratorServicesDelegate( this );
			delegate.getDsnsService();
			}
		
		public function result( rpcEvent : Object ) : void {
			model.datasources.source = rpcEvent.result as Array;
			CursorManager.removeBusyCursor();
			if (model.datasources.length >= 1) {
				var event : GetTablesEvent = new GetTablesEvent(model.datasources[0]);
  				CairngormEventDispatcher.getInstance().dispatchEvent( event );
  			}
  			else {
  				Alert.show("No supported datasources were found");
  			}
		}
		
		public function fault( rpcEvent : Object ) : void {
			// store an error message in the model locator
			// labels, alerts, etc can bind to this to notify the user of errors
			mx.controls.Alert.show("Fault occured in GetDatasourcesCommand.");
			mx.controls.Alert.show(rpcEvent.fault.faultCode);
			mx.controls.Alert.show(rpcEvent.fault.faultString);
		}
	}
}