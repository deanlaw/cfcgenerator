<cfcomponent displayName="coldfusion8 datasource">
	<cffunction name="init" access="public" output="false" returntype="scorpio">
		<cfargument name="dsn" type="cfcgenerator.com.cf.datasource.datasource" required="true" />
		
		<cfset setDsn(arguments.dsn)>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setDsn" access="public" output="false" returntype="void">
		<cfargument name="dsn" type="cfcgenerator.com.cf.datasource.datasource" required="true" />
		
		<cfset variables.dsn = arguments.dsn />
	</cffunction>
	<cffunction name="getDsn" access="public" output="false" returntype="void">
	</cffunction>
	
	<cffunction name="getTables" access="public" output="false" returntype="cfcgenerator.com.cf.datasource.table.table[]">
		<cfset var qAllTables = "" />
		<cfset var objTable = "" />
		<cfset var arrReturn = arrayNew(1) />
		
		<cfdbinfo datasource="#variables.dsn.getDsnName()#" name="qAllTables" type="tables" />
		<cfloop query="qAllTables">
			<cfset objTable = createObject("component","cfcgenerator.com.cf.datasource.table.table").init(qAllTables.table_name,qAllTables.table_type) />
			<cfset arrayAppend(arrReturn,objTable) />
		</cfloop>
		<cfreturn arrReturn />
	</cffunction>
	
	<cffunction name="getColumns" access="public" output="false" returntype="cfcgenerator.com.cf.datasource.table.column[]">
		<cfargument name="table" type="cfcgenerator.com.cf.datasource.table.table" required="true" />
		
		<cfset var qColumns = "" />
		<cfset var objColumn = "" />
		<cfset var arrReturn = arrayNew(1) />
		
		<cfdbinfo datasource="#variables.dsn.getDsnName()#" name="qColumns" type="columns" table="#arguments.table.getTableName()#" />
		<cfloop query="qColumns">
			<cfset objColumn = createObject("component","cfcgenerator.com.cf.datasource.table.column").init(qColumns.column_name,qColumns.is_nullable,qColumns.type_name,qColumns.column_size,false,qColumns.is_primarykey) />
			<cfset arrayAppend(arrReturn,objColumn) />
		</cfloop>
		<cfreturn arrReturn />
	</cffunction>
	
	<!--- these functions are modified from reactor v0.1 --->
	<cffunction name="translateCfSqlType" hint="I translate the rdbms specific data type names into ColdFusion cf_sql_xyz names" output="false" returntype="string">
		<cfargument name="typeName" hint="I am the type name to translate" required="yes" type="string" />
	</cffunction>
	
	<cffunction name="translateDataType" hint="I translate the rdbms specific data type names into ColdFusion data type names" output="false" returntype="string">
		<cfargument name="typeName" hint="I am the type name to translate" required="yes" type="string" />
	</cffunction>
</cfcomponent>