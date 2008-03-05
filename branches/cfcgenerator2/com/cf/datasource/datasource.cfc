<cfcomponent name="datasource" displayname="datasource" hint="a datasource bean">
	<cfproperty name="dsnName" type="string" required="false" default="" />
	<cfproperty name="dsnType" type="string" required="false" default="" />
	
	<cffunction name="init" access="public" output="false" returntype="cfcgenerator.com.cf.datasource.datasource">
		<cfargument name="dsnName" type="string" required="false" default="" />
		<cfargument name="dsnType" type="string" required="false" default="" />
		
		<cfset setDsnName(arguments.dsnName) />
		<cfset setDsnType(arguments.dsnType) />
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
</cfcomponent>