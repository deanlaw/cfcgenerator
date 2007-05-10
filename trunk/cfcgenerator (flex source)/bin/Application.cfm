<cfapplication name="cfcgenerator" />
<cfparam name="application.inited" default="false" />
<cfparam name="url.reload" default="false" />
<cfif not application.inited or url.reload>
	<cfset xslBasePath = "/cfcgenerator/xsl/" />
	<cfset application.generatorService = createObject("component","cfcgenerator.com.cf.model.generatorService").init(xslBasePath) />
	<cfset application.inited = true />
</cfif>