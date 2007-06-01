<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"  />
		<xsl:template match="/">
package <xsl:value-of select="//bean/@path"/>
{
	[RemoteClass(alias="<xsl:value-of select="//bean/@path"/>")]

	[Bindable]
	public class <xsl:value-of select="//bean/@name"/>VO
	{

		<xsl:for-each select="root/bean/dbtable/column">public var <xsl:value-of select="@name"/>:<xsl:choose><xsl:when test="@type='numeric'">Number</xsl:when><xsl:when test="@type='date'">Date</xsl:when><xsl:when test="@type='boolean'">Boolean</xsl:when><xsl:otherwise>String</xsl:otherwise></xsl:choose> = <xsl:choose><xsl:when test="@type='string'">""</xsl:when><xsl:otherwise>Null</xsl:otherwise></xsl:choose>;
		</xsl:for-each>
		public function <xsl:value-of select="//bean/@name"/>VO()
		{
		}

	}
}</xsl:template>
</xsl:stylesheet>