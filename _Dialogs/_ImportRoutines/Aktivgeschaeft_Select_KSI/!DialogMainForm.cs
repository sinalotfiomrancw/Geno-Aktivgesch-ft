using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Audicon.SmartAnalyzer.Common.Types;

namespace Aktivgeschaeft_Select_KSI
{
    //[DefaultForm]  // uncomment this line for apps requiring IDEA 10.1 and higher
    public partial class _DialogMainForm : Form
    {
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

        private void Button_OK_Click(object sender, EventArgs e)
        {
            smartDataExchanger1.Value["FilePathStandard"] = smartTextBox1.Value;
            //smartDataExchanger1.Value["AccountChoice"] = smartFromToList1.Count;
        }
        private void smartHelp1_Click(object sender, EventArgs e)
        {
            try
            {
                openFileDialog1.InitialDirectory = smartDataExchanger1.Value["FilePathStandard"].ToString();
            }
            catch
            {

            }
            openFileDialog1.Title = "KSI-Datei";
            openFileDialog1.Filter = "CSV-Datei|*.CSV;*.csv";
            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                string replacePath;
                replacePath = openFileDialog1.FileName;
                //MessageBox.Show(replacePath);
                smartTextBox1.Value = replacePath;
            }
        }

        private void _DialogMainForm_Load_1(object sender, EventArgs e)
        {
        }
    }
}
