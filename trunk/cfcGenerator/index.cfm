<!--- Set the path to the application's mach-ii.xml file. --->
<cfset MACHII_CONFIG_PATH = ExpandPath("config/mach-ii.xml") />
<!--- Set the configuration mode (when to reload): -1=never, 0=dynamic, 1=always --->
<cfset MACHII_CONFIG_MODE = 0 />
<!--- Set the app key for sub-applications within a single cf-application. --->
<cfset MACHII_APP_KEY = GetFileFromPath(ExpandPath(".")) />
<!---
Whether or not to validate the XML configuration file before parsing.
Only works on CFMX7. Default to false.
--->
<cfset MACHII_VALIDATE_XML = false />
<!--- Set the path to the Mach-II's DTD file.  Default to ./config/mach-ii_1_1.dtd. --->
<cfset MACHII_DTD_PATH = ExpandPath('config/mach-ii_1_1.dtd') />
<!--- Include the mach-ii.cfm file included with the core code. --->
<cfinclude template="/MachII/mach-ii.cfm" />