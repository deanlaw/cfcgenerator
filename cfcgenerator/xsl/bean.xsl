<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"  />
		<xsl:template match="/">
&lt;cfcomponent displayname="<xsl:value-of select="//bean/@name"/>" output="false" accessors="true"&gt;
		<xsl:for-each select="root/bean/dbtable/column">&lt;cfproperty name="<xsl:value-of select="@name" />" type="<xsl:value-of select="@type" />" validate="<xsl:value-of select="@type" />" <xsl:choose><xsl:when test="@type='numeric'">validateparams="{min=0}" default="0"</xsl:when><xsl:when test="@type='binary'">validateparams="{min=0,max=1}" default="0"</xsl:when><xsl:when test="@type='string'">validateparams="maxLength=<xsl:value-of select="@length" />" default=""</xsl:when><xsl:otherwise>default=""</xsl:otherwise></xsl:choose> getter="true" setter="true" /&gt;
		</xsl:for-each>
	&lt;!---
	PROPERTIES
	---&gt;
	&lt;cfset variables.instance = StructNew() /&gt;

	&lt;!---
	INITIALIZATION / CONFIGURATION
	---&gt;
	&lt;cffunction name="init" access="public" returntype="<xsl:value-of select="//bean/@path"/>" output="false"&gt;
		<xsl:for-each select="root/bean/dbtable/column">&lt;cfargument name="<xsl:value-of select="@name" />" type="<xsl:choose><xsl:when test="@type='uuid'">uuid</xsl:when><xsl:otherwise>string</xsl:otherwise></xsl:choose>" required="false" <xsl:choose><xsl:when test="@type = 'uuid'">default="#createUUID()#"</xsl:when><xsl:otherwise>default=""</xsl:otherwise></xsl:choose> /&gt;
		</xsl:for-each>
		&lt;!--- run setters ---&gt;
		<xsl:for-each select="root/bean/dbtable/column">&lt;cfset this.set<xsl:value-of select="@name" />(arguments.<xsl:value-of select="@name" />) /&gt;
		</xsl:for-each>
		&lt;cfreturn this /&gt;
 	&lt;/cffunction&gt;

	&lt;!---
	PUBLIC FUNCTIONS
	---&gt;
	<!-- custom code -->

&lt;/cfcomponent&gt;</xsl:template>
</xsl:stylesheet>
