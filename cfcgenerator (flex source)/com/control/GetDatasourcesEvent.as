package com.control 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class GetDatasourcesEvent extends CairngormEvent 
	{
		public function GetDatasourcesEvent() 
		{
			super(GeneratorControl.EVENT_GET_DSNS);
		}
	}	
}