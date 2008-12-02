package com.control 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class SaveFileEvent extends CairngormEvent 
	{
		public var code : String;
		public var filePath : String;
		public var showAlert : Boolean;
		
		public function SaveFileEvent(code:String,filePath:String,showAlert:Boolean=true) 
		{
			super(GeneratorControl.EVENT_SAVE_FILE);
			this.code = code;
			this.filePath = filePath;
			this.showAlert = showAlert;
		}
	}	
}