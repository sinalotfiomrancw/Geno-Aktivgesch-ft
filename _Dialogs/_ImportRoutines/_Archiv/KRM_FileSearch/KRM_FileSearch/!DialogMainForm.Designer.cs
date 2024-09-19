namespace KRM_FileSearch
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
            this.btn_Options = new System.Windows.Forms.Button();
            this.smartLabel1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.sTB_FilePath = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.btn_FileSearch = new System.Windows.Forms.Button();
            this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
            this.smartDataExchanger = new Audicon.SmartAnalyzer.Client.CustomControls.SmartDataExchanger();
            this.sLWarningLatestVersion = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            this.btn_OK = new System.Windows.Forms.Button();
            this.smartLabel2 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.sTB_DataExportDate = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
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
            // btn_Options
            // 
            resources.ApplyResources(this.btn_Options, "btn_Options");
            this.btn_Options.Name = "btn_Options";
            this.btn_Options.UseVisualStyleBackColor = true;
            this.btn_Options.Click += new System.EventHandler(this.btn_Options_Click);
            // 
            // smartLabel1
            // 
            resources.ApplyResources(this.smartLabel1, "smartLabel1");
            this.smartLabel1.Name = "smartLabel1";
            // 
            // sTB_FilePath
            // 
            resources.ApplyResources(this.sTB_FilePath, "sTB_FilePath");
            this.sTB_FilePath.Constraint = conString1;
            this.sTB_FilePath.LanguageCode = "";
            this.sTB_FilePath.Name = "sTB_FilePath";
            this.sTB_FilePath.ReportingName = "";
            this.sTB_FilePath.Value = "";
            this.sTB_FilePath.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.String;
            // 
            // btn_FileSearch
            // 
            resources.ApplyResources(this.btn_FileSearch, "btn_FileSearch");
            this.btn_FileSearch.Name = "btn_FileSearch";
            this.btn_FileSearch.UseVisualStyleBackColor = true;
            this.btn_FileSearch.Click += new System.EventHandler(this.btn_FileSearch_Click);
            // 
            // openFileDialog1
            // 
            this.openFileDialog1.FileName = "openFileDialog1";
            // 
            // smartDataExchanger
            // 
            this.smartDataExchanger.Name = "smartDataExchanger";
            this.smartDataExchanger.ReportingName = null;
            this.smartDataExchanger.ReportingValue = "";
            // 
            // sLWarningLatestVersion
            // 
            resources.ApplyResources(this.sLWarningLatestVersion, "sLWarningLatestVersion");
            this.sLWarningLatestVersion.Name = "sLWarningLatestVersion";
            // 
            // pictureBox1
            // 
            resources.ApplyResources(this.pictureBox1, "pictureBox1");
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.TabStop = false;
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
            // _DialogMainForm
            // 
            resources.ApplyResources(this, "$this");
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.sTB_DataExportDate);
            this.Controls.Add(this.smartLabel2);
            this.Controls.Add(this.btn_OK);
            this.Controls.Add(this.pictureBox1);
            this.Controls.Add(this.sLWarningLatestVersion);
            this.Controls.Add(this.btn_FileSearch);
            this.Controls.Add(this.sTB_FilePath);
            this.Controls.Add(this.smartLabel1);
            this.Controls.Add(this.btn_Options);
            this.Controls.Add(this.Button_Cancel);
            this.KeyPreview = true;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "_DialogMainForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.Load += new System.EventHandler(this._DialogMainForm_Load);
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this._DialogMainForm_KeyDown);
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton Button_Cancel;
        private System.Windows.Forms.Button btn_Options;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox sTB_FilePath;
        private System.Windows.Forms.Button btn_FileSearch;
        private System.Windows.Forms.OpenFileDialog openFileDialog1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartDataExchanger smartDataExchanger;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel sLWarningLatestVersion;
        private System.Windows.Forms.PictureBox pictureBox1;
        private System.Windows.Forms.Button btn_OK;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel2;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox sTB_DataExportDate;
    }
}

