	&lt;cffunction name="getByAttributesQuery" access="public" output="false" returntype="query"&gt;
		<xsl:for-each select="root/bean/dbtable/column">&lt;cfargument name="<xsl:value-of select="@name" />" type="<xsl:value-of select="@type" />" required="false" /&gt;
		</xsl:for-each>&lt;cfargument name="orderby" type="string" required="false" default="<xsl:value-of select="//bean/@name"/>.<xsl:for-each select="root/bean/dbtable/column[@primaryKey='Yes']"><xsl:value-of select="@name" /></xsl:for-each>" /&gt;
		
		&lt;cfset var qList = "" /&gt;
		&lt;cfset var tQuery = "" /&gt;	
		&lt;cfsavecontent variable="qList"&gt;
		&lt;cfoutput&gt;
			FROM		<xsl:value-of select="//bean/@name"/>.<xsl:value-of select="//bean/@name"/> AS <xsl:value-of select="//bean/@name"/>
			WHERE		<xsl:value-of select="//bean/@name"/>.<xsl:for-each select="root/bean/dbtable/column[@primaryKey='Yes']"><xsl:value-of select="@name" /></xsl:for-each> IS NOT NULL
		<xsl:for-each select="root/bean/dbtable/column">&lt;cfif structKeyExists(arguments,"<xsl:value-of select="@name" />") and len(arguments.<xsl:value-of select="@name" />)&gt;
			AND		<xsl:value-of select="//bean/@name"/>.<xsl:value-of select="@name" /> = :<xsl:value-of select="@name" />
		&lt;/cfif&gt;</xsl:for-each>
		&lt;cfif structKeyExists(arguments, "orderby") and len(arguments.orderBy)&gt;
			ORDER BY #arguments.orderby#
		&lt;/cfif&gt;
		&lt;/cfoutput&gt;
		&lt;/cfsavecontent&gt;
		&lt;cfset tQuery = variables.transfer.createQuery(qList) /&gt;
		<xsl:for-each select="root/bean/dbtable/column">&lt;cfif structKeyExists(arguments,"<xsl:value-of select="@name" />") and len(arguments.<xsl:value-of select="@name" />)&gt;
			&lt;cfset tQuery.setParam("<xsl:value-of select="@name" />",arguments.<xsl:value-of select="@name" />) /&gt;
		&lt;/cfif&gt;
		</xsl:for-each>
		&lt;cfreturn variables.transfer.listByQuery(tQuery) /&gt;
	&lt;/cffunction&gt;