<cfcomponent name="mssql">
	
	<cffunction name="init" access="public" output="false" returntype="mssql">
		<cfset variables.dsn = "" />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getTables" access="public" output="false" returntype="query">
		<cfset var qAllTables = "" />
		
		<cfif not len(variables.dsn)>
			<cfthrow message="you must provide a dsn" />
		</cfif>
		<cfquery name="qAllTables" datasource="#form.dsn#">
			exec sp_tables @table_type="'Table'"
		</cfquery>
		<cfreturn qAllTables />
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
				<cfreturn "cf_sql_date" />
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
		</cfswitch>
	</cffunction>
	
	<cffunction name="setTableMetadata" access="public" output="false" returntype="void">
		<cfset var qTable = "" />
		<!--- get table column info --->
		<!--- This is a modified version of the query in sp_columns --->
		<cfquery name="qTable" datasource="#variables.dsn#">
			SELECT
				TABLE_NAME = convert(sysname,o.name),
				COLUMN_NAME = convert(sysname,c.name),
				convert (sysname,case
					when t.xusertype > 255 then t.name
					else d.TYPE_NAME collate database_default
				end) TYPE_NAME,
				convert(int,case
					when type_name(d.ss_dtype) IN ('numeric','decimal') then	/* decimal/numeric types */
					OdbcPrec(c.xtype,c.length,c.xprec)+2
					else
					isnull(d.length, c.length)
				end) LENGTH,
				NULLABLE = convert(smallint, ColumnProperty (c.id, c.name, 'AllowsNull')),
				IS_NULLABLE = convert(varchar(254),
				substring('NO YES',(ColumnProperty (c.id, c.name, 'AllowsNull')*3)+1,3)),
				CASE
					WHEN columnProperty(object_id('#variables.table#'),convert(sysname,c.name), 'IsIdentity') > 0 THEN 'true'
					ELSE 'false'
				END AS [identity]
			FROM	sysobjects o,
				master.dbo.spt_datatype_info d,
				systypes t,
				syscolumns c
				LEFT OUTER JOIN syscomments m on c.cdefault = m.id
					AND m.colid = 1
			WHERE	o.id = object_id('#variables.table#')
			AND c.id = o.id
			AND t.xtype = d.ss_dtype
			AND c.length = isnull(d.fixlen, c.length)
			AND (o.type not in ('P', 'FN', 'TF', 'IF') OR (o.type in ('TF', 'IF') and c.number = 0))
			AND isnull(d.AUTO_INCREMENT,0) = isnull(ColumnProperty (c.id, c.name, 'IsIdentity'),0)
			AND c.xusertype = t.xusertype
		</cfquery>
		<cfset variables.tableMetadata = qTable />
	</cffunction>
	<cffunction name="getTableMetaData" access="public" output="false" returntype="query">
		<cfreturn variables.tableMetadata />
	</cffunction>
	
	<cffunction name="setPrimaryKeyList" access="public" output="false" returntype="void">
		<cfset var qPrimaryKeys = "" />
		<cfset var lstPrimaryKeys = "" />
		<cfstoredproc datasource="#variables.dsn#" procedure="sp_pkeys">
			<cfprocparam value="#variables.table#" cfsqltype="CF_SQL_VARCHAR" />
			<cfprocresult name="qPrimaryKeys" />
		</cfstoredproc>
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