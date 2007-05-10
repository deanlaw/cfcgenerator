package com.commands {

	import mx.rpc.IResponder;
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.business.GeneratorServicesDelegate;
	import com.model.ModelLocator;
	import mx.controls.Alert;
	import com.control.SaveFileEvent;

	public class SaveFileCommand implements Command, IResponder {

		private var model : ModelLocator = ModelLocator.getInstance();
		
		public function execute( cgEvent:CairngormEvent ) : void {
			var delegate : GeneratorServicesDelegate = new GeneratorServicesDelegate( this );
			var saveFileEvent : SaveFileEvent = SaveFileEvent( cgEvent );
			delegate.saveFileService(saveFileEvent.code,saveFileEvent.filePath);
			}
		
		public function result( rpcEvent : Object ) : void {
			mx.controls.Alert.show(rpcEvent.result,"Save File");
		}
		
		public function fault( rpcEvent : Object ) : void {
			// store an error message in the model locator
			// labels, alerts, etc can bind to this to notify the user of errors
			mx.controls.Alert.show("Fault occured in SaveFileCommand.");
			mx.controls.Alert.show(rpcEvent.fault.faultCode);
			mx.controls.Alert.show(rpcEvent.fault.faultString);
			}
		}
	}