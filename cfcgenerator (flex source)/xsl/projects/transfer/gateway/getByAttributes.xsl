	&lt;cffunction name="getByAttributes" access="public" output="false" returntype="array"&gt;
		<xsl:for-each select="root/bean/dbtable/column">&lt;cfargument name="<xsl:value-of select="@name" />" type="<xsl:value-of select="@type" />" required="false" /&gt;
		</xsl:for-each>&lt;cfargument name="orderby" type="string" required="false" /&gt;
		
		&lt;cfset var qList = getByAttributesQuery(argumentCollection=arguments) /&gt;		
		&lt;cfset var arrObjects = arrayNew(1) /&gt;
		&lt;cfset var tmpObj = "" /&gt;
		&lt;cfset var i = 0 /&gt;
		&lt;cfloop from="1" to="#qList.recordCount#" index="i"&gt;
			&lt;cfset tmpObj = variables.transfer.get("<xsl:value-of select="//bean/@name"/>.<xsl:value-of select="//bean/@name"/>",qList.<xsl:for-each select="root/bean/dbtable/column[@primaryKey='Yes']"><xsl:value-of select="@name" /></xsl:for-each>[i]) /&gt;
			&lt;cfset arrayAppend(arrObjects,tmpObj) /&gt;
		&lt;/cfloop&gt;
				
		&lt;cfreturn arrObjects /&gt;
	&lt;/cffunction&gt;