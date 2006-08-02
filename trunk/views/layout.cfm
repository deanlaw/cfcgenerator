<cfcontent reset="true"><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Illudium PU-36 Code Generator - v.0.3</title>
</head>

<body>

<cfoutput>
<div id="container">	
	#request.content#
</div>
</cfoutput>
<cfif isDefined("request.debugvar")><cfdump var="#request.debugvar#" label="request.debugvar"></cfif>
</body>
</html>
