using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace UG5KCfgService
{
    public partial class UG5KCentralCfgService : ServiceBase
    {
        public UG5KCentralCfgService()
        {
            InitializeComponent();
            /** Creacion del LOG de Eventos... */
            ug5kServEventLog = new EventLog();
            if (!EventLog.SourceExists("UG5KEventSource"))
            {
                EventLog.CreateEventSource("UG5KEventSource", "UG5KEventLog");
            }
            ug5kServEventLog.Source = "UG5KEventSource";
            ug5kServEventLog.Log = "UG5KEventLog";

        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="args"></param>
        protected override void OnStart(string[] args)
        {
            ug5kServEventLog.WriteEntry("Arrancando Servicio....");
            StartOnDebugMode();
        }
        /// <summary>
        /// 
        /// </summary>
        protected override void OnStop()
        {
            StopOnDebugMode();
            ug5kServEventLog.WriteEntry("Deteniendo Servicio....");
        }

        ManualResetEvent SyncAndEndEvent = new ManualResetEvent(false);
        NodeProcess nodeProcess = new NodeProcess();
        public void StartOnDebugMode()
        {
            if (SyncAndEndEvent == null)
            {
                SyncAndEndEvent = new ManualResetEvent(false);
                Task.Factory.StartNew(() =>
                {
                    do
                    {
                        if (!nodeProcess.IsAlive)
                            nodeProcess.Start();

                    } while (!SyncAndEndEvent.WaitOne(2000, false));
                    if (nodeProcess.IsAlive)
                        nodeProcess.Stop();
                });
            }
        }

        public void StopOnDebugMode()
        {
            SyncAndEndEvent.Set();
        }

    }
}
