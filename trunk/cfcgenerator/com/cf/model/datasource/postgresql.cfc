<cfcomponent name="Postgresql">
	
	<cffunction name="init" access="public" output="false" returntype="postgresql">
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
			SELECT table_name
				,CASE WHEN table_type = 'BASE TABLE' 
					THEN 'TABLE' 
					ELSE table_type 
				END 
			FROM information_schema.tables
			WHERE table_schema NOT IN ('pg_catalog', 'information_schema')
			ORDER BY table_name
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
	
	<!--- these functions are modified from reactor --->
	<cffunction name="translateCfSqlType" hint="I translate the Postgres data type names into ColdFusion cf_sql_xyz names" output="false" returntype="string">
		<cfargument name="typeName" hint="I am the type name to translate" required="yes" type="string" />
		<cfswitch expression="#lcase(arguments.typeName)#">
			<!--- time --->
			<cfcase value="date">
				<cfreturn "cf_sql_timestamp" />
			</cfcase>
			<cfcase value="timestamp">
				<cfreturn "cf_sql_timestamp" />
			</cfcase>

			<!--- bit / bool --->
			<cfcase value="bit">
				<cfreturn "cf_sql_bit" />
			</cfcase>
			<cfcase value="bool,boolean">
				<cfreturn "cf_sql_varchar" />
			</cfcase>

			<!--- numerics --->
			<cfcase value="oid">
				<cfreturn "cf_sql_integer" />
			</cfcase>
			<cfcase value="smallint">
				<cfreturn "cf_sql_smallint" />
			</cfcase>
			<cfcase value="integer,int,serial">
				<cfreturn "cf_sql_integer" />
			</cfcase>
			<cfcase value="bigint,bigserial">
				<cfreturn "cf_sql_bigint" />
			</cfcase>
			<cfcase value="numeric,smallmoney,money">
				<!--- postgres has deprecated the money type: http://www.postgresql.org/docs/8.1/static/datatype-money.html --->
				<cfreturn "cf_sql_numeric" />
			</cfcase>
			<cfcase value="real">
				<cfreturn "cf_sql_real" />
			</cfcase>
			<cfcase value="decimal,double precision,float">
				<cfreturn "cf_sql_decimal" />
			</cfcase>
			
			<!--- binary --->
			<cfcase value="bytea">
				<cfreturn "cf_sql_binary" />
			</cfcase>

			<!--- strings --->
			<cfcase value="char,character">
				<cfreturn "cf_sql_char" />
			</cfcase>
			<cfcase value="varchar,character varying">
				<cfreturn "cf_sql_varchar" />
			</cfcase>
			<cfcase value="text">
				<cfreturn "cf_sql_longvarchar" />
			</cfcase>
		</cfswitch>
		<cfthrow message="Unsupported (or incorrectly supported) database datatype: #arguments.typeName#." />
	</cffunction>
	
	<cffunction name="translateDataType" hint="I translate the Postgres data type names into ColdFusion data type names" output="false" returntype="string">
		<cfargument name="typeName" hint="I am the type name to translate" required="yes" type="string" />
		<cfswitch expression="#arguments.typeName#">
			<cfcase value="smallint,int,integer,bigint,serial,bigserial">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="bytea">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="bit,bool,boolean">
				<cfreturn "boolean" />
			</cfcase>
			<cfcase value="char,character,varchar,varying character,text">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="date,time,timestamp">
				<cfreturn "date" />
			</cfcase>
			<cfcase value="decimal,double,float,money,numeric,real">
				<cfreturn "numeric" />
			</cfcase>
		</cfswitch>

		<cfthrow message="Unsupported (or incorrectly supported) database datatype: #arguments.typeName#." />

	</cffunction>
	
	<cffunction name="setTableMetadata" access="public" output="false" returntype="void">
		<cfset var qTable = "" />
		<!--- get table column info --->
		<!--- This is a modified version of the query in sp_columns --->
		<cfquery name="qTable" datasource="#variables.dsn#">
			SELECT COLUMN_NAME
				,CASE
					WHEN IS_NULLABLE = 'Yes' AND COLUMN_DEFAULT IS NULL THEN 'true'
					ELSE 'false'
				END AS nullable
				,DATA_TYPE AS type_name
				,CASE
					WHEN CHARACTER_MAXIMUM_LENGTH IS NULL THEN 0
					ELSE CHARACTER_MAXIMUM_LENGTH
				END as length
				,CASE
					WHEN data_type = 'serial' THEN 'true'
					WHEN data_type = 'bigserial' THEN 'true'
					ELSE 'false'
				END AS identity
			FROM information_schema.COLUMNS
			WHERE TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="128" value="#variables.table#" />
		</cfquery>
		<cfset variables.tableMetadata = qTable />
	</cffunction>
	<cffunction name="getTableMetaData" access="public" output="false" returntype="query">
		<cfreturn variables.tableMetadata />
	</cffunction>
	
	<cffunction name="setPrimaryKeyList" access="public" output="false" returntype="void">
		<cfset var qPrimaryKeys = "" />
		<cfset var lstPrimaryKeys = "" />
		<cfquery name="qPrimaryKeys" datasource="#variables.dsn#">
			SELECT column_name 
			FROM information_schema.table_constraints a
				,information_schema.key_column_usage b
			WHERE a.table_name = b.table_name
			AND a.constraint_name = b.constraint_name
			AND a.constraint_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRIMARY KEY" />
			AND a.table_name = <cfqueryparam cfsqltype="cf_sql_varchar" scale="128" value="#variables.table#" />
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
				<dbtable name="#variables.table#">
				<cfloop query="variables.tableMetadata">
					<column name="#variables.tableMetadata.column_name#"
							type="<cfif listFindNoCase('char,character', variables.tableMetadata.type_name) AND variables.tableMetadata.length EQ 35>uuid<cfelse>#translateDataType(listFirst(variables.tableMetadata.type_name," "))#</cfif>"
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
