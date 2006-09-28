<cfcomponent output="false" extends="MachII.framework.Listener" displayname="userListener" hint="I am a user listener.">

	<cffunction name="configure" access="public" returntype="void" output="false">
		<cfset variables.adminAPIService = createObject("component","cfcGenerator.model.adminAPIService").init(variables.getProperty("adminPass")) />
		<cfset variables.mysql = createObject("component","cfcGenerator.model.mysql").init() />
		<cfset variables.mssql = createObject("component","cfcGenerator.model.mssql").init() />
		<cfset variables.oracle = createObject("component","cfcGenerator.model.oracle").init() />
		<cfset variables.xsl = createObject("component","cfcGenerator.model.xslService").init() />
	</cffunction>

	<cffunction name="getDSNs" access="public" returntype="struct" output="false">
		<cfargument name="event" type="MachII.framework.Event" required="yes" />
		<cfreturn variables.adminAPIService.getdatasources() />
	</cffunction>
	
	<cffunction name="getDatabaseType" access="public" returntype="string" output="false">
		<cfargument name="event" type="MachII.framework.Event" required="yes" />
		
		<cfset var datasources = event.getArg("DSNs") />
		<cfset var thisDSN = "" />

		<cfset thisDSN = datasources[event.getArg("dsn")] />
		<cfif thisDSN.driver eq "MSSQLServer"  or thisDSN.class contains "MSSQLServer">
			<cfreturn "mssql" />
		<cfelseif thisDSN.driver contains "mySQL" or thisDSN.class contains "mySQL">
			<cfreturn "mysql" />
		<cfelseif thisDSN.driver contains "Oracle" or thisDSN.class contains "Oracle">
			<cfreturn "Oracle" />
		</cfif>
	</cffunction>
	
	<cffunction name="getTables" access="public" returntype="query" output="false">
		<cfargument name="event" type="MachII.framework.Event" required="yes" />
		
		<cfset var dbType = event.getArg("dbtype") />
		<cfset var qryReturn = "" />
		<cfset variables[dbtype].setDSN(event.getArg("dsn")) />
		<cfreturn variables[dbtype].getTables() />
	</cffunction>
	
	<cffunction name="getTableXML" access="public" returntype="xml" output="false">
		<cfargument name="event" type="MachII.framework.Event" required="yes" />
		
		<cfset var qTables = "" />
		<cfset var dbType = event.getArg("dbtype") />
		<cfset variables[dbtype].setTable(event.getArg("table")) />
		<cfset variables[dbtype].setComponentPath(event.getArg("componentPath")) />
		<cfreturn variables[dbtype].getTableXML() />
	</cffunction>
	
	<cffunction name="getGeneratedCFCs" access="public" returntype="array" output="false">
		<cfargument name="event" type="MachII.framework.Event" required="yes" />
		
		<!--- configure the xsl component with the dsn --->
		<cfset variables.xsl.configure(event.getArg("dsn"),variables.getProperty("xslBasePath")) />
		<!--- get an array containing the generated code --->
		<cfreturn variables.xsl.getComponents(event.getArg("xmlTable")) />
	</cffunction>
</cfcomponent>