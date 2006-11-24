<cfcomponent output="false">
	<cffunction name="init" access="public" returntype="generatorService" output="false">
		<cfargument name="xslBasePath" type="string" required="true" />
		<cfargument name="adminPass" type="string" required="true" />
		
		<cfset variables.xslBasePath = arguments.xslBasePath />
		<cfset variables.adminPass = arguments.adminPass />
		<cfset variables.adminAPIFacade = createObject("component","cfcgenerator.com.cf.model.adminAPI.adminAPIFacade").init(variables.adminPass) />
		<cfset variables.xsl = createObject("component","cfcgenerator.com.cf.model.xsl.xslService").init() />
		<cfreturn this />
	</cffunction>

	<cffunction name="getDSNs" access="public" returntype="array" output="false">
		<cfreturn variables.adminAPIFacade.getDatasources() />
	</cffunction>
	
	<cffunction name="getDSN" access="public" returntype="cfcgenerator.com.cf.model.datasource.datasource" output="false">
		<cfargument name="dsn" type="string" required="yes" />
		
		<cfreturn variables.adminAPIFacade.getDatasource(arguments.dsn) />
	</cffunction>
	
	<cffunction name="getTables" access="public" returntype="array" output="false">
		<cfargument name="dsn" type="string" required="yes" />
		
		<cfreturn variables.adminAPIFacade.getDatasource(arguments.dsn).getDbms().getTables() />
	</cffunction>
	
	<!--- TODO: I may need a better place for this logic --->
	<cffunction name="getProjectTemplates" access="public" returntype="array" output="false">
		<cfset var qryTemplateFolders = "" />
		<cfset var arrTemplateFolders = arrayNew(1) />
		<cfset arrayAppend(arrTemplateFolders,"default") />
		<cfdirectory name="qryTemplateFolders" action="list" directory="#expandPath(variables.xslBasePath&'projects')#" />
		<cfloop query="qryTemplateFolders">
			<!--- only directories and not the .svn dir if it exists --->
			<cfif qryTemplateFolders.type eq "Dir" and qryTemplateFolders.name neq ".svn">
				<cfset arrayAppend(arrTemplateFolders,qryTemplateFolders.name) />
			</cfif>
		</cfloop>
		<cfreturn arrTemplateFolders />
	</cffunction>
	
	<cffunction name="getGeneratedCFCs" access="public" returntype="array" output="false">
		<cfargument name="dsn" type="string" required="yes" />
		<cfargument name="componentPath" type="string" required="yes" />
		<cfargument name="table" type="string" required="yes" />
		<cfargument name="projectPath" type="string" required="no" default="" />
		<cfargument name="rootPath" type="string" required="no" default="" />
		<cfargument name="stripLineBreaks" type="boolean" required="no" default="false" />
		
		<cfset var code = arrayNew(1) />
		<cfset var i = 0 />
		<cfset var thisPage = "" />
		<cfset var separator = getOSFileSeparator() />
		<!--- TODO: this is a fix for if project path is default, its is passed as empty --->
		<cfif arguments.projectPath eq "default">
			<cfset arguments.projectPath = "" />
		</cfif>
		<cfif len(arguments.rootPath)>
			<cfset arguments.rootPath = arguments.rootPath & separator & replace(arguments.componentPath,".",separator,"all") />
		</cfif>
		<!--- configure the xsl component with the dsn --->
		<cfset variables.xsl.configure(arguments.dsn,variables.xslBasePath,arguments.projectPath,arguments.rootPath) />
		<cfset variables.adminAPIFacade.getDatasource(arguments.dsn).getDbms().setComponentPath(arguments.componentPath) />
		<cfset variables.adminAPIFacade.getDatasource(arguments.dsn).getDbms().setTable(arguments.table)>
		<!--- get an array containing the generated code --->
		<cfset code = variables.xsl.getComponents(variables.adminAPIFacade.getDatasource(arguments.dsn).getDbms().getTableXML()) />
		<!--- try to remove extraneous line breaks and spaces that seem to appear in flex in some cases but not in CF --->
		<cfif arguments.stripLineBreaks>
			<cfloop from="1" to="#arrayLen(code)#" index="i">
				<cfset thisPage = code[i] />
				<cfset thisPage.setContent(trim(replaceNoCase(thisPage.getContent(),"#chr(10)#","","all")))>
			</cfloop>
		</cfif>
		<cfreturn code />
	</cffunction>
	
	<!--- TODO: I may need a better place for this logic as well --->
	<cffunction name="saveFile" access="public" returntype="string" output="false">
		<cfargument name="code" type="string" required="yes" />
		<cfargument name="filePath" type="string" required="yes" />
		
		<cfset var rtnMessage = "Save Succeeded" />
		<cfset var thePath = getDirectoryFromPath(arguments.filePath) />
		
		<cftry>
			<!--- create the directory if it doesn't currently exist --->
			<cfif not directoryExists(thePath)>
				<cfdirectory action="create" directory="#thePath#" />
			</cfif>
			<cffile action="write" file="#arguments.filePath#" output="#arguments.code#" charset="utf-8" />
			<cfcatch type="any">
				<cfset rtnMessage = "Save Failed: " & cfcatch.Message />
			</cfcatch>
		</cftry>
		<cfreturn rtnMessage />
	</cffunction>
	
	<!--- code supplied by Luis Majano --->
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