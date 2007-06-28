	<%cffunction name="save" access="public" output="false" returntype="boolean"%>
		<%cfargument name="#root.bean.xmlAttributes.name#" type="#root.bean.xmlAttributes.path#" required="true" /%>
		
		<%cfset var success = false /%>
		<%cfif exists(arguments.#root.bean.xmlAttributes.name#)%>
			<%cfset success = update(arguments.#root.bean.xmlAttributes.name#) /%>
		<%cfelse%>
			<%cfset success = create(arguments.#root.bean.xmlAttributes.name#) /%>
		<%/cfif%>
		
		<%cfreturn success /%>
	<%/cffunction%>