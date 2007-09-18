<cfcomponent name="adminAPIFacade" output="false" hint="a wrapper for admiapi functions">
	<cffunction name="init" access="public" output="false" returntype="adminAPIFacade">
		<cfargument name="administratorPassword" type="string" required="true" />
		
		<cfset variables.administrator = createObject("component","cfide.adminapi.administrator").login(arguments.administratorPassword) />
		<cfset variables.datasource = createObject("component","cfide.adminapi.datasource") />
		<cfset variables.arrDSNs = arrayNew(1) />
		<cfset setDatasources() />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="setDatasources" access="public" output="false" returntype="void">
		<cfset var dsns = variables.datasource.getdatasources() />
		<cfset var objDatasource = "" />
		<cfset var thisDSN = "" />
		<cfset var thisType = "" />
		<cfset var sortedDSNs = structSort(dsns,"textnocase","asc","name") />
		<cfset var i = 0 />
		<cfloop from="1" to="#arrayLen(sortedDSNs)#" index="i">
			<cfset thisDSN = sortedDSNs[i] />
			<cfset thisType = driverOrClassToType(dsns[thisDSN]) />
			<cfif len(thisType)>
				<cfset objDatasource = createObject("component","cfcgenerator.com.cf.model.datasource.datasource").init(dsns[thisDSN].name,thisType,dsns[thisDSN].driver) />
				<cfset arrayAppend(variables.arrDSNs,objDatasource) />
			</cfif>
		</cfloop>
	</cffunction>
	<cffunction name="getDatasources" access="public" output="false" returntype="array">
		<cfreturn variables.arrDSNs />
	</cffunction>
	<cffunction name="getDatasource" access="public" output="false" returntype="cfcgenerator.com.cf.model.datasource.datasource">
		<cfargument name="datasource" type="string" required="true" />
		<cfset var returnDSN = "" />
		<cfset var i = 0 />
		<cfloop from="1" to="#arrayLen(variables.arrDSNs)#" index="i">
			<cfif variables.arrDSNs[i].getDsnName() EQ arguments.datasource>
				<cfset returnDSN = variables.arrDSNs[i] />
			</cfif>
		</cfloop>
		<cfreturn returnDSN />
	</cffunction>
	
	<cffunction name="driverOrClassToType" access="private" output="false" returntype="string">
		<cfargument name="datasource" required="true" type="struct" />
		
		<cfif ((arguments.datasource.driver eq "MSSQLServer")  or (arguments.datasource.class contains "MSSQLServer"))>
			<cfreturn "mssql" />
		<cfelseif ((arguments.datasource.driver contains "mySQL") or (arguments.datasource.class contains "mySQL"))>
			<cfreturn "mysql" />
		<cfelseif ((arguments.datasource.driver contains "Oracle") or (arguments.datasource.class contains "Oracle"))>
			<cfreturn "oracle" />
		<cfelseif ((arguments.datasource.driver contains "Informix") or (arguments.datasource.class contains "Informix"))>
			<cfreturn "informix" />
		<cfelseif ((arguments.datasource.driver contains "Postgres") or (arguments.datasource.class contains "postgresql"))>
			<cfreturn "postgresql" />
		<!--- if you are running cf8 we can try to leverage db metadata tags --->
		<cfelseif listFirst(server.coldfusion.ProductVersion) gte 8 and arguments.datasource.driver neq "MSAccess"><!--- only access with unicode seems to work with dbinfo --->
			<cfreturn "scorpio" />
		<cfelse><!--- not a supported type --->
			<cfreturn "" />
		</cfif>
	</cffunction>
	
</cfcomponent>