package com.control 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class GetTemplatesEvent extends CairngormEvent 
	{
		public function GetTemplatesEvent() 
		{
			super(GeneratorControl.EVENT_GET_TEMPLATES);
		}
	}	
}