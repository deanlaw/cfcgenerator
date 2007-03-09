<cfcomponent name="xslService">
	<cffunction name="init" access="public" output="false" returntype="xslService">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="configure" access="public" output="false" returntype="void">
		<cfargument name="dsn" required="true" type="string" />
		<cfargument name="basePath" required="true" type="string" />
		<cfargument name="projectPath" type="string" required="no" default="" />
		<cfargument name="rootPath" required="no" type="string" default="" />
		
		<cfset var separator = getOSFileSeparator() />
		<cfset variables.basePath = expandPath(arguments.basePath) />
		<cfset variables.dsn = arguments.dsn />
		<cfset variables.projectPath = variables.basePath & 'projects' & separator & arguments.projectPath & separator />
		<cfif len(arguments.rootPath)>
			<cfset variables.rootPath = expandPath(arguments.rootPath) />
		<cfelse>
			<cfset variables.rootPath = "" />
		</cfif>
		<cfset readConfig() />
	</cffunction>
	
	<cffunction name="getComponents" access="public" output="false" returntype="array">
		<cfargument name="xmlTable" required="true" type="xml" />
		
		<cfset var i = 0 />
		<cfset var separator = getOSFileSeparator() />
		<cfset var xsl = "" />
		<cfset var name = "" />
		<cfset var filename = "" />
		<cfset var content = "" />
		<cfset var thisRootPath = "" />
		<cfset var objPage = "" />
		<cfset var arrComponents = arrayNew(1) />
		<!--- loop through cfc types --->
		<cfloop from="1" to="#arrayLen(variables.config.generator.xmlChildren)#" index="i">
			<cfset xsl = buildXSL(variables.config.generator.xmlChildren[i]) />
			<cfset name = variables.config.generator.xmlChildren[i].xmlName />
			<cfset content = xmlTransform(arguments.xmlTable,xsl) />
			<cfset thisRootPath = "" />
			<cfif len(rootPath) and structKeyExists(variables.config.generator.xmlChildren[i].xmlAttributes,"fileType")>
				<!--- if text to append to file name is specified use it otherwise default to the object type name --->
				<cfif structKeyExists(variables.config.generator.xmlChildren[i].xmlAttributes,"fileNameAppend")>
					<cfset thisRootPath = variables.rootPath & variables.config.generator.xmlChildren[i].xmlAttributes.fileNameAppend & "." & variables.config.generator.xmlChildren[i].xmlAttributes.fileType  />
				<cfelse>
					<cfset thisRootPath = variables.rootPath & ucase(left(name,1)) & right(name,len(name)-1) & "." & variables.config.generator.xmlChildren[i].xmlAttributes.fileType  />
				</cfif>
			</cfif>
			<cfset objPage = createObject("component","cfcgenerator.com.cf.model.xsl.generatedPage").init(name,xsl,content,thisRootPath) />
			<cfset arrayAppend(arrComponents,objPage) />
		</cfloop>
		<cfreturn arrComponents />
	</cffunction>
	
	<cffunction name="readConfig" access="private" output="false" returntype="void">		
		<cfset var configXML = "" />
		
		<cfif fileExists(variables.projectPath & "yac.xml")>
			<cfset variables.usePath = variables.projectPath />
			<cffile action="read" file="#variables.projectPath & 'yac.xml'#" variable="configXML" charset="utf-8" />
		<cfelse>
			<cfset variables.usePath = variables.basePath />
			<cffile action="read" file="#variables.basePath & 'yac.xml'#" variable="configXML" charset="utf-8" />
		</cfif>
		<cfset variables.config = xmlParse(configXML) />
	</cffunction>
	
	<cffunction name="buildXSL" access="private" output="false" returntype="string">
		<cfargument name="typeXML" required="true" type="xml" />
		
		<cfset var returnXSL = "" />
		<cfset var innerXSL = "" />
		<cfset var tmpXSL = "" />
		<cfset var i = 0 />
		<cfset var separator = getOSFileSeparator() />
		
		<!--- loop through each include and append it to the inner XSL --->
		<cfloop from="1" to="#arrayLen(arguments.typeXML.xmlChildren)#" index="i">
			<cffile action="read" file="#variables.usePath & arguments.typeXML.xmlName & separator & arguments.typeXML.xmlChildren[i].xmlAttributes.file#" variable="tmpXSL" charset="utf-8" />
			<cfset innerXSL = innerXSL & chr(13) & chr(13) & tmpXSL />
		</cfloop>
		<!--- read the base template --->
		<cffile action="read" file="#variables.usePath & arguments.typeXML.xmlName & '.xsl'#" variable="tmpXSL" charset="utf-8" />
		<cfset returnXSL = replaceNoCase(trim(tmpXSL),"<!-- custom code -->",trim(innerXSL)) />
		<cfreturn trim(returnXSL) />
	</cffunction>
	
	<!--- code supplied by Luis Majano --->
	<cffunction name="getOSFileSeparator" access="public" returntype="any" output="false" hint="Get the operating system's file separator character">
        <cfscript>
        var objFile =  createObject("java","java.lang.System");
        return objFile.getProperty("file.separator");
        </cfscript>
    </cffunction>
</cfcomponent>