using Renci.SshNet;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;


namespace TestSSHClient
{
    class Program
    {
        static void Main(string[] args)
        {
           //Read parameter value from appconfig.
            string iIP = ConfigurationManager.AppSettings["IP"];
            string iUser = ConfigurationManager.AppSettings["User"];
            string iPassword = ConfigurationManager.AppSettings["Password"];
            string ifilename = "test";
            string storageaccount = ConfigurationManager.AppSettings["storageaccount"];
            string storagekey = ConfigurationManager.AppSettings["storagekey"];
            //create a guid which will be used as the processid
            Guid g = Guid.NewGuid();

            //buiding parameter value for the custom script.
            //Note calling activate.sh
            string activatecmd = string.Format(
                "/home/lkmsft/connector/activate.sh {0} {1} '{2}' '{3}' '{4}' '{5}' ",
                "/home/lkmsft/connector/testffmpeg/testffmpeg.sh", 
                g,
                "https://www.wowza.com/downloads/images/Butterfly_HD_1080p.mp4",
                ifilename,
                storageaccount,
                storagekey);

            SshCommand rt;

            Console.WriteLine("process id" + g.ToString());
            //connect to the VM
            using (var client = new SshClient(iIP, iUser, iPassword))
        {
            client.Connect();
            
            //run command activate.sh 
            rt = client.RunCommand(activatecmd);
                Console.WriteLine(rt);

            //now check status buy calling wait.sh.  
            //keep checking while return status is 0 means still processing.
            //stop if return code is 1 (finished with error) or 2 (finished with success). 
                   do
                    {
                       rt =  client.RunCommand("/home/lkmsft/connector/wait.sh " + g);
                   
                   
                    Console.WriteLine(rt.ExitStatus);
                    Console.WriteLine(rt.Result);
                    System.Threading.Thread.Sleep(5000);
                    } while (rt.ExitStatus == 0);

                if (rt.ExitStatus==1)
                {
                    Console.WriteLine("error");
                    client.RunCommand("/home/lkmsft/connector/clean.sh " + g);
                }
                else
                {
                    Console.WriteLine("process complete");
                    client.RunCommand("/home/lkmsft/connector/clean.sh "+ g);
                    Console.WriteLine("CLean up complete");
                }
                client.Disconnect();
                Console.WriteLine("this is my process id " + g);
                Console.ReadLine();
               
            
        } 

        }
    }
}
