	&lt;cffunction name="save<xsl:value-of select="//bean/@name"/>" access="public" output="false" returntype="void"&gt;
		&lt;cfargument name="<xsl:value-of select="//bean/@name"/>" type="<xsl:value-of select="//bean/@path"/>" required="true" /&gt;
		
		&lt;cfset variables.transfer.save(arguments.<xsl:value-of select="//bean/@name"/>) /&gt;
	&lt;/cffunction&gt;