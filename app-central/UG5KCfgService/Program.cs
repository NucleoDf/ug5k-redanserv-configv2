using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace UG5KCfgService
{
    static class Program
    {
        static string appGuid = "{1937350A-B485-491A-BDB9-C3E2CFDB90E5}";

        /// <summary>
        /// Punto de entrada principal para la aplicación.
        /// </summary>
        static void Main(string[] args)
        {
            using (Mutex mutex = new Mutex(false, "Global\\" + appGuid))
            {
                ServiceBase[] ServicesToRun;
                ServicesToRun = new ServiceBase[]
                {
                        new UG5KCentralCfgService()
                };

                if (!mutex.WaitOne(0, false))
                {
                    // TODO. LOG....
                    return;
                }
                /** */
                AppDomain.CurrentDomain.UnhandledException += new UnhandledExceptionEventHandler(MyGlobalExceptionHandler);
                if (args.Contains("-console"))
                {
                    (ServicesToRun[0] as UG5KCentralCfgService)?.StartOnDebugMode();
                    char key;
                    while ((key = Console.ReadKey(true).KeyChar) != 'q')
                    {
                    }
                    (ServicesToRun[0] as UG5KCentralCfgService)?.StopOnDebugMode();
                }
                else
                {
                    ServiceBase.Run(ServicesToRun);
                }
            }
        }

        static void MyGlobalExceptionHandler(object sender, UnhandledExceptionEventArgs args)
        {
            Exception x = (Exception)args.ExceptionObject;
            // TODO LOG...
            // TODO EXIT...
        }

    }
}
