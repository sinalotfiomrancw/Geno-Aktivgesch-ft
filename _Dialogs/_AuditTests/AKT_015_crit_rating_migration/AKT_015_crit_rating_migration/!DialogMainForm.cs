using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Audicon.SmartAnalyzer.Common.Types;

namespace AKT_015_crit_rating_migration
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
            //_DialogMainForm_Resize(null, null);
        }
        private void _DialogMainForm_Resize(object sender, EventArgs e)
        {
            try
            {
                var delta = 10;
                var extraHeight = this.Height - this.ClientSize.Height;
                var extraWidth = this.Width - this.ClientSize.Width;

                smartLabel1.Top = delta;
                smartLabel1.Left = delta;

                sTB_RatingMigration.Top = smartLabel1.Bottom + delta;
                sTB_RatingMigration.Left = delta;

                sCheckB_PosVeränderungen.Top = sTB_RatingMigration.Bottom + delta;
                sCheckB_PosVeränderungen.Left = delta;

                Button_OK.Top = delta;
                Button_OK.Left = smartLabel1.Right + delta;

                Button_Cancel.Top = Button_OK.Bottom + delta;
                Button_Cancel.Left = Button_OK.Left;

                Button_Description.Top = Button_Cancel.Bottom + delta;
                Button_Description.Left = Button_OK.Left;

                this.Height = sCheckB_PosVeränderungen.Bottom + delta + extraHeight;
                this.Width = Button_OK.Right + delta + extraWidth;
            }
            catch
            {

            }
        }
    }
}
