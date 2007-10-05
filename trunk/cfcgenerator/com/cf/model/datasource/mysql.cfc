<cfcomponent name="mysql">
	
	<cffunction name="init" access="public" output="false" returntype="mysql">
		<cfargument name="dsn" type="string" required="true" />
		
		<cfset setDSN(arguments.dsn) />
		<cfset isMySQL5plus() />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isMySQL5plus" access="private" output="false" returntype="boolean">
		<!--- a simple test to see if the information_schema exists --->
		<cfset var qTestMySQL = "" />
		<cfset var rtnValue = true />
		<cfif not isDefined("variables.isMySQL5plusVar")>
			<cftry>
				<cfquery name="qTestMySQL" datasource="#variables.dsn#">
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
		
		<cfif not len(variables.dsn)>
			<cfthrow errorcode="you must provide a dsn" />
		</cfif>
		
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
			<cfset objTable = createObject("component","cfcgenerator.com.cf.model.datasource.table.table").init(qAllTables.table_name,qAllTables.table_type) />
			<cfset arrayAppend(arrReturn,objTable) />
		</cfloop>
		<cfreturn arrReturn />
	</cffunction>
	<!------------------------>
	
	<cffunction name="getTables_5" access="public" output="false" returntype="array">
		<cfset var qAllTables = "" />
		<cfset objTable = "" />
		<cfset arrReturn = arrayNew(1) />
		
		<cfif not len(variables.dsn)>
			<cfthrow errorcode="you must provide a dsn" />
		</cfif>
		<cfquery name="qAllTables" datasource="#variables.dsn#">
			SELECT database() as DATABASE_NAME, TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE
			FROM information_schema.TABLES
			WHERE TABLE_SCHEMA = database()
		</cfquery>
		<cfloop query="qAllTables">
			<cfset objTable = createObject("component","cfcgenerator.com.cf.model.datasource.table.table").init(qAllTables.table_name,qAllTables.table_type) />
			<cfset arrayAppend(arrReturn,objTable) />
		</cfloop>
		<cfreturn arrReturn />
	</cffunction>
	
	<cffunction name="setDSN" access="public" output="false" returntype="void">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsn = arguments.dsn />
	</cffunction>
	<cffunction name="setComponentPath" access="public" output="false" returntype="void">
		<cfargument name="componentPath" type="string" required="true" />
		<cfset variables.componentPath = arguments.componentPath />
	</cffunction>
	<cffunction name="setTable" access="public" output="false" returntype="void">
		<cfargument name="table" type="string" required="true" />
		
		<cfset variables.table = arguments.table />
		<cfset setTableMetadata() />
		<cfset setPrimaryKeyList() />
	</cffunction>
	
	<!--- these functions are modified from reactor v0.1 --->
	<cffunction name="translateCfSqlType" hint="I translate the MySQL data type names into ColdFusion cf_sql_xyz names" output="false" returntype="string">
		<cfargument name="typeName" hint="I am the type name to translate" required="yes" type="string" />
		
		<cfswitch expression="#arguments.typeName#">
			<cfcase value="bigint">
				<cfreturn "cf_sql_bigint" />
			</cfcase>
			<cfcase value="binary">
				<cfreturn "cf_sql_binary" />
			</cfcase>
			<cfcase value="bit">
				<cfreturn "cf_sql_bit" />
			</cfcase>
			<cfcase value="char">
				<cfreturn "cf_sql_char" />
			</cfcase>
			<cfcase value="datetime">
				<cfreturn "cf_sql_timestamp" />
			</cfcase>
			<cfcase value="decimal">
				<cfreturn "cf_sql_decimal" />
			</cfcase>
			<cfcase value="double">
				<cfreturn "cf_sql_numeric" />
			</cfcase>
			<cfcase value="float">
				<cfreturn "cf_sql_float" />
			</cfcase>
			<cfcase value="image">
				<cfreturn "cf_sql_longvarbinary" />
			</cfcase>
			<cfcase value="int">
				<cfreturn "cf_sql_integer" />
			</cfcase>
			<cfcase value="money">
				<cfreturn "cf_sql_money" />
			</cfcase>
			<cfcase value="nchar">
				<cfreturn "cf_sql_char" />
			</cfcase>
			<cfcase value="ntext">
				<cfreturn "cf_sql_longvarchar" />
			</cfcase>
			<cfcase value="numeric">
				<cfreturn "cf_sql_varchar" />
			</cfcase>
			<cfcase value="nvarchar">
				<cfreturn "cf_sql_varchar" />
			</cfcase>
			<cfcase value="longtext">
				<cfreturn "cf_sql_longvarchar" />
			</cfcase>
			<cfcase value="real">
				<cfreturn "cf_sql_real" />
			</cfcase>
			<cfcase value="smalldatetime">
				<cfreturn "cf_sql_date" />
			</cfcase>
			<cfcase value="smallint">
				<cfreturn "cf_sql_smallint" />
			</cfcase>
			<cfcase value="smallmoney">
				<cfreturn "cf_sql_decimal" />
			</cfcase>
			<cfcase value="text">
				<cfreturn "cf_sql_longvarchar" />
			</cfcase>
			<cfcase value="timestamp">
				<cfreturn "cf_sql_timestamp" />
			</cfcase>
			<cfcase value="tinyint">
				<cfreturn "cf_sql_tinyint" />
			</cfcase>
			<cfcase value="uniqueidentifier">
				<cfreturn "cf_sql_idstamp" />
			</cfcase>
			<cfcase value="varbinary">
				<cfreturn "cf_sql_varbinary" />
			</cfcase>
			<cfcase value="varchar">
				<cfreturn "cf_sql_varchar" />
			</cfcase>
		</cfswitch>
	</cffunction>
	
	<cffunction name="translateDataType" hint="I translate the MSSQL data type names into ColdFusion data type names" output="false" returntype="string">
		<cfargument name="typeName" hint="I am the type name to translate" required="yes" type="string" />
	
		<cfswitch expression="#arguments.typeName#">
			<cfcase value="bigint">
				<cfreturn "Numeric" />
			</cfcase>
			<cfcase value="binary">
				<cfreturn "String" />
			</cfcase>
			<cfcase value="bit">
				<cfreturn "Boolean" />
			</cfcase>
			<cfcase value="char">
				<cfreturn "String" />
			</cfcase>
			<cfcase value="datetime">
				<cfreturn "Date" />
			</cfcase>
			<cfcase value="decimal">
				<cfreturn "Numeric" />
			</cfcase>
			<cfcase value="double">
				<cfreturn "Numeric" />
			</cfcase>
			<cfcase value="float">
				<cfreturn "Numeric" />
			</cfcase>
			<cfcase value="image">
				<cfreturn "Numeric" />
			</cfcase>
			<cfcase value="int">
				<cfreturn "Numeric" />
			</cfcase>
			<cfcase value="money">
				<cfreturn "Numeric" />
			</cfcase>
			<cfcase value="nchar">
				<cfreturn "String" />
			</cfcase>
			<cfcase value="ntext">
				<cfreturn "String" />
			</cfcase>
			<cfcase value="numeric">
				<cfreturn "Numeric" />
			</cfcase>
			<cfcase value="nvarchar">
				<cfreturn "String" />
			</cfcase>
			<cfcase value="longtext">
				<cfreturn "String" />
			</cfcase>
			<cfcase value="real">
				<cfreturn "Numeric" />
			</cfcase>
			<cfcase value="smalldatetime">
				<cfreturn "Date" />
			</cfcase>
			<cfcase value="smallint">
				<cfreturn "Numeric" />
			</cfcase>
			<cfcase value="smallmoney">
				<cfreturn "Numeric" />
			</cfcase>
			<cfcase value="text">
				<cfreturn "String" />
			</cfcase>
			<cfcase value="timestamp">
				<cfreturn "Date" />
			</cfcase>
			<cfcase value="tinyint">
				<cfreturn "Boolean" />
			</cfcase>
			<cfcase value="uniqueidentifier">
				<cfreturn "String" />
			</cfcase>
			<cfcase value="varbinary">
				<cfreturn "String" />
			</cfcase>
			<cfcase value="varchar">
				<cfreturn "String" />
			</cfcase>
		</cfswitch>
	</cffunction>
	
	<cffunction name="setTableMetadata" access="public" output="false" returntype="void">
		<cfif isMySQL5plus()>
			<cfset setTableMetadata_5() />
		<cfelse>
			<cfset setTableMetadata_41() />
		</cfif>
	</cffunction>
	<cffunction name="setTableMetadata_5" access="private" output="false" returntype="void">
		<cfset var qTable = "" />
		<!--- get table column info, borrowed from Reactor --->
		<cfquery name="qTable" datasource="#variables.dsn#">
			SELECT COLUMN_NAME,
			CASE
				WHEN IS_NULLABLE = 'Yes' AND COLUMN_DEFAULT IS NULL THEN 'true'
				ELSE 'false'
			END as nullable,
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
			WHERE TABLE_SCHEMA = Database() AND TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" scale="128" value="#variables.table#" />
		</cfquery>
		<cfset variables.tableMetadata = qTable />
	</cffunction>
	<!--- MySQL 4.1 support thanks to Josh Nathanson --->
	<cffunction name="setTableMetadata_41" access="private" output="false" returntype="void">
		<cfset var qTable_pre = "" />
		<cfset var qTable = "" />
		<cfset var lgth = "" />
		<cfset var typ = "" />
		<cfset var lgth_str = "" />

		<cfquery name="qTable_pre" datasource= "#variables.dsn#">
			DESCRIBE #variables.table#
		</cfquery>

		<cfset qTable = QueryNew("COLUMN_NAME, nullable, type_name, length, identity")>

		<cfoutput query="qTable_pre">
			<!--- set type and length --->
			<cfset lgth = REFind("[0-9]+",Type,1,true)>
			<cfset typ = REFind("[a-zA-Z]+",Type,1,true)>
			<cfif lgth.len[1]> 
			<!--- if lgth is found by REFind, return struct - lgth.len[1] will be nonzero --->
				<cfset lgth_str = Mid(Type,lgth.pos[1],lgth.len[1])>
			<cfelse>
				<cfset lgth_str = "0">
			</cfif>
			<cfset typ_str = Mid(Type,typ.pos[1],typ.len[1])> <!--- there will always be a type --->
		
			<cfset QueryAddRow(qTable)>
			<cfset QuerySetCell(qTable,"COLUMN_NAME",Field)>
			<cfif Null is "Yes">
				<cfset QuerySetCell(qTable, "nullable", "true")>
			<cfelse>
				<cfset QuerySetCell(qTable, "nullable", "false")>
			</cfif>
			<cfset QuerySetCell(qTable, "type_name", typ_str)>
			<cfset QuerySetCell(qTable, "length", lgth_str)>
			<cfif Extra is "auto_increment">
				<cfset QuerySetCell(qTable, "identity", "true")>
			<cfelse>
				<cfset QuerySetCell(qTable, "identity", "false")>
			</cfif>
	
		</cfoutput>

		<cfset variables.tableMetadata = qTable />
	</cffunction>
	<!------------------------>
	<cffunction name="getTableMetaData" access="public" output="false" returntype="query">
		<cfreturn variables.tableMetadata />
	</cffunction>
	
	<cffunction name="setPrimaryKeyList" access="public" output="false" returntype="void">
		<cfif isMySQL5plus()>
			<cfset setPrimaryKeyList_5() />
		<cfelse>
			<cfset setPrimaryKeyList_41() />
		</cfif>
	</cffunction>
	<cffunction name="setPrimaryKeyList_5" access="public" output="false" returntype="void">
		<cfset var qPrimaryKeys = "" />
		<cfset var lstPrimaryKeys = "" />
		<cfquery name="qPrimaryKeys" datasource="#variables.dsn#">
			SELECT COLUMN_NAME
			FROM information_schema.COLUMNS
			WHERE TABLE_SCHEMA = Database()
			AND TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" scale="128" value="#variables.table#" />
			AND	COLUMN_KEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRI" />
		</cfquery>
		<cfset lstPrimaryKeys = valueList(qPrimaryKeys.column_name) />
		<cfset variables.primaryKeyList = lstPrimaryKeys />
	</cffunction>
	<!--- MySQL 4.1 support thanks to Josh Nathanson --->
	<cffunction name="setPrimaryKeyList_41" access="public" output="false" returntype="void">
		<cfset var qPrimaryKeys_pre = "" />
		<cfset var qPrimaryKeys = "" />
		<cfset var lstPrimaryKeys = "" />
		
		<cfquery name="qPrimaryKeys_pre" datasource= "#variables.dsn#">
		DESCRIBE #variables.table#
		</cfquery>
		
		<cfquery name="qPrimaryKeys" dbtype="query">
		SELECT Field AS COLUMN_NAME FROM qPrimaryKeys_pre
		WHERE [Key] = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRI" />
		</cfquery>

		<cfset lstPrimaryKeys = valueList(qPrimaryKeys.column_name) />
		<cfset variables.primaryKeyList = lstPrimaryKeys />
	</cffunction>
	<!------------------------>
	<cffunction name="getPrimaryKeyList" access="public" output="false" returntype="string">
		<cfreturn variables.primaryKeyList />
	</cffunction>

	<cffunction name="getTableXML" access="public" output="false" returntype="xml">
		<cfset var xmlTable = "" />
		<!--- convert the table data into an xml format --->
		<cfxml variable="xmlTable">
		<cfoutput>
		<root>
			<bean name="#listLast(variables.componentPath,'.')#" path="#variables.componentPath#">
				<dbtable name="#variables.table#">
				<cfloop query="variables.tableMetadata">
					<column name="#variables.tableMetadata.column_name#"
							type="<cfif variables.tableMetadata.type_name EQ 'char' AND variables.tableMetadata.length EQ 35 AND listFind(variables.primaryKeyList,variables.tableMetadata.column_name)>uuid<cfelse>#translateDataType(variables.tableMetadata.type_name)#</cfif>"
							cfSqlType="#translateCfSqlType(variables.tableMetadata.type_name)#"
							required="#yesNoFormat(variables.tableMetadata.nullable-1)#"
							length="#variables.tableMetadata.length#"
							primaryKey="#yesNoFormat(listFind(variables.primaryKeyList,variables.tableMetadata.column_name))#"
							identity="#variables.tableMetadata.identity#" />
				</cfloop>
				</dbtable>
			</bean>
		</root>
		</cfoutput>
		</cfxml>
		<cfreturn xmlTable />
	</cffunction>
</cfcomponent>