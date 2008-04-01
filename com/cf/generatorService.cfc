<cfcomponent output="false">
	<cffunction name="init" access="public" returntype="generatorService" output="false">
		<cfargument name="xslBasePath" type="string" required="true" />
		
		<cfset variables.xslBasePath = arguments.xslBasePath />
		<cfset variables.adminPass = "" />
		<cfset variables.codeService = createObject("component","com.cf.code.codeService").init() />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setAdminPassword" access="public" returntype="boolean" output="false">
		<cfargument name="adminPass" type="string" required="true" />
		
		<cfset var success = true />
		
		<cfset variables.adminPass = arguments.adminPass />
		<cftry>
			<cfset loadAdminApi() />
			<cfcatch type="any">
				<cfset success = false />
				<Cfrethrow />
			</cfcatch>
		</cftry>
		<cfreturn success />
	</cffunction>
	
	<cffunction name="loadAdminApi" access="private" returntype="void" output="false">
		<cfset variables.adminAPIFacade = createObject("component","cfcgenerator.com.cf.adminAPI.adminAPIFacade").init(variables.adminPass) />
	</cffunction>

	<cffunction name="getDSNs" access="public" returntype="cfcgenerator.com.cf.datasource.datasource[]" output="false">
		<cfreturn variables.adminAPIFacade.getDatasources() />
	</cffunction>
	
	<cffunction name="getTables" access="public" returntype="cfcgenerator.com.cf.datasource.table.table[]" output="false">
		<cfargument name="dsn" type="cfcgenerator.com.cf.datasource.datasource" required="yes" />
		
		<cfset var thisDSN = createObject("component","cfcgenerator.com.cf.datasource.#arguments.dsn.getDsnType()#").init(arguments.dsn) />
		<cfreturn thisDSN.getTables() />
	</cffunction>
	
	<cffunction name="getColumns" access="public" returntype="cfcgenerator.com.cf.datasource.table.table" output="false">
		<cfargument name="dsn" type="cfcgenerator.com.cf.datasource.datasource" required="yes" />
		<cfargument name="table" type="cfcgenerator.com.cf.datasource.table.table" required="yes" />
		
		<cfset var thisDSN = createObject("component","cfcgenerator.com.cf.datasource.#arguments.dsn.getDsnType()#").init(arguments.dsn) />
		<cfreturn thisDSN.getColumns(arguments.table) />
	</cffunction>
	
	<cffunction name="generate" access="public" returntype="struct" output="false">
		<cfargument name="dsn" type="cfcgenerator.com.cf.datasource.datasource" required="yes" />
		<cfargument name="tables" type="cfcgenerator.com.cf.datasource.table.table[]" required="false" />
		<cfargument name="componentPath" type="string" required="false" default="" />
		<cfargument name="projectPath" type="string" required="no" default="" />
		<cfargument name="rootPath" type="string" required="no" default="" />
		<cfargument name="stripLineBreaks" type="boolean" required="no" default="false" />
		
		<cfset var i = 0 />
		<cfset var code = structNew() />
		<cfset variables.codeService.configure(arguments.dsn,arguments.rootPath,arguments.projectPath) />
		<cfloop from="1" to="#arrayLen(arguments.tables)#" index="i">
			<cfset code[arguments.tables[i].getTableName()] = variables.codeService.getComponents(arguments.tables[i]) />
		</cfloop>
		<cfreturn code>
	</cffunction>

<!--- utility functions --->
	<cffunction name="getOSFileSeparator" access="public" returntype="any" output="false" hint="Get the operating system's file separator character">
        <cfscript>
        var objFile =  createObject("java","java.lang.System");
        return objFile.getProperty("file.separator");
        </cfscript>
    </cffunction>
	
	<cffunction name="structToArray" output="false" access="private" returntype="array">
		<cfargument name="thisStruct" type="struct" required="true" />
		
		<cfset var arrReturn = arrayNew(1) />
		<cfset var thisItem = "" />
		<cfloop collection="#arguments.thisStruct#" item="thisItem">
			<cfset arrayAppend(arrReturn,arguments.thisStruct[thisItem]) />
		</cfloop>
		<cfreturn arrReturn />
	</cffunction>
</cfcomponent>