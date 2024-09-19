namespace Aktivgeschaeft_01_SelectFolder
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
            Audicon.SmartAnalyzer.Client.CustomControls.ConString conString3 = new Audicon.SmartAnalyzer.Client.CustomControls.ConString();
            this.Button_OK = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.Button_Cancel = new Audicon.SmartAnalyzer.Client.CustomControls.SmartButton();
            this.sTB_FolderPath = new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox();
            this.btn_SearchFolder = new System.Windows.Forms.Button();
            this.folderBrowserDialog1 = new System.Windows.Forms.FolderBrowserDialog();
            this.tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel();
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
            // sTB_FolderPath
            // 
            this.sTB_FolderPath.Constraint = conString3;
            resources.ApplyResources(this.sTB_FolderPath, "sTB_FolderPath");
            this.sTB_FolderPath.LanguageCode = "";
            this.sTB_FolderPath.Name = "sTB_FolderPath";
            this.sTB_FolderPath.ReportingName = "";
            this.sTB_FolderPath.Value = "";
            this.sTB_FolderPath.ValueType = Audicon.SmartAnalyzer.Client.CustomControls.DataType.String;
            this.sTB_FolderPath.OnTextChanged += new Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox.TextChangedHandler(this.sTB_FolderPath_OnTextChanged);
            // 
            // btn_SearchFolder
            // 
            resources.ApplyResources(this.btn_SearchFolder, "btn_SearchFolder");
            this.btn_SearchFolder.Name = "btn_SearchFolder";
            this.btn_SearchFolder.UseVisualStyleBackColor = true;
            this.btn_SearchFolder.Click += new System.EventHandler(this.btn_SearchFolder_Click);
            // 
            // tableLayoutPanel1
            // 
            resources.ApplyResources(this.tableLayoutPanel1, "tableLayoutPanel1");
            this.tableLayoutPanel1.Name = "tableLayoutPanel1";
            // 
            // _DialogMainForm
            // 
            resources.ApplyResources(this, "$this");
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.tableLayoutPanel1);
            this.Controls.Add(this.btn_SearchFolder);
            this.Controls.Add(this.sTB_FolderPath);
            this.Controls.Add(this.Button_Cancel);
            this.Controls.Add(this.Button_OK);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.KeyPreview = true;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "_DialogMainForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this._DialogMainForm_KeyDown);
            this.ResumeLayout(false);

        }

        #endregion
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton Button_OK;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartButton Button_Cancel;
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartTextBox sTB_FolderPath;
        private System.Windows.Forms.Button btn_SearchFolder;
        private System.Windows.Forms.FolderBrowserDialog folderBrowserDialog1;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel1;
    }
}

