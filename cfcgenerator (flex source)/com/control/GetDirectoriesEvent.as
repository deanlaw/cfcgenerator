package com.control 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vo.directoryVO;
	
	public class GetDirectoriesEvent extends CairngormEvent
	{
		public var directory : directoryVO;
		
		public function GetDirectoriesEvent(directory:directoryVO) 
		{
			super(GeneratorControl.EVENT_GET_DIRS);
			this.directory = directory;
		}
	}	
}