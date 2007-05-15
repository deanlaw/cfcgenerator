<cfset directoryService = createObject("component","FileExplorer.com.cf.model.directoryService").init() />

<cfif structKeyExists(url,"viewDir")>
	<cfset directories = directoryService.getDirectories(url.viewDir) />
<cfelse>
	<cfset directories = directoryService.getRoots() />
</cfif>

<cfoutput>
<cfloop from="1" to="#arrayLen(directories)#" index="i">
	<cfif directories[i].getHasChildren()><a href="#CGI.SCRIPT_NAME#?viewDir=#directories[i].getPath()#"></cfif>#directories[i].getPath()#<cfif directories[i].getHasChildren()></a></cfif><br />
</cfloop>
</cfoutput>