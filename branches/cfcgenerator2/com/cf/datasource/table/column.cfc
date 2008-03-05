<cfcomponent name="table" displayname="table" hint="a table bean">
	<cfproperty name="columnName" type="string" required="false" default="" />
	<cfproperty name="nullable" type="boolean" required="false" default="true" />
	<cfproperty name="typeName" type="string" required="false" default="" />
	<cfproperty name="length" type="numeric" required="false" default="0" />
	<cfproperty name="identity" type="boolean" required="false" default="false" />
	<cfproperty name="primaryKey" type="boolean" required="false" default="false" />
	<cfproperty name="alias" type="string" required="false" default="" />
	<cfproperty name="ignore" type="boolean" required="false" default="false" />
	
	<cffunction name="init" access="public" output="false" returntype="column">
		<cfargument name="columnName" type="string" required="false" default="" />
		<cfargument name="nullable" type="boolean" required="false" default="true" />
		<cfargument name="typeName" type="string" required="false" default="" />
		<cfargument name="length" type="numeric" required="false" default="0" />
		<cfargument name="identity" type="boolean" required="false" default="false" />
		<cfargument name="primaryKey" type="boolean" required="false" default="false" />
		<cfargument name="alias" type="string" required="false" default="" />
		<cfargument name="ignore" type="boolean" required="false" default="false" />
		
		<cfset setColumnName(arguments.columnName) />
		<cfset setAlias(arguments.alias) />
		<cfset setNullable(arguments.nullable) />
		<cfset setTypeName(arguments.typeName) />
		<cfset setLength(arguments.length) />
		<cfset setIdentity(arguments.identity) />
		<cfset setPrimaryKey(arguments.primaryKey) />
		<cfset setAlias(arguments.alias) />
		<cfset setIgnore(arguments.ignore) />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setColumnName" access="public" output="false" returntype="void">
		<cfargument name="columnName" type="string" required="false" default="" />
		
		<cfset variables.columnName = arguments.columnName />
	</cffunction>
	<cffunction name="getColumnName" access="public" output="false" returntype="string">
		<cfreturn variables.columnName />
	</cffunction>
	
	<cffunction name="setNullable" access="public" output="false" returntype="void">
		<cfargument name="nullable" type="boolean" required="false" default="true" />
		
		<cfset variables.nullable = yesNoFormat(arguments.nullable) />
	</cffunction>
	<cffunction name="getNullable" access="public" output="false" returntype="boolean">
		<cfreturn variables.nullable />
	</cffunction>
	
	<cffunction name="setTypeName" access="public" output="false" returntype="void">
		<cfargument name="typeName" type="string" required="false" default="" />
		
		<cfset variables.typeName = arguments.typeName />
	</cffunction>
	<cffunction name="getTypeName" access="public" output="false" returntype="string">
		<cfreturn variables.typeName />
	</cffunction>
	
	<cffunction name="setLength" access="public" output="false" returntype="void">
		<cfargument name="length" type="numeric" required="false" default="0" />
		
		<cfset variables.length = arguments.length />
	</cffunction>
	<cffunction name="getLength" access="public" output="false" returntype="numeric">
		<cfreturn variables.length />
	</cffunction>
	
	<cffunction name="setIdentity" access="public" output="false" returntype="void">
		<cfargument name="identity" type="boolean" required="false" default="true" />
		
		<cfset variables.identity = yesNoFormat(arguments.identity) />
	</cffunction>
	<cffunction name="getIdentity" access="public" output="false" returntype="boolean">
		<cfreturn variables.identity />
	</cffunction>
	
	<cffunction name="setPrimaryKey" access="public" output="false" returntype="void">
		<cfargument name="primaryKey" type="boolean" required="false" default="true" />
		
		<cfset variables.primaryKey = yesNoFormat(arguments.primaryKey) />
	</cffunction>
	<cffunction name="getPrimaryKey" access="public" output="false" returntype="boolean">
		<cfreturn variables.primaryKey />
	</cffunction>
	
	<cffunction name="setAlias" access="public" output="false" returntype="void">
		<cfargument name="alias" type="string" required="false" default="" />
		
		<cfset variables.alias = arguments.alias />
	</cffunction>
	<cffunction name="getAlias" access="public" output="false" returntype="string">
		<cfreturn variables.alias />
	</cffunction>
	
	<cffunction name="setIgnore" access="public" output="false" returntype="void">
		<cfargument name="ignore" type="boolean" required="false" default="true" />
		
		<cfset variables.ignore = yesNoFormat(arguments.ignore) />
	</cffunction>
	<cffunction name="getIgnore" access="public" output="false" returntype="boolean">
		<cfreturn variables.ignore />
	</cffunction>
</cfcomponent>