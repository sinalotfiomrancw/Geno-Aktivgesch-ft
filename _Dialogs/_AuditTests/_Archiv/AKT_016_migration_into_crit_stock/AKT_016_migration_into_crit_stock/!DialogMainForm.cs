using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Audicon.SmartAnalyzer.Common.Types;

namespace AKT_016_migration_into_crit_stock
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

        private void sCB_UseCritStock_CheckedChanged(object sender, EventArgs e)
        {
            if(sCB_UseCritStock.Checked)
            {
                smartLabel1.Enabled = true;
                smartLabel2.Enabled = true;
                sComB_LowerLimit.Enabled = true;
                sComB_UpperLimit.Enabled = true;

                //sComB_LowerLimit.IsOptional = false;
                //sComB_UpperLimit.IsOptional = false;
            }

            if (sCB_UseCritStock.Checked == false)
            {
                smartLabel1.Enabled = false;
                smartLabel2.Enabled = false;
                sComB_LowerLimit.Enabled = false;
                sComB_UpperLimit.Enabled = false;

                //sComB_LowerLimit.IsOptional = true;
                //sComB_UpperLimit.IsOptional = true;

                sComB_LowerLimit.SelectedIndex = 0;
                sComB_UpperLimit.SelectedIndex = 0;
            }
        }

        private void sComB_LowerLimit_SelectedIndexChanged(object sender, EventArgs e)
        {
            if(sComB_LowerLimit.SelectedIndex == 20 && sComB_UpperLimit.SelectedIndex < sComB_LowerLimit.SelectedIndex)
            {
                sComB_UpperLimit.SelectedIndex = sComB_LowerLimit.SelectedIndex;
            }
            else if(sComB_UpperLimit.SelectedIndex < sComB_LowerLimit.SelectedIndex)
            {
                sComB_UpperLimit.SelectedIndex = sComB_LowerLimit.SelectedIndex + 1;
            }
            else if (sComB_LowerLimit.SelectedIndex == 0)
            {
                sComB_UpperLimit.SelectedIndex = 0;
            }
        }

        private void sComB_UpperLimit_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (sComB_UpperLimit.SelectedIndex == 1 && sComB_UpperLimit.SelectedIndex < sComB_LowerLimit.SelectedIndex)
            {
                sComB_LowerLimit.SelectedIndex = sComB_UpperLimit.SelectedIndex;
            }
            else if (sComB_UpperLimit.SelectedIndex < sComB_LowerLimit.SelectedIndex && sComB_UpperLimit.SelectedIndex != 0)
            {
                sComB_LowerLimit.SelectedIndex = sComB_UpperLimit.SelectedIndex - 1;
            }
            else if (sComB_UpperLimit.SelectedIndex == 0)
            {
                sComB_LowerLimit.SelectedIndex = 0;
            }
            else if (sComB_LowerLimit.SelectedIndex == 0)
            {
                sComB_LowerLimit.SelectedIndex = 1;
            }
        }

        private void _DialogMainForm_Load(object sender, EventArgs e)
        {
            if(sCB_UseCritStock.Checked != true)
            {
                smartLabel1.Enabled = false;
                smartLabel2.Enabled = false;
                sComB_LowerLimit.Enabled = false;
                sComB_UpperLimit.Enabled = false;

                sComB_LowerLimit.SelectedIndex = 0;
                sComB_UpperLimit.SelectedIndex = 0;

                //sComB_LowerLimit.IsOptional = true;
                //sComB_UpperLimit.IsOptional = true;
            }
        }

        private void btn_OK_Click(object sender, EventArgs e)
        {
            if(sCB_UseCritStock.Checked == true && sComB_LowerLimit.SelectedIndex != 0 && sComB_UpperLimit.SelectedIndex != 0)
            {
                DialogResult = DialogResult.OK;
                Close();
            }
            else
            {
                DialogResult = DialogResult.OK;
                Close();
            }
        }
    }
}
