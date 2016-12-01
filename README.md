# Avmconnector
This code sample demonstrates a way to communicate/integrate with processes/applications running on a Linux Azure VM from an Azure or non Azure external workflow. This approach can help with bringing in 3rd party or open source software to be integrated with a workflow running on an Azure service like a website via remove bash call. 

The code base is devided into two parts.

1.  The client side code that shows how to make the remote bash call.  Think of it as the workflow manager that will 
include the external process/application as a part of the workflow.  I have a .net C# project sample here but you can chose the language of your choice.

2.  The second part are the bash scripts follows the pattern of 
  >a. Calling activate script which then will run the desired script for the specific process of the software we need to run. (in the current example a FFMPEG transcoder running transcode command on FFMPEG. 
  
  >b. Wait while the process is running the client is pulling the process execution status.  The Server side code returns 3 possible values (running/Success/fail).  
  
  >c. After the client receives either success or fail (That means the server side is finished) execute clean up. 
  
  
[![N|Solid](https://github.com/lukhand/Avmconnector/blob/master/Diagram.PNG)](https://github.com/lukhand/Avmconnector/blob/master/Diagram.PNG)

In order to replace or add additional process to run one needs to add the process script as identified on the orange box above.  

##Server Side Scripts:

###Activate.sh:

parameters:

1. Scriptname - Scriptname to execute
2. The processID in the form of a guid.
3. The paramaters (if needed-can be blank)

Returns: 
Nothing

 - This script receives the custom script name to execute and also parameters that needs to be passed. You dont need to alter this script as this is the main that calls the actual scripts to be executed (like FFMPEG.sh).   
 - This process also creates a temporary folder with the name of the processID to store all the temporary files (input/output file etc) and also the value of the status of the process (0 for running, 1 for success, 2 for fail)
  

###Wait.sh

Parameters:

1. Transaction ID

Returns

	0 if the custom script is still running
	1 if custom script finished with error
	2 if custom script finished with success

Wait is the script that the tells the client the status of the process that was invoked by the client.  

###Clean.sh

 remove the directory and all the temporary information that was created by Activate.sh.  


##SAMPLE CUSTOM SCRIPT::

###FFMPEG.sh

 Input
  1. ProcessID (Mandatory)
  2. url - http video(to be transcoded)location. (Like blob sas url)

This script pulls the original video into the temporary folder and then executes trancode job to multi-bitrate outputs. After the transcoding is finished it uploads the output videos to BLOB storage.  
	

###NOTE when creating your own custom script(s)....

1.  Always follow the format of putting the process ID as the first parameter.
2.  All infromation that this script creates should be stored inside the temporaty folder created by Activate.sh.  	 
3.  Always put echo "0" >> ./result.code at the end of the script if the execution is successful.  
