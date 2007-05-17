<cfcomponent output="false">
	<cffunction name="init" access="public" output="false" returntype="directoryService">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getRoots" access="public" output="false" returntype="array">
		<cfset var fileObj = createObject("java","java.io.File") />
		<cfset var systemRoots = fileObj.listRoots() />
		<cfset var i = 0 />
		<cfset var arrReturn = arrayNew(1) />
		<cfset var thisDirectory = "" />
		
		<cfloop from="1" to="#arrayLen(systemRoots)#" index="i">
			<cfset thisDirectory = createObject("component","cfcgenerator.com.cf.model.directory.directory").init(systemRoots[i].getAbsolutePath(),systemRoots[i].getAbsolutePath(),"",true) />
			<cfset arrayAppend(arrReturn,thisDirectory) />
		</cfloop>
		
		<cfreturn arrReturn />
	</cffunction>
	
	<cffunction name="getDirectories" access="public" output="false" returntype="array">
		<cfargument name="baseDirectory" type="string" required="true" />
		
		<cfset var fileObj = createObject("java","java.io.File").Init(arguments.baseDirectory) />
		<cfset var allFiles = fileObj.listFiles() />
		<cfset var i = 0 />
		<cfset var x = 0 />
		<cfset var arrReturn = arrayNew(1) />
		<cfset var thisDirectory = "" />
		<cfset var thisHasChildren = false />
		<cfset var thisChildren = arrayNew(1) />
		<cfset var thisParent = "" />
		
		<!--- trap for null returned by allFiles --->
		   <cfif not isDefined("allFiles")>
		      <cfset allFiles = arrayNew(1) />
		   </cfif>
		
		<cfloop from="1" to="#arrayLen(allFiles)#" index="i">
			<cfif allFiles[i].isDirectory()>
				<!--- figure out if at least one of the children is a directory --->
				<cfset thisChildren = allFiles[i].listFiles() />
				<!--- trap for null --->
				<cfif not isDefined("thisChildren")>
					<cfset thisChildren = arrayNew(1) />
				</cfif>
				<cfset thisHasChildren = false />
				<cfloop from="1" to="#arrayLen(thisChildren)#" index="x">
					<cfif thisChildren[x].isDirectory()>
						<cfset thisHasChildren = true />
						<cfbreak />
					</cfif>
				</cfloop>
				<!--- get the parent directory, and trap for a case where null could be returned (though this should not come up) --->
				<cfset thisParent = allFiles[1].getParent() />
				<cfif not isDefined("thisParent")>
					<cfset thisParent = "" />
				</cfif>
				<cfset thisDirectory = createObject("component","cfcgenerator.com.cf.model.directory.directory").init(allFiles[i].getName(),allFiles[i].getAbsolutePath(),thisParent,thisHasChildren) />
				<cfset arrayAppend(arrReturn,thisDirectory) />
			</cfif>
		</cfloop>
		
		<cfreturn arrReturn />
	</cffunction>
</cfcomponent>