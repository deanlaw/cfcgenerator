package com.model 
{
 	import com.adobe.cairngorm.model.ModelLocator;
	import mx.collections.ArrayCollection;
	import com.vo.datasourceVO;
	import com.vo.tableVO;
	import com.vo.generatedPageVO;

 	[Bindable]
	public class ModelLocator implements com.adobe.cairngorm.model.ModelLocator
	{
		private static var modelLocator : com.model.ModelLocator;
		
		public static function getInstance() : com.model.ModelLocator 
		{
			if ( modelLocator == null )
				modelLocator = new com.model.ModelLocator();
				
			return modelLocator;
	   }
	   
   	public function ModelLocator() 
   	{
   		if ( com.model.ModelLocator.modelLocator != null )
				throw new Error( "Only one ModelLocator instance should be instantiated" );	
   	}
		
		public var reloadAdminPassPopup : String;
		public var reloadCodeTabs : String;
		public var datasources : ArrayCollection = new ArrayCollection();
		public var tables : ArrayCollection = new ArrayCollection();
		public var generatedPages : ArrayCollection = new ArrayCollection();
		public var templates : ArrayCollection = new ArrayCollection();
		public var datasource : datasourceVO;
		public var table : tableVO;
		public var generatedPage : generatedPageVO;
		
	}	
}

