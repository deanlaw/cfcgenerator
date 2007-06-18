<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"  />
		<xsl:template match="/">
&lt;?xml version="1.0" encoding="UTF-8"?&gt;

&lt;beans&gt;
	&lt;!-- Transfer --&gt;
	&lt;bean id="transfer" class="transfer.TransferFactory"&gt;
		&lt;constructor-arg name="datasourcePath"&gt;&lt;value&gt;/config/datasource.xml&lt;/value&gt;&lt;/constructor-arg&gt;
		&lt;constructor-arg name="configPath"&gt;&lt;value&gt;/config/transfer.xml&lt;/value&gt;&lt;/constructor-arg&gt;
		&lt;constructor-arg name="definitionPath"&gt;&lt;value&gt;/com/transfer&lt;/value&gt;&lt;/constructor-arg&gt;
	&lt;/bean&gt;
	&lt;bean id="<xsl:value-of select="//bean/@name"/>Gateway" class="<xsl:value-of select="//bean/@path"/>Gateway"&gt;
		&lt;constructor-arg name="transfer"&gt;
			&lt;bean id="transfer" factory-bean="transfer" factory-method="getTransfer" /&gt;
		&lt;/constructor-arg&gt;
	&lt;/bean&gt;
	&lt;bean id="<xsl:value-of select="//bean/@name"/>Service" class="<xsl:value-of select="//bean/@path"/>Service"&gt;
		&lt;constructor-arg name="transfer"&gt;
			&lt;bean id="transfer" factory-bean="transfer" factory-method="getTransfer" /&gt;
		&lt;/constructor-arg&gt;
		&lt;constructor-arg name="<xsl:value-of select="//bean/@name"/>Gateway"&gt;
			&lt;ref bean="<xsl:value-of select="//bean/@name"/>Gateway"/&gt;
		&lt;/constructor-arg&gt;
	&lt;/bean&gt;
&lt;/beans&gt;</xsl:template>
</xsl:stylesheet>