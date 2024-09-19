namespace AKT_016_migration_into_crit_stock
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
            this.Button_Description = new Audicon.SmartAnalyzer.Client.CustomControls.SmartHelp();
            this.Button_Cancel = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.sCB_UseCritStock = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.smartLabel1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.sComB_LowerLimit = new Audicon.SmartAnalyzer.Client.CustomControls.SmartComboBox();
            this.smartLabel2 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.sComB_UpperLimit = new Audicon.SmartAnalyzer.Client.CustomControls.SmartComboBox();
            this.btn_OK = new System.Windows.Forms.Button();
            this.smartGroupBox1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartGroupBox();
            this.nTB_Risikovolumen = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.smartGroupBox1.SuspendLayout();
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
            // sCB_UseCritStock
            // 
            this.sCB_UseCritStock.Enables = new string[] {
        "",
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
            resources.ApplyResources(this.sCB_UseCritStock, "sCB_UseCritStock");
            this.sCB_UseCritStock.Name = "sCB_UseCritStock";
            this.sCB_UseCritStock.ReportingName = "";
            this.sCB_UseCritStock.UseVisualStyleBackColor = true;
            this.sCB_UseCritStock.CheckedChanged += new System.EventHandler(this.sCB_UseCritStock_CheckedChanged);
            // 
            // smartLabel1
            // 
            resources.ApplyResources(this.smartLabel1, "smartLabel1");
            this.smartLabel1.Name = "smartLabel1";
            // 
            // sComB_LowerLimit
            // 
            this.sComB_LowerLimit.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            resources.ApplyResources(this.sComB_LowerLimit, "sComB_LowerLimit");
            this.sComB_LowerLimit.FormattingEnabled = true;
            this.sComB_LowerLimit.Items.AddRange(new object[] {
            resources.GetString("sComB_LowerLimit.Items"),
            resources.GetString("sComB_LowerLimit.Items1"),
            resources.GetString("sComB_LowerLimit.Items2"),
            resources.GetString("sComB_LowerLimit.Items3"),
            resources.GetString("sComB_LowerLimit.Items4"),
            resources.GetString("sComB_LowerLimit.Items5"),
            resources.GetString("sComB_LowerLimit.Items6"),
            resources.GetString("sComB_LowerLimit.Items7"),
            resources.GetString("sComB_LowerLimit.Items8"),
            resources.GetString("sComB_LowerLimit.Items9"),
            resources.GetString("sComB_LowerLimit.Items10"),
            resources.GetString("sComB_LowerLimit.Items11"),
            resources.GetString("sComB_LowerLimit.Items12"),
            resources.GetString("sComB_LowerLimit.Items13"),
            resources.GetString("sComB_LowerLimit.Items14"),
            resources.GetString("sComB_LowerLimit.Items15"),
            resources.GetString("sComB_LowerLimit.Items16"),
            resources.GetString("sComB_LowerLimit.Items17"),
            resources.GetString("sComB_LowerLimit.Items18"),
            resources.GetString("sComB_LowerLimit.Items19"),
            resources.GetString("sComB_LowerLimit.Items20"),
            resources.GetString("sComB_LowerLimit.Items21"),
            resources.GetString("sComB_LowerLimit.Items22"),
            resources.GetString("sComB_LowerLimit.Items23"),
            resources.GetString("sComB_LowerLimit.Items24"),
            resources.GetString("sComB_LowerLimit.Items25")});
            this.sComB_LowerLimit.Name = "sComB_LowerLimit";
            this.sComB_LowerLimit.ReportingName = "";
            this.sComB_LowerLimit.Selection = 0;
            this.sComB_LowerLimit.SelectedIndexChanged += new System.EventHandler(this.sComB_LowerLimit_SelectedIndexChanged);
            // 
            // smartLabel2
            // 
            resources.ApplyResources(this.smartLabel2, "smartLabel2");
            this.smartLabel2.Name = "smartLabel2";
            // 
            // sComB_UpperLimit
            // 
            this.sComB_UpperLimit.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            resources.ApplyResources(this.sComB_UpperLimit, "sComB_UpperLimit");
            this.sComB_UpperLimit.FormattingEnabled = true;
            this.sComB_UpperLimit.Items.AddRange(new object[] {
            resources.GetString("sComB_UpperLimit.Items"),
            resources.GetString("sComB_UpperLimit.Items1"),
            resources.GetString("sComB_UpperLimit.Items2"),
            resources.GetString("sComB_UpperLimit.Items3"),
            resources.GetString("sComB_UpperLimit.Items4"),
            resources.GetString("sComB_UpperLimit.Items5"),
            resources.GetString("sComB_UpperLimit.Items6"),
            resources.GetString("sComB_UpperLimit.Items7"),
            resources.GetString("sComB_UpperLimit.Items8"),
            resources.GetString("sComB_UpperLimit.Items9"),
            resources.GetString("sComB_UpperLimit.Items10"),
            resources.GetString("sComB_UpperLimit.Items11"),
            resources.GetString("sComB_UpperLimit.Items12"),
            resources.GetString("sComB_UpperLimit.Items13"),
            resources.GetString("sComB_UpperLimit.Items14"),
            resources.GetString("sComB_UpperLimit.Items15"),
            resources.GetString("sComB_UpperLimit.Items16"),
            resources.GetString("sComB_UpperLimit.Items17"),
            resources.GetString("sComB_UpperLimit.Items18"),
            resources.GetString("sComB_UpperLimit.Items19"),
            resources.GetString("sComB_UpperLimit.Items20"),
            resources.GetString("sComB_UpperLimit.Items21"),
            resources.GetString("sComB_UpperLimit.Items22"),
            resources.GetString("sComB_UpperLimit.Items23"),
            resources.GetString("sComB_UpperLimit.Items24"),
            resources.GetString("sComB_UpperLimit.Items25")});
            this.sComB_UpperLimit.Name = "sComB_UpperLimit";
            this.sComB_UpperLimit.ReportingName = "";
            this.sComB_UpperLimit.Selection = 0;
            this.sComB_UpperLimit.SelectedIndexChanged += new System.EventHandler(this.sComB_UpperLimit_SelectedIndexChanged);
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
            resources.ApplyResources(this.smartGroupBox1, "smartGroupBox1");
            this.smartGroupBox1.Controls.Add(this.nTB_Risikovolumen);
            this.smartGroupBox1.Name = "smartGroupBox1";
            this.smartGroupBox1.TabStop = false;
            // 
            // nTB_Risikovolumen
            // 
            this.nTB_Risikovolumen.AllowEmpty = true;
            conNumeric1.DefaultValue = ((long)(0));
            this.nTB_Risikovolumen.Constraint = conNumeric1;
            resources.ApplyResources(this.nTB_Risikovolumen, "nTB_Risikovolumen");
            this.nTB_Risikovolumen.LanguageCode = "";
            this.nTB_Risikovolumen.Name = "nTB_Risikovolumen";
            this.nTB_Risikovolumen.ReportingName = "";
            this.nTB_Risikovolumen.Value = "";
            this.nTB_Risikovolumen.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.Numeric;
            // 
            // _DialogMainForm
            // 
            resources.ApplyResources(this, "$this");
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.smartGroupBox1);
            this.Controls.Add(this.btn_OK);
            this.Controls.Add(this.sComB_UpperLimit);
            this.Controls.Add(this.smartLabel2);
            this.Controls.Add(this.sComB_LowerLimit);
            this.Controls.Add(this.smartLabel1);
            this.Controls.Add(this.sCB_UseCritStock);
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
            this.smartGroupBox1.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private Audicon.SmartAnalyzer.Client.CustomControls.SmartHelp Button_Description;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton Button_Cancel;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox sCB_UseCritStock;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartComboBox sComB_LowerLimit;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel2;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartComboBox sComB_UpperLimit;
        private System.Windows.Forms.Button btn_OK;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartGroupBox smartGroupBox1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox nTB_Risikovolumen;
    }
}

