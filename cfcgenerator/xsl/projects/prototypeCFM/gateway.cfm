<cfoutput>
<%cfcomponent displayname="#root.bean.xmlAttributes.name#Gateway" output="false"%>
	<%cffunction name="init" access="public" output="false" returntype="<xsl:value-of select="//bean/@path"/>Gateway"%>
		<%cfargument name="dsn" type="string" required="true" /%>
		<%cfset variables.dsn = arguments.dsn /%>
		<%cfreturn this /%>
	<%/cffunction%>
	
	<!-- custom code -->

<%/cfcomponent%>
</cfoutput>