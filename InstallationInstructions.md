# Introduction #

How to install the project.


# Details #

  1. Copy the contents into a directory name "cfcgenerator" under your web root _NOTE: If you need to place it elsewhere, a mapping should work,  but you will need to edit your [webroot](webroot.md)\web-inf\flex\services-config.xml and set_

&lt;use-mappings&gt;

true

&lt;/use-mappings&gt;

_1. That's it!_

_NOTE: When loading a new version it may sometimes be necessary to append ?reload=true to the generator URL to refresh items cached in the application scope._