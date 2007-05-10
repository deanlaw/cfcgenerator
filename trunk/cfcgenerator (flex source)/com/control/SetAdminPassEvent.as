package com.control 
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class SetAdminPassEvent extends CairngormEvent 
	{
		public var adminPass : String;
		
		public function SetAdminPassEvent(adminPass:String) 
		{
			super(GeneratorControl.EVENT_SET_ADMINPASS);
			this.adminPass = adminPass;
		}
	}	
}