<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"  />
		<xsl:template match="/">
&lt;cfcomponent displayname="<xsl:value-of select="//bean/@name"/>" output="false" extends="transfer.com.TransferDecorator"&gt;
	<xsl:for-each select="root/bean/dbtable/column">&lt;cfproperty name="<xsl:value-of select="@name" />" type="<xsl:value-of select="@type" />" default="" /&gt;
	</xsl:for-each>
	<!-- custom code -->

&lt;/cfcomponent&gt;</xsl:template>
</xsl:stylesheet>