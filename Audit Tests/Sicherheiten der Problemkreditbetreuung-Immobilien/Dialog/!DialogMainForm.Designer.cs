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
            Audicon.SmartAnalyzer.Client.CustomControls.ConNumeric conNumeric1 = new Audicon.SmartAnalyzer.Client.CustomControls.ConNumeric();
            this.Button_OK = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.Button_Cancel = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.smartLabel1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.smartFromToList1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartFromToList();
            this.smartComboBox1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartComboBox();
            this.smartTextBox1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
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
            // smartComboBox1
            // 
            this.smartComboBox1.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            resources.ApplyResources(this.smartComboBox1, "smartComboBox1");
            this.smartComboBox1.FormattingEnabled = true;
            this.smartComboBox1.IsOptional = true;
            this.smartComboBox1.Items.AddRange(new object[] {
            resources.GetString("smartComboBox1.Items"),
            resources.GetString("smartComboBox1.Items1"),
            resources.GetString("smartComboBox1.Items2"),
            resources.GetString("smartComboBox1.Items3"),
            resources.GetString("smartComboBox1.Items4")});
            this.smartComboBox1.Name = "smartComboBox1";
            this.smartComboBox1.ReportingName = "";
            this.smartComboBox1.Selection = -1;
            this.smartComboBox1.SelectedIndexChanged += new System.EventHandler(this.comboBox1_SelectedIndexChanged);
            // 
            // smartTextBox1
            // 
            conNumeric1.DefaultValue = ((long)(0));
            this.smartTextBox1.Constraint = conNumeric1;
            resources.ApplyResources(this.smartTextBox1, "smartTextBox1");
            this.smartTextBox1.LanguageCode = "";
            this.smartTextBox1.Name = "smartTextBox1";
            this.smartTextBox1.ReportingName = "";
            this.smartTextBox1.Value = "";
            this.smartTextBox1.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.Numeric;
            // 
            // _DialogMainForm
            // 
            resources.ApplyResources(this, "$this");
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.smartTextBox1);
            this.Controls.Add(this.smartComboBox1);
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
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartComboBox smartComboBox1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox smartTextBox1;
    }
}

