Instructions:

REQUIREMENTS
----------------------------------------------------------
* ColdFusion MX 7.0.2 - Flash Remoting support must be enabled under Data & Services Flex Integration
	- NOTE: This component utlizes the adminAPI, so you must have access to the
		local ColdFusion server administrator password.
* Currently supports MySQL 5 (possibly 4.1 but it has not been tested) and MSSQL 2000/2005 and Oracle (contributed by Beth Bowden)

Installation:
1) Copy the contents into a directory name "cfcgenerator" under your web root
	- NOTE:	If you need to place it elsewhere, a mapping should work, 
		but you will need to edit your [webroot]\web-inf\flex\services-config.xml
		and set <use-mappings>true</use-mappings>
2) Set your ColdFusion administrator password as the value of adminPass in Application.cfm
3) That's it!

ABOUT
----------------------------------------------------------
The Illudium PU-36 Code Generator uses database metadata that it converts into a custom XML format and applies to XSL templates to generate ColdFusion code for you. While most of the templates generate ColdFusion components (cfc), the generator can generate any type of code. Out of the box it also includes some XML templates as well as a simple ActionScript value object template. Keep in mind, the generated code is intended as a starting point for you to customize, not an end point.

USING THE GENERATOR
----------------------------------------------------------
When the generator initially loads it should automatically populate several select boxes. The first is available DSNs (for supported dbms see above). Once the DSN loads, the tables select should populate with a list of tables within that DSN. Lastly, the templates select should populate with all available xsl template options (for tips on how to customize templates, see below).

To generate templates:

1) Select the DSN that contains the table you would like to generate against.
2) Select the table from the list of tables.
3) Optionally, choose a different template to generate against.
4) Required, specify the default dot notation cfc path (i.e. com.user.user for /com/user/user.cfc)
5) Optionally, specify a relative site root system path (this is required to activate the save file capability)
6) Optionally, check "Strip extra line breaks" if the generated code displays with extra line breaks
7) Click Generate

Once the code generates, you will receive a set of tabs relating to each item you generated with a text area containing the generated code. You can choose to simply copy/paste each item by clicking the "Select All" button or you can save the file to a specified path by clicking the save file button - a default path and file name is specified for you, however you can change this before saving (Note: if the path doesn't exist it will be created for you).

CUSTOMIZING TEMPLATES
----------------------------------------------------------
The code is generated off a set of stylesheets located in the /xsl/ folder. This is configured using the yac.xml file in the /xsl/ folder (yet another config). You can list the items you wish to generate off the stylesheet - each child of the root (i.e. <bean>) should have a base stylesheet (i.e. bean.xsl). The internal functions of most of these stylesheets have been seperated out to make them easier to tweak and customize to suit your needs - the includes are defined by the <include> children of the xml node and should be located in a folder of the same name (i.e. <bean> functions should be in the /xsl/bean/ folder). The xsl of each function will be added in the order you specify in the yac.xml. You determine where the function will be placed in your base stylesheet by the location of a comment reading "<!-- custom code -->" (see the current files if this isn't clear). Feel free to add your own generated files and templates, you aren't limited to only the items that I created.

If you would like to have the ability to save files directly from the generator, you will need to specify the fileType attribute within each child of the root.

The generator allows you to choose the set of templates that you would like to generate against, allowing you the ability to add custom templates without modifying the core code. The custom stylesheets should be placed in a subfolder of /xsl/projects/. You will find a copy of the core files in there under the prototype folder that you can copy or rename. There is also an included set of templates for using Mark Mandel's Transfer ORM project. Each set of templates needs its own yac.xml file.

For reference purposes, here is the XML that is used to populate the templates:

<root>
	<bean name="name" path="dot.notation.path">
		<dbtable name="tableName">
			<column name="columnName"
				type="cfDataType"
				cfSqlType="cfSQLDataType"
				required="yes|no"
				length="##"
				primaryKey="yes|no"
				identity="true|false" />
		</dbtable>
	</bean>
</root>

Please feel free to share your custom templates by sending them to brinaldi@remotesynthesis.com for possible inclusion in future versions of the project. I will be sure to give you credit.

SUPPORT AND CONTRIBUTIONS
----------------------------------------------------------
If you need assistance or would like to contribute to this project, email brinaldi@remotesynthesis.com. If you find this project useful/helpful, feel free to send me Itunes gift certificates as a thank you :)