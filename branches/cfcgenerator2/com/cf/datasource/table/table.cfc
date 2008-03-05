<cfcomponent name="table" displayname="table" hint="a table bean">
	<cfproperty name="tableName" type="string" required="false" default="" />
	<cfproperty name="tableType" type="string" required="false" default="" />
	<cfproperty name="alias" type="string" required="false" default="" />
	<cfproperty name="columns" type="array" required="false" />
	
	<cffunction name="init" access="public" output="false" returntype="table">
		<cfargument name="tableName" type="string" required="false" default="" />
		<cfargument name="tableType" type="string" required="false" default="" />
		<cfargument name="alias" type="string" required="false" default="" />
		<cfargument name="columns" type="cfcgenerator.com.cf.datasource.table.column[]" required="false" default="#arrayNew(1)#" />
		
		<cfset setTableName(arguments.tableName) />
		<cfset setTableType(arguments.tableType) />
		<cfset setAlias(arguments.alias) />
		<cfset setColumns(arguments.columns) />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setTableName" access="public" output="false" returntype="void">
		<cfargument name="tableName" type="string" required="false" default="" />
		
		<cfset variables.tableName = arguments.tableName />
	</cffunction>
	<cffunction name="getTableName" access="public" output="false" returntype="string">
		<cfreturn variables.tableName />
	</cffunction>
	
	<cffunction name="setAlias" access="public" output="false" returntype="void">
		<cfargument name="alias" type="string" required="false" default="" />
		
		<cfset variables.alias = arguments.alias />
	</cffunction>
	<cffunction name="getAlias" access="public" output="false" returntype="string">
		<cfreturn variables.alias />
	</cffunction>
	
	<cffunction name="setTableType" access="public" output="false" returntype="void">
		<cfargument name="tableType" type="string" required="false" default="" />
		
		<cfset variables.tableType = arguments.tableType />
	</cffunction>
	<cffunction name="getTableType" access="public" output="false" returntype="string">
		<cfreturn variables.tableType />
	</cffunction>
	
	<cffunction name="setColumns" access="public" output="false" returntype="void">
		<cfargument name="columns" type="cfcgenerator.com.cf.datasource.table.column[]" required="true" />
		
		<cfset variables.columns = arguments.columns />
	</cffunction>
	<cffunction name="getColumns" access="public" output="false" returntype="cfcgenerator.com.cf.datasource.table.column[]">
		<cfreturn variables.columns />
	</cffunction>
</cfcomponent>