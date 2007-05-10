<cfcomponent output="false">
<!--- 	<cfset init()>
	<cffunction name="init" access="public" returntype="void" output="false">
		<cfargument name="xslBasePath" type="string" required="true" />
		<cfargument name="adminPass" type="string" required="true" />
		
		<cfset variables.xslBasePath = arguments.xslBasePath />
		<cfset variables.adminPass = arguments.adminPass />
		<cfset variables.adminAPIFacade = createObject("component","cfcgenerator.com.cf.model.adminAPI.adminAPIFacade").init(variables.adminPass) />
		<cfset variables.xsl = createObject("component","cfcgenerator.com.cf.model.xsl.xslService").init() />
	</cffunction> --->
	
	<cffunction name="setAdminPassword" access="public" returntype="boolean" output="false">
		<cfargument name="adminPass" type="string" required="true" />
		
		<cfreturn application.generatorService.setAdminPassword(arguments.adminPass) />
	</cffunction>
	
	<cffunction name="getDSNs" access="remote" returntype="array" output="false">
		<cfreturn application.generatorService.getDSNs() />
	</cffunction>
	
	<cffunction name="getDSN" access="remote" returntype="cfcgenerator.com.cf.model.datasource.datasource" output="false">
		<cfargument name="dsn" type="string" required="yes" />
		
		<cfreturn  application.generatorService.getDSN(arguments.dsn) />
	</cffunction>
	
	<cffunction name="getTables" access="remote" returntype="array" output="false">
		<cfargument name="dsn" type="string" required="yes" />
		
		<cfreturn application.generatorService.getTables(arguments.dsn) />
	</cffunction>
	
	<cffunction name="getProjectTemplates" access="remote" returntype="array" output="false">
		<cfreturn application.generatorService.getProjectTemplates() />
	</cffunction>
	
	<cffunction name="getGeneratedCFCs" access="remote" returntype="array" output="false">
		<cfargument name="dsn" type="string" required="yes" />
		<cfargument name="componentPath" type="string" required="yes" />
		<cfargument name="table" type="string" required="yes" />
		<cfargument name="projectPath" type="string" required="no" default="" />
		<cfargument name="stripLineBreaks" type="boolean" required="no" default="false" />
		<cfargument name="rootPath" type="string" required="no" default="" />
		
		<cfreturn application.generatorService.getGeneratedCFCs(argumentCollection=arguments) />
	</cffunction>
	
	<cffunction name="saveFile" access="remote" returntype="string" output="false">
		<cfargument name="code" type="string" required="yes" />
		<cfargument name="filePath" type="string" required="yes" />
		
		<cfreturn application.generatorService.saveFile(arguments.code,arguments.filePath) />
	</cffunction>
</cfcomponent>