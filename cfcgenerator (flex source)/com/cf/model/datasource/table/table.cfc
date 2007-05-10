<cfcomponent name="table" displayname="table" hint="a table bean">
	<cfproperty name="tableName" type="string" required="false" default="" />
	<cfproperty name="tableType" type="string" required="false" default="" />
	
	<cffunction name="init" access="public" output="false" returntype="table">
		<cfargument name="tableName" type="string" required="false" default="" />
		<cfargument name="tableType" type="string" required="false" default="" />
		
		<cfset setTableName(arguments.tableName) />
		<cfset setTableType(arguments.tableType) />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setTableName" access="public" output="false" returntype="void">
		<cfargument name="tableName" type="string" required="false" default="" />
		
		<cfset variables.tableName = arguments.tableName />
	</cffunction>
	<cffunction name="getTableName" access="public" output="false" returntype="string">
		<cfreturn variables.tableName />
	</cffunction>
	
	<cffunction name="setTableType" access="public" output="false" returntype="void">
		<cfargument name="tableType" type="string" required="false" default="" />
		
		<cfset variables.tableType = arguments.tableType />
	</cffunction>
	<cffunction name="getTableType" access="public" output="false" returntype="string">
		<cfreturn variables.tableType />
	</cffunction>
</cfcomponent>