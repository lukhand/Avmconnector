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
           
            string iIP = ConfigurationManager.AppSettings["IP"];
            string iUser = ConfigurationManager.AppSettings["User"];
            string iPassword = ConfigurationManager.AppSettings["Password"];
            Guid g = Guid.NewGuid();
            string activatecmd = string.Format("/home/lkmsft/connector/activate.sh {0} {1} '{2}'","/home/lkmsft/connector/testffmpeg/testffmpeg.sh", g,"https://www.wowza.com/downloads/images/Butterfly_HD_1080p.mp4");
            SshCommand rt;

            Console.WriteLine("process id" + g.ToString());
            using (var client = new SshClient(iIP, iUser, iPassword))
        {
            client.Connect();
            rt = client.RunCommand(activatecmd);
                Console.WriteLine(rt);

                   do
                    {
                       rt =  client.RunCommand("/home/lkmsft/connector/wait.sh " + g);
                    //Console.WriteLine(x);

                   
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
