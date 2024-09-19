namespace risk_relevance
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
            Audicon.SmartAnalyzer.Client.CustomControls.ConDecimal conDecimal16 = new Audicon.SmartAnalyzer.Client.CustomControls.ConDecimal();
            Audicon.SmartAnalyzer.Client.CustomControls.ConDecimal conDecimal17 = new Audicon.SmartAnalyzer.Client.CustomControls.ConDecimal();
            Audicon.SmartAnalyzer.Client.CustomControls.ConDecimal conDecimal18 = new Audicon.SmartAnalyzer.Client.CustomControls.ConDecimal();
            Audicon.SmartAnalyzer.Client.CustomControls.ConNumeric conNumeric6 = new Audicon.SmartAnalyzer.Client.CustomControls.ConNumeric();
            this.Button_OK = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.Button_Cancel = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.smartGroupBox1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartGroupBox();
            this.sCB_UseIdividualRiskRel = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.smartLabel2 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.smartLabel3 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.smartLabel4 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.smartLabel5 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.sComB_Rating = new Audicon.SmartAnalyzer.Client.CustomControls.SmartComboBox();
            this.sTB_RiskVolume = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.sTB_BlankVolume = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.sTB_Overdraft = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.btn_Save = new System.Windows.Forms.Button();
            this.saveFileDialog1 = new System.Windows.Forms.SaveFileDialog();
            this.btn_Load = new System.Windows.Forms.Button();
            this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
            this.smartLabel1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.sTB_Boni = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.sComB_JoinType = new Audicon.SmartAnalyzer.Client.CustomControls.SmartComboBox();
            this.smartGroupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // Button_OK
            // 
            resources.ApplyResources(this.Button_OK, "Button_OK");
            this.Button_OK.DialogResult = System.Windows.Forms.DialogResult.OK;
            this.Button_OK.Name = "Button_OK";
            this.Button_OK.ResultType = Audicon.SmartAnalyzer.Client.CustomControls.DiagResult.OK;
            this.Button_OK.UseVisualStyleBackColor = true;
            // 
            // Button_Cancel
            // 
            resources.ApplyResources(this.Button_Cancel, "Button_Cancel");
            this.Button_Cancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.Button_Cancel.Name = "Button_Cancel";
            this.Button_Cancel.ResultType = Audicon.SmartAnalyzer.Client.CustomControls.DiagResult.Cancel;
            this.Button_Cancel.UseVisualStyleBackColor = true;
            // 
            // smartGroupBox1
            // 
            resources.ApplyResources(this.smartGroupBox1, "smartGroupBox1");
            this.smartGroupBox1.Controls.Add(this.sCB_UseIdividualRiskRel);
            this.smartGroupBox1.Name = "smartGroupBox1";
            this.smartGroupBox1.TabStop = false;
            // 
            // sCB_UseIdividualRiskRel
            // 
            resources.ApplyResources(this.sCB_UseIdividualRiskRel, "sCB_UseIdividualRiskRel");
            this.sCB_UseIdividualRiskRel.Enables = new string[] {
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
            this.sCB_UseIdividualRiskRel.Name = "sCB_UseIdividualRiskRel";
            this.sCB_UseIdividualRiskRel.ReportingName = "";
            this.sCB_UseIdividualRiskRel.UseVisualStyleBackColor = true;
            this.sCB_UseIdividualRiskRel.CheckedChanged += new System.EventHandler(this.sCB_UseIdividualRiskRel_CheckedChanged);
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
            // smartLabel4
            // 
            resources.ApplyResources(this.smartLabel4, "smartLabel4");
            this.smartLabel4.Name = "smartLabel4";
            // 
            // smartLabel5
            // 
            resources.ApplyResources(this.smartLabel5, "smartLabel5");
            this.smartLabel5.Name = "smartLabel5";
            // 
            // sComB_Rating
            // 
            resources.ApplyResources(this.sComB_Rating, "sComB_Rating");
            this.sComB_Rating.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.sComB_Rating.FormattingEnabled = true;
            this.sComB_Rating.Items.AddRange(new object[] {
            resources.GetString("sComB_Rating.Items"),
            resources.GetString("sComB_Rating.Items1"),
            resources.GetString("sComB_Rating.Items2"),
            resources.GetString("sComB_Rating.Items3"),
            resources.GetString("sComB_Rating.Items4"),
            resources.GetString("sComB_Rating.Items5"),
            resources.GetString("sComB_Rating.Items6"),
            resources.GetString("sComB_Rating.Items7"),
            resources.GetString("sComB_Rating.Items8"),
            resources.GetString("sComB_Rating.Items9"),
            resources.GetString("sComB_Rating.Items10"),
            resources.GetString("sComB_Rating.Items11"),
            resources.GetString("sComB_Rating.Items12"),
            resources.GetString("sComB_Rating.Items13"),
            resources.GetString("sComB_Rating.Items14"),
            resources.GetString("sComB_Rating.Items15"),
            resources.GetString("sComB_Rating.Items16"),
            resources.GetString("sComB_Rating.Items17"),
            resources.GetString("sComB_Rating.Items18"),
            resources.GetString("sComB_Rating.Items19"),
            resources.GetString("sComB_Rating.Items20"),
            resources.GetString("sComB_Rating.Items21"),
            resources.GetString("sComB_Rating.Items22"),
            resources.GetString("sComB_Rating.Items23"),
            resources.GetString("sComB_Rating.Items24"),
            resources.GetString("sComB_Rating.Items25")});
            this.sComB_Rating.Name = "sComB_Rating";
            this.sComB_Rating.ReportingName = "";
            this.sComB_Rating.Selection = 0;
            // 
            // sTB_RiskVolume
            // 
            this.sTB_RiskVolume.AllowEmpty = true;
            resources.ApplyResources(this.sTB_RiskVolume, "sTB_RiskVolume");
            conDecimal16.DefaultValue = 0D;
            this.sTB_RiskVolume.Constraint = conDecimal16;
            this.sTB_RiskVolume.LanguageCode = "";
            this.sTB_RiskVolume.Name = "sTB_RiskVolume";
            this.sTB_RiskVolume.ReportingName = "";
            this.sTB_RiskVolume.Value = "";
            this.sTB_RiskVolume.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.Decimal;
            // 
            // sTB_BlankVolume
            // 
            this.sTB_BlankVolume.AllowEmpty = true;
            resources.ApplyResources(this.sTB_BlankVolume, "sTB_BlankVolume");
            conDecimal17.DefaultValue = 0D;
            this.sTB_BlankVolume.Constraint = conDecimal17;
            this.sTB_BlankVolume.LanguageCode = "";
            this.sTB_BlankVolume.Name = "sTB_BlankVolume";
            this.sTB_BlankVolume.ReportingName = "";
            this.sTB_BlankVolume.Value = "";
            this.sTB_BlankVolume.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.Decimal;
            // 
            // sTB_Overdraft
            // 
            this.sTB_Overdraft.AllowEmpty = true;
            resources.ApplyResources(this.sTB_Overdraft, "sTB_Overdraft");
            conDecimal18.DefaultValue = 0D;
            this.sTB_Overdraft.Constraint = conDecimal18;
            this.sTB_Overdraft.LanguageCode = "";
            this.sTB_Overdraft.Name = "sTB_Overdraft";
            this.sTB_Overdraft.ReportingName = "";
            this.sTB_Overdraft.Value = "";
            this.sTB_Overdraft.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.Decimal;
            // 
            // btn_Save
            // 
            resources.ApplyResources(this.btn_Save, "btn_Save");
            this.btn_Save.Name = "btn_Save";
            this.btn_Save.UseVisualStyleBackColor = true;
            this.btn_Save.Click += new System.EventHandler(this.btn_Save_Click);
            // 
            // btn_Load
            // 
            resources.ApplyResources(this.btn_Load, "btn_Load");
            this.btn_Load.Name = "btn_Load";
            this.btn_Load.UseVisualStyleBackColor = true;
            this.btn_Load.Click += new System.EventHandler(this.btn_Load_Click);
            // 
            // openFileDialog1
            // 
            this.openFileDialog1.FileName = "openFileDialog1";
            // 
            // smartLabel1
            // 
            resources.ApplyResources(this.smartLabel1, "smartLabel1");
            this.smartLabel1.Name = "smartLabel1";
            // 
            // sTB_Boni
            // 
            this.sTB_Boni.AllowEmpty = true;
            resources.ApplyResources(this.sTB_Boni, "sTB_Boni");
            conNumeric6.DefaultValue = ((long)(0));
            this.sTB_Boni.Constraint = conNumeric6;
            this.sTB_Boni.LanguageCode = "";
            this.sTB_Boni.Name = "sTB_Boni";
            this.sTB_Boni.ReportingName = "";
            this.sTB_Boni.Value = "";
            this.sTB_Boni.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.Numeric;
            // 
            // sComB_JoinType
            // 
            resources.ApplyResources(this.sComB_JoinType, "sComB_JoinType");
            this.sComB_JoinType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.sComB_JoinType.FormattingEnabled = true;
            this.sComB_JoinType.Items.AddRange(new object[] {
            resources.GetString("sComB_JoinType.Items"),
            resources.GetString("sComB_JoinType.Items1")});
            this.sComB_JoinType.Name = "sComB_JoinType";
            this.sComB_JoinType.ReportingName = "";
            this.sComB_JoinType.Selection = 0;
            // 
            // _DialogMainForm
            // 
            resources.ApplyResources(this, "$this");
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.sComB_JoinType);
            this.Controls.Add(this.sTB_Boni);
            this.Controls.Add(this.smartLabel1);
            this.Controls.Add(this.btn_Load);
            this.Controls.Add(this.btn_Save);
            this.Controls.Add(this.sTB_Overdraft);
            this.Controls.Add(this.sTB_BlankVolume);
            this.Controls.Add(this.sTB_RiskVolume);
            this.Controls.Add(this.sComB_Rating);
            this.Controls.Add(this.smartLabel5);
            this.Controls.Add(this.smartLabel4);
            this.Controls.Add(this.smartLabel3);
            this.Controls.Add(this.smartLabel2);
            this.Controls.Add(this.smartGroupBox1);
            this.Controls.Add(this.Button_Cancel);
            this.Controls.Add(this.Button_OK);
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

        }

        #endregion
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton Button_OK;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton Button_Cancel;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartGroupBox smartGroupBox1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel2;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel3;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel4;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel5;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartComboBox sComB_Rating;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox sTB_RiskVolume;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox sTB_BlankVolume;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox sTB_Overdraft;
        private System.Windows.Forms.Button btn_Save;
        private System.Windows.Forms.SaveFileDialog saveFileDialog1;
        private System.Windows.Forms.Button btn_Load;
        private System.Windows.Forms.OpenFileDialog openFileDialog1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox sCB_UseIdividualRiskRel;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox sTB_Boni;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartComboBox sComB_JoinType;
    }
}

