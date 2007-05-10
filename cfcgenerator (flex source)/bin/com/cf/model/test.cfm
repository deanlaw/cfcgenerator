<cfset loggedIn = application.generatorService.setAdminPassword("password")>

<cfif loggedIn>
	<cfset dsns = application.generatorService.getDsns() />
	
	<cfdump var="#dsns#">
	
	<cfif arrayLen(dsns)>
		<cfset tables = application.generatorService.getTables(dsns[1].getDsnName()) />
		<cfdump var="#tables#">
	</cfif>
<cfelse>
	failed.
</cfif>