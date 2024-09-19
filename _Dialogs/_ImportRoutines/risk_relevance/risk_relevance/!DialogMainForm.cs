using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Audicon.SmartAnalyzer.Common.Types;
using System.Xml;
using System.Threading.Tasks;

namespace risk_relevance
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

        private void btn_Save_Click(object sender, EventArgs e)
        {
            XmlDocument xmlDoc = new XmlDocument();
            XmlNode rootNode = xmlDoc.CreateElement("KRM");
            xmlDoc.AppendChild(rootNode);

            XmlNode savedNode = xmlDoc.CreateElement("saved");
            savedNode.InnerText = DateTime.Now.ToString();
            rootNode.AppendChild(savedNode);
            //Dialog Values
            XmlNode JoinTypeNode = xmlDoc.CreateElement("JoinType");
            JoinTypeNode.InnerText = sComB_JoinType.SelectedItem.ToString();
            rootNode.AppendChild(JoinTypeNode);

            XmlNode BoniNode = xmlDoc.CreateElement("Boni");
            BoniNode.InnerText = sTB_Boni.Value;
            rootNode.AppendChild(BoniNode);

            XmlNode RatingNode = xmlDoc.CreateElement("Rating");
            RatingNode.InnerText = sComB_Rating.SelectedItem.ToString();
            rootNode.AppendChild(RatingNode);

            XmlNode RiskVolumeNode = xmlDoc.CreateElement("Risikovolumen");
            RiskVolumeNode.InnerText = sTB_RiskVolume.Value;
            rootNode.AppendChild(RiskVolumeNode);

            XmlNode BlankVolumeNode = xmlDoc.CreateElement("Blankovolumen");
            BlankVolumeNode.InnerText = sTB_BlankVolume.Value;
            rootNode.AppendChild(BlankVolumeNode);

            XmlNode OverdraftNode = xmlDoc.CreateElement("Ueberziehung");
            OverdraftNode.InnerText = sTB_Overdraft.Value;
            rootNode.AppendChild(OverdraftNode);

            SaveFileDialog saveFileDialog1 = new SaveFileDialog();
            saveFileDialog1.Filter = "Parameter-Datei" + " (*.xml)|*.xml|" + "Alle Formate" + " (*.*)|*.*";
            saveFileDialog1.Title = "Parameter-Datei speichern";
            saveFileDialog1.InitialDirectory = System.Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + "\\CaseWare IDEA\\SmartAnalyzer\\FilterParameters";
            saveFileDialog1.RestoreDirectory = true;
            saveFileDialog1.DefaultExt = "xml";
            saveFileDialog1.FileName = "KRM_Risikorelevanz.xml";
            if (saveFileDialog1.ShowDialog() == DialogResult.OK)
            {
                // If the file name is not an empty string open it for saving.                 
                if (saveFileDialog1.FileName != "")
                {
                    System.IO.FileStream fs = (System.IO.FileStream)saveFileDialog1.OpenFile();
                    xmlDoc.Save(fs);
                    fs.Close();
                }
            }
        }

        private void btn_Load_Click(object sender, EventArgs e)
        {
            openFileDialog1.InitialDirectory = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData) + "\\CaseWare IDEA\\SmartAnalyzer\\FilterParameters";
            openFileDialog1.Title = "Parameter-Datei laden";
            openFileDialog1.Filter = "Parameter-Datei" + " (*.xml)|*.xml|" + "Alle Formate" + " (*.*)|*.*";
            openFileDialog1.RestoreDirectory = true;
            openFileDialog1.DefaultExt = "xml";
            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                XmlDocument doc = new XmlDocument();
                doc.Load(openFileDialog1.FileName);
                
                XmlNode JoinTypeNode = doc.DocumentElement.SelectSingleNode("JoinType");
                sComB_JoinType.SelectedItem = JoinTypeNode.InnerText;
                
                XmlNode BoniNode = doc.DocumentElement.SelectSingleNode("Boni");
                sTB_Boni.Value = BoniNode.InnerText;
                
                XmlNode RatingNode = doc.DocumentElement.SelectSingleNode("Rating");
                sComB_Rating.SelectedItem = RatingNode.InnerText;
                
                XmlNode RiskVolumeNode = doc.DocumentElement.SelectSingleNode("Risikovolumen");
                sTB_RiskVolume.Value = RiskVolumeNode.InnerText;

                XmlNode BlankVolumeNode = doc.DocumentElement.SelectSingleNode("Blankovolumen");
                sTB_BlankVolume.Value = BlankVolumeNode.InnerText;

                XmlNode OverdraftNode = doc.DocumentElement.SelectSingleNode("Ueberziehung");
                sTB_Overdraft.Value = OverdraftNode.InnerText;
            }
        }

        private void sOG_rr_Load(object sender, EventArgs e)
        {

        }

        private void _DialogMainForm_Load(object sender, EventArgs e)
        {
            //_DialogMainForm_Resize(null, null);

            sComB_JoinType.Enabled = false;
            sTB_Boni.Enabled = false;
            sComB_Rating.Enabled = false;
            sTB_BlankVolume.Enabled = false;
            sTB_RiskVolume.Enabled = false;
            sTB_Overdraft.Enabled = false;
            btn_Load.Enabled = false;
            btn_Save.Enabled = false;
        }

        private void sCB_UseIdividualRiskRel_CheckedChanged(object sender, EventArgs e)
        {
            if(sCB_UseIdividualRiskRel.Checked == true)
            {
                sComB_JoinType.Enabled = true;
                sTB_Boni.Enabled = true;
                sComB_Rating.Enabled = true;
                sTB_BlankVolume.Enabled = true;
                sTB_RiskVolume.Enabled = true;
                sTB_Overdraft.Enabled = true;
                btn_Load.Enabled = true;
                btn_Save.Enabled = true;
            }
            if (sCB_UseIdividualRiskRel.Checked == false)
            {
                sComB_JoinType.Enabled = false;
                sTB_Boni.Enabled = false;
                sComB_Rating.Enabled = false;
                sTB_BlankVolume.Enabled = false;
                sTB_RiskVolume.Enabled = false;
                sTB_Overdraft.Enabled = false;
                btn_Load.Enabled = false;
                btn_Save.Enabled = false;

                sComB_JoinType.SelectedIndex = 0;
                sTB_Boni.Value = null;
                sComB_Rating.SelectedIndex = 0;
                sTB_BlankVolume.Value = null;
                sTB_RiskVolume.Value = null;
                sTB_Overdraft.Value = null;
            }
        }
        private void _DialogMainForm_Resize(object sender, EventArgs e)
        {
            try
            {
                var delta = 10;
                var extraHeight = this.Height - this.ClientSize.Height;
                var extraWidth = this.Width - this.ClientSize.Width;

                //group box
                //---------------------------------------------------------
                smartGroupBox1.Top = delta + extraHeight;
                smartGroupBox1.Left = delta + extraWidth;

                sCB_UseIdividualRiskRel.Top = 2 * delta;
                sCB_UseIdividualRiskRel.Left = delta;

                smartGroupBox1.Height = sCB_UseIdividualRiskRel.Height + 3 * delta; // 2 Top, 1 bottom
                //smartGroupBox1.Width = sTB_Boni.Right;
                //---------------------------------------------------------

                sComB_JoinType.Top = smartGroupBox1.Bottom + delta;
                sComB_JoinType.Left = delta + extraWidth;
                //sComB_JoinType.Width = sTB_Boni.Right;

                //---------------------------------------------------------
                smartLabel1.Top = sComB_JoinType.Top + sComB_JoinType.Height + delta + 5;
                smartLabel1.Left = delta + extraWidth;

                sTB_Boni.Top = sComB_JoinType.Bottom + delta;
                sTB_Boni.Left = smartLabel1.Right + delta;
                //---------------------------------------------------------
                //---------------------------------------------------------
                smartLabel2.Top = sTB_Boni.Bottom + delta + 5;
                smartLabel2.Left = delta + extraWidth;

                sComB_Rating.Top = sTB_Boni.Bottom + delta;
                sComB_Rating.Left = smartLabel2.Right + delta;
                //---------------------------------------------------------
                //---------------------------------------------------------
                smartLabel3.Top = sComB_Rating.Bottom + delta + 5;
                smartLabel3.Left = delta + extraWidth;

                sTB_RiskVolume.Top = sComB_Rating.Bottom + delta;
                sTB_RiskVolume.Left = smartLabel3.Right + delta;
                //---------------------------------------------------------
                //---------------------------------------------------------
                smartLabel4.Top = sTB_RiskVolume.Bottom + delta + 5;
                smartLabel4.Left = delta + extraWidth;

                sTB_BlankVolume.Top = sTB_RiskVolume.Bottom + delta;
                sTB_BlankVolume.Left = smartLabel4.Right + delta;
                //---------------------------------------------------------
                //---------------------------------------------------------
                smartLabel5.Top = sTB_BlankVolume.Bottom + delta + 5;
                smartLabel5.Left = delta + extraWidth;

                sTB_Overdraft.Top = sTB_BlankVolume.Bottom + delta;
                sTB_Overdraft.Left = smartLabel5.Right + delta;
                //---------------------------------------------------------

                btn_Save.Top = smartLabel5.Bottom + delta;
                btn_Save.Left = delta + extraWidth;

                btn_Load.Top = btn_Save.Top;
                btn_Load.Left = btn_Save.Right + delta;

                Button_OK.Top = btn_Save.Top;
                Button_OK.Left = btn_Load.Right + 4 * delta;

                Button_Cancel.Top = btn_Save.Top;
                Button_Cancel.Left = Button_OK.Right + delta;

                this.Height = Button_Cancel.Bottom + delta + extraHeight;
                this.Width = Button_Cancel.Right + delta + extraWidth;
            }
            catch
            {

            }
        }
    }
}
