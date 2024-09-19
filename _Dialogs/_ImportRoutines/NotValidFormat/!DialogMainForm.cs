using Audicon.SmartAnalyzer.Common.Types;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace NotValidFormat
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

        private void _DialogMainForm_Load(object sender, EventArgs e)
        {
            MessageBox.Show("Die Version der KRM-Datei konnte nicht erkannt werden. Durch den Import kann es zu Verschiebungen der Zeilen kommen. Bitte überprüfen Sie die Kopfzeilen der KRM-Datei.\r\nImport trotzdem ausführen?\r\nWeitere Hinweise finden Sie im Leitfaden der App.");
        }
    }
}
