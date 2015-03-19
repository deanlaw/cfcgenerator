## 

&lt;generator&gt;

 ##

None

## Child tags of generator ##



&lt;filename fileNamePrepend="&lt;string&gt;" fileNameAppend="&lt;string&gt;" fileType="&lt;string&gt;" templateType="&lt;cfm or leave out attribute entirly&gt;"&gt;



Where 'filename' must be the name of a file in same dir. as yac.xml, with an extension of .cfm or .xsl as determined by the templateType attribute.

fileNamePrepend and fileNameAppend add strings to the start or end of the final file name. <br>
fileNamePrepend may contain slashes to put the output in a subdirectory. <br>
fileNameAppend appends after the name but before the full stop and extension.<br>
<br>
fileType will be appended to the final file name prepended by a full stop i.e. it defines the extension of the generated file.<br>
<br>
<h2>Children of child tags of generator</h2>

<br>
<br>
<include file="filenameString" /><br>
<br>
<br>
<br>
filenameString must be a file name including the extension that lives in a subfolder of the folder yac.xml is in. The name of the folder must match the name of the parent tag.<br>
The result of this template will be added to the result of the main template defined by that parent tag, at the point where the template says <code>&lt;!-- custom code --&gt;</code>