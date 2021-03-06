Quickly read xml file and convert to SAS/WPS dataset

see
https://goo.gl/96uCPM
https://stackoverflow.com/questions/48349862/quickly-read-xml-file-and-convert-to-data-frame


INPUT
=====

 d:/xml/simple.xml

  <?xml version="1.0" encoding="utf-8"?>
  <tags>
    <row Id="1" TagName=".net" Count="261481" ExcerptPostId="3624959" WikiPostId="3607476" />
    <row Id="2" TagName="html" Count="710104" ExcerptPostId="3673183" />
    <row Id="3" TagName="javascript" Count="1519901" ExcerptPostId="3624960" WikiPostId="3607052" />
  </tags>


PROCESS  (WPS/PROC R Working Code)
=======

   tagsXML <- xmlParse("d:/xml/simple.xml");
   want <- XML:::xmlAttrsToDataFrame(getNodeSet(tagsXML, path="//row"));
   import r=want data=wrk.wantwps;


OUTPUT
======

  WORK.WANTWPS total obs=3

     ID    TAGNAME        COUNT     EXCERPTPOSTID    WIKIPOSTID

     1     .net          261481        3624959        3607476
     2     html          710104        3673183
     3     javascript    1519901       3624960        3607052


*                _                         _
 _ __ ___   __ _| | _____  __  ___ __ ___ | |
| '_ ` _ \ / _` | |/ / _ \ \ \/ / '_ ` _ \| |
| | | | | | (_| |   <  __/  >  <| | | | | | |
|_| |_| |_|\__,_|_|\_\___| /_/\_\_| |_| |_|_|

;

data _null_;
 file "d:/xml/simple.xml";
 input;
 put _infile_;
cards4;
<?xml version="1.0" encoding="utf-8"?>
<tags>
  <row Id="1" TagName=".net" Count="261481" ExcerptPostId="3624959" WikiPostId="3607476" />
  <row Id="2" TagName="html" Count="710104" ExcerptPostId="3673183" />
  <row Id="3" TagName="javascript" Count="1519901" ExcerptPostId="3624960" WikiPostId="3607052" />
</tags>
;;;;
run;quit;
*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;
%utl_submit_wps64('
libname sd1 sas7bdat "d:/sd1";
options set=R_HOME "C:/Program Files/R/R-3.3.2";
libname wrk sas7bdat "%sysfunc(pathname(work))";
libname hlp sas7bdat "C:\Program Files\SASHome\SASFoundation\9.4\core\sashelp";
proc r;
submit;
source("C:/Program Files/R/R-3.3.2/etc/Rprofile.site", echo=T);
library(XML);
tagsXML <- xmlParse("d:/xml/simple.xml");
want <- XML:::xmlAttrsToDataFrame(getNodeSet(tagsXML, path="//row"));
endsubmit;
import r=want data=wrk.wantwps;
run;quit;
');


