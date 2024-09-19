namespace AKT_017_new_credit_neg_characteristic
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
            Audicon.SmartAnalyzer.Client.CustomControls.ConDate conDate1 = new Audicon.SmartAnalyzer.Client.CustomControls.ConDate();
            Audicon.SmartAnalyzer.Client.CustomControls.ConNumeric conNumeric1 = new Audicon.SmartAnalyzer.Client.CustomControls.ConNumeric();
            Audicon.SmartAnalyzer.Client.CustomControls.ConNumeric conNumeric2 = new Audicon.SmartAnalyzer.Client.CustomControls.ConNumeric();
            Audicon.SmartAnalyzer.Client.CustomControls.ConNumeric conNumeric3 = new Audicon.SmartAnalyzer.Client.CustomControls.ConNumeric();
            Audicon.SmartAnalyzer.Client.CustomControls.ConString conString1 = new Audicon.SmartAnalyzer.Client.CustomControls.ConString();
            this.Button_Description = new Audicon.SmartAnalyzer.Client.CustomControls.SmartHelp();
            this.Button_Cancel = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.smartLabel1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.sTB_CustomerSince = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.sCB_Rating = new Audicon.SmartAnalyzer.Client.CustomControls.SmartComboBox();
            this.sTB_Overdraft = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.sTB_OverdraftDays = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.sTB_EWBValue = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.sCheckB_Schufa = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.sCheckB_CustomerSince = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.sCheckB_Rating = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.sCheckB_Overdraft = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.sCheckB_OverdraftDays = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.sCheckB_EWBValue = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.btn_OK = new System.Windows.Forms.Button();
            this.sTB_CheckDefined = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.smartLabel2 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.smartLabel3 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
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
            // smartLabel1
            // 
            resources.ApplyResources(this.smartLabel1, "smartLabel1");
            this.smartLabel1.Name = "smartLabel1";
            // 
            // sTB_CustomerSince
            // 
            conDate1.DefaultValue = new System.DateTime(2023, 1, 1, 0, 0, 0, 0);
            conDate1.Max = new System.DateTime(2050, 12, 31, 0, 0, 0, 0);
            conDate1.Min = new System.DateTime(1753, 1, 1, 0, 0, 0, 0);
            this.sTB_CustomerSince.Constraint = conDate1;
            resources.ApplyResources(this.sTB_CustomerSince, "sTB_CustomerSince");
            this.sTB_CustomerSince.IsOptional = true;
            this.sTB_CustomerSince.LanguageCode = "";
            this.sTB_CustomerSince.Name = "sTB_CustomerSince";
            this.sTB_CustomerSince.ReportingName = "";
            this.sTB_CustomerSince.Value = "";
            this.sTB_CustomerSince.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.Date;
            // 
            // sCB_Rating
            // 
            this.sCB_Rating.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            resources.ApplyResources(this.sCB_Rating, "sCB_Rating");
            this.sCB_Rating.FormattingEnabled = true;
            this.sCB_Rating.IsOptional = true;
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
            // sTB_Overdraft
            // 
            conNumeric1.DefaultValue = ((long)(0));
            this.sTB_Overdraft.Constraint = conNumeric1;
            resources.ApplyResources(this.sTB_Overdraft, "sTB_Overdraft");
            this.sTB_Overdraft.IsOptional = true;
            this.sTB_Overdraft.LanguageCode = "";
            this.sTB_Overdraft.Name = "sTB_Overdraft";
            this.sTB_Overdraft.ReportingName = "";
            this.sTB_Overdraft.Value = "";
            this.sTB_Overdraft.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.Numeric;
            // 
            // sTB_OverdraftDays
            // 
            conNumeric2.DefaultValue = ((long)(0));
            this.sTB_OverdraftDays.Constraint = conNumeric2;
            resources.ApplyResources(this.sTB_OverdraftDays, "sTB_OverdraftDays");
            this.sTB_OverdraftDays.IsOptional = true;
            this.sTB_OverdraftDays.LanguageCode = "";
            this.sTB_OverdraftDays.Name = "sTB_OverdraftDays";
            this.sTB_OverdraftDays.ReportingName = "";
            this.sTB_OverdraftDays.Value = "";
            this.sTB_OverdraftDays.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.Numeric;
            // 
            // sTB_EWBValue
            // 
            conNumeric3.DefaultValue = ((long)(0));
            this.sTB_EWBValue.Constraint = conNumeric3;
            resources.ApplyResources(this.sTB_EWBValue, "sTB_EWBValue");
            this.sTB_EWBValue.IsOptional = true;
            this.sTB_EWBValue.LanguageCode = "";
            this.sTB_EWBValue.Name = "sTB_EWBValue";
            this.sTB_EWBValue.ReportingName = "";
            this.sTB_EWBValue.Value = "";
            this.sTB_EWBValue.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.Numeric;
            // 
            // sCheckB_Schufa
            // 
            this.sCheckB_Schufa.Enables = new string[] {
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
            resources.ApplyResources(this.sCheckB_Schufa, "sCheckB_Schufa");
            this.sCheckB_Schufa.Name = "sCheckB_Schufa";
            this.sCheckB_Schufa.ReportingName = "";
            this.sCheckB_Schufa.UseVisualStyleBackColor = true;
            // 
            // sCheckB_CustomerSince
            // 
            this.sCheckB_CustomerSince.Enables = new string[] {
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
            resources.ApplyResources(this.sCheckB_CustomerSince, "sCheckB_CustomerSince");
            this.sCheckB_CustomerSince.Name = "sCheckB_CustomerSince";
            this.sCheckB_CustomerSince.ReportingName = "";
            this.sCheckB_CustomerSince.UseVisualStyleBackColor = true;
            this.sCheckB_CustomerSince.CheckedChanged += new System.EventHandler(this.sCheckB_CustomerSince_CheckedChanged);
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
            // sCheckB_Overdraft
            // 
            this.sCheckB_Overdraft.Enables = new string[] {
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
            resources.ApplyResources(this.sCheckB_Overdraft, "sCheckB_Overdraft");
            this.sCheckB_Overdraft.Name = "sCheckB_Overdraft";
            this.sCheckB_Overdraft.ReportingName = "";
            this.sCheckB_Overdraft.UseVisualStyleBackColor = true;
            this.sCheckB_Overdraft.CheckedChanged += new System.EventHandler(this.sCheckB_Overdraft_CheckedChanged);
            // 
            // sCheckB_OverdraftDays
            // 
            this.sCheckB_OverdraftDays.Enables = new string[] {
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
            resources.ApplyResources(this.sCheckB_OverdraftDays, "sCheckB_OverdraftDays");
            this.sCheckB_OverdraftDays.Name = "sCheckB_OverdraftDays";
            this.sCheckB_OverdraftDays.ReportingName = "";
            this.sCheckB_OverdraftDays.UseVisualStyleBackColor = true;
            this.sCheckB_OverdraftDays.CheckedChanged += new System.EventHandler(this.sCheckB_OverdraftDays_CheckedChanged);
            // 
            // sCheckB_EWBValue
            // 
            this.sCheckB_EWBValue.Enables = new string[] {
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
            resources.ApplyResources(this.sCheckB_EWBValue, "sCheckB_EWBValue");
            this.sCheckB_EWBValue.Name = "sCheckB_EWBValue";
            this.sCheckB_EWBValue.ReportingName = "";
            this.sCheckB_EWBValue.UseVisualStyleBackColor = true;
            this.sCheckB_EWBValue.CheckedChanged += new System.EventHandler(this.sCheckB_EWBValue_CheckedChanged);
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
            // smartLabel2
            // 
            resources.ApplyResources(this.smartLabel2, "smartLabel2");
            this.smartLabel2.Name = "smartLabel2";
            // 
            // smartLabel3
            // 
            resources.ApplyResources(this.smartLabel3, "smartLabel3");
            this.smartLabel3.Name = "smartLabel3";
            // 
            // _DialogMainForm
            // 
            resources.ApplyResources(this, "$this");
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.smartLabel3);
            this.Controls.Add(this.smartLabel2);
            this.Controls.Add(this.sTB_CheckDefined);
            this.Controls.Add(this.btn_OK);
            this.Controls.Add(this.sCheckB_EWBValue);
            this.Controls.Add(this.sCheckB_OverdraftDays);
            this.Controls.Add(this.sCheckB_Overdraft);
            this.Controls.Add(this.sCheckB_Rating);
            this.Controls.Add(this.sCheckB_CustomerSince);
            this.Controls.Add(this.sCheckB_Schufa);
            this.Controls.Add(this.sTB_EWBValue);
            this.Controls.Add(this.sTB_OverdraftDays);
            this.Controls.Add(this.sTB_Overdraft);
            this.Controls.Add(this.sCB_Rating);
            this.Controls.Add(this.sTB_CustomerSince);
            this.Controls.Add(this.smartLabel1);
            this.Controls.Add(this.Button_Cancel);
            this.Controls.Add(this.Button_Description);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.KeyPreview = true;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "_DialogMainForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.Load += new System.EventHandler(this._DialogMainForm_Load_1);
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this._DialogMainForm_KeyDown);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private Audicon.SmartAnalyzer.Client.CustomControls.SmartHelp Button_Description;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton Button_Cancel;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox sTB_CustomerSince;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartComboBox sCB_Rating;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox sTB_Overdraft;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox sTB_OverdraftDays;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox sTB_EWBValue;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox sCheckB_Schufa;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox sCheckB_CustomerSince;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox sCheckB_Rating;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox sCheckB_Overdraft;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox sCheckB_OverdraftDays;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox sCheckB_EWBValue;
        private System.Windows.Forms.Button btn_OK;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox sTB_CheckDefined;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel2;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel3;
    }
}

