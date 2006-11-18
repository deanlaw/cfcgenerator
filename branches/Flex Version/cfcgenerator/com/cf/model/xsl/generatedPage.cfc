<cfcomponent name="generatedPage" displayname="generated page" hint="a generated page bean">
	<cfproperty name="pageName" type="string" required="false" default="" />
	<cfproperty name="xsl" type="string" required="false" default="" />
	<cfproperty name="content" type="string" required="false" default="" />
	
	<cffunction name="init" access="public" output="false" returntype="generatedPage">
		<cfargument name="pageName" type="string" required="false" default="" />
		<cfargument name="xsl" type="string" required="false" default="" />
		<cfargument name="content" type="string" required="false" default="" />
		
		<cfset setPageName(arguments.pageName) />
		<cfset setXsl(arguments.xsl) />
		<cfset setContent(arguments.content) />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setPageName" access="public" output="false" returntype="void">
		<cfargument name="pageName" type="string" required="false" default="" />
		
		<cfset variables.pageName = arguments.pageName />
	</cffunction>
	<cffunction name="getPageName" access="public" output="false" returntype="string">
		<cfreturn variables.pageName />
	</cffunction>
	
	<cffunction name="setXsl" access="public" output="false" returntype="void">
		<cfargument name="xsl" type="string" required="false" default="" />
		
		<cfset variables.xsl = arguments.xsl />
	</cffunction>
	<cffunction name="getXsl" access="public" output="false" returntype="string">
		<cfreturn variables.xsl />
	</cffunction>
	
	<cffunction name="setContent" access="public" output="false" returntype="void">
		<cfargument name="content" type="string" required="false" default="" />
		
		<cfset variables.content = arguments.content />
	</cffunction>
	<cffunction name="getContent" access="public" output="false" returntype="string">
		<cfreturn variables.content />
	</cffunction>
</cfcomponent>