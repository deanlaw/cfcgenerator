<cfcomponent output="false">
	<cffunction name="getRoots" access="remote" output="false" returntype="array">
		<cfreturn application.directoryService.getRoots() />
	</cffunction>
	
	<cffunction name="getDirectories" access="remote" output="false" returntype="array">
		<cfargument name="baseDirectory" type="string" required="true" />
		
		<cfreturn application.directoryService.getDirectories(arguments.baseDirectory) />
	</cffunction>
</cfcomponent>