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

namespace Aktivgeschaeft_01_SelectFolder
{
    public partial class Einstellungen : Form
    {
        private Audicon.SmartAnalyzer.Client.CustomControls.SmartDataExchanger smartDataExchangerGotten;
        private IExecutionContext executionContext;

        string Importdefinition;
        string ColumnDelimiter;
        bool ActivateWarning;
        public Einstellungen(Audicon.SmartAnalyzer.Client.CustomControls.SmartDataExchanger smartDataExchangerSend)
        {
            InitializeComponent();

            smartDataExchangerGotten = smartDataExchangerSend;
        }

        private void Einstellungen_Load(object sender, EventArgs e)
        {
            InitSmartContext();

            //get resource strings
            //lables
            sLVersion_Importdefinition.Text = DialogStrings.lableVersion_ImportDefinition;
            sLColumn_Delimiter.Text = DialogStrings.lableColumn_Delimiter;
            //checkbox
            sCBVersion_Warning.Text = DialogStrings.checkboxAktivate_Version_Warning;
            //combobox items
            sComboBVersion_Importdefinition.Items.Add(DialogStrings.comboboxVersion_Importdefinition_1);
            sComboBVersion_Importdefinition.Items.Add(DialogStrings.comboboxVersion_Importdefinition_2);

            sComboBColumn_Delimiter.Items.Add(DialogStrings.comboboxColumn_Delimiter_1);
            sComboBColumn_Delimiter.Items.Add(DialogStrings.comboboxColumn_Delimiter_2);

            //load saved inputs
            Importdefinition = Properties.Settings.Default.ImportDefinition;
            ColumnDelimiter = Properties.Settings.Default.ColumnDelimiter;
            ActivateWarning = Properties.Settings.Default.ActivateWarning;

            //set combobox sComboBVersion_Importdefinition
            if ((Importdefinition == null) || ((Importdefinition != null) && (Importdefinition.Equals(""))))
            {
                sComboBVersion_Importdefinition.SelectedIndex = 1;
            }
            else
            {
                try
                {
                    sComboBVersion_Importdefinition.SelectedItem = Importdefinition;
                    if (sComboBVersion_Importdefinition.SelectedItem.ToString() != Importdefinition)
                    {
                        sComboBVersion_Importdefinition.SelectedIndex = 1;
                    }
                }
                catch
                {
                    MessageBox.Show(DialogStrings.warning_SaveEntriesNotFound);
                    sComboBVersion_Importdefinition.SelectedIndex = 1;
                }
                
            }

            //set combobox sComboBColumn_Delimiter
            if ((ColumnDelimiter == null) || ((ColumnDelimiter != null) && (ColumnDelimiter.Equals(""))))
            {
                sComboBColumn_Delimiter.SelectedIndex = 0;
            }
            else
            {
                try
                {
                    sComboBColumn_Delimiter.SelectedItem = ColumnDelimiter;
                    if (sComboBColumn_Delimiter.SelectedItem.ToString() != ColumnDelimiter)
                    {
                        sComboBColumn_Delimiter.SelectedIndex = 1;
                    }
                }
                catch
                {
                    MessageBox.Show(DialogStrings.warning_SaveEntriesNotFound);
                    sComboBColumn_Delimiter.SelectedIndex = 0;
                }

            }

            //set sCBVersion_Warning
            sCBVersion_Warning.Checked = ActivateWarning;
        }

        private void InitSmartContext()
        {
            foreach (DictionaryEntry item in smartDataExchangerGotten.Value)
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

        private void btnSave_Click(object sender, EventArgs e)
        {
            Properties.Settings.Default.ImportDefinition = sComboBVersion_Importdefinition.SelectedItem.ToString();
            Properties.Settings.Default.ColumnDelimiter = sComboBColumn_Delimiter.SelectedItem.ToString();
            Properties.Settings.Default.ActivateWarning = sCBVersion_Warning.Checked;
            Properties.Settings.Default.Save();

            MessageBox.Show(DialogStrings.info_SaveMessage);
            this.Close();
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
