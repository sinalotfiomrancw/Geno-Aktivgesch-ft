using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Audicon.SmartAnalyzer.Common.Types;
using System.IO;

namespace Aktivgeschaeft_01_SelectFolder
{
    //[DefaultForm]  // uncomment this line for apps requiring IDEA 10.1 and higher
    public partial class _DialogMainForm : Form
    {
        string folderPath = "";
        private Dictionary<string, string> searchPatterns = new Dictionary<string, string>
        {
            { "KRM", "KRM" },
            { "Kreditbesch", "Kreditbeschlussbuch" },
            { "pattern3", "Pattern 3" }
        };
        private TableLayoutPanel tableLayoutPanel;
        public _DialogMainForm()
        {
            InitializeComponent();
            //InitializeTableLayoutPanel();
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

        private void sTB_FolderPath_OnTextChanged(object sender, EventArgs data)
        {
            //folderPath = sTB_FolderPath.Value;
            //if ( Directory.Exists(folderPath) )
            //{
            //    SearchFiles();
            //}
            //else
            //{
            //
            //}
        }

        private void SearchFiles()
        {
            Dictionary<string, string> foundFiles = new Dictionary<string, string>();
            List<string> notFoundFiles = new List<string>();

            string[] csvFiles = Directory.GetFiles(folderPath, "*.xlsx");

            foreach (string csvFile in csvFiles)
            {
                string fileName = Path.GetFileNameWithoutExtension(csvFile);
                bool isMatched = false;

                foreach (var pattern in searchPatterns)
                {
                    if (fileName.Contains(pattern.Key))
                    {
                        foundFiles.Add(fileName, pattern.Value);
                        isMatched = true;
                        break;
                    }
                }

                if (!isMatched)
                    notFoundFiles.Add(fileName);
            }

            ShowSearchResults(foundFiles, notFoundFiles);
        }

        private void ShowSearchResults(Dictionary<string, string> foundFiles, List<string> notFoundFiles)
        {
            foreach (var pattern in searchPatterns)
            {
                if (foundFiles.ContainsKey(pattern.Value))
                    AddResultToTable(pattern.Value, foundFiles[pattern.Value]);
                else
                    AddResultToTable(pattern.Value, "Not Found");
            }

            foreach (var file in notFoundFiles)
            {
                AddResultToTable("Not Found", file);
            }
        }
        private void InitializeTableLayoutPanel()
        {
            tableLayoutPanel = new TableLayoutPanel();
            tableLayoutPanel.Location = new System.Drawing.Point(15, 80);
            tableLayoutPanel.MaximumSize = new System.Drawing.Size(1000, 1000);
            tableLayoutPanel.AutoSize = true;
            //tableLayoutPanel.Size = new System.Drawing.Size(400, 100);
            //tableLayoutPanel.Dock = DockStyle.Left;
            tableLayoutPanel.CellBorderStyle = TableLayoutPanelCellBorderStyle.OutsetDouble;
            tableLayoutPanel.ColumnCount = 2;
            tableLayoutPanel.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50F));
            tableLayoutPanel.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50F));
            tableLayoutPanel.AutoScroll = true;

            Controls.Add(tableLayoutPanel);
        }

        private void AddResultToTable(string pattern, string file)
        {
            var patternLabel = new Label();
            patternLabel.Text = pattern;

            var fileLabel = new Label();
            fileLabel.Text = file;

            tableLayoutPanel.RowCount++;
            tableLayoutPanel.RowStyles.Add(new RowStyle(SizeType.AutoSize));
            tableLayoutPanel.Controls.Add(patternLabel, 0, tableLayoutPanel.RowCount - 1);
            tableLayoutPanel.Controls.Add(fileLabel, 1, tableLayoutPanel.RowCount - 1);
        }

        private void btn_SearchFolder_Click(object sender, EventArgs e)
        {
            DialogResult result = folderBrowserDialog1.ShowDialog();
            if ( result == DialogResult.OK)
            {
                folderPath = folderBrowserDialog1.SelectedPath;
            }

            sTB_FolderPath.Value = folderPath;
        }
    }
}
