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
			SELECT owner
        	,  TABLE_NAME
        	, 'TABLE'   TABLE_TYPE
			FROM all_tables
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
			SELECT
				col.COLUMN_NAME AS COLUMN_NAME,
            	 /* Oracle has no equivalent to autoincrement or  identity */
             	'false' AS "IDENTITY",                    
				CASE
					WHEN col.NULLABLE = 'Y' AND col.DATA_DEFAULT IS NULL THEN 1 /* a column is defined as nullable only if it doesn't have a default */
					ELSE 0
				END AS NULLABLE,
				col.DATA_TYPE AS TYPE_NAME,
				CASE
               /* 26 is the length of now() in ColdFusion (i.e. {ts '2006-06-26 13:10:14'})*/
					WHEN col.data_type = 'DATE' THEN 26
					ELSE col.data_length
				END AS length,
				CASE
					WHEN primaryConstraints.column_name IS NOT NULL THEN 'true'
					ELSE 'false'
				END AS is_primarykey
            FROM	all_tab_columns   col,
					(SELECT  colCon.column_name,
                 			  colcon.table_name
					FROM    all_cons_columns  colCon,
						all_constraints   tabCon
					WHERE tabCon.table_name = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="128" value="#variables.table#" />
					AND colCon.CONSTRAINT_NAME = tabCon.CONSTRAINT_NAME
					AND colCon.TABLE_NAME      = tabCon.TABLE_NAME
					AND 'P'                    = tabCon.CONSTRAINT_TYPE
                 ) primaryConstraints
			WHERE col.table_name = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="128" value="#variables.table#" />
					AND col.COLUMN_NAME        = primaryConstraints.COLUMN_NAME (+)
					AND col.TABLE_NAME       = primaryConstraints.TABLE_NAME (+)
			ORDER BY col.column_id
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