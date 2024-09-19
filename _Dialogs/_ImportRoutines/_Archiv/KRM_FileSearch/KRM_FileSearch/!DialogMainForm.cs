using Audicon.SmartAnalyzer.Common.Interfaces;
using Audicon.SmartAnalyzer.Common.Types;
using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Windows.Forms;
using Audicon.SmartAnalyzer.Common.Types.ExecutionContext;

namespace KRM_FileSearch
{
    [DefaultForm]  // uncomment this line for apps requiring IDEA 10.1 and higher
    public partial class _DialogMainForm : Form
    {
        private IExecutionContext executionContext;

        string Importdefinition;
        string ColumnDelimiter;
        bool ActivateWarning;
        public _DialogMainForm()
        {
            InitializeComponent();
            this.Font = SystemFonts.DefaultFont;
            foreach (Control c in this.Controls)
            {
                c.Font = SystemFonts.DefaultFont;
            }
        }

        private void _DialogMainForm_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Escape) this.Close();
        }

        private void btn_FileSearch_Click(object sender, EventArgs e)
        {
            openFileDialog1.Title = "KRM";
            openFileDialog1.Filter = "Text-Datei|*.TXT;*.txt;*.CSV;*.csv";//|Excel|*.xlsx;*.XLSX";
            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                sTB_FilePath.Value = openFileDialog1.FileName;
            }
        }

        private void btn_Options_Click(object sender, EventArgs e)
        {
            Einstellungen newEinstellungen = new Einstellungen(smartDataExchanger);
            newEinstellungen.ShowDialog();

            GetSettings();
        }

        private void _DialogMainForm_Load(object sender, EventArgs e)
        {
            InitSmartContext();

            //get resource strings
            //lables
            sLWarningLatestVersion.Text = DialogStrings.warning_Latest_Version;
            //pictures
            pictureBox1.Image = SystemIcons.Warning.ToBitmap();
            //set predfined values
            sTB_DataExportDate.Value = DateTime.Now.ToString();

            GetSettings();
        }

        private void InitSmartContext()
        {
            foreach (DictionaryEntry item in smartDataExchanger.Value)
            {
                if (item.Key.ToString().Equals("SmartContextKey"))
                {
                    executionContext = (IExecutionContext)item.Value;
                }
                //else if (item.Key.ToString().Equals("LibraryKey"))
                //{
                //    libraryPath = (String)item.Value;
                //}
            }
        }

        private void GetSettings()
        {
            Importdefinition = Properties.Settings.Default.ImportDefinition;
            ColumnDelimiter = Properties.Settings.Default.ColumnDelimiter;
            ActivateWarning = Properties.Settings.Default.ActivateWarning;

            if(Importdefinition != DialogStrings.comboboxVersion_Importdefinition_2 && ActivateWarning == true)
            {
                pictureBox1.Visible = true;
                sLWarningLatestVersion.Visible = true;
            }
            else
            {
                pictureBox1.Visible = false;
                sLWarningLatestVersion.Visible = false;
            }
        }

        private void btn_OK_Click(object sender, EventArgs e)
        {
            if(File.Exists(sTB_FilePath.Value) != true)
            {
                MessageBox.Show(DialogStrings.error_FileNotFound, Text, MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            smartDataExchanger.Value["ImpDef"] = Properties.Settings.Default.ImportDefinition;
            smartDataExchanger.Value["ColDel"] = Properties.Settings.Default.ColumnDelimiter;

            DialogResult = DialogResult.OK;
            Close();
        }
    }
}
