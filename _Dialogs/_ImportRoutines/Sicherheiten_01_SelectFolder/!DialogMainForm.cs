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
using Audicon.SmartAnalyzer.Client.CustomControls;

namespace Sicherheiten_01_SelectFolder
{
    [DefaultForm]  // uncomment this line for apps requiring IDEA 10.1 and higher
    public partial class _DialogMainForm : Form
    {
        private IExecutionContext executionContext;

        string directoryPath;

        //files
        const string SB_Key = "Basisdaten";
        const string SBI_Key = "Immo";
        const string SBH_Key = "Bürgschaften";
        const string SZR_Key = "Realkredit";
        const string SZS_Key = "Si-Wert";

        private Dictionary<string, string> searchPatterns = new Dictionary<string, string>
        {
            { SB_Key, "Basisdaten" },
            { SBI_Key, "Immo" },
            { SBH_Key, "Bürgschaften" },
            { SZR_Key, "Realkredit" },
            { SZS_Key, "Si-Wert" }
        };

        private Dictionary<string, string> foundFiles = new Dictionary<string, string>
        {
            { SB_Key, "" },
            { SBI_Key, "" },
            { SBH_Key, "" },
            { SZR_Key, "" },
            { SZS_Key, "" }
        };

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

        private void btn_FileSearch_Click(object sender, EventArgs e)
        {
            if (folderBrowserDialog1.ShowDialog() == DialogResult.OK)
            {
                sTB_FilePath.Value = folderBrowserDialog1.SelectedPath;
            }
        }

        private void _DialogMainForm_Load(object sender, EventArgs e)
        {
            InitSmartContext();

            //get resource strings
            //lables
            //set predfined values
            //sTB_DataExportDate.Value = DateTime.Now.ToString();

            //_DialogMainForm_Resize(null, null);

            sSi_Bas.Enabled = false;
            sSi_Bas_Immo.Enabled = false;
            sSi_Buerg_Haft.Enabled = false;
            sSi_Zwek_RK.Enabled = false;
            sSi_Zwek_Si_Wert.Enabled = false;
        }

        private void InitSmartContext()
        {
            foreach (DictionaryEntry item in smartDataExchanger.Value)
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

        private void btn_OK_Click(object sender, EventArgs e)
        {
            string folderPath = sTB_FilePath.Value;
            string subfolderPath = "";
            bool foundUtf16File = false;
            string[] csvTxtFiles = Directory.GetFiles(folderPath, "*.csv", SearchOption.TopDirectoryOnly)
                            .Union(Directory.GetFiles(folderPath, "*.txt", SearchOption.TopDirectoryOnly))
                            .ToArray();

            foreach (string filePath in csvTxtFiles)
            {
                if (IsUtf16Encoded(filePath))
                {
                    foundUtf16File = true;
                    break;
                }
            }
            if (foundUtf16File)
            {
                // Execute code when there is at least one UTF-16 encoded file
                subfolderPath = CreateTimestampFolder(folderPath);
                if (subfolderPath != null)
                {
                    ConvertUtf16ToAnsi(folderPath, subfolderPath);
                    CopyFilesWithUniqueNames(folderPath, subfolderPath);
                }

            }
            else
            {
                // Execute code when there are no UTF-16 encoded files
                //Console.WriteLine("No UTF-16 encoded files found.");
            }

            smartDataExchanger.Value["TempFolder"] = subfolderPath;

            DialogResult = DialogResult.OK;
            Close();
        }

        private void sTB_FilePath_OnTextChanged(object sender, EventArgs data)
        {
            directoryPath = sTB_FilePath.Value;

            sSi_Bas.Checked = false;
            sSi_Bas_Immo.Checked = false;
            sSi_Buerg_Haft.Checked = false;
            sSi_Zwek_RK.Checked = false;
            sSi_Zwek_Si_Wert.Checked = false;

            sSi_Bas.Enabled = false;
            sSi_Bas_Immo.Enabled = false;
            sSi_Buerg_Haft.Enabled = false;
            sSi_Zwek_RK.Enabled = false;
            sSi_Zwek_Si_Wert.Enabled = false;

            foundFiles.Clear();

            if (Directory.Exists(directoryPath))
            {
                SearchFiles();
                ActivateTopics();
            }
            else
            {

            }
        }

        private void SearchFiles()
        {
            string[] allFiles = Directory.GetFiles(directoryPath, "*.*");

            //foreach(string allFile in allFiles)
            //{
            //    string fileName = Path.GetFileName(allFile);
            //
            //    foreach (var pattern in searchPatterns)
            //    {
            //        if (fileName.Contains(pattern.Value))
            //        {
            //            foundFiles.Add(pattern.Key, fileName);
            //            break;
            //        }
            //    }
            //}
            foreach (var pattern in searchPatterns)
            {
                foreach (string allFile in allFiles)
                {
                    string fileName = Path.GetFileName(allFile);

                    if ((pattern.Value) == "Basisdaten")
                    {
                        if (fileName.Contains(pattern.Value) && !fileName.Contains("Immo"))
                        {
                            foundFiles.Add(pattern.Key, fileName);
                            break;
                        }
                    }
                    else if (fileName.Contains(pattern.Value))
                    {
                        foundFiles.Add(pattern.Key, fileName);
                        break;
                    }
                }
            }
        }

        private void ActivateTopics()
        {
            //KRM
            if (foundFiles.ContainsKey(SB_Key) == true)
            {
                sSi_Bas.Checked = true;

                sSi_Bas.Enabled = true;
            }
            if (foundFiles.ContainsKey(SBI_Key) == true)
            {
                sSi_Bas_Immo.Checked = true;

                sSi_Bas_Immo.Enabled = true;
            }
            if (foundFiles.ContainsKey(SBH_Key) == true)
            {
                sSi_Buerg_Haft.Checked = true;

                sSi_Buerg_Haft.Enabled = true;
            }
            if (foundFiles.ContainsKey(SZR_Key) == true)
            {
                sSi_Zwek_RK.Checked = true;

                sSi_Zwek_RK.Enabled = true;
            }
            if (foundFiles.ContainsKey(SZS_Key) == true)
            {
                sSi_Zwek_Si_Wert.Checked = true;

                sSi_Zwek_Si_Wert.Enabled = true;
            }
        }

        static string CreateTimestampFolder(string baseFolderPath)
        {
            // Generate a timestamp
            string timestamp = DateTime.Now.ToString("yyyyMMddHHmmss");

            // Create a subfolder with timestamp called "Für Import aufbereitete Dateien_{timestamp}"
            string subfolderName = $"Temp_{timestamp}";
            string subfolderPath = Path.Combine(baseFolderPath, subfolderName);

            try
            {
                Directory.CreateDirectory(subfolderPath);
                return subfolderPath;
            }
            catch (Exception e)
            {
                Console.WriteLine($"Error creating folder: {e.Message}");
                return null;
            }
        }

        static void ConvertUtf16ToAnsi(string originalFolderPath, string subfolderPath)
        {
            // Iterate through all files in the original folder
            foreach (string filePath in Directory.GetFiles(originalFolderPath, "*.*"))
            {
                // Check if the file is a .txt or .csv file
                string fileExtension = Path.GetExtension(filePath).ToLower();
                if (fileExtension != ".txt" && fileExtension != ".csv")
                {
                    Console.WriteLine($"{Path.GetFileName(filePath)} is not a .txt or .csv file. Skipping...");
                    continue;
                }

                // Check if the file is encoded in UTF-16
                byte[] bom = new byte[2];
                using (FileStream fileStream = new FileStream(filePath, FileMode.Open, FileAccess.Read))
                {
                    fileStream.Read(bom, 0, 2);
                }

                if (bom[0] != 0xFF || bom[1] != 0xFE)
                {
                    Console.WriteLine($"{Path.GetFileName(filePath)} is not UTF-16 encoded. Skipping...");
                    continue;
                }

                // Create a new file path for the ANSI-encoded file in the subfolder
                string newFileName = Path.GetFileNameWithoutExtension(filePath) + fileExtension;
                string newFilePath = Path.Combine(subfolderPath, newFileName);

                // Convert UTF-16 to ANSI and save as a new file, replacing unencodable characters with '?'
                using (StreamReader reader = new StreamReader(filePath, Encoding.Unicode))
                using (StreamWriter writer = new StreamWriter(newFilePath, false, Encoding.GetEncoding(1252)))
                {
                    while (!reader.EndOfStream)
                    {
                        string line = reader.ReadLine();
                        writer.WriteLine(line);
                    }
                }

                Console.WriteLine($"{Path.GetFileName(filePath)} converted to ANSI encoding and saved in '{subfolderPath}'.");
            }
        }


        static void CopyFilesWithUniqueNames(string sourceFolderPath, string targetFolderPath)
        {
            // Check if the source folder path exists
            if (!Directory.Exists(sourceFolderPath))
            {
                Console.WriteLine($"The source folder '{sourceFolderPath}' does not exist.");
                return;
            }

            // Check if the target folder path exists, and if not, create it
            if (!Directory.Exists(targetFolderPath))
            {
                Directory.CreateDirectory(targetFolderPath);
            }

            // Iterate through all files in the source folder
            foreach (string filePath in Directory.GetFiles(sourceFolderPath, "*.*"))
            {
                // Check if the file is a .txt or .csv file
                string fileExtension = Path.GetExtension(filePath).ToLower();
                if (fileExtension != ".txt" && fileExtension != ".csv")
                {
                    Console.WriteLine($"{Path.GetFileName(filePath)} is not a .txt or .csv file. Skipping...");
                    continue;
                }

                // Check if a file with the same name already exists in the target folder
                string targetFilePath = Path.Combine(targetFolderPath, Path.GetFileName(filePath));
                if (File.Exists(targetFilePath))
                {
                    Console.WriteLine($"{Path.GetFileName(filePath)} already exists in the target folder. Skipping...");
                    continue;
                }

                // Copy the file to the target folder
                File.Copy(filePath, targetFilePath);

                Console.WriteLine($"{Path.GetFileName(filePath)} copied to the target folder.");
            }
        }
        static bool IsUtf16Encoded(string filePath)
        {
            byte[] buffer = new byte[4];
            using (FileStream fileStream = new FileStream(filePath, FileMode.Open, FileAccess.Read))
            {
                fileStream.Read(buffer, 0, 4);
            }

            return (buffer[0] == 0xFF && buffer[1] == 0xFE) || (buffer[0] == 0xFE && buffer[1] == 0xFF);
        }
    }
}
