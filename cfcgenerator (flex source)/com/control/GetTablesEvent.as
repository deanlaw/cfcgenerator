package com.control 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vo.datasourceVO;
	
	public class GetTablesEvent extends CairngormEvent 
	{
		public var datasource : datasourceVO;
		
		public function GetTablesEvent(datasource : datasourceVO) 
		{
			super(GeneratorControl.EVENT_GET_TABLES);
			this.datasource = datasource;
		}
	}	
}