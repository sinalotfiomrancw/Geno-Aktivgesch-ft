using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Audicon.SmartAnalyzer.Common.Types;

namespace AKT_019_new_credit_reduced_safeties
{
    //[DefaultForm]  // uncomment this line for apps requiring IDEA 10.1 and higher
    public partial class _DialogMainForm : Form
    {
        bool bRating;
        bool bChangeOfRiskVolume;
        string sMessage = "";
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

        private void sCheckB_Rating_CheckedChanged(object sender, EventArgs e)
        {
            if (sCheckB_Rating.Checked)
            {
                sCB_Rating.Enabled = true;
                //sCB_Rating.IsOptional = false;
            }
            else
            {
                sCB_Rating.SelectedIndex = 0;
                sCB_Rating.Enabled = false;
                //sCB_Rating.IsOptional = true;
            }
        }

        private void _DialogMainForm_Load(object sender, EventArgs e)
        {
            if (sCheckB_Rating.Checked == false)
            {
                sCB_Rating.Enabled = false;
                //sCB_Rating.IsOptional = true;
            }
            if (sCheckB_ChangeOfRiskVolume.Checked == false)
            {
                sTB_ChangeOfRiskVolume.Enabled = false;
                //sTB_ChangeOfRiskVolume.IsOptional = true;
            }

            //_DialogMainForm_Resize(null, null);
        }

        private void sCheckB_ChangeOfRiskVolume_CheckedChanged(object sender, EventArgs e)
        {
            if (sCheckB_ChangeOfRiskVolume.Checked)
            {
                sTB_ChangeOfRiskVolume.Enabled = true;
                //sTB_ChangeOfRiskVolume = false;
            }
            else
            {
                sTB_ChangeOfRiskVolume.Value = string.Empty;
                sTB_ChangeOfRiskVolume.Enabled = false;
                //sTB_ChangeOfRiskVolume.IsOptional = true;
            }
        }

        private void btn_OK_Click(object sender, EventArgs e)
        {
            sTB_CheckDefined.Value = string.Empty;
            sMessage = "Sie haben die folgenden Negativmerkmale ausgewählt, jedoch keinen Wert eingetragen:";

            if (sCheckB_Rating.Checked)
            {
                if (sCB_Rating.SelectedIndex == 0)
                {
                    bRating = false;
                    sMessage += Environment.NewLine + "Rating";
                }
                else
                {
                    bRating = true;
                }
            }
            else
            {
                bRating = true;
            }

            if (sCheckB_ChangeOfRiskVolume.Checked)
            {
                if (string.IsNullOrEmpty(sTB_ChangeOfRiskVolume.Value))
                {
                    bChangeOfRiskVolume = false;
                    sMessage += Environment.NewLine + "Änderung des Risikovolumens";
                }
                else
                {
                    bChangeOfRiskVolume = true;
                }
            }
            else
            {
                bChangeOfRiskVolume = true;
            }

            sMessage += Environment.NewLine + "Bitte geben Sie entsprechende Werte ein.";

            if ( !bRating || !bChangeOfRiskVolume )
            {
                MessageBox.Show(sMessage);
            }
            else
            {
                if ( sCheckB_Rating.Checked || sCheckB_ChangeOfRiskVolume.Checked)
                {
                    sTB_CheckDefined.Value = ";";
                    DialogResult = DialogResult.OK;
                    Close();
                }
                else
                {
                    sTB_CheckDefined.Value = string.Empty;
                    DialogResult = DialogResult.OK;
                    Close();
                }
            }
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

                //---------------------------------------------------------------
                sCheckB_Rating.Top = smartLabel1.Bottom + delta + 2;
                sCheckB_Rating.Left = delta;

                sCB_Rating.Top = smartLabel1.Bottom + delta;
                sCB_Rating.Left = sCheckB_Rating.Right + delta;
                //---------------------------------------------------------------
                sCheckB_ChangeOfRiskVolume.Top = sCB_Rating.Bottom + delta + 2;
                sCheckB_ChangeOfRiskVolume.Left = delta;

                sTB_ChangeOfRiskVolume.Top = sCB_Rating.Bottom + delta;
                sTB_ChangeOfRiskVolume.Left = sCheckB_ChangeOfRiskVolume.Right + delta;
                //---------------------------------------------------------------
                btn_OK.Top = delta;
                btn_OK.Left = smartLabel1.Right + 4 * delta;

                Button_Cancel.Top = btn_OK.Bottom + delta - 5;
                Button_Cancel.Left = btn_OK.Left;

                Button_Description.Top = Button_Cancel.Bottom + delta - 5;
                Button_Description.Left = btn_OK.Left;

                this.Height = sTB_ChangeOfRiskVolume.Bottom + delta + extraHeight;
                this.Width = btn_OK.Right + delta + extraWidth;
            }
            catch
            {

            }
        }
    }
}
