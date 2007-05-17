package com.vo
{
	[RemoteClass(alias="cfcgenerator.com.cf.model.directory.directory")]

	[Bindable]
	public class directoryVO
	{

		public var directoryName:String = "";
		public var path:String = "";
		public var parentPath:String = "";
		public var hasChildren:Boolean = false;


		public function directoryVO()
		{
		}

	}
}