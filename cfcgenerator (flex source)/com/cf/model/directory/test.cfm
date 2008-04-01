<cfset directoryService = createObject("component","cfcgenerator.com.cf.directory.directoryService").init() />

<cfif structKeyExists(url,"viewDir")>
	<cfset directories = directoryService.getDirectories(url.viewDir) />
<cfelse>
	<cfset directories = directoryService.getRoots() />
</cfif>

<cfoutput>
<cfloop from="1" to="#arrayLen(directories)#" index="i">
	<cfif directories[i].getHasChildren()><a href="#CGI.SCRIPT_NAME#?viewDir=#directories[i].getPath()#"></cfif>#directories[i].getDirectoryName()#<cfif directories[i].getHasChildren()></a></cfif><br />
</cfloop>
</cfoutput>