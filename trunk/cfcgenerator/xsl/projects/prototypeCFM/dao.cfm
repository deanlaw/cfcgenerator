<cfoutput>
<%cfcomponent displayname="#root.bean.xmlAttributes.name#DAO" hint="table ID column = <xsl:for-each select="root/bean/dbtable/column[@primaryKey='Yes']"><xsl:value-of select="@name" /><xsl:if test="position() != last()">,</xsl:if></xsl:for-each>"%>

	<%cffunction name="init" access="public" output="false" returntype="#root.bean.xmlAttributes.path#DAO"%>
		<%cfargument name="dsn" type="string" required="true"%>
		<%cfset variables.dsn = arguments.dsn%>
		<%cfreturn this%>
	<%/cffunction%>
	
	<!-- custom code -->

<%/cfcomponent%>
</cfoutput>