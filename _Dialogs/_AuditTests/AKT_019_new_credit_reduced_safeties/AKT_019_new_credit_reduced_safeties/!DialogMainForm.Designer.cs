namespace AKT_019_new_credit_reduced_safeties
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
            Audicon.SmartAnalyzer.Client.CustomControls.ConNumeric conNumeric1 = new Audicon.SmartAnalyzer.Client.CustomControls.ConNumeric();
            Audicon.SmartAnalyzer.Client.CustomControls.ConString conString1 = new Audicon.SmartAnalyzer.Client.CustomControls.ConString();
            this.Button_Description = new Audicon.SmartAnalyzer.Client.CustomControls.SmartHelp();
            this.Button_Cancel = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.sCB_Rating = new Audicon.SmartAnalyzer.Client.CustomControls.SmartComboBox();
            this.sTB_ChangeOfRiskVolume = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.sCheckB_Rating = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.smartLabel1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.sCheckB_ChangeOfRiskVolume = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.btn_OK = new System.Windows.Forms.Button();
            this.sTB_CheckDefined = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.SuspendLayout();
            // 
            // Button_Description
            // 
            resources.ApplyResources(this.Button_Description, "Button_Description");
            this.Button_Description.HelpId = null;
            this.Button_Description.Name = "Button_Description";
            this.Button_Description.UseVisualStyleBackColor = true;
            // 
            // Button_Cancel
            // 
            this.Button_Cancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            resources.ApplyResources(this.Button_Cancel, "Button_Cancel");
            this.Button_Cancel.Name = "Button_Cancel";
            this.Button_Cancel.ResultType = Audicon.SmartAnalyzer.Client.CustomControls.DiagResult.Cancel;
            this.Button_Cancel.UseVisualStyleBackColor = true;
            // 
            // sCB_Rating
            // 
            this.sCB_Rating.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            resources.ApplyResources(this.sCB_Rating, "sCB_Rating");
            this.sCB_Rating.FormattingEnabled = true;
            this.sCB_Rating.Items.AddRange(new object[] {
            resources.GetString("sCB_Rating.Items"),
            resources.GetString("sCB_Rating.Items1"),
            resources.GetString("sCB_Rating.Items2"),
            resources.GetString("sCB_Rating.Items3"),
            resources.GetString("sCB_Rating.Items4"),
            resources.GetString("sCB_Rating.Items5"),
            resources.GetString("sCB_Rating.Items6"),
            resources.GetString("sCB_Rating.Items7"),
            resources.GetString("sCB_Rating.Items8"),
            resources.GetString("sCB_Rating.Items9"),
            resources.GetString("sCB_Rating.Items10"),
            resources.GetString("sCB_Rating.Items11"),
            resources.GetString("sCB_Rating.Items12"),
            resources.GetString("sCB_Rating.Items13"),
            resources.GetString("sCB_Rating.Items14"),
            resources.GetString("sCB_Rating.Items15"),
            resources.GetString("sCB_Rating.Items16"),
            resources.GetString("sCB_Rating.Items17"),
            resources.GetString("sCB_Rating.Items18"),
            resources.GetString("sCB_Rating.Items19"),
            resources.GetString("sCB_Rating.Items20"),
            resources.GetString("sCB_Rating.Items21"),
            resources.GetString("sCB_Rating.Items22"),
            resources.GetString("sCB_Rating.Items23"),
            resources.GetString("sCB_Rating.Items24"),
            resources.GetString("sCB_Rating.Items25")});
            this.sCB_Rating.Name = "sCB_Rating";
            this.sCB_Rating.ReportingName = "";
            this.sCB_Rating.Selection = 0;
            // 
            // sTB_ChangeOfRiskVolume
            // 
            conNumeric1.DefaultValue = ((long)(0));
            this.sTB_ChangeOfRiskVolume.Constraint = conNumeric1;
            resources.ApplyResources(this.sTB_ChangeOfRiskVolume, "sTB_ChangeOfRiskVolume");
            this.sTB_ChangeOfRiskVolume.IsOptional = true;
            this.sTB_ChangeOfRiskVolume.LanguageCode = "";
            this.sTB_ChangeOfRiskVolume.Name = "sTB_ChangeOfRiskVolume";
            this.sTB_ChangeOfRiskVolume.ReportingName = "";
            this.sTB_ChangeOfRiskVolume.Value = "";
            this.sTB_ChangeOfRiskVolume.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.Numeric;
            // 
            // sCheckB_Rating
            // 
            this.sCheckB_Rating.Enables = new string[] {
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
            resources.ApplyResources(this.sCheckB_Rating, "sCheckB_Rating");
            this.sCheckB_Rating.Name = "sCheckB_Rating";
            this.sCheckB_Rating.ReportingName = "";
            this.sCheckB_Rating.UseVisualStyleBackColor = true;
            this.sCheckB_Rating.CheckedChanged += new System.EventHandler(this.sCheckB_Rating_CheckedChanged);
            // 
            // smartLabel1
            // 
            resources.ApplyResources(this.smartLabel1, "smartLabel1");
            this.smartLabel1.Name = "smartLabel1";
            // 
            // sCheckB_ChangeOfRiskVolume
            // 
            this.sCheckB_ChangeOfRiskVolume.Enables = new string[] {
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
            resources.ApplyResources(this.sCheckB_ChangeOfRiskVolume, "sCheckB_ChangeOfRiskVolume");
            this.sCheckB_ChangeOfRiskVolume.Name = "sCheckB_ChangeOfRiskVolume";
            this.sCheckB_ChangeOfRiskVolume.ReportingName = "";
            this.sCheckB_ChangeOfRiskVolume.UseVisualStyleBackColor = true;
            this.sCheckB_ChangeOfRiskVolume.CheckedChanged += new System.EventHandler(this.sCheckB_ChangeOfRiskVolume_CheckedChanged);
            // 
            // btn_OK
            // 
            resources.ApplyResources(this.btn_OK, "btn_OK");
            this.btn_OK.Name = "btn_OK";
            this.btn_OK.UseVisualStyleBackColor = true;
            this.btn_OK.Click += new System.EventHandler(this.btn_OK_Click);
            // 
            // sTB_CheckDefined
            // 
            this.sTB_CheckDefined.Constraint = conString1;
            resources.ApplyResources(this.sTB_CheckDefined, "sTB_CheckDefined");
            this.sTB_CheckDefined.LanguageCode = "";
            this.sTB_CheckDefined.Name = "sTB_CheckDefined";
            this.sTB_CheckDefined.ReportingName = "";
            this.sTB_CheckDefined.ShowInReport = false;
            this.sTB_CheckDefined.TabStop = false;
            this.sTB_CheckDefined.Value = "";
            this.sTB_CheckDefined.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.String;
            // 
            // _DialogMainForm
            // 
            resources.ApplyResources(this, "$this");
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.sTB_CheckDefined);
            this.Controls.Add(this.btn_OK);
            this.Controls.Add(this.sCheckB_ChangeOfRiskVolume);
            this.Controls.Add(this.smartLabel1);
            this.Controls.Add(this.sCheckB_Rating);
            this.Controls.Add(this.sTB_ChangeOfRiskVolume);
            this.Controls.Add(this.sCB_Rating);
            this.Controls.Add(this.Button_Cancel);
            this.Controls.Add(this.Button_Description);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.KeyPreview = true;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "_DialogMainForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.Load += new System.EventHandler(this._DialogMainForm_Load);
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this._DialogMainForm_KeyDown);
            this.ResumeLayout(false);

        }

        #endregion

        private Audicon.SmartAnalyzer.Client.CustomControls.SmartHelp Button_Description;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton Button_Cancel;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartComboBox sCB_Rating;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox sTB_ChangeOfRiskVolume;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox sCheckB_Rating;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox sCheckB_ChangeOfRiskVolume;
        private System.Windows.Forms.Button btn_OK;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox sTB_CheckDefined;
    }
}

