namespace UG5KCfgService
{
    partial class UG5KCentralCfgService
    {
        /// <summary> 
        /// Variable del diseñador necesaria.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Limpiar los recursos que se estén usando.
        /// </summary>
        /// <param name="disposing">true si los recursos administrados se deben desechar; false en caso contrario.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Código generado por el Diseñador de componentes

        /// <summary> 
        /// Método necesario para admitir el Diseñador. No se puede modificar
        /// el contenido de este método con el editor de código.
        /// </summary>
        private void InitializeComponent()
        {
            this.ug5kServEventLog = new System.Diagnostics.EventLog();
            ((System.ComponentModel.ISupportInitialize)(this.ug5kServEventLog)).BeginInit();
            // 
            // UG5KCentralCfgService
            // 
            this.ServiceName = "UG5KCentralCfgService";
            ((System.ComponentModel.ISupportInitialize)(this.ug5kServEventLog)).EndInit();

        }

        #endregion

        private System.Diagnostics.EventLog ug5kServEventLog;
    }
}
