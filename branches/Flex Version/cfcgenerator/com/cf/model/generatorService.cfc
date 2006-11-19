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
	
	<!--- TODO: I need a better place for this logic --->
	<cffunction name="getProjectTemplates" access="public" returntype="array" output="false">
		<cfset var qryTemplateFolders = "" />
		<cfset var arrTemplateFolders = arrayNew(1) />
		<cfset arrayAppend(arrTemplateFolders,"default") />
		<cfdirectory name="qryTemplateFolders" action="list" directory="#expandPath(variables.xslBasePath&'projects')#" />
		<cfloop query="qryTemplateFolders">
			<!--- only directories and not svn directory if you pulled this from svn --->
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
		<cfargument name="stripLineBreaks" type="boolean" required="no" default="false" />
		
		<cfset var code = arrayNew(1) />
		<cfset var i = 0 />
		<cfset var thisPage = "" />
		<!--- TODO: this is a fix for if project path is default, its is passed as empty --->
		<cfif arguments.projectPath eq "default">
			<cfset arguments.projectPath = "" />
		</cfif>
		<!--- configure the xsl component with the dsn --->
		<cfset variables.xsl.configure(arguments.dsn,variables.xslBasePath,arguments.projectPath) />
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