	<%cffunction name="get#root.bean.xmlAttributes.name#s" access="public" output="false" returntype="array"%>
		<cfloop from="1" to="#arrayLen(root.bean.dbtable.xmlChildren)#" index="i"><%cfargument name="#root.bean.dbtable.xmlChildren[i].xmlAttributes.name#" type="#root.bean.dbtable.xmlChildren[i].xmlAttributes.type#" required="false" /%>
		</cfloop>
		<%cfreturn variables.#root.bean.xmlAttributes.name#Gateway.getByAttributes(argumentCollection=arguments) /%>
	<%/cffunction%>