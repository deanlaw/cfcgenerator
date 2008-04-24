<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"  />
		<xsl:template match="/">
&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;transfer xsi:noNamespaceSchemaLocation="/transfer/resources/xsd/transfer.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"&gt;
	&lt;objectDefinitions&gt;
		&lt;package name="<xsl:value-of select="//bean/@name"/>"&gt;
			&lt;object name="<xsl:value-of select="//bean/@name"/>" table="<xsl:value-of select="//dbtable/@name" />" decorator="<xsl:value-of select="//bean/@path"/>"&gt;
				<xsl:for-each select="root/bean/dbtable/column[@primaryKey='Yes']">&lt;id name="<xsl:value-of select="@name" />" type="<xsl:value-of select="@type" />" /&gt;
				</xsl:for-each>
				<xsl:for-each select="root/bean/dbtable/column[@primaryKey!='Yes']">&lt;property name="<xsl:value-of select="@name" />" type="<xsl:value-of select="@type" />" column="<xsl:value-of select="@name" />" nullable="<xsl:choose><xsl:when test="@required='No'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose>" /&gt;
			</xsl:for-each>&lt;/object&gt;
		&lt;/package&gt;
	&lt;/objectDefinitions&gt;
&lt;/transfer&gt;</xsl:template>
</xsl:stylesheet>