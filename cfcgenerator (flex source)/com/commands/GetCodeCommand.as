package com.commands {

	import mx.rpc.IResponder;
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.business.GeneratorServicesDelegate;
	import com.model.ModelLocator;
	import mx.controls.Alert;
	import com.control.GetGeneratedCodeEvent;
	import com.vo.datasourceVO;
	import mx.utils.UIDUtil;
	import mx.managers.CursorManager;

	public class GetCodeCommand implements Command, IResponder {

		private var model : ModelLocator = ModelLocator.getInstance();
		
		public function execute( cgEvent:CairngormEvent ) : void {
			CursorManager.setBusyCursor();
			model.reloadCodeTabs = UIDUtil.createUID();
			var delegate : GeneratorServicesDelegate = new GeneratorServicesDelegate( this );
			var getGeneratedCodeEvent : GetGeneratedCodeEvent = GetGeneratedCodeEvent( cgEvent );  
			delegate.getCodeService(getGeneratedCodeEvent.datasource,getGeneratedCodeEvent.path,getGeneratedCodeEvent.table,getGeneratedCodeEvent.template,getGeneratedCodeEvent.stripLineBreaks,getGeneratedCodeEvent.rootpath);
			}
		
		public function result( rpcEvent : Object ) : void {
			CursorManager.removeBusyCursor();
			model.generatedPages.source = rpcEvent.result as Array;
			}
		
		public function fault( rpcEvent : Object ) : void {
			CursorManager.removeBusyCursor();
			// store an error message in the model locator
			// labels, alerts, etc can bind to this to notify the user of errors
			mx.controls.Alert.show("Fault occured in GetTablesCommand.");
			mx.controls.Alert.show(rpcEvent.fault.faultCode);
			mx.controls.Alert.show(rpcEvent.fault.faultString);
			}
		}
	}