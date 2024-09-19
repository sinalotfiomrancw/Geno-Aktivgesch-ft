using System;

namespace MaRisk
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
            Audicon.SmartAnalyzer.Client.CustomControls.ConString conString2 = new Audicon.SmartAnalyzer.Client.CustomControls.ConString();
            this.Button_OK = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.Button_Cancel = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.smartLabel1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.smartFromToList1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartFromToList();
            this.WER = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.BelWertV = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.Realisationswert = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.Sonstiges = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.smartTextBox1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.Button_Description = new Audicon.SmartAnalyzer.Client.CustomControls.SmartHelp();
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
            // smartLabel1
            // 
            resources.ApplyResources(this.smartLabel1, "smartLabel1");
            this.smartLabel1.Name = "smartLabel1";
            // 
            // smartFromToList1
            // 
            this.smartFromToList1.AllowEmpty = true;
            this.smartFromToList1.Caption = "Sicherheitenart: (optional)";
            this.smartFromToList1.CaptionFrom = "von";
            this.smartFromToList1.CaptionTo = "bis";
            this.smartFromToList1.Constraint = conString1;
            resources.ApplyResources(this.smartFromToList1, "smartFromToList1");
            this.smartFromToList1.IsOptional = false;
            this.smartFromToList1.Name = "smartFromToList1";
            this.smartFromToList1.ParameterName = null;
            this.smartFromToList1.ReportingName = "";
            this.smartFromToList1.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.String;
            // 
            // WER
            // 
            resources.ApplyResources(this.WER, "WER");
            this.WER.Enables = new string[] {
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
            this.WER.IsOptional = true;
            this.WER.Name = "WER";
            this.WER.ReportingName = "";
            this.WER.UseVisualStyleBackColor = true;
            // 
            // BelWertV
            // 
            resources.ApplyResources(this.BelWertV, "BelWertV");
            this.BelWertV.Enables = new string[] {
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
            this.BelWertV.IsOptional = true;
            this.BelWertV.Name = "BelWertV";
            this.BelWertV.ReportingName = "";
            this.BelWertV.UseVisualStyleBackColor = true;
            // 
            // Realisationswert
            // 
            resources.ApplyResources(this.Realisationswert, "Realisationswert");
            this.Realisationswert.Enables = new string[] {
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
            this.Realisationswert.IsOptional = true;
            this.Realisationswert.Name = "Realisationswert";
            this.Realisationswert.ReportingName = "";
            this.Realisationswert.UseVisualStyleBackColor = true;
            // 
            // Sonstiges
            // 
            resources.ApplyResources(this.Sonstiges, "Sonstiges");
            this.Sonstiges.Enables = new string[] {
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
            this.Sonstiges.IsOptional = true;
            this.Sonstiges.Name = "Sonstiges";
            this.Sonstiges.ReportingName = "";
            this.Sonstiges.UseVisualStyleBackColor = true;
            // 
            // smartTextBox1
            // 
            this.smartTextBox1.Constraint = conString2;
            resources.ApplyResources(this.smartTextBox1, "smartTextBox1");
            this.smartTextBox1.LanguageCode = "";
            this.smartTextBox1.Name = "smartTextBox1";
            this.smartTextBox1.ReportingName = "";
            this.smartTextBox1.ShowInReport = false;
            this.smartTextBox1.Value = "";
            this.smartTextBox1.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.String;
            // 
            // Button_Description
            // 
            resources.ApplyResources(this.Button_Description, "Button_Description");
            this.Button_Description.HelpId = null;
            this.Button_Description.Name = "Button_Description";
            this.Button_Description.UseVisualStyleBackColor = true;
            // 
            // _DialogMainForm
            // 
            resources.ApplyResources(this, "$this");
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.Button_Description);
            this.Controls.Add(this.smartTextBox1);
            this.Controls.Add(this.Sonstiges);
            this.Controls.Add(this.Realisationswert);
            this.Controls.Add(this.BelWertV);
            this.Controls.Add(this.WER);
            this.Controls.Add(this.smartFromToList1);
            this.Controls.Add(this.smartLabel1);
            this.Controls.Add(this.Button_Cancel);
            this.Controls.Add(this.Button_OK);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.KeyPreview = true;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "_DialogMainForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.MyDialog_FormClosing);
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this._DialogMainForm_KeyDown);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton Button_OK;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton Button_Cancel;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartFromToList smartFromToList1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox WER;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox BelWertV;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox Realisationswert;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox Sonstiges;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox smartTextBox1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartHelp Button_Description;
    }
}

