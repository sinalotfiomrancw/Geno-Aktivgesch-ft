using Audicon.SmartAnalyzer.Client.CustomControls;

namespace Sicherheiten_01_SelectFolder
{
    partial class _DialogMainForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(_DialogMainForm));
            Audicon.SmartAnalyzer.Client.CustomControls.ConString conString1 = new Audicon.SmartAnalyzer.Client.CustomControls.ConString();
            this.Button_Cancel = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.smartLabel1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.sTB_FilePath = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.btn_FileSearch = new System.Windows.Forms.Button();
            this.smartDataExchanger = new Audicon.SmartAnalyzer.Client.CustomControls.SmartDataExchanger();
            this.btn_OK = new System.Windows.Forms.Button();
            this.folderBrowserDialog1 = new System.Windows.Forms.FolderBrowserDialog();
            this.smartGroupBox1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartGroupBox();
            this.sSi_Zwek_Si_Wert = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.sSi_Zwek_RK = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.sSi_Buerg_Haft = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.sSi_Bas_Immo = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.sSi_Bas = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.smartGroupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // Button_Cancel
            // 
            resources.ApplyResources(this.Button_Cancel, "Button_Cancel");
            this.Button_Cancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.Button_Cancel.Name = "Button_Cancel";
            this.Button_Cancel.ResultType = Audicon.SmartAnalyzer.Client.CustomControls.DiagResult.Cancel;
            this.Button_Cancel.UseVisualStyleBackColor = true;
            // 
            // smartLabel1
            // 
            resources.ApplyResources(this.smartLabel1, "smartLabel1");
            this.smartLabel1.Name = "smartLabel1";
            // 
            // sTB_FilePath
            // 
            this.sTB_FilePath.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.sTB_FilePath.Constraint = conString1;
            resources.ApplyResources(this.sTB_FilePath, "sTB_FilePath");
            this.sTB_FilePath.LanguageCode = "";
            this.sTB_FilePath.Name = "sTB_FilePath";
            this.sTB_FilePath.ReportingName = "";
            this.sTB_FilePath.Value = "";
            this.sTB_FilePath.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.String;
            this.sTB_FilePath.OnTextChanged += new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox.TextChangedHandler(this.sTB_FilePath_OnTextChanged);
            // 
            // btn_FileSearch
            // 
            resources.ApplyResources(this.btn_FileSearch, "btn_FileSearch");
            this.btn_FileSearch.Name = "btn_FileSearch";
            this.btn_FileSearch.UseVisualStyleBackColor = true;
            this.btn_FileSearch.Click += new System.EventHandler(this.btn_FileSearch_Click);
            // 
            // smartDataExchanger
            // 
            this.smartDataExchanger.Name = "smartDataExchanger";
            this.smartDataExchanger.ReportingName = null;
            this.smartDataExchanger.ReportingValue = "";
            // 
            // btn_OK
            // 
            resources.ApplyResources(this.btn_OK, "btn_OK");
            this.btn_OK.Name = "btn_OK";
            this.btn_OK.UseVisualStyleBackColor = true;
            this.btn_OK.Click += new System.EventHandler(this.btn_OK_Click);
            // 
            // smartGroupBox1
            // 
            this.smartGroupBox1.Controls.Add(this.sSi_Zwek_Si_Wert);
            this.smartGroupBox1.Controls.Add(this.sSi_Zwek_RK);
            this.smartGroupBox1.Controls.Add(this.sSi_Buerg_Haft);
            this.smartGroupBox1.Controls.Add(this.sSi_Bas_Immo);
            this.smartGroupBox1.Controls.Add(this.sSi_Bas);
            resources.ApplyResources(this.smartGroupBox1, "smartGroupBox1");
            this.smartGroupBox1.Name = "smartGroupBox1";
            this.smartGroupBox1.TabStop = false;
            // 
            // sSi_Zwek_Si_Wert
            // 
            this.sSi_Zwek_Si_Wert.Enables = new string[] {
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null};
            resources.ApplyResources(this.sSi_Zwek_Si_Wert, "sSi_Zwek_Si_Wert");
            this.sSi_Zwek_Si_Wert.Name = "sSi_Zwek_Si_Wert";
            this.sSi_Zwek_Si_Wert.ReportingName = "";
            this.sSi_Zwek_Si_Wert.UseVisualStyleBackColor = true;
            // 
            // sSi_Zwek_RK
            // 
            this.sSi_Zwek_RK.Enables = new string[] {
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null};
            resources.ApplyResources(this.sSi_Zwek_RK, "sSi_Zwek_RK");
            this.sSi_Zwek_RK.Name = "sSi_Zwek_RK";
            this.sSi_Zwek_RK.ReportingName = "";
            this.sSi_Zwek_RK.UseVisualStyleBackColor = true;
            // 
            // sSi_Buerg_Haft
            // 
            this.sSi_Buerg_Haft.Enables = new string[] {
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null};
            resources.ApplyResources(this.sSi_Buerg_Haft, "sSi_Buerg_Haft");
            this.sSi_Buerg_Haft.Name = "sSi_Buerg_Haft";
            this.sSi_Buerg_Haft.ReportingName = "";
            this.sSi_Buerg_Haft.UseVisualStyleBackColor = true;
            // 
            // sSi_Bas_Immo
            // 
            this.sSi_Bas_Immo.Enables = new string[] {
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null};
            resources.ApplyResources(this.sSi_Bas_Immo, "sSi_Bas_Immo");
            this.sSi_Bas_Immo.Name = "sSi_Bas_Immo";
            this.sSi_Bas_Immo.ReportingName = "";
            this.sSi_Bas_Immo.UseVisualStyleBackColor = true;
            // 
            // sSi_Bas
            // 
            this.sSi_Bas.Enables = new string[] {
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null};
            resources.ApplyResources(this.sSi_Bas, "sSi_Bas");
            this.sSi_Bas.Name = "sSi_Bas";
            this.sSi_Bas.ReportingName = "";
            this.sSi_Bas.UseVisualStyleBackColor = true;
            // 
            // _DialogMainForm
            // 
            resources.ApplyResources(this, "$this");
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.SystemColors.ControlLightLight;
            this.Controls.Add(this.smartGroupBox1);
            this.Controls.Add(this.btn_OK);
            this.Controls.Add(this.btn_FileSearch);
            this.Controls.Add(this.sTB_FilePath);
            this.Controls.Add(this.smartLabel1);
            this.Controls.Add(this.Button_Cancel);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.KeyPreview = true;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "_DialogMainForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.Load += new System.EventHandler(this._DialogMainForm_Load);
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this._DialogMainForm_KeyDown);
            this.smartGroupBox1.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton Button_Cancel;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox sTB_FilePath;
        private System.Windows.Forms.Button btn_FileSearch;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartDataExchanger smartDataExchanger;
        private System.Windows.Forms.Button btn_OK;
        private System.Windows.Forms.FolderBrowserDialog folderBrowserDialog1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartGroupBox smartGroupBox1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox sSi_Bas_Immo;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox sSi_Bas;
        private SmartCheckBox sSi_Zwek_RK;
        private SmartCheckBox sSi_Buerg_Haft;
        private SmartCheckBox sSi_Zwek_Si_Wert;
    }
}

