<cfcomponent name="codeService">
	<cffunction name="init" access="public" output="false" returntype="codeService">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="configure" access="public" output="false" returntype="void">
		<cfargument name="dsn" required="true" type="cfcgenerator.com.cf.datasource.datasource" />
		<cfargument name="basePath" required="true" type="string" />
		<cfargument name="projectPath" type="string" required="no" default="" />
		<cfargument name="rootPath" required="no" type="string" default="" />
		
		<cfset var separator = getOSFileSeparator() />
		<cfset variables.basePath = expandPath(arguments.basePath) />
		<cfset variables.dsn = arguments.dsn />
		<cfset variables.projectPath = variables.basePath & 'projects' & separator & arguments.projectPath & separator />
		<cfif len(arguments.rootPath)>
			<cfset variables.rootPath = arguments.rootPath />
		<cfelse>
			<cfset variables.rootPath = "" />
		</cfif>
		<cfset readConfig() />
	</cffunction>
	
	<cffunction name="getTableXML" access="public" output="false" returntype="xml">
		<cfargument name="table" required="true" type="cfcgenerator.com.cf.datasource.table.table" />
		<cfset var xmlTable = "" />
		<cfset var columns = table.getColumns() />
		<cfset var i = 0 />
		<cfset column = "" />
		
		<!--- convert the table data into an xml format --->
		<!--- added listfirst to the sql_type because identity is sometimes appended --->
		<cfxml variable="xmlTable">
		<cfoutput>
		<root>
			<bean name="#listLast(variables.rootPath,'.')#" path="#variables.rootPath#">
				<dbtable name="#arguments.table.getTableName()#">
				<cfloop from="1" to="#arrayLen(columns)#" index="i">
					<cfset column = columns[i]>
					<cfif not column.getIgnore()>
					<column name="#column.getColumnName()#"
							alias="#column.getAlias()#"
							type="<cfif column.getTypeName() EQ 'char' AND column.getLength() EQ 35 AND column.getPrimaryKey()>uuid<cfelse>#translateDataType(listFirst(column.getTypeName()," "))#</cfif>"
							cfSqlType="#translateCfSqlType(listFirst(column.getTypeName()," "))#"
							required="#column.getNullable()#"
							length="#column.getLength()#"
							primaryKey="#column.getPrimaryKey()#"
							identity="#column.getIdentity()#" />
					</cfif>
				</cfloop>
				</dbtable>
			</bean>
		</root>
		</cfoutput>
		</cfxml>
		<cfreturn xmlTable />
	</cffunction>
	
	<cffunction name="getComponents" access="public" output="false" returntype="cfcgenerator.com.cf.code.generatedPage[]">
		<cfargument name="table" required="true" type="cfcgenerator.com.cf.datasource.table.table" />
		
		<cfset var i = 0 />
		<cfset var template = "" />
		<cfset var name = "" />
		<cfset var filename = "" />
		<cfset var content = "" />
		<cfset var thisRootPath = "" />
		<cfset var objPage = "" />
		<cfset var arrComponents = arrayNew(1) />
		<cfset var xmlTable = getTableXML(arguments.table) />
		
		<!--- loop through cfc types --->
		<cfloop from="1" to="#arrayLen(variables.config.generator.xmlChildren)#" index="i">
			<cfset template = buildTemplate(variables.config.generator.xmlChildren[i]) />
			<cfset name = variables.config.generator.xmlChildren[i].xmlName />
			<cfif structKeyExists(variables.config.generator.xmlChildren[i].xmlAttributes,"templateType") and variables.config.generator.xmlChildren[i].xmlAttributes.templateType eq "cfm">
				<cfset content = processCFMTemplate(template,xmlTable) />
			<cfelse>
				<cfset content = xmlTransform(xmlTable,template) />
			</cfif>
			<cfset thisRootPath = "" />
			<cfif len(variables.rootPath) and structKeyExists(variables.config.generator.xmlChildren[i].xmlAttributes,"fileType")>
				<!--- if text to append to file name is specified use it otherwise default to the object type name --->
				<cfif structKeyExists(variables.config.generator.xmlChildren[i].xmlAttributes,"fileNameAppend")>
					<cfset thisRootPath = variables.rootPath & variables.config.generator.xmlChildren[i].xmlAttributes.fileNameAppend & "." & variables.config.generator.xmlChildren[i].xmlAttributes.fileType  />
				<cfelse>
					<cfset thisRootPath = variables.rootPath & ucase(left(name,1)) & right(name,len(name)-1) & "." & variables.config.generator.xmlChildren[i].xmlAttributes.fileType  />
				</cfif>
			</cfif>
			<cfset objPage = createObject("component","cfcgenerator.com.cf.code.generatedPage").init(name,template,content,thisRootPath) />
			<cfset arrayAppend(arrComponents,objPage) />
		</cfloop>
		
		<cfreturn arrComponents />
	</cffunction>
	
	<cffunction name="processCFMTemplate" access="private" output="false" returntype="string">
		<cfargument name="template" type="string" required="true" />
		<cfargument name="xmlTable" required="true" type="xml" />
		
		<cfset var content = "" />
		<cfset var root = arguments.xmlTable.root />
		<cfset var tempFilePath = '../../../temp/#createUUID()#.cfm' />
		
		<cfif not directoryExists(expandPath('../../../temp/'))>
			<cfdirectory action="create" directory="#expandPath('../../../temp')#">
		</cfif>
		
		<!--- write the cfm to a hard file so it can be dynamically evaluated --->
		<cffile action="write" file="#expandPath(tempFilePath)#" output="#arguments.template#" />
		<cfsavecontent variable="content">
			<!--- workaround - looks like there is a bug in 7.0.2 multi-server (may be mac only) --->
			<cfif getBaseTemplatePath() eq getCurrentTemplatePath()>
				<cfinclude template="../com/#tempFilePath#" />
			<cfelse>
				<cfinclude template="../#tempFilePath#" />
			</cfif>
		</cfsavecontent>
		<cfset content =  replaceList(content,"%%,<%,%>,%","[PERCENT],<,>,##") />
		<cfset content = replaceList(content,"[PERCENT]","%") />
		<cffile action="delete" file="#expandPath(tempFilePath)#" />
		
		<cfreturn content />
	</cffunction>
	
	<cffunction name="readConfig" access="private" output="false" returntype="void">		
		<cfset var configXML = "" />
		
		<cfif fileExists(variables.projectPath & "yac.xml")>
			<cfset variables.usePath = variables.projectPath />
			<cffile action="read" file="#variables.projectPath & 'yac.xml'#" variable="configXML" charset="utf-8" />
		<cfelse>
			<cfset variables.usePath = variables.basePath />
			<cffile action="read" file="#variables.basePath & 'yac.xml'#" variable="configXML" charset="utf-8" />
		</cfif>
		<cfset variables.config = xmlParse(configXML) />
	</cffunction>
	
	<cffunction name="buildTemplate" access="private" output="false" returntype="string">
		<cfargument name="typeXML" required="true" type="xml" />
		
		<cfset var returnTemplate = "" />
		<cfset var innerTemplate = "" />
		<cfset var tmpTemplate = "" />
		<cfset var i = 0 />
		<cfset var separator = getOSFileSeparator() />
		<cfset var templateType = "xsl" />
		
		<cfif structKeyExists(typeXML.xmlAttributes,"templateType")>
			<cfset templateType = typeXML.xmlAttributes.templateType />
		</cfif>
		
		<!--- loop through each include and append it to the inner XSL/CFML --->
		<cfloop from="1" to="#arrayLen(arguments.typeXML.xmlChildren)#" index="i">
			<cffile action="read" file="#variables.usePath & arguments.typeXML.xmlName & separator & arguments.typeXML.xmlChildren[i].xmlAttributes.file#" variable="tmpTemplate" charset="utf-8" />
			<cfset innerTemplate = innerTemplate & chr(13) & chr(13) & tmpTemplate />
		</cfloop>
		<!--- read the base template --->
		<cffile action="read" file="#variables.usePath & arguments.typeXML.xmlName & '.' & templateType#" variable="tmpTemplate" charset="utf-8" />
		<cfset returnTemplate = replaceNoCase(trim(tmpTemplate),"<!-- custom code -->",trim(innerTemplate)) />
		<cfreturn trim(returnTemplate) />
	</cffunction>
	
	<!--- code supplied by Luis Majano --->
	<cffunction name="getOSFileSeparator" access="public" returntype="any" output="false" hint="Get the operating system's file separator character">
        <cfscript>
        var objFile =  createObject("java","java.lang.System");
        return objFile.getProperty("file.separator");
        </cfscript>
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
</cfcomponent>