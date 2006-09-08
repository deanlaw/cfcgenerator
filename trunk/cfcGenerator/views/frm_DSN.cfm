<cfset dsns = event.getArg("DSNs") />

<cfif isStruct(dsns)>
<cfoutput>
<cfform action="index.cfm?event=com.form" method="post" format="xml" skin="lightgray">
	<cfselect name="dsn" label="Choose a datasource">
		<cfloop collection="#DSNs#" item="ds">
		<!--- only mssql or mysql for now --->
		<cfif ((DSNs[ds].driver eq "MSSQLServer")  or (DSNs[ds].class contains "MSSQLServer")) or ((DSNs[ds].driver contains "mySQL") or (DSNs[ds].class contains "mySQL"))>
			<option value="#ds#">#DSNs[ds].name#</option>
		</cfif>
		</cfloop>
	</cfselect>
	<cfinput type="submit" name="submitted" value="continue" />
</cfform>
</cfoutput>
<cfelse>
<p>You have no MySQL or MSSQL DSNs.</p>
</cfif>