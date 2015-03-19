# Introduction #

How to create custom templates.

# Details #

The code is generated off a set of stylesheets located in the `/xsl/` folder. This is
configured using the yac.xml file in the /xsl/ folder (yet another config).

Custom versions can be installed in (new) subfolders of `/xsl/projects/`. You will find a
copy of the core files in there under the prototype folder that you can copy or rename.
There is also an included set of templates for using Mark Mandel's Transfer ORM project and a few others like a version that uses CFML based templates, not XSLT ones.
Each set of templates needs its own yac.xml file.

You can list
the items you wish to generate off the stylesheet - each child of the root (i.e. 

&lt;bean&gt;

)
should have a base stylesheet (i.e. bean.xsl). The internal functions of most of these
stylesheets have been seperated out to make them easier to tweak and customize to suit
your needs - the includes are defined by the 

&lt;include&gt;

 children of the xml node and should
be located in a folder of the same name (i.e. 

&lt;bean&gt;

 functions should be in the /xsl/bean/
folder). The xsl of each function will be added in the order you specify in the yac.xml.
You determine where the function will be placed in your base stylesheet by the location of
a comment reading "<!-- custom code -->" (see the current files if this isn't clear).

Feel
free to add your own generated files and templates, you aren't limited to only the items
that I created.

If you would like to have the ability to save files directly from the generator, you will
need to specify the fileType attribute within each child of the root.

The generator allows you to choose the set of templates that you would like to generate
against, allowing you the ability to add custom templates without modifying the core code

For reference purposes, here is the XML that is used to populate the templates:
```
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
```

Please feel free to share your custom templates by sending them to the Google Group (http://groups.google.com/group/cfcgenerator) for possible inclusion in future versions of the project. We will be sure to give you credit.