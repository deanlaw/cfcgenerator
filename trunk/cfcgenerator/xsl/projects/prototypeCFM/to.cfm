<cfoutput>
<%cfcomponent displayname="#root.bean.xmlAttributes.name#TO" output="false"%>

	<%cffunction name="init" access="public" returntype="#root.bean.xmlAttributes.path#TO" output="false"%>
		<cfloop from="1" to="#arrayLen(root.bean.dbtable.xmlChildren)#" index="i"><%cfargument name="#root.bean.dbtable.xmlChildren[i].xmlAttributes.name#" type="#root.bean.dbtable.xmlChildren[i].xmlAttributes.type#" required="false" <cfif root.bean.dbtable.xmlChildren[i].xmlAttributes.type eq "uuid">default="%createUUID()%"</cfif> /%>
		</cfloop>
		<cfloop from="1" to="#arrayLen(root.bean.dbtable.xmlChildren)#" index="i">
		<%cfset this.#root.bean.dbtable.xmlChildren[i].xmlAttributes.name# = arguments.#root.bean.dbtable.xmlChildren[i].xmlAttributes.name# /%></cfloop>
		
		<%cfreturn this /%>
	<%/cffunction%>
<%cfcomponent%>
</cfoutput>