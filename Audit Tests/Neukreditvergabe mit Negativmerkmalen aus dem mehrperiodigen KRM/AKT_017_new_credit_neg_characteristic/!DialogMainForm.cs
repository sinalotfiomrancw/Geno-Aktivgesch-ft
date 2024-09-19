using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Audicon.SmartAnalyzer.Common.Types;

namespace AKT_017_new_credit_neg_characteristic
{
    //[DefaultForm]  // uncomment this line for apps requiring IDEA 10.1 and higher
    public partial class _DialogMainForm : Form
    {
        bool bCustomerSince;
        bool bRating;
        bool bOverdraft;
        bool bOverdraftDays;
        bool bEWBValue;
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

        private void _DialogMainForm_Load(object sender, EventArgs e)
        {

        }

        private void btn_OK_Click(object sender, EventArgs e)
        {
            sTB_CheckDefined.Value = string.Empty;
            sMessage = "Sie haben die folgenden Negativmerkmale ausgewählt, jedoch keinen Wert eingetragen:";

            if ( sCheckB_CustomerSince.Checked)
            {
                if (string.IsNullOrEmpty(sTB_CustomerSince.Value))
                {
                    bCustomerSince = false;
                    sMessage += Environment.NewLine + "Kunde seit";
                }
                else
                {
                    bCustomerSince = true;
                }
            }
            else
            {
                bCustomerSince = true;
            }

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

            if (sCheckB_Overdraft.Checked)
            {
                if (string.IsNullOrEmpty(sTB_Overdraft.Value))
                {
                    bOverdraft = false;
                    sMessage += Environment.NewLine + "Überziehung";
                }
                else
                {
                    bOverdraft = true;
                }
            }
            else
            {
                bOverdraft = true;
            }

            if (sCheckB_OverdraftDays.Checked)
            {
                if (string.IsNullOrEmpty(sTB_OverdraftDays.Value))
                {
                    bOverdraftDays = false;
                    sMessage += Environment.NewLine + "Überziehungstage";
                }
                else
                {
                    bOverdraftDays = true;
                }
            }
            else
            {
                bOverdraftDays = true;
            }

            if (sCheckB_EWBValue.Checked)
            {
                if (string.IsNullOrEmpty(sTB_EWBValue.Value))
                {
                    bEWBValue = false;
                    sMessage += Environment.NewLine + "EWB-Betrag";
                }
                else
                {
                    bEWBValue = true;
                }
            }
            else
            {
                bEWBValue = true;
            }

            sMessage += Environment.NewLine + "Bitte geben Sie entsprechende Werte ein.";

            if ( !bCustomerSince || !bRating || !bOverdraft || !bOverdraftDays || !bEWBValue)
            {
                MessageBox.Show(sMessage);
            }
            else
            {
                if (sCheckB_CustomerSince.Checked || sCheckB_Rating.Checked || sCheckB_Overdraft.Checked || sCheckB_OverdraftDays.Checked || sCheckB_EWBValue.Checked || sCheckB_Schufa.Checked)
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

        private void sCheckB_CustomerSince_CheckedChanged(object sender, EventArgs e)
        {
            if (sCheckB_CustomerSince.Checked)
            {
                sTB_CustomerSince.Enabled = true;
                //sTB_CustomerSince.IsOptional = false;
            }
            else
            {
                sTB_CustomerSince.Value = string.Empty;
                sTB_CustomerSince.Enabled = false;
                //sTB_CustomerSince.IsOptional = true;
            }
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

        private void sCheckB_Overdraft_CheckedChanged(object sender, EventArgs e)
        {
            if (sCheckB_Overdraft.Checked)
            {
                sTB_Overdraft.Enabled = true;
                //sTB_Overdraft.IsOptional = false;
            }
            else
            {
                sTB_Overdraft.Value = string.Empty;
                sTB_Overdraft.Enabled = false;
                //sTB_Overdraft.IsOptional = true;
            }
        }

        private void sCheckB_OverdraftDays_CheckedChanged(object sender, EventArgs e)
        {
            if (sCheckB_OverdraftDays.Checked)
            {
                sTB_OverdraftDays.Enabled = true;
                //sTB_OverdraftDays.IsOptional = false;
            }
            else
            {
                sTB_OverdraftDays.Value = string.Empty;
                sTB_OverdraftDays.Enabled = false;
                //sTB_OverdraftDays.IsOptional = true;
            }
        }


        private void sCheckB_EWBValue_CheckedChanged(object sender, EventArgs e)
        {
            if (sCheckB_EWBValue.Checked)
            {
                sTB_EWBValue.Enabled = true;
                //sTB_EWBValue.IsOptional = false;
            }
            else
            {
                sTB_EWBValue.Value = string.Empty;
                sTB_EWBValue.Enabled = false;
                //sTB_EWBValue.IsOptional = true;
            }
        }

        private void _DialogMainForm_Load_1(object sender, EventArgs e)
        {
            if (sCheckB_CustomerSince.Checked == false)
            {
                sTB_CustomerSince.Enabled = false;
                //sTB_CustomerSince.IsOptional = true;
            }
                
            if (sCheckB_Rating.Checked == false)
            {
                sCB_Rating.Enabled = false;
                //sCB_Rating.IsOptional = true;
            }
                
            if (sCheckB_Overdraft.Checked == false)
            {
                sTB_Overdraft.Enabled = false;
                //sTB_Overdraft.IsOptional = true;
            }
                
            if (sCheckB_OverdraftDays.Checked == false)
            {
                sTB_OverdraftDays.Enabled = false;
                //sTB_OverdraftDays.IsOptional = true;
            }
                
            if (sCheckB_EWBValue.Checked == false)
            {
                sTB_EWBValue.Enabled = false;
                //sTB_EWBValue.IsOptional = true;
            }

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

                sCheckB_CustomerSince.Top = smartLabel1.Bottom + delta + 2;
                sCheckB_CustomerSince.Left = delta;

                sTB_CustomerSince.Top = smartLabel1.Bottom + delta;
                sTB_CustomerSince.Left = sCheckB_CustomerSince.Right + delta;
                //---------------------------------------------------------------
                sCheckB_Rating.Top = sTB_CustomerSince.Bottom + delta + 2;
                sCheckB_Rating.Left = delta;

                sCB_Rating.Top = sTB_CustomerSince.Bottom + delta;
                sCB_Rating.Left = sCheckB_Rating.Right + delta;
                //---------------------------------------------------------------
                sCheckB_Overdraft.Top = sCB_Rating.Bottom + delta + 2;
                sCheckB_Overdraft.Left = delta;

                sTB_Overdraft.Top = sCB_Rating.Bottom + delta;
                sTB_Overdraft.Left = sCheckB_Overdraft.Right + delta;
                //---------------------------------------------------------------
                sCheckB_OverdraftDays.Top = sTB_Overdraft.Bottom + delta + 2;
                sCheckB_OverdraftDays.Left = delta;

                sTB_OverdraftDays.Top = sTB_Overdraft.Bottom + delta;
                sTB_OverdraftDays.Left = sCheckB_OverdraftDays.Right + delta;
                //---------------------------------------------------------------
                sCheckB_EWBValue.Top = sTB_OverdraftDays.Bottom + delta + 2;
                sCheckB_EWBValue.Left = delta;

                sTB_EWBValue.Top = sTB_OverdraftDays.Bottom + delta;
                sTB_EWBValue.Left = sCheckB_EWBValue.Right + delta;
                //---------------------------------------------------------------
                sCheckB_Schufa.Top = sTB_EWBValue.Bottom + delta + 2;
                sCheckB_Schufa.Left = delta;
                //---------------------------------------------------------------
                btn_OK.Top = delta;
                btn_OK.Left = smartLabel1.Right + 4 * delta;

                Button_Cancel.Top = btn_OK.Bottom + delta - 5;
                Button_Cancel.Left = btn_OK.Left;

                Button_Description.Top = Button_Cancel.Bottom + delta - 5;
                Button_Description.Left = btn_OK.Left;

                this.Height = sCheckB_Schufa.Bottom + delta + extraHeight;
                this.Width = btn_OK.Right + delta + extraWidth;
            }
            catch
            {

            }
        }
    }
}
