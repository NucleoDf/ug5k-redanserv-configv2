using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;



namespace uv5ki_nbx_webapp
{
    class Program
    {
        static void Main(string[] args)
        {
            AppServer.nbxPublicData data = new AppServer.nbxPublicData();
            AppServer.nbxWebAppServer server = new AppServer.nbxWebAppServer();

            server.Start(1023, data);

            ConsoleKeyInfo result;
            do
            {
                result = Console.ReadKey(true);
                switch (result.Key)
                {
                    case ConsoleKey.D1:
                        break;
                }
            } while (result.Key != ConsoleKey.Escape);

            server.Stop();

        }
    }
}
