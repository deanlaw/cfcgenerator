<cfcomponent name="datasource" displayname="datasource" hint="a datasource bean">
	<cfproperty name="dsnName" type="string" required="false" default="" />
	<cfproperty name="dsnType" type="string" required="false" default="" />
	
	<cffunction name="init" access="public" output="false" returntype="cfcgenerator.com.cf.model.datasource.datasource">
		<cfargument name="dsnName" type="string" required="false" default="" />
		<cfargument name="dsnType" type="string" required="false" default="" />
		
		<cfset setDsnName(arguments.dsnName) />
		<cfset setDsnType(arguments.dsnType) />
		<cfset setDbms() />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setDsnName" access="public" output="false" returntype="void">
		<cfargument name="dsnName" type="string" required="false" default="" />
		
		<cfset variables.dsnName = arguments.dsnName />
	</cffunction>
	<cffunction name="getDsnName" access="public" output="false" returntype="string">
		<cfreturn variables.dsnName />
	</cffunction>
	
	<cffunction name="setDsnType" access="public" output="false" returntype="void">
		<cfargument name="dsnType" type="string" required="false" default="" />
		
		<cfset variables.dsnType = arguments.dsnType />
	</cffunction>
	<cffunction name="getDsnType" access="public" output="false" returntype="string">
		<cfreturn variables.dsnType />
	</cffunction>
	
	<cffunction name="setDbms" access="public" output="false" returntype="void">
		<cfset variables.dbms = createObject("component","cfcgenerator.com.cf.model.datasource.#dsntype#").init(getDsnName()) />
	</cffunction>
	<cffunction name="getDbms" access="public" output="false" returntype="any">
		<cfreturn variables.dbms />
	</cffunction>
</cfcomponent>