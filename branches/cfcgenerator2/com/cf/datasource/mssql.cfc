<cfcomponent displayName="mssql datasource">
	<cffunction name="init" access="public" output="false" returntype="mssql">
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
		
		<cfquery name="qAllTables" datasource="#variables.dsn.getDsnName()#">
			exec sp_tables @table_type="'Table'"
		</cfquery>
		<cfloop query="qAllTables">
			<cfset objTable = createObject("component","cfcgenerator.com.cf.datasource.table.table").init(qAllTables.table_name,qAllTables.table_type) />
			<cfset arrayAppend(arrReturn,objTable) />
		</cfloop>
		<cfreturn arrReturn />
	</cffunction>
	
	<cffunction name="getColumns" access="public" output="false" returntype="cfcgenerator.com.cf.datasource.table.table">
		<cfargument name="table" type="cfcgenerator.com.cf.datasource.table.table" required="true" />
		
		<cfset var qColumns = "" />
		<cfset var objColumn = "" />
		<cfset var arrColumns = arrayNew(1) />
		
		<!--- This is a modified version of the query in sp_columns --->
		<cfquery name="qColumns" datasource="#variables.dsn.getDsnName()#">	
			SELECT	c.COLUMN_NAME,
			c.DATA_TYPE as TYPE_NAME,
			CASE
				WHEN ISNUMERIC(c.CHARACTER_MAXIMUM_LENGTH) = 1 THEN c.CHARACTER_MAXIMUM_LENGTH
				ELSE 0
				END AS LENGTH,
			CASE
				WHEN c.IS_NULLABLE = 'No' AND c.Column_Default IS NULL THEN 0 /* a column is defined as nullable only if it doesn't have a default */
				ELSE 1
				END AS NULLABLE,
			CASE
				WHEN columnProperty(object_id(c.TABLE_NAME), c.COLUMN_NAME, 'IsIdentity') > 0 THEN 'true'
				ELSE 'false'
				END AS [IDENTITY],
			(
				SELECT count(ccu.COLUMN_NAME)
				FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE ccu
					INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
					ON ccu.CONSTRAINT_NAME = tc.CONSTRAINT_NAME
				AND 	ccu.TABLE_NAME = c.TABLE_NAME
				AND	tc.CONSTRAINT_TYPE = 'PRIMARY KEY'
				AND	ccu.COLUMN_NAME = c.COLUMN_NAME) AS IS_PRIMARYKEY
			FROM INFORMATION_SCHEMA.COLUMNS as c
			WHERE c.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.table.getTableName()#" />
		</cfquery>
		<cfloop query="qColumns">
			<cfset objColumn = createObject("component","cfcgenerator.com.cf.datasource.table.column").init(qColumns.column_name,qColumns.nullable,qColumns.type_name,qColumns.length,qColumns.identity,qColumns.is_primarykey) />
			<cfset arrayAppend(arrColumns,objColumn) />
		</cfloop>
		<cfset arguments.table.setColumns(arrColumns) />
		<cfreturn arguments.table />
	</cffunction>
	
	<!--- these functions are modified from reactor v0.1 --->
	<cffunction name="translateCfSqlType" hint="I translate the rdbms specific data type names into ColdFusion cf_sql_xyz names" output="false" returntype="string">
		<cfargument name="typeName" hint="I am the type name to translate" required="yes" type="string" />
	</cffunction>
	
	<cffunction name="translateDataType" hint="I translate the rdbms specific data type names into ColdFusion data type names" output="false" returntype="string">
		<cfargument name="typeName" hint="I am the type name to translate" required="yes" type="string" />
	</cffunction>
</cfcomponent>