package com.control 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class GetRootsEvent extends CairngormEvent 
	{
		public function GetRootsEvent() 
		{
			super(GeneratorControl.EVENT_GET_ROOTS);
		}
	}	
}