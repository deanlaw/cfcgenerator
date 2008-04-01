<cfset xslBasePath = "/cfcgenerator/xsl/" />
<cfset generatorService = createObject("component","cfcgenerator.com.cf.generatorService").init(xslBasePath) />
<cfset loggedIn = generatorService.setAdminPassword("password")>

<cfif loggedIn>
	<cfparam name="url.showDSN" default="1" />
	<cfset dsns = generatorService.getDSNs() />
	<cfoutput>
		#dsns[url.showDSN].getDsnName()# : #dsns[url.showDSN].getDsnType()#<br />
		<cfset tables = generatorService.getTables(dsns[url.showDSN]) />
		<cfloop from="1" to="#arrayLen(tables)#" index="i">
			#tables[i].getTableName()#<br />
			<cfif i eq 1>
				<cfset table = generatorService.getColumns(dsns[url.showDSN],tables[i])>
				<cfset columns = table.getColumns() />
				<cfloop from="1" to="#arrayLen(columns)#" index="z">
					- #columns[z].getColumnName()# : #columns[z].getPrimaryKey()#<br />
				</cfloop>
			</cfif>
		</cfloop>
	</cfoutput>
<cfelse>
	failed.
</cfif>

<cfset tablesToGenerate = arrayNew(1) />
<cfset tablesToGenerate[1] = table />
<cfset tablesToGenerate[2] = tables[2] />
<cfset code = generatorService.generate(dsns[url.showDSN],tablesToGenerate,"","","/xsl/") />
<cfdump var="#code[table.getTableName()][1].getContent()#">