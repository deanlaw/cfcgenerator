package com.control 
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.vo.tableVO;
	import com.vo.datasourceVO;
	
	public class GetGeneratedCodeEvent extends CairngormEvent 
	{
		public var datasource : datasourceVO;
		public var table : tableVO;
		public var path : String;
		public var template : String;
		public var stripLineBreaks : Boolean;
		public var rootpath : String;
		
		public function GetGeneratedCodeEvent(datasource:datasourceVO,table:tableVO, path:String, template:String, stripLineBreaks:Boolean, rootpath:String) 
		{
			super(GeneratorControl.EVENT_GET_CODE);
			this.datasource = datasource;
			this.table = table;
			this.path = path;
			this.template = template;
			this.stripLineBreaks = stripLineBreaks;
			this.rootpath = rootpath;
		}
	}	
}