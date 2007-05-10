package com.control 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class SaveFileEvent extends CairngormEvent 
	{
		public var code : String;
		public var filePath : String;
		
		public function SaveFileEvent(code:String,filePath:String) 
		{
			super(GeneratorControl.EVENT_SAVE_FILE);
			this.code = code;
			this.filePath = filePath;
		}
	}	
}