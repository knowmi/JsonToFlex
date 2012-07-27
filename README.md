JsonToFlex v0.1:
=================
Creator : Muhammad Noman (mnoman@ci.com)
Date: July 27, 2012
version: 0.1


CREDITS:
========
This code is based on Ben Rimbey's blog post @  
http://benrimbey.wordpress.com/2009/06/20/reflection-based-json-validation-with-vo-structs/



DESCRIPTION:
============
This compact library maps JSON objects to Flex Action Script objects


Usage:
======
Download the JsonToFlex.swc file and copy to your "libs" folder from 
https://github.com/knowmi/JsonToFlex/downloads

// Inside your http result handler
var asdf:Object = JsonToFlex.mapToASObjects( JSON.decode(event.result as String), true );       // 'true' enables debugging and is optional


Requirements:
=============
- All JSON Objects need to have a "className" property defined for every JSON object. 
- className should be the full path  (e.g. ci.ps.model.Province) to flex vo/model objects
- mapToAsObject(..) static method takes JSON decoded object and returns YOUR typed objects


Limitations:
============
- [Bindable] tags are not supported in Action Script class as of version 0.1
