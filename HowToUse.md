# Introduction #

Basic usage of the code generator.


# Details #
When the generator initially loads it it will request your ColdFusion Administrator password, after which it should automatically populate several select boxes.
The first is available DSNs (for supported dbms see above). Once the DSN loads, the tables
select should populate with a list of tables within that DSN. Lastly, the templates select
should populate with all available xsl template options (learn more about [customizing templates](CustomizingTemplates.md) and about the included [Templates](Templates.md)).

To generate templates:

  1. Select the DSN that contains the table you would like to generate against. **(required)**
  1. Select the table from the list of tables. **(required)**
  1. Choose a different template to generate against _(optional)_
  1. Specify the default dot notation cfc path (i.e. com.user.user for /com/user/user.cfc) **(required)**
  1. Specify a relative site root system path (this is required to activate the save file capability) _(optional)_
  1. Check "Strip extra line breaks" if the generated code displays with extra line breaks _(optional)_
  1. Click Generate

Once the code generates, you will receive a set of tabs relating to each item you
generated with a text area containing the generated code. You can choose to simply
copy/paste each item by clicking the "Select All" button or you can save the file to a
specified path by clicking the save file button - a default path and file name is
specified for you, however you can change this before saving (Note: if the path doesn't
exist it will be created for you).