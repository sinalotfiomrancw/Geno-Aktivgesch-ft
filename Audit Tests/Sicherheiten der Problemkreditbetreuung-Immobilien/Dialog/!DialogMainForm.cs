using Audicon.SmartAnalyzer.Client.CustomControls;
using Audicon.SmartAnalyzer.Common.Types;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

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
                if (string.IsNullOrEmpty(smartTextBox1.Value))
                {
                    // Cancel the closing of the dialog
                    MessageBox.Show("Bitte geben Sie die erforderlichen Angaben für Bewertungsart ein.");
                    e.Cancel = true;
                }
                else
                {
                   e.Cancel = false;
                }
            }
            else if (this.DialogResult == DialogResult.Cancel)
            {
                // Ensure that the DialogResult is not OK when Cancel is clicked
                this.DialogResult = DialogResult.Cancel;
                e.Cancel = false;
            }
        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Get the selected index
            int selectedIndex = smartComboBox1.SelectedIndex;

            // Check if the selected index is greater than 0 and less than 4
            if (selectedIndex >= 0 && selectedIndex < 5)
            {
                // Assign a specific string to the TextBox
                smartTextBox1.Value = "1";
            }
            else
            {
                // Clear the TextBox if the condition is not met
                smartTextBox1.Value = "";
            }
        }

    }
}
