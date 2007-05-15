<cfcomponent output="false">
	<cfproperty name="path" type="string" required="true" />
	<cfproperty name="parentPath" type="string" required="true" />
	<cfproperty name="hasChildren" type="boolean" required="true" />
	
	<cffunction name="init" access="public" output="false" returntype="directory">
		<cfargument name="path" type="string" required="true" />
		<cfargument name="parentPath" type="string" required="true" />
		<cfargument name="hasChildren" type="boolean" required="true" />
		
		<cfset setPath(arguments.path) />
		<cfset setParentPath(arguments.parentPath) />
		<cfset setHasChildren(arguments.hasChildren) />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setPath" access="public" output="false" returntype="void">
		<cfargument name="path" type="string" required="true" />
		
		<cfset variables.path = arguments.path />
	</cffunction>
	<cffunction name="getPath" access="public" output="false" returntype="string">	
		<cfreturn variables.path />
	</cffunction>
	
	<cffunction name="setParentPath" access="public" output="false" returntype="void">
		<cfargument name="parentPath" type="string" required="true" />
		
		<cfset variables.parentPath = arguments.parentPath />
	</cffunction>
	<cffunction name="getParentPath" access="public" output="false" returntype="string">	
		<cfreturn variables.parentPath />
	</cffunction>
	
	<cffunction name="setHasChildren" access="public" output="false" returntype="void">
		<cfargument name="hasChildren" type="string" required="true" />
		
		<cfset variables.hasChildren = arguments.hasChildren />
	</cffunction>
	<cffunction name="getHasChildren" access="public" output="false" returntype="string">	
		<cfreturn variables.hasChildren />
	</cffunction>
</cfcomponent>