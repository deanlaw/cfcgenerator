<cfcomponent name="informix">
	
	<cffunction name="init" access="public" output="false" returntype="informix">
		<cfargument name="dsn" type="string" required="true" />
		
		<cfset setDSN(arguments.dsn) />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getTables" access="public" output="false" returntype="array">
		<cfset var qAllTables = "" />
		<cfset objTable = "" />
		<cfset arrReturn = arrayNew(1) />
		
		<cfif not len(variables.dsn)>
			<cfthrow message="you must provide a dsn" />
		</cfif>
		
		<cfquery name="qAllTables" datasource="#variables.dsn#">
			SELECT 
			tabname
			, owner
			, tabtype
			FROM systables
			WHERE tabid > 99
			AND tabtype IN ('T','V')
			ORDER BY 1
		</cfquery>
		
		<cfloop query="qAllTables">
			<cfset objTable = createObject("component","cfcgenerator.com.cf.model.datasource.table.table").init(qAllTables.tabname,qAllTables.tabtype) />
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
	<cffunction name="translateCfSqlType" hint="I translate the MSSQL data type names into ColdFusion cf_sql_xyz names" output="false" returntype="string">
		<cfargument name="typeName" hint="I am the type name to translate" required="yes" type="string" />
		
		<cfswitch expression="#arguments.typeName#">
			<cfcase value="0">
				<cfreturn "cf_sql_char" />
			</cfcase>
			<cfcase value="1">
				<cfreturn "cf_sql_smallint" />
			</cfcase>
			<cfcase value="2">
				<cfreturn "cf_sql_integer" />
			</cfcase>
			<cfcase value="3">
				<cfreturn "cf_sql_float" />
			</cfcase>
			<cfcase value="4">
				<!--- SMALL FLOAT --->
				<cfreturn "cf_sql_float" />
			</cfcase>
			<cfcase value="5">
				<cfreturn "cf_sql_decimal" />
			</cfcase>
			<cfcase value="6">
				<cfreturn "cf_sql_integer" />
			</cfcase>
			<cfcase value="7">
				<cfreturn "cf_sql_date" />
			</cfcase>
			<cfcase value="8">
				<cfreturn "cf_sql_money" />
			</cfcase>
			<cfcase value="10">
				<cfreturn "cf_sql_timestamp" />
			</cfcase>
			<cfcase value="13">
				<cfreturn "cf_sql_varchar" />
			</cfcase>
			<cfcase value="40">
				<cfreturn "cf_sql_longvarchar" />
			</cfcase>
			<cfcase value="41">
				<cfreturn "cf_sql_longvarchar" />
			</cfcase>
			<cfcase value="262">
				<cfreturn "cf_sql_serial" />
			</cfcase>
		</cfswitch>
	</cffunction>
	
	<cffunction name="translateDataType" hint="I translate the MSSQL data type names into ColdFusion data type names" output="false" returntype="string">
		<cfargument name="typeName" hint="I am the type name to translate" required="yes" type="string" />
		
		<cfswitch expression="#arguments.typeName#">
			<cfcase value="0">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="1">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="2">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="3">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="4">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="5">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="6">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="7">
				<cfreturn "date" />
			</cfcase>
			<cfcase value="8">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="10">
				<cfreturn "date" />
			</cfcase>
			<cfcase value="13">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="40">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="41">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="262">
				<cfreturn "string" />
			</cfcase>
		</cfswitch>
		
	</cffunction>
	
	<cffunction name="setTableMetadata" access="public" output="false" returntype="void">
		<cfset var qTable = "" />
		<!--- get table column info --->
		<!--- This is a modified version of the query in sp_columns --->
		<cfquery name="qTable" datasource="#variables.dsn#">
			SELECT
			c.colname AS COLUMN_NAME
			, CASE
				WHEN c.coltype = 262
				THEN c.coltype
				WHEN c.coltype >= 256
				THEN (c.coltype-256)
				ELSE c.coltype
				END 
				AS TYPE_NAME
			, c.collength AS LENGTH
			, CASE
				WHEN c.coltype >= 256  
				THEN 0
				ELSE 1
				END 
				AS NULLABLE
			, CASE
				WHEN c.coltype = 262  
				THEN 1
				ELSE 0
				END 
				AS IDENTITY
			FROM syscolumns c
			WHERE c.tabid = (	SELECT t.tabid
								FROM systables t
								WHERE t.tabid > 99
								AND t.tabname = <cfqueryparam
													cfsqltype="cf_sql_char"
													null="#YesNoFormat(Len(variables.table) EQ 0)#"
													value="#variables.table#">
							)
			ORDER BY c.colno, c.colname
		</cfquery>
		
		<cfset variables.tableMetadata = qTable />
	</cffunction>
	
	<cffunction name="getTableMetaData" access="public" output="false" returntype="query">
		<cfreturn variables.tableMetadata />
	</cffunction>
	
	<cffunction name="setPrimaryKeyList" access="public" output="false" returntype="void">
		<cfset var qPrimaryKeys = "" />
		<cfset var lstPrimaryKeys = "" />
		<cfset var i = 0>
		<cfset var qTableId = "">
		<cfset var tableID = 0>
		
		<cfquery name="qTableId" datasource="#variables.dsn#">
			SELECT t.tabid
			FROM systables t
			WHERE t.tabid > 99
			AND t.tabname = <cfqueryparam
								cfsqltype="cf_sql_char"
								null="#YesNoFormat(Len(variables.table) EQ 0)#"
								value="#variables.table#">
		</cfquery>
		
		<cfset tableID = Trim(qTableId.tabid)>
		
		<cfquery name="qPrimaryKeys" datasource="#variables.dsn#">
		  	<cfloop from="1" to="16" index="i" step="1">
				<cfif i GT 1>UNION</cfif>
		  		SELECT 
		  		i.idxname AS PK_NAME
		  		, i.idxtype
		  		<cfif i eq 1>
					, i.part#i# AS index_order
		  		<cfelse>
					, i.part#i#
		  		</cfif>
		  		, c.colname AS COLUMN_NAME
		  		FROM sysindexes i
		  		INNER JOIN syscolumns c ON (i.tabid = c.tabid AND c.colno = i.part#i#)
		  		WHERE i.tabid = <cfqueryparam cfsqltype="cf_sql_char" value="#tableID#">
				AND i.idxtype = <cfqueryparam cfsqltype="cf_sql_char" value="U">
				AND i.part#i# != <cfqueryparam cfsqltype="cf_sql_char" value="0">
	  		</cfloop>
		</cfquery>

		<cfset lstPrimaryKeys = valueList(qPrimaryKeys.column_name) />
		<cfset variables.primaryKeyList = lstPrimaryKeys />
	</cffunction>
	
	<cffunction name="getPrimaryKeyList" access="public" output="false" returntype="string">
		<cfreturn variables.primaryKeyList />
	</cffunction>

	<cffunction name="getTableXML" access="public" output="false" returntype="xml">
		<cfset var xmlTable = "" />
		<!--- convert the table data into an xml format --->
		<!--- added listfirst to the sql_type because identity is sometimes appended --->
		<cfxml variable="xmlTable">
		<cfoutput>
		<root>
			<bean name="#listLast(variables.componentPath,'.')#" path="#variables.componentPath#">
				<dbtable name="#variables.table#" type="informix">
				<cfloop query="variables.tableMetadata">
					<column name="#variables.tableMetadata.column_name#"
							type="<cfif variables.tableMetadata.type_name EQ 'char' AND variables.tableMetadata.length EQ 35 AND listFind(variables.primaryKeyList,variables.tableMetadata.column_name)>uuid<cfelse>#translateDataType(listFirst(variables.tableMetadata.type_name," "))#</cfif>"
							cfSqlType="#translateCfSqlType(listFirst(variables.tableMetadata.type_name," "))#"
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