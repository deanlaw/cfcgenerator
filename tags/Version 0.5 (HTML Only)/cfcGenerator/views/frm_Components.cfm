<cfset dbType = event.getArg("dbType") />
<cfset tables = event.getArg("tables") />

<cfparam name="form.table" default="" />
<cfparam name="form.componentPath" default="" />
<cfparam name="form.generateService" default="0" />
<cfparam name="form.generateTO" default="0" />
<cfparam name="form.generateColdspringXML" default="0" />

<cfoutput>
<cfform action="index.cfm?event=com.display" method="post" format="xml" skin="lightgray">
	<cfinput type="hidden" name="dbtype" value="#dbtype#" />
	<cfinput type="hidden" name="dsn" value="#form.dsn#" />
	<cfformitem type="html">DSN: #form.dsn# (<a href="index.cfm">click to change</a>)</cfformitem>
	<cfinput type="text" name="componentPath" label="Component Path:" size="50" required="true" value="#form.componentPath#" />
	<cfselect name="table" label="Choose a table" selected="#form.table#">
		<cfloop query="tables">
			<option value="#tables.table_name#">#tables.table_name#</option>
		</cfloop>
	</cfselect>
	<!--- <cfinput type="checkbox" name="generateService" value="1" label="Generate Service" checked="#yesNoFormat(form.generateService)#" />
	<cfinput type="checkbox" name="generateTO" value="1" label="Generate Transfer Object" checked="#yesNoFormat(form.generateTO)#" />
	<cfinput type="checkbox" name="generateColdspringXML" value="1" label="Generate ColdSpring XML Snippet" checked="#yesNoFormat(form.generateColdspringXML)#" /> --->
	<cfinput type="submit" name="submitted" value="continue" />
</cfform>
</cfoutput>