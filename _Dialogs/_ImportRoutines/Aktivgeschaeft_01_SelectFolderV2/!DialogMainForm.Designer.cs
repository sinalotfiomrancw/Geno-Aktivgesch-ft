namespace Aktivgeschaeft_01_SelectFolderV2
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
            Audicon.SmartAnalyzer.Client.CustomControls.ConDate conDate1 = new Audicon.SmartAnalyzer.Client.CustomControls.ConDate();
            this.Button_Cancel = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.smartLabel1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.sTB_FilePath = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.btn_FileSearch = new System.Windows.Forms.Button();
            this.smartDataExchanger = new Audicon.SmartAnalyzer.Client.CustomControls.SmartDataExchanger();
            this.btn_OK = new System.Windows.Forms.Button();
            this.smartLabel2 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.sTB_DataExportDate = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.folderBrowserDialog1 = new System.Windows.Forms.FolderBrowserDialog();
            this.smartGroupBox1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartGroupBox();
            this.sCB_KGW = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.sCB_KRM = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
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
            // smartLabel2
            // 
            resources.ApplyResources(this.smartLabel2, "smartLabel2");
            this.smartLabel2.Name = "smartLabel2";
            // 
            // sTB_DataExportDate
            // 
            conDate1.DefaultValue = new System.DateTime(2023, 1, 1, 0, 0, 0, 0);
            conDate1.Max = new System.DateTime(2050, 12, 31, 0, 0, 0, 0);
            conDate1.Min = new System.DateTime(1753, 1, 1, 0, 0, 0, 0);
            this.sTB_DataExportDate.Constraint = conDate1;
            resources.ApplyResources(this.sTB_DataExportDate, "sTB_DataExportDate");
            this.sTB_DataExportDate.LanguageCode = "";
            this.sTB_DataExportDate.Name = "sTB_DataExportDate";
            this.sTB_DataExportDate.ReportingName = "";
            this.sTB_DataExportDate.Value = "";
            this.sTB_DataExportDate.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.Date;
            // 
            // smartGroupBox1
            // 
            this.smartGroupBox1.Controls.Add(this.sCB_KGW);
            this.smartGroupBox1.Controls.Add(this.sCB_KRM);
            resources.ApplyResources(this.smartGroupBox1, "smartGroupBox1");
            this.smartGroupBox1.Name = "smartGroupBox1";
            this.smartGroupBox1.TabStop = false;
            // 
            // sCB_KGW
            // 
            resources.ApplyResources(this.sCB_KGW, "sCB_KGW");
            this.sCB_KGW.Enables = new string[] {
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
            this.sCB_KGW.Name = "sCB_KGW";
            this.sCB_KGW.ReportingName = "";
            this.sCB_KGW.UseVisualStyleBackColor = true;
            // 
            // sCB_KRM
            // 
            resources.ApplyResources(this.sCB_KRM, "sCB_KRM");
            this.sCB_KRM.Enables = new string[] {
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
            this.sCB_KRM.Name = "sCB_KRM";
            this.sCB_KRM.ReportingName = "";
            this.sCB_KRM.UseVisualStyleBackColor = true;
            // 
            // _DialogMainForm
            // 
            resources.ApplyResources(this, "$this");
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.SystemColors.ControlLightLight;
            this.Controls.Add(this.smartGroupBox1);
            this.Controls.Add(this.sTB_DataExportDate);
            this.Controls.Add(this.smartLabel2);
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
            this.smartGroupBox1.PerformLayout();
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
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel2;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox sTB_DataExportDate;
        private System.Windows.Forms.FolderBrowserDialog folderBrowserDialog1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartGroupBox smartGroupBox1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox sCB_KGW;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox sCB_KRM;
    }
}

