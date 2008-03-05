<cfcomponent displayName="mysql datasource">
	<cffunction name="init" access="public" output="false" returntype="mysql">
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
	
	<cffunction name="isMySQL5plus" access="private" output="false" returntype="boolean">
		<!--- a simple test to see if the information_schema exists --->
		<cfset var qTestMySQL = "" />
		<cfset var rtnValue = true />
		<cfif not isDefined("variables.isMySQL5plusVar")>
			<cftry>
				<cfquery name="qTestMySQL" datasource="#variables.dsn.getDsnName()#">
					SELECT 0 FROM INFORMATION_SCHEMA.columns LIMIT 1
				</cfquery>
				<cfcatch type="database">
					<cfset rtnValue = false />
				</cfcatch>
			</cftry>
			<cfset variables.isMySQL5plusVar = rtnValue />
		<cfelse>
			<cfset rtnValue = variables.isMySQL5plusVar />
		</cfif>
		<cfreturn rtnValue />
	</cffunction>
	
	<cffunction name="getTables" access="public" output="false" returntype="array">
		<cfif isMySQL5Plus()>
			<cfreturn getTables_5() />
		<cfelse>
			<cfreturn getTables_41() />
		</cfif>
	</cffunction>
	
	<!--- MySQL 4.1 support thanks to Josh Nathanson --->
	<cffunction name="getTables_41" access="private" output="false" returntype="array">
		<cfset var qStatus = "" />
		<cfset var qDB = "" />
		<cfset var getDBname = "" />
		<cfset var qAllTables = "" />
		<cfset objTable = "" />
		<cfset arrReturn = arrayNew(1) />
		
		<cfquery name="qStatus" datasource="#variables.dsn#">
		SHOW TABLE STATUS
		</cfquery>

		<cfquery name="qDB" datasource="#variables.dsn#">
		SHOW OPEN TABLES
		</cfquery>

		<cfquery name="getDBname" dbtype="query">
		SELECT Database AS db FROM qDB
		GROUP BY Database
		</cfquery>

		<cfquery name="qAllTables" dbtype="query">
		SELECT '#getDBname.db#' as DATABASE_NAME, '#getDBname.db#' AS TABLE_SCHEMA, Name AS TABLE_NAME, Engine AS TABLE_TYPE
			FROM qStatus
		</cfquery>

		<cfloop query="qAllTables">
			<cfset objTable = createObject("component","cfcgenerator.com.cf.datasource.table.table").init(qAllTables.table_name,qAllTables.table_type) />
			<cfset arrayAppend(arrReturn,objTable) />
		</cfloop>
		<cfreturn arrReturn />
	</cffunction>
	<!------------------------>
	
	<cffunction name="getTables_5" access="public" output="false" returntype="array">
		<cfset var qAllTables = "" />
		<cfset objTable = "" />
		<cfset arrReturn = arrayNew(1) />
		
		<cfquery name="qAllTables" datasource="#variables.dsn.getDsnName()#">
			SELECT database() as DATABASE_NAME, TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE
			FROM information_schema.TABLES
			WHERE TABLE_SCHEMA = database()
		</cfquery>
		<cfloop query="qAllTables">
			<cfset objTable = createObject("component","cfcgenerator.com.cf.datasource.table.table").init(qAllTables.table_name,qAllTables.table_type) />
			<cfset arrayAppend(arrReturn,objTable) />
		</cfloop>
		<cfreturn arrReturn />
	</cffunction>
	
	<cffunction name="getColumns" access="public" output="false" returntype="cfcgenerator.com.cf.datasource.table.table">
		<cfargument name="table" type="cfcgenerator.com.cf.datasource.table.table" required="true" />
		
		<cfset var arrColumns = arrayNew(1) />
		<cfif isMySQL5plus()>
			<cfset arrColumns = getColumns_5(arguments.table) />
		<cfelse>
			<cfset arrColumns = getColumns_41(arguments.table) />
		</cfif>
		<cfset arguments.table.setColumns(arrColumns) />
		<cfreturn arguments.table />
	</cffunction>
	
	<cffunction name="getColumns_5" access="private" output="false" returntype="cfcgenerator.com.cf.datasource.table.column[]">
		<cfargument name="table" type="cfcgenerator.com.cf.datasource.table.table" required="true" />
		
		<cfset var qColumns = "" />
		<cfset var objColumn = "" />
		<cfset var arrReturn = arrayNew(1) />

		<cfquery name="qColumns" datasource="#variables.dsn.getDsnName()#">
			SELECT COLUMN_NAME,
			CASE
				WHEN IS_NULLABLE = 'Yes' AND COLUMN_DEFAULT IS NULL THEN 'true'
				ELSE 'false'
			END as nullable,
			CASE
				WHEN COLUMN_KEY = 'Pri' THEN 'true'
				ELSE 'false'
			END as is_primarykey,
			DATA_TYPE as type_name,
			CASE
				WHEN CHARACTER_MAXIMUM_LENGTH IS NULL THEN 0
				ELSE CHARACTER_MAXIMUM_LENGTH
			END as length,
			CASE
				WHEN EXTRA = 'auto_increment' THEN 'true'
				ELSE 'false'
			END as identity
			FROM information_schema.COLUMNS
			WHERE TABLE_SCHEMA = Database() AND TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.table.getTableName()#" />
		</cfquery>
		<cfloop query="qColumns">
			<cfset objColumn = createObject("component","cfcgenerator.com.cf.datasource.table.column").init(qColumns.column_name,qColumns.nullable,qColumns.type_name,qColumns.length,qColumns.identity,qColumns.is_primarykey) />
			<cfset arrayAppend(arrReturn,objColumn) />
		</cfloop>
		<cfreturn arrReturn />
	</cffunction>
	
	<!--- MySQL 4.1 support thanks to Josh Nathanson --->
	<cffunction name="setTableMetadata_41" access="private" output="false" returntype="cfcgenerator.com.cf.datasource.table.column[]">
		<cfset var qTable = "" />
		<cfset var qColumns = "" />
		<cfset var lgth = "" />
		<cfset var typ = "" />
		<cfset var lgth_str = "" />
		<cfset var objColumn = "" />
		<cfset var arrReturn = arrayNew(1) />

		<cfquery name="qTable" datasource= "#variables.dsn.getDsnName()#">
			DESCRIBE #arguments.table.getTableName()#
		</cfquery>

		<cfset qColumns = QueryNew("COLUMN_NAME, nullable, type_name, length, identity")>

		<cfloop query="qTable">
			<!--- set type and length --->
			<cfset lgth = REFind("[0-9]+",Type,1,true)>
			<cfset typ = REFind("[a-zA-Z]+",Type,1,true)>
			<cfif lgth.len[1]> 
			<!--- if lgth is found by REFind, return struct - lgth.len[1] will be nonzero --->
				<cfset lgth_str = mid(Type,lgth.pos[1],lgth.len[1])>
			<cfelse>
				<cfset lgth_str = "0">
			</cfif>
			<cfset typ_str = mid(Type,typ.pos[1],typ.len[1])> <!--- there will always be a type --->
		
			<cfset queryAddRow(qColumns)>
			<cfset querySetCell(qColumns,"COLUMN_NAME",Field)>
			<cfif null eq "Yes">
				<cfset querySetCell(qColumns,"nullable","true")>
			<cfelse>
				<cfset querySetCell(qColumns,"nullable","false")>
			</cfif>
			<cfset querySetCell(qColumns,"type_name",typ_str)>
			<cfset querySetCell(qColumns,"length",lgth_str)>
			<cfif extra eq "auto_increment">
				<cfset querySetCell(qColumns,"identity","true")>
			<cfelse>
				<cfset querySetCell(qColumns,"identity","false")>
			</cfif>
	
		</cfloop>
		<cfloop query="qColumns">
			<cfset objColumn = createObject("component","cfcgenerator.com.cf.datasource.table.column").init(qColumns.column_name,qColumns.nullable,qColumns.type_name,qColumns.length,qColumns.identity) />
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