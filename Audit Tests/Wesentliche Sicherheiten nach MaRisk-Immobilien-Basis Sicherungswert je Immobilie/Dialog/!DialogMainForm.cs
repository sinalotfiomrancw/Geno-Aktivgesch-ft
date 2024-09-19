using Audicon.SmartAnalyzer.Common.Types;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace MaRisk
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
        
        private void MyDialog_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (this.DialogResult == DialogResult.OK)
            {
                // Check if the special condition is not met
                if (string.IsNullOrEmpty(smartTextBox1.Value) || string.IsNullOrEmpty(smartTextBox2.Value))
                {
                    // Cancel the closing of the dialog
                    MessageBox.Show("Bitte geben Sie die erforderlichen Angaben über den Betrag des Sicherheitenwerts verteilt juristisch und die Überprüfungsdauer ein.");
                    e.Cancel = true;
                    return;
                }
                else
                {
                    e.Cancel = false;
                    return;
                }
            }
            else if (this.DialogResult == DialogResult.Cancel)
            {
                e.Cancel = false;
            }
        }

        private void _DialogMainForm_Load(object sender, EventArgs e)
        {

        }
    }
}
