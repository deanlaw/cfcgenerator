#  Illudium PU-36 Code Generator
This project generates ColdFusion components (i.e. bean, DAO, gateway, service), ColdSpring XML, Transfer XML, and ActionScript Value-Objects using the ColdFusion admin API and database introspection. The UI is built in Flex for an easy-to-use and intuitive interface. The code is outputted for easily saving or pasting into a project to allow you to get a head-start on some of the grunt work of building object-oriented applications in ColdFusion. It uses XSL or CFML to generate the components and is designed to allow you to easily add to or modify the generated code. You can even create new templates that can be swapped out at run-time.

REQUIREMENTS
----------------------------------------------------------
* ColdFusion MX 7.0.2 - Flash Remoting support must be enabled under Data & Services Flex Integration
	- NOTE: This component utlizes the adminAPI, so you must have access to the
		local ColdFusion server administrator password.
* Currently supports MySQL 4.1 and 5 and MSSQL 2000/2005 and Oracle (contributed by Beth Bowden)
* Running ColdFusion 8 Beta adds limited support for any type of database supported by ColdFusion
	- Access is supported in Unicode mode only
	- Identity field support is not available
	- Unknown data types (due to a bug in the beta) will default to string

Installation:
1) Copy the contents into a directory name "cfcgenerator" under your web root
	- NOTE:	If you need to place it elsewhere, a mapping should work, 
		but you will need to edit your [webroot]\web-inf\flex\services-config.xml
		and set <use-mappings>true</use-mappings>
3) That's it!

ABOUT
----------------------------------------------------------
The Illudium PU-36 Code Generator uses database metadata that it converts into a custom XML format and applies to XSL  or CFML templates to generate ColdFusion code for you. While most of the templates generate ColdFusion components (cfc), the generator can generate any type of code. Out of the box it also includes some XML templates as well as a simple ActionScript value object template. Keep in mind, the generated code is intended as a starting point for you to customize, not an end point.

USING THE GENERATOR
----------------------------------------------------------
When the generator initially loads it will prompt you for your ColdFusion administrator password, after which it should automatically populate several select boxes. The first is available DSNs (for supported dbms see above). Once the DSN loads, the tables select should populate with a list of tables within that DSN. Lastly, the templates select should populate with all available xsl template options (for tips on how to customize templates, see below).

To generate templates:

1) Select the DSN that contains the table you would like to generate against.
2) Select the table from the list of tables.
3) Optionally, choose a different template to generate against.
4) Required, specify the default dot notation cfc path (i.e. com.user.user for /com/user/user.cfc)
5) Optionally, choose a system save path using the directory browser (this is required to activate the save file capability)
6) Optionally, check "Strip extra line breaks" if the generated code displays with extra line breaks
7) Click Generate

Once the code generates, you will receive a set of tabs relating to each item you generated with a text area containing the generated code. You can choose to simply copy/paste each item by clicking the "Select All" button or you can save the file to a specified path by clicking the save file button - a default path and file name is specified for you, however you can change this before saving (Note: if the path doesn't exist it will be created for you).

CUSTOMIZING TEMPLATES
----------------------------------------------------------
The code is generated off a set of XSL or CFML templates located in the /xsl/ folder. Each is configured using the yac.xml file in the /xsl/ folder (yet another config). You can list the items you wish to generate off the stylesheet - each child of the root (i.e. <bean>) should have a base template (i.e. bean.xsl or bean.cfm) - note: the default is xsl, to use a cfm template you specify  templateType="cfm". The internal functions of most of these stylesheets have been seperated out to make them easier to tweak and customize to suit your needs - the includes are defined by the <include> children of the xml node and should be located in a folder of the same name (i.e. <bean> functions should be in the /xsl/bean/ folder). The xsl/cfml of each function will be added in the order you specify in the yac.xml. You determine where the function will be placed in your base stylesheet by the location of a comment reading "<!-- custom code -->" (see the current files if this isn't clear). Feel free to add your own generated files and templates, you aren't limited to only the items that I created.

If you would like to have the ability to save files directly from the generator, you will need to specify the fileType attribute within each child of the root.

By default the file name will append the object type name, but this can be overidden using the fileNameAppend attribute. For instance, the bean has a fileNameAppend="" so that the generated name is the base object name, for example user.cfc and not userBean.cfc.

The generator allows you to choose the set of templates that you would like to generate against, allowing you the ability to add custom templates without modifying the core code. The custom stylesheets should be placed in a subfolder of /xsl/projects/. You will find a copy of the core files in there under the prototype folder that you can copy or rename. There is also an included set of templates for using Mark Mandel's Transfer ORM project. Each set of templates needs its own yac.xml file.

For reference purposes, here is the XML that is used to populate the templates (note: for XSL this is applied directly to the template using XSLT, for CFML it is passed to the template as a variable called root):

<root>
	<bean name="component_name" path="dot.notation.component.path">
		<dbtable name="table_name" type="dsn_type">
			<column name=column_name"
				type="data_type"
				cfSqlType="cfsql_data_type"
				required="yes|no"
				length="int"
				primaryKey="yes|no"
				identity="true|false" />
		</dbtable>
	</bean>
</root>

Using the Generated Code
----------------------------------------------------------
While the tool is not designed to teach you object-oriented coding concepts, if you would like to learn how to use the generated code and some of the OO concepts behind it, I wrote a series of posts covering this topic (specifically relating it back to the generated code):

Part 1 - http://www.remotesynthesis.com/blog/index.cfm/2007/6/1/Objects-and-Composition-in-CFCs
Part 2 (ColdSpring) - http://www.remotesynthesis.com/blog/index.cfm/2007/6/5/Objects-and-Composition-in-CFCs--Part-2-ColdSpring
Part 3 (Transfer) - http://www.remotesynthesis.com/blog/index.cfm/2007/6/20/Objects-and-Composition-Part-3--Using-Transfer

SUPPORT AND CONTRIBUTIONS
----------------------------------------------------------
Please feel free to share your custom templates or ask questions via the Google Group at: http://groups.google.com/group/cfcgenerator

If you need assistance or would like to contribute to this project, email brinaldi@remotesynthesis.com. If you find this project useful/helpful, you can visit my wishlist at http://www.amazon.com/gp/registry/wishlist/1BL8G2FZM978/ref=wl_web/
