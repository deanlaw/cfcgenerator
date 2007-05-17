package com.control 
{
	import com.adobe.cairngorm.control.FrontController;
	// import command classes
	import com.commands.SetAdminPassCommand;
	import com.commands.GetDatasourcesCommand;
	import com.commands.GetTablesCommand;
	import com.commands.GetCodeCommand;
	import com.commands.GetTemplatesCommand;
	import com.commands.SaveFileCommand;
	import com.commands.GetRootsCommand;
	import com.commands.GetDirectoriesCommand;
	
	public class GeneratorControl extends FrontController
	{
		public static const EVENT_SET_ADMINPASS : String = "EVENT_SET_ADMINPASS";
		public static const EVENT_GET_DSNS : String = "EVENT_GET_DSNS";
		public static const EVENT_GET_TABLES : String = "EVENT_GET_TABLES";
		public static const EVENT_GET_CODE : String = "EVENT_GET_CODE";
		public static const EVENT_GET_TEMPLATES : String = "EVENT_GET_TEMPLATES";
		public static const EVENT_SAVE_FILE : String = "EVENT_SAVE_FILE";
		public static const EVENT_GET_ROOTS : String = "EVENT_GET_ROOTS";
		public static const EVENT_GET_DIRS : String = "EVENT_GET_DIRS";
		
		public function GeneratorControl():void
		{
			addCommand(GeneratorControl.EVENT_SET_ADMINPASS, SetAdminPassCommand);
			addCommand(GeneratorControl.EVENT_GET_DSNS, GetDatasourcesCommand);
			addCommand(GeneratorControl.EVENT_GET_TABLES, GetTablesCommand);
			addCommand(GeneratorControl.EVENT_GET_CODE, GetCodeCommand);
			addCommand(GeneratorControl.EVENT_GET_TEMPLATES, GetTemplatesCommand);
			addCommand(GeneratorControl.EVENT_SAVE_FILE, SaveFileCommand);
			addCommand(GeneratorControl.EVENT_GET_ROOTS, GetRootsCommand);
			addCommand(GeneratorControl.EVENT_GET_DIRS, GetDirectoriesCommand);
		}
		
	}
}