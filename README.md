# Avmconnector
This code sample demonstrates a way to communicate/integrate with processes/applications running on a Linux Azure VM from an Azure or non Azure external workflow. This approach can help with bringing in 3rd party or open source software to be integrated with a workflow via remove bash call. 

The code base is devided into two parts.

1.  The Client that shows sample code on how to make the remote bash call.  Think of it as the workflow manager that will 
include the external process/application as a part of the workflow.  I have a .net C# project sample here but you can chose the language of your choice.

2.  The second part are the bash scripts that follow the pattern below.

[![N|Solid](https://github.com/lukhand/Avmconnector/blob/master/Diagram.PNG)](https://github.com/lukhand/Avmconnector/blob/master/Diagram.PNG)
