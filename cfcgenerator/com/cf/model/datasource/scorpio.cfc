<cfcomponent name="scorpio">
	
	<cffunction name="init" access="public" output="false" returntype="scorpio">
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
		<cfdbinfo datasource="#variables.dsn#" name="qAllTables" type="tables" />
		<cfloop query="qAllTables">
			<cfif qAllTables.table_type NEQ "SYSTEM TABLE">
				<cfset objTable = createObject("component","cfcgenerator.com.cf.model.datasource.table.table").init(qAllTables.table_name,qAllTables.table_type) />
				<cfset arrayAppend(arrReturn,objTable) />
			</cfif>
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
	</cffunction>
	
	<!--- these functions are modified from reactor v0.1 --->
	<cffunction name="translateCfSqlType" hint="I translate the MSSQL data type names into ColdFusion cf_sql_xyz names" output="false" returntype="string">
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
			<!--- oracle specific --->
			<cfcase value="rowid">
				<cfreturn "cf_sql_varchar" />
			</cfcase>
			<cfcase value="date">
				<cfreturn "cf_sql_timestamp" />
			</cfcase>
			<cfcase value="timestamp(6)">
				<cfreturn "cf_sql_date" />
			</cfcase>
			<cfcase value="varchar2">
				<cfreturn "cf_sql_varchar" />
			</cfcase>
			<cfcase value="nvarchar2">
				<cfreturn "cf_sql_varchar" />
			</cfcase>
			<cfcase value="blob">
				<cfreturn "cf_sql_blob" />
			</cfcase>
			<cfcase value="clob">
				<cfreturn "cf_sql_clob" />
			</cfcase>
			<cfcase value="nclob">
				<cfreturn "cf_sql_clob" />
			</cfcase>
			<cfcase value="long">
				<cfreturn "cf_sql_longvarchar" />
			</cfcase>
			<cfcase value="long raw">
				<!--- @@Note: may need "tobinary(ToBase64(x))" when updating --->
				<cfreturn "cf_sql_longvarbinary" />
			</cfcase>
			<cfcase value="raw">
			   <!--- @@Note: may need "tobinary(ToBase64(x))" when updating --->
				<cfreturn "cf_sql_varbinary" />
			</cfcase>
			<cfcase value="number">
				<cfreturn "cf_sql_numeric" />
			</cfcase>
			<cfdefaultcase>
				<!--- 
					this is required because of a bug in cfdbinfo as of RC1 regarding
					and because this function may be missing some types for previously unsupported db types
				  --->
				<cfreturn "cf_sql_varchar" />
			</cfdefaultcase>
		</cfswitch>
	</cffunction>
	
	<cffunction name="translateDataType" hint="I translate the MSSQL data type names into ColdFusion data type names" output="false" returntype="string">
		<cfargument name="typeName" hint="I am the type name to translate" required="yes" type="string" />
		
		<cfswitch expression="#arguments.typeName#">
			<cfcase value="bigint">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="binary">
				<cfreturn "binary" />
			</cfcase>
			<cfcase value="bit">
				<cfreturn "boolean" />
			</cfcase>
			<cfcase value="char">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="datetime">
				<cfreturn "date" />
			</cfcase>
			<cfcase value="decimal">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="float">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="image">
				<cfreturn "binary" />
			</cfcase>
			<cfcase value="int">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="money">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="nchar">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="ntext">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="numeric">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="nvarchar">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="real">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="smalldatetime">
				<cfreturn "date" />
			</cfcase>
			<cfcase value="smallint">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="smallmoney">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="text">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="timestamp">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="tinyint">
				<cfreturn "numeric" />
			</cfcase>
			<cfcase value="uniqueidentifier">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="varbinary">
				<cfreturn "binary" />
			</cfcase>
			<cfcase value="varchar">
				<cfreturn "string" />
			</cfcase>
			<!--- oracle specific --->
			<cfcase value="rowid">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="date">
				<cfreturn "date" />
			</cfcase>
			<cfcase value="timestamp(6)">
				<cfreturn "date" />
			</cfcase>
			<cfcase value="varchar2">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="nvarchar2">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="blob">
				<cfreturn "binary" />
			</cfcase>
			<cfcase value="clob">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="nclob">
				<cfreturn "string" />
			</cfcase>
			<cfcase value="long">
				<cfreturn "string" />
			</cfcase>
		   <cfcase value="long raw">
				<cfreturn "binary" />
			</cfcase>
			<cfcase value="raw">
				<cfreturn "binary" />
			</cfcase>
			<cfcase value="number">
				<cfreturn "numeric" />
			</cfcase>
			<cfdefaultcase>
				<!--- 
					this is required because of a bug in cfdbinfo as of RC1 regarding
					and because this function may be missing some types for previously unsupported db types
				  --->
				<cfreturn "string" />
			</cfdefaultcase>
		</cfswitch>
	</cffunction>
	
	<cffunction name="setTableMetadata" access="public" output="false" returntype="void">
		<cfset var qTable = "" />
		<!--- get table column info --->
		<cfdbinfo datasource="#variables.dsn#" name="qTable" type="columns" table="#variables.table#" />
		<cfset variables.tableMetadata = qTable />
	</cffunction>
	<cffunction name="getTableMetaData" access="public" output="false" returntype="query">
		<cfreturn variables.tableMetadata />
	</cffunction>

	<cffunction name="getTableXML" access="public" output="false" returntype="xml">
		<cfset var xmlTable = "" />
		<!--- convert the table data into an xml format --->
		<!--- added listfirst to the sql_type because identity is sometimes appended --->
		<cfxml variable="xmlTable">
		<!--- NOTE: no way to get identity as of RC1 --->
		<cfoutput>
		<root>
			<bean name="#listLast(variables.componentPath,'.')#" path="#variables.componentPath#">
				<dbtable name="#variables.table#">
				<cfloop query="variables.tableMetadata">
					<column name="#variables.tableMetadata.column_name#"
							type="<cfif variables.tableMetadata.type_name EQ 'char' AND variables.tableMetadata.column_size EQ 35 AND variables.tableMetadata.is_primarykey>uuid<cfelse>#translateDataType(listFirst(variables.tableMetadata.type_name," "))#</cfif>"
							cfSqlType="#translateCfSqlType(listFirst(variables.tableMetadata.type_name," "))#"
							required="#variables.tableMetadata.is_nullable#"
							length="#variables.tableMetadata.column_size#"
							primaryKey="#variables.tableMetadata.is_primarykey#"
							identity="false" />
				</cfloop>
				</dbtable>
			</bean>
		</root>
		</cfoutput>
		</cfxml>
		<cfreturn xmlTable />
	</cffunction>
</cfcomponent>