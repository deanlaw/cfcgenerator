package com.model 
{
 	import com.adobe.cairngorm.model.ModelLocator;
 	import com.vo.datasourceVO;
 	import com.vo.directoryVO;
 	import com.vo.generatedPageVO;
 	import com.vo.tableVO;
 	
 	import mx.collections.ArrayCollection;

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
		public var openPopup : String;
		public var datasources : ArrayCollection = new ArrayCollection();
		public var tables : ArrayCollection = new ArrayCollection();
		public var generatedPages : ArrayCollection = new ArrayCollection();
		public var templates : ArrayCollection = new ArrayCollection();
		public var datasource : datasourceVO;
		public var table : tableVO;
		public var generatedPage : generatedPageVO;
		public var selectedDirectory : directoryVO;
		public var directories : ArrayCollection = new ArrayCollection();
		// again hacking in generate all
		public var tablesToGenerate : ArrayCollection = new ArrayCollection();
		public var currentObjectPath: String = "";
		public var currentObjectFilePath : String = "";
		public var currentObjectStripBreaks : Boolean = false;
		public var currentObjectTemplate : String;
		public var openMultiGeneratePopup : Boolean = false;
		
	}	
}

