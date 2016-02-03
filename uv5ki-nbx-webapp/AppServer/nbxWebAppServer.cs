﻿using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

using System.Globalization;
using System.Net;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using NLog;


namespace uv5ki_nbx_webapp.AppServer
{
    /// <summary>
    ///     { "cfg": 2, "rad": 2, "ifx": 2, "pbx": 0 }
    /// </summary>
    class stdGlobal
    {
        public int cfg { get; set; }
        public int rad { get; set; }
        public int ifx { get; set; }
        public int pbx { get; set; }
    }

    /// <summary>
    /// { "fecha": "10/01/2015 08:00", "nombre": "Configuracion 1" }
    /// </summary>
    class pcfData
    {
        public string fecha { get; set; }
        public string nombre { get; set; }
    }

    /// <summary>
    /// 
    /// </summary>
    class margenData
    {
        public int max { get; set; }
        public int min { get; set; }
    }

    /// <summary>
    /// 
    /// </summary>
    class lparData
    {
        public string nombre { get; set; }
        public string mostrar { get; set; }
        public int tipo { get; set; }
        public List<string> opciones { get; set; }
        public int validar { get; set; }
        public margenData margenes { get; set; }
        public string valor { get; set; }
    }
    /// <summary>
    /// 
    /// </summary>
    class lparGroup
    {
        public string name { get; set; }
        public List<lparData> par { get; set; }
    }

    /// <summary>
    /// 
    /// </summary>
    class nbxLocalConfig
    {
        public lparGroup pgn { get; set; }
        public lparGroup pif { get; set; }
        public lparGroup prd { get; set; }
        public lparGroup pcf { get; set; }
        public lparGroup pit { get; set; }
        public lparGroup ppx { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public nbxLocalConfig()
        {
            pgn = new lparGroup();
            pif = new lparGroup();
            prd = new lparGroup();
            pcf = new lparGroup();
            pit = new lparGroup();
            ppx = new lparGroup();
        }

        /// <summary>
        /// 
        /// </summary>
        public void LoadFromFile1() 
        {
            string exePath = System.Reflection.Assembly.GetEntryAssembly().Location;
            NodeBoxConfig LocalConfig = new NodeBoxConfig(Path.GetDirectoryName(exePath), "es");

            pgn = new lparGroup();
            pgn.name = "Parametros Generales";
            pgn.par = new List<lparData>();
            foreach (KeyValuePair<string, string> prop in LocalConfig.SectionProperties(NodeBoxConfig.cNbxSectionName))
            {
                pgn.par.Add(new lparData()
                {
                    nombre = prop.Key,
                    mostrar = LocalConfig.GetStringDisplay(prop.Key),
                    tipo = 0,
                    validar = 0,
                    margenes = new margenData() { max = 0, min = 0 },
                    opciones = new List<string>() { "", "" },
                    valor = prop.Value
                });
            }
            pgn.par = pgn.par.OrderBy(o => o.mostrar).ToList();

            pif = new lparGroup();
            pif.name = "Parametros de Infraestructura";
            pif.par = new List<lparData>();
            foreach (KeyValuePair<string, string> prop in LocalConfig.SectionProperties(NodeBoxConfig.cInfraSectionName))
            {
                pif.par.Add(new lparData()
                {
                    nombre = prop.Key,
                    mostrar = LocalConfig.GetStringDisplay(prop.Key),
                    tipo = 0,
                    validar = 0,
                    margenes = new margenData() { max = 0, min = 0 },
                    opciones = new List<string>() { "", "" },
                    valor = prop.Value
                });
            }
            pif.par = pif.par.OrderBy(o => o.mostrar).ToList();

            prd = new lparGroup();
            prd.name = "Parametros de Servicio Radio";
            prd.par = new List<lparData>();
            foreach (KeyValuePair<string, string> prop in LocalConfig.SectionProperties(NodeBoxConfig.cRadioSectionName))
            {
                prd.par.Add(new lparData()
                {
                    nombre = prop.Key,
                    mostrar = LocalConfig.GetStringDisplay(prop.Key),
                    tipo = 0,
                    validar = 0,
                    margenes = new margenData() { max = 0, min = 0 },
                    opciones = new List<string>() { "", "" },
                    valor = prop.Value
                });
            }
            prd.par = prd.par.OrderBy(o => o.mostrar).ToList();

            pcf = new lparGroup();
            pcf.name = "Parametros de Servicio Configuracion";
            pcf.par = new List<lparData>();
            foreach (KeyValuePair<string, string> prop in LocalConfig.SectionProperties(NodeBoxConfig.cConfigSectionName))
            {
                pcf.par.Add(new lparData()
                {
                    nombre = prop.Key,
                    mostrar = LocalConfig.GetStringDisplay(prop.Key),
                    tipo = 0,
                    validar = 0,
                    margenes = new margenData() { max = 0, min = 0 },
                    opciones = new List<string>() { "", "" },
                    valor = prop.Value
                });
            }
            pcf.par = pcf.par.OrderBy(o => o.mostrar).ToList();

            pit = new lparGroup();
            pit.name = "Parametros de Servicio Interfaces";
            pit.par = new List<lparData>();
            foreach (KeyValuePair<string, string> prop in LocalConfig.SectionProperties(NodeBoxConfig.cTifxSectionName))
            {
                pit.par.Add(new lparData()
                {
                    nombre = prop.Key,
                    mostrar = LocalConfig.GetStringDisplay(prop.Key),
                    tipo = 0,
                    validar = 0,
                    margenes = new margenData() { max = 0, min = 0 },
                    opciones = new List<string>() { "", "" },
                    valor = prop.Value
                });
            }
            pit.par = pit.par.OrderBy(o => o.mostrar).ToList();

            ppx = new lparGroup();
            ppx.name = "Parametros de Servicio de PABX";
            ppx.par = new List<lparData>();
            foreach (KeyValuePair<string, string> prop in LocalConfig.SectionProperties(NodeBoxConfig.cPabxSectionName))
            {
                ppx.par.Add(new lparData()
                {
                    nombre = prop.Key,
                    mostrar = LocalConfig.GetStringDisplay(prop.Key),
                    tipo = 0,
                    validar = 0,
                    margenes = new margenData() { max = 0, min = 0 },
                    opciones = new List<string>() { "", "" },
                    valor = prop.Value
                });
            }
            ppx.par = ppx.par.OrderBy(o => o.mostrar).ToList();
        }

        public void LoadFromFile() 
        {
            string exePath = System.Reflection.Assembly.GetEntryAssembly().Location;
            NodeBoxConfig LocalConfig = new NodeBoxConfig(Path.GetDirectoryName(exePath), "es");

            List<Tuple<string, string, lparGroup>> grupos = new List<Tuple<string, string, lparGroup>>() {
                new Tuple<string, string, lparGroup> (NodeBoxConfig.cNbxSectionName, "Parametros Generales", pgn),
                new Tuple<string, string, lparGroup> (NodeBoxConfig.cInfraSectionName, "Parametros de Infraestructura", pif),
                new Tuple<string, string, lparGroup> (NodeBoxConfig.cRadioSectionName, "Parametros de Servicio Radio", prd),
                new Tuple<string, string, lparGroup> (NodeBoxConfig.cConfigSectionName, "Parametros de Servicio Configuracion", pcf),
                new Tuple<string, string, lparGroup> (NodeBoxConfig.cTifxSectionName, "Parametros de Servicio Interfaces", pit),
                new Tuple<string, string, lparGroup> (NodeBoxConfig.cPabxSectionName, "Parametros de Servicio de PABX", ppx)
            };

            foreach (Tuple<string, string, lparGroup> sec in grupos)
            {
                sec.Item3.name = sec.Item2;
                sec.Item3.par = new List<lparData>();
                foreach (KeyValuePair<string, string> prop in LocalConfig.SectionProperties(sec.Item1))
                {
                    sec.Item3.par.Add(new lparData()
                    {
                        nombre = prop.Key,
                        mostrar = LocalConfig.GetStringDisplay(prop.Key),
                        tipo = 0,
                        validar = 0,
                        margenes = new margenData() { max = 0, min = 0 },
                        opciones = new List<string>() { "", "" },
                        valor = prop.Value
                    });
                }
                sec.Item3.par = sec.Item3.par.OrderBy(o => o.mostrar).ToList();
            }        

        }
        
        /// <summary>
        /// 
        /// </summary>
        public void SaveToFile()
        {
            string exePath = System.Reflection.Assembly.GetEntryAssembly().Location;
            NodeBoxConfig LocalConfig = new NodeBoxConfig(Path.GetDirectoryName(exePath), "es");

            List<Tuple<string, lparGroup>> grupos = new List<Tuple<string, lparGroup>>() {
                new Tuple<string, lparGroup> (NodeBoxConfig.cNbxSectionName, pgn),
                new Tuple<string, lparGroup> (NodeBoxConfig.cInfraSectionName, pif),
                new Tuple<string, lparGroup> (NodeBoxConfig.cRadioSectionName, prd),
                new Tuple<string, lparGroup> (NodeBoxConfig.cConfigSectionName, pcf),
                new Tuple<string, lparGroup> (NodeBoxConfig.cTifxSectionName, pit),
                new Tuple<string, lparGroup> (NodeBoxConfig.cPabxSectionName, ppx)
            };

            //
            foreach (Tuple<string, lparGroup> grp in grupos)
            {
                foreach (lparData par in grp.Item2.par)
                {
                    LocalConfig.PropertySet(grp.Item1, par.nombre, par.valor);
                }
            }

            LocalConfig.Save();
        }
    }

    /// <summary>
    /// 
    /// </summary>
    class nbxPublicData
    {
        public stdGlobal std = new stdGlobal();
        public List<pcfData> pcf = new List<pcfData>();
        public nbxLocalConfig lcf = new nbxLocalConfig();
    }


    /// <summary>
    /// 
    /// </summary>
    class nbxWebAppServer
    {
        /** Peticiones REST */
        const string rest_url_std = "std";
        const string rest_url_preconf = "preconf";
        const string rest_url_local_config = "lconfig";

        /// <summary>
        /// 
        /// </summary>
        Logger _Logger = LogManager.GetCurrentClassLogger();
        HttpListener _listener = null;
        nbxPublicData _rtData = null;


        /// <summary>
        /// 
        /// </summary>
        public nbxWebAppServer()
        {
            SetRequestRootDirectory();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="port"></param>
        public void Start(int port, nbxPublicData rtData)
        {
            // TODO. Para el idioma...

            //CultureInfo culture = new CultureInfo(Properties.Settings.Default.Idioma);
            //Thread.CurrentThread.CurrentCulture = culture;
            //Thread.CurrentThread.CurrentUICulture = culture;

            SetRequestRootDirectory();

            _listener = new HttpListener();
            _listener.Prefixes.Add("http://*:" + port.ToString() + "/");
            _listener.Start();
            _listener.BeginGetContext(new AsyncCallback(GetContextCallback), null);

            _rtData = rtData;
            _rtData.lcf.LoadFromFile();
        }

        /// <summary>
        /// 
        /// </summary>
        public void Stop()
        {
            _listener.Close();
            _listener = null;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="result"></param>
        void GetContextCallback(IAsyncResult result)
        {
            if (_listener == null || _listener.IsListening == false)
                return;

            HttpListenerContext context = _listener.EndGetContext(result);
            HttpListenerRequest request = context.Request;
            HttpListenerResponse response = context.Response;

            try
            {
                // TODO. Idioma
                //CultureInfo culture = new CultureInfo(Properties.Settings.Default.Idioma);
                //Thread.CurrentThread.CurrentCulture = culture;
                //Thread.CurrentThread.CurrentUICulture = culture;

                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                if (request.HttpMethod == "POST")
                {
                    ProcesaPeticionPost(request, response, sb);
                    Render(Encode(sb.ToString()), response);
                }
                else if (request.HttpMethod == "PUT")
                {
                    ProcesaPeticionPut(request, response, sb);
                    Render(Encode(sb.ToString()), response);
                }
                else if (request.HttpMethod == "DELETE")
                {
                    ProcesaPeticionDelete(request, response, sb);
                    Render(Encode(sb.ToString()), response);
                }
                else if (request.HttpMethod == "GET")
                {
                    /** Miro si esta solicitando un fichero */
                    string url = context.Request.Url.LocalPath;
                    if (url.Length > 1 && File.Exists(url.Substring(1)))
                    {
                        /** Es un fichero lo envio... */
                        string file = url.Substring(1);
                        string ext = Path.GetExtension(file).ToLowerInvariant();

                        response.ContentType = FileContentType(ext);
                        ProcessFile(file, response);
                    }
                    else
                    {
                        /** Es una Peticion. La Proceso */
                        ProcesaPeticionGet(request, response, sb);
                        Render(Encode(sb.ToString()), response);    // Render(sb.ToString(), response);
                    }
                }
            }
            catch (Exception x)
            {
                response.StatusCode = 500;
                Render(Encode(x.Message), response);

                _Logger.Debug(x, "Excepcion en WebServer. GetContextCallback: " + x.Message);

            }
            finally
            {
                _listener.BeginGetContext(new AsyncCallback(GetContextCallback), null);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="file"></param>
        private void ProcessFile(string file, HttpListenerResponse response)
        {
            byte[] content = File.ReadAllBytes(file);
            response.OutputStream.Write(content, 0, content.Length);
            response.Close();

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="res"></param>
        /// <param name="sb"></param>
        private void ProcesaPeticionGet(HttpListenerRequest request, HttpListenerResponse response, StringBuilder sb)
        {
            _Logger.Debug("GET {0}", request.Url.LocalPath);

            if (request.Url.LocalPath == "/")
            {
                response.Redirect("/index.html");
            }
            else
            {
                string[] par = request.Url.LocalPath.Split('/');
                if (par.Count() > 1)
                {
                    switch (par[1])
                    {
                        case rest_url_std:
                            processEstadoGeneral(request, response, sb);
                            break;
                        case rest_url_preconf:
                            processPreconfiguracionesGet(request, response, sb);
                            break;
                        case rest_url_local_config:
                            processLocalConfigGet(request, response, sb);
                            break;
                        default:
                            sb.Append(webappError(0));
                            response.StatusCode = 404;          // No Implementado...
                            break;
                    }
                }
            }

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="request"></param>
        /// <param name="response"></param>
        /// <param name="sb"></param>
        private void ProcesaPeticionPost(HttpListenerRequest request, HttpListenerResponse response, StringBuilder sb)
        {
            _Logger.Debug("POST {0}", request.Url.LocalPath);

            if (request.Url.LocalPath.StartsWith("/" + rest_url_preconf))
            {
                processPreconfiguracionesPost(request, response, sb);
            }
            else if (request.Url.LocalPath.StartsWith("/" + rest_url_local_config))
            {
                processLocalConfigPost(request, response, sb);
            }
            else
            {
                sb.Append(webappError(0));
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="request"></param>
        /// <param name="response"></param>
        /// <param name="sb"></param>
        private void ProcesaPeticionPut(HttpListenerRequest request, HttpListenerResponse response, StringBuilder sb)
        {
            _Logger.Debug("PUT {0}", request.Url.LocalPath);

            if (request.Url.LocalPath.StartsWith(rest_url_preconf))
            {
                processPreconfiguracionesPut(request, response, sb);
            }
            else
            {
                sb.Append(webappError(0));
            }
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="request"></param>
        /// <param name="response"></param>
        /// <param name="sb"></param>
        private void ProcesaPeticionDelete(HttpListenerRequest request, HttpListenerResponse response, StringBuilder sb)
        {
            _Logger.Debug("DELETE {0}", request.Url.LocalPath);

            if (request.Url.LocalPath.StartsWith(rest_url_preconf))
            {
                processPreconfiguracionesDelete(request, response, sb);
            }
            else
            {
                sb.Append(webappError(0));
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="msg"></param>
        /// <param name="res"></param>
        private void Render(string msg, HttpListenerResponse res)
        {
            byte[] buffer = System.Text.Encoding.UTF8.GetBytes(msg);
            res.ContentLength64 = buffer.Length;

            using (System.IO.Stream outputStream = res.OutputStream)
            {
                outputStream.Write(buffer, 0, buffer.Length);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="entrada"></param>
        /// <returns></returns>
        private string Encode(string entrada)
        {
            char[] chars = entrada.ToCharArray();
            StringBuilder result = new StringBuilder(entrada.Length + (int)(entrada.Length * 0.1));

            foreach (char c in chars)
            {
                int value = Convert.ToInt32(c);
                if (value > 127)
                    result.AppendFormat("&#{0};", value);
                else
                    result.Append(c);
            }

            return result.ToString();
        }

        /// <summary>
        /// 
        /// </summary>
        private void SetRequestRootDirectory()
        {
            // Configurable.
            string exePath = System.Reflection.Assembly.GetEntryAssembly().Location;
            string rootDirectory = Path.Combine(Path.GetDirectoryName(exePath), "appweb");
            Directory.SetCurrentDirectory(rootDirectory);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ext"></param>
        /// <returns></returns>
        Dictionary<string, string> _filetypes = new Dictionary<string, string>()
        {
            {".css","text/css"},
            {".jpeg","image/jpg"},
            {".jpg","image/jpg"},
            {".htm","text/html"},
            {".html","text/html"},
            {".ico","image/ico"},
            {".js","text/json"},
            {".json","text/json"},
            {".txt","text/text"},
            {".bmp","image/bmp"}
        };
        /// <summary>
        /// 
        /// </summary>
        /// <param name="ext"></param>
        /// <returns></returns>
        private string FileContentType(string ext)
        {
            if (_filetypes.ContainsKey(ext))
                return _filetypes[ext];
            return "text/text";
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="request"></param>
        /// <param name="response"></param>
        /// <param name="sb"></param>
        private void processEstadoGeneral(HttpListenerRequest request, HttpListenerResponse response, StringBuilder sb)
        {
            GetEstadoGeneral();
            response.ContentType = "application/json";
            string data = JsonConvert.SerializeObject(_rtData.std);
            sb.Append(data);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="request"></param>
        /// <param name="response"></param>
        /// <param name="sb"></param>
        private void processPreconfiguracionesGet(HttpListenerRequest request, HttpListenerResponse response, StringBuilder sb)
        {
            GetListaPreconfiguraciones();
            response.ContentType = "application/json";
            string data = JsonConvert.SerializeObject(_rtData.pcf);
            sb.Append(data);
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="request"></param>
        /// <param name="response"></param>
        /// <param name="sb"></param>
        private void processPreconfiguracionesPost(HttpListenerRequest request, HttpListenerResponse response, StringBuilder sb)
        {
            response.ContentType = "application/json";
            // TODO.
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="request"></param>
        /// <param name="response"></param>
        /// <param name="sb"></param>
        private void processPreconfiguracionesPut(HttpListenerRequest request, HttpListenerResponse response, StringBuilder sb)
        {
            response.ContentType = "application/json";
            // TODO.
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="request"></param>
        /// <param name="response"></param>
        /// <param name="sb"></param>
        private void processPreconfiguracionesDelete(HttpListenerRequest request, HttpListenerResponse response, StringBuilder sb)
        {
            response.ContentType = "application/json";
            // TODO.
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="request"></param>
        /// <param name="response"></param>
        /// <param name="sb"></param>
        private void processLocalConfigGet(HttpListenerRequest request, HttpListenerResponse response, StringBuilder sb)
        {
            response.ContentType = "application/json";
            string data = JsonConvert.SerializeObject(_rtData.lcf);
            sb.Append(data);
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="request"></param>
        /// <param name="response"></param>
        /// <param name="sb"></param>
        private void processLocalConfigPost(HttpListenerRequest request, HttpListenerResponse response, StringBuilder sb)
        {
            response.ContentType = "application/json";
            string text;
            using (var reader = new StreamReader(request.InputStream,
                                                 request.ContentEncoding))
            {
                text = reader.ReadToEnd();
                _rtData.lcf = JsonConvert.DeserializeObject<nbxLocalConfig>(text);
                _rtData.lcf.SaveToFile();
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="nError"></param>
        /// <returns></returns>
        private string webappError(int nError)
        {
            return string.Format("{{\"localError\": {0}}}", nError);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        private void GetEstadoGeneral()
        {
            // TODO. Obtener los datos de Verdad...
            _rtData.std.cfg = 0;
            _rtData.std.ifx = 1;
            _rtData.std.rad = 1;
            _rtData.std.pbx = 2;
        }

        /// <summary>
        /// 
        /// </summary>
        private void GetListaPreconfiguraciones()
        {
            // TODO.... Inicializo los datos de verdad...
            _rtData.pcf.Clear();
            _rtData.pcf.Add(new pcfData() { fecha = "20/11/2015 08:00", nombre = "Preconfig Server...1" });
            _rtData.pcf.Add(new pcfData() { fecha = "20/01/2016 18:20", nombre = "Preconfig Server...2" });
        }
    }

}
