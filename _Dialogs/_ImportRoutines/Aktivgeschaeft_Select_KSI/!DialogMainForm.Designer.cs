namespace Aktivgeschaeft_Select_KSI
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
            this.Button_OK = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.Button_Cancel = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.smartLabel1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
            this.smartDataExchanger1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartDataExchanger();
            this.smartTextBox1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.smartHelp1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartHelp();
            this.SuspendLayout();
            // 
            // Button_OK
            // 
            resources.ApplyResources(this.Button_OK, "Button_OK");
            this.Button_OK.DialogResult = System.Windows.Forms.DialogResult.OK;
            this.Button_OK.Name = "Button_OK";
            this.Button_OK.ResultType = Audicon.SmartAnalyzer.Client.CustomControls.DiagResult.OK;
            this.Button_OK.UseVisualStyleBackColor = true;
            this.Button_OK.Click += new System.EventHandler(this.Button_OK_Click);
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
            // openFileDialog1
            // 
            this.openFileDialog1.FileName = "openFileDialog1";
            // 
            // smartDataExchanger1
            // 
            this.smartDataExchanger1.Name = "smartDataExchanger1";
            this.smartDataExchanger1.ReportingName = null;
            this.smartDataExchanger1.ReportingValue = "";
            // 
            // smartTextBox1
            // 
            this.smartTextBox1.Constraint = conString1;
            resources.ApplyResources(this.smartTextBox1, "smartTextBox1");
            this.smartTextBox1.LanguageCode = "";
            this.smartTextBox1.Name = "smartTextBox1";
            this.smartTextBox1.ReportingName = "";
            this.smartTextBox1.Value = "";
            this.smartTextBox1.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.String;
            // 
            // smartHelp1
            // 
            resources.ApplyResources(this.smartHelp1, "smartHelp1");
            this.smartHelp1.HelpId = null;
            this.smartHelp1.Name = "smartHelp1";
            this.smartHelp1.UseVisualStyleBackColor = true;
            this.smartHelp1.Click += new System.EventHandler(this.smartHelp1_Click);
            // 
            // _DialogMainForm
            // 
            resources.ApplyResources(this, "$this");
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.smartHelp1);
            this.Controls.Add(this.smartTextBox1);
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
            this.Load += new System.EventHandler(this._DialogMainForm_Load_1);
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this._DialogMainForm_KeyDown);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton Button_OK;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton Button_Cancel;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel1;
        private System.Windows.Forms.OpenFileDialog openFileDialog1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartDataExchanger smartDataExchanger1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox smartTextBox1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartHelp smartHelp1;
    }
}

