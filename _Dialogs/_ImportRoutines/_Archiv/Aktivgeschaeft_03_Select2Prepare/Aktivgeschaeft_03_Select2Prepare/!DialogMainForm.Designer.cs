namespace Aktivgeschaeft_03_Select2Prepare
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
            this.Button_OK = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.Button_Cancel = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.smartLabel1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel();
            this.smartCheckBox1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.smartCheckBox2 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox();
            this.smartGroupBox1 = new Audicon.SmartAnalyzer.Client.CustomControls.SmartGroupBox();
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
            // smartLabel1
            // 
            resources.ApplyResources(this.smartLabel1, "smartLabel1");
            this.smartLabel1.Name = "smartLabel1";
            // 
            // smartCheckBox1
            // 
            resources.ApplyResources(this.smartCheckBox1, "smartCheckBox1");
            this.smartCheckBox1.Enables = new string[] {
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
            this.smartCheckBox1.Name = "smartCheckBox1";
            this.smartCheckBox1.ReportingName = "";
            this.smartCheckBox1.UseVisualStyleBackColor = true;
            // 
            // smartCheckBox2
            // 
            resources.ApplyResources(this.smartCheckBox2, "smartCheckBox2");
            this.smartCheckBox2.Enables = new string[] {
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
            this.smartCheckBox2.Name = "smartCheckBox2";
            this.smartCheckBox2.ReportingName = "";
            this.smartCheckBox2.UseVisualStyleBackColor = true;
            // 
            // smartGroupBox1
            // 
            this.smartGroupBox1.BackColor = System.Drawing.SystemColors.Control;
            this.smartGroupBox1.Controls.Add(this.smartCheckBox2);
            this.smartGroupBox1.Controls.Add(this.smartCheckBox1);
            resources.ApplyResources(this.smartGroupBox1, "smartGroupBox1");
            this.smartGroupBox1.Name = "smartGroupBox1";
            this.smartGroupBox1.TabStop = false;
            // 
            // _DialogMainForm
            // 
            resources.ApplyResources(this, "$this");
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.smartLabel1);
            this.Controls.Add(this.Button_Cancel);
            this.Controls.Add(this.Button_OK);
            this.Controls.Add(this.smartGroupBox1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.KeyPreview = true;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "_DialogMainForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this._DialogMainForm_KeyDown);
            this.smartGroupBox1.ResumeLayout(false);
            this.smartGroupBox1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton Button_OK;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton Button_Cancel;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartLabel smartLabel1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox smartCheckBox1;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartCheckBox smartCheckBox2;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartGroupBox smartGroupBox1;
    }
}

