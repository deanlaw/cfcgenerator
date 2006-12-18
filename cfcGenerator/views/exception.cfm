<cfset variables.exception = event.getArg("exception") />

<h3>Mach-II Exception</h3>

<cfoutput>
<table>
	<tr>
		<td valign="top"><strong>Message</strong></td>
		<td valign="top">#variables.exception.getMessage()#</td>
	</tr>
	<tr>
		<td valign="top"><strong>Detail</strong></td>
		<td valign="top">#variables.exception.getDetail()#</td>
	</tr>
	<tr>
		<td valign="top"><strong>Extended Info</strong></td>
		<td valign="top">#variables.exception.getExtendedInfo()#</td>
	</tr>
	<tr>
		<td valign="top"><strong>Tag Context</strong></td>
		<td valign="top">
			<cfset variables.tagCtxArr = variables.exception.getTagContext() />
			<cfloop index="i" from="1" to="#ArrayLen(variables.tagCtxArr)#">
				<cfset variables.tagCtx = variables.tagCtxArr[i] />
				#variables.tagCtx['template']# (#variables.tagCtx['line']#)<br>
			</cfloop>
		</td>
	</tr>
</table>
</cfoutput>