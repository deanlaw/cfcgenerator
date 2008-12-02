package com.commands {

	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.business.GeneratorServicesDelegate;
	import com.control.SaveFileEvent;
	import com.model.ModelLocator;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;

	public class SaveFileCommand implements Command, IResponder {

		private var model : ModelLocator = ModelLocator.getInstance();
		private var showAlert : Boolean = true;
		
		public function execute( cgEvent:CairngormEvent ) : void {
			var delegate : GeneratorServicesDelegate = new GeneratorServicesDelegate( this );
			var saveFileEvent : SaveFileEvent = SaveFileEvent( cgEvent );
			showAlert = saveFileEvent.showAlert;
			delegate.saveFileService(saveFileEvent.code,saveFileEvent.filePath);
			}
		
		public function result( rpcEvent : Object ) : void {
			// hacking away again for multi save
			if (showAlert) {
				mx.controls.Alert.show(rpcEvent.result,"Save File");
			}
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