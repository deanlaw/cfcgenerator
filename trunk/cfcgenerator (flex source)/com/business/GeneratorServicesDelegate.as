package com.business {

	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.vo.datasourceVO;
	import com.vo.tableVO;
	import mx.controls.Alert;

	public class GeneratorServicesDelegate {

		private var command : IResponder;
		private var service : Object;

		public function GeneratorServicesDelegate( command : IResponder ) {
			// constructor will store a reference to the service we're going to call
			this.service = ServiceLocator.getInstance().getRemoteObject( 'generatorServices' );
			// and store a reference to the command that created this delegate
			this.command = command;
		}
		
		public function setAdminPassword(adminPass:String) : void {
			// call the service
			var token:AsyncToken = service.setAdminPassword.send(adminPass);
			// notify this command when the service call completes
			token.addResponder( command );
		}

		public function getDsnsService() : void {
			// call the service
			var token:AsyncToken = service.getDSNs.send();
			// notify this command when the service call completes
			token.addResponder( command );
		}
		
		public function getCodeService(datasource:datasourceVO,path:String,table:tableVO,template:String,stripLineBreaks:Boolean,rootpath:String) : void {
			// call the service
			var token:AsyncToken = service.getGeneratedCFCs.send(datasource.dsnName,path,table.tableName,template,stripLineBreaks,rootpath);
			// notify this command when the service call completes
			token.addResponder( command );
		}

		public function getTablesService(datasource:datasourceVO) : void {
			// call the service
			var token:AsyncToken = service.getTables.send(datasource.dsnName);
			// notify this command when the service call completes
			token.addResponder( command );
		}
		
		public function getTemplatesService() : void {
			// call the service
			var token:AsyncToken = service.getProjectTemplates.send();
			// notify this command when the service call completes
			token.addResponder( command );
		}
		
		public function saveFileService(code:String,filePath:String) : void {
			// call the service
			var token:AsyncToken = service.saveFile.send(code,filePath);
			// notify this command when the service call completes
			token.addResponder( command );
		}
	}
}