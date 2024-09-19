namespace AKT_015_crit_rating_migration
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
            Audicon.SmartAnalyzer.Client.CustomControls.ConNumeric conNumeric2 = new Audicon.SmartAnalyzer.Client.CustomControls.ConNumeric();
            this.Button_Description = new Audicon.SmartAnalyzer.Client.CustomControls.SmartHelp();
            this.Button_OK = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.Button_Cancel = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.smartLabel1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.sTB_RatingMigration = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.sCheckB_PosVeränderungen = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.smartLabel2 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.sTB_Risikovolumen = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.SuspendLayout();
            // 
            // Button_Description
            // 
            resources.ApplyResources(this.Button_Description, "Button_Description");
            this.Button_Description.HelpId = null;
            this.Button_Description.Name = "Button_Description";
            this.Button_Description.UseVisualStyleBackColor = true;
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
            // smartLabel1
            // 
            resources.ApplyResources(this.smartLabel1, "smartLabel1");
            this.smartLabel1.Name = "smartLabel1";
            // 
            // sTB_RatingMigration
            // 
            this.sTB_RatingMigration.AllowEmpty = true;
            conNumeric1.DefaultValue = ((long)(0));
            conNumeric1.Max = ((long)(25));
            conNumeric1.Min = ((long)(0));
            this.sTB_RatingMigration.Constraint = conNumeric1;
            resources.ApplyResources(this.sTB_RatingMigration, "sTB_RatingMigration");
            this.sTB_RatingMigration.IsOptional = true;
            this.sTB_RatingMigration.LanguageCode = "";
            this.sTB_RatingMigration.Name = "sTB_RatingMigration";
            this.sTB_RatingMigration.ReportingName = "";
            this.sTB_RatingMigration.Value = "";
            this.sTB_RatingMigration.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.Numeric;
            // 
            // sCheckB_PosVeränderungen
            // 
            resources.ApplyResources(this.sCheckB_PosVeränderungen, "sCheckB_PosVeränderungen");
            this.sCheckB_PosVeränderungen.Enables = new string[] {
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
            this.sCheckB_PosVeränderungen.Name = "sCheckB_PosVeränderungen";
            this.sCheckB_PosVeränderungen.ReportingName = "";
            this.sCheckB_PosVeränderungen.UseVisualStyleBackColor = true;
            // 
            // smartLabel2
            // 
            resources.ApplyResources(this.smartLabel2, "smartLabel2");
            this.smartLabel2.Name = "smartLabel2";
            // 
            // sTB_Risikovolumen
            // 
            this.sTB_Risikovolumen.AllowEmpty = true;
            conNumeric2.DefaultValue = ((long)(0));
            this.sTB_Risikovolumen.Constraint = conNumeric2;
            resources.ApplyResources(this.sTB_Risikovolumen, "sTB_Risikovolumen");
            this.sTB_Risikovolumen.LanguageCode = "";
            this.sTB_Risikovolumen.Name = "sTB_Risikovolumen";
            this.sTB_Risikovolumen.ReportingName = "";
            this.sTB_Risikovolumen.Value = "";
            this.sTB_Risikovolumen.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.Numeric;
            // 
            // _DialogMainForm
            // 
            resources.ApplyResources(this, "$this");
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.sTB_Risikovolumen);
            this.Controls.Add(this.smartLabel2);
            this.Controls.Add(this.sCheckB_PosVeränderungen);
            this.Controls.Add(this.sTB_RatingMigration);
            this.Controls.Add(this.smartLabel1);
            this.Controls.Add(this.Button_Cancel);
            this.Controls.Add(this.Button_OK);
            this.Controls.Add(this.Button_Description);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.KeyPreview = true;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "_DialogMainForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this._DialogMainForm_KeyDown);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private Audicon.SmartAnalyzer.Client.CustomControls.SmartHelp Button_Description;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton Button_OK;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton Button_Cancel;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox sTB_RatingMigration;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox sCheckB_PosVeränderungen;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel2;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox sTB_Risikovolumen;
    }
}

