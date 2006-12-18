<!--- <cfdump var="#createObject('component','cfcgeneratorFlex.com.cf.model.generatorRemote').getDSNs()#"> --->
<cfdirectory name="qryTemplateFolders" action="list" directory="#expandPath('/cfcgeneratorFLEX/xsl/projects')#" />
<cfdump var="#qryTemplateFolders#">