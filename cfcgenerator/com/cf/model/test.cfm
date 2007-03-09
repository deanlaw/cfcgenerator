<cfset dsns = application.generatorService.getDsns() />

<cfdump var="#dsns#">

<cfif arrayLen(dsns)>
	<cfset tables = application.generatorService.getTables(dsns[1].getDsnName()) />
	<cfdump var="#tables#">
</cfif>