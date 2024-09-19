'--------------------------------------------------------------------------------
' changed by:	
' changed on:	
' description:	
'--------------------------------------------------------------------------------
Option Explicit

'#Region - SmartAnalyzer standard constants
' Execution status codes
Const EXEC_STATUS_FAILED    As Long = 0
Const EXEC_STATUS_SUCCEEDED As Long = 1
Const EXEC_STATUS_CANCELED  As Long = 3

' Result file type codes
' Used for UniqueFileName and CreateResultObject functions
Const NOT_A_RESULT          As Long = 0
Const INPUT_DATABASE        As Long = 1
Const INTERMEDIATE_RESULT   As Long = 2
Const FINAL_RESULT          As Long = 4
Const NO_REGISTRATION       As Long = 8
'#End Region

'#Region - SmartAnalyzer standard variables
' m_checkpointName is used for error logging and this variable has to be kept global!
' The value provided by this variable shall give a clue where an error occurred.
' Remarks: It is set in Sub 'SetCheckpoint'
'          And  used in Sub 'LogSmartAnalyzerError'
Dim m_checkpointName As String

' The following variables are defined globally because they might be used in several sub routines.
' If this is not the case, please remove the variables from here!
Dim oMC As Object 	' Macro Commands Object
Dim oSC As Object 	' Simple Commands Object
Dim oTM As Object 	' Task Management Object
Dim oPip As Object	' Object for Protecting the Intellectual Property
Dim oDialogPara As Object
'#End Region

'#Region - IDEA standard variables
' These variables are only globally defined because "Option Explicit"
' is used and IDEA is not recording them anymore.
' Defining these variables narrow to the place where they are used would be much better.
Dim db As Object
Dim task As Object
Dim field As Object
Dim table As Object
Dim eqn As String
Dim dbName As String
Dim rs As Object
Dim rec As Object
'#End Region

'#Region - Input file
' Include the primary input file an all tag names
Dim sInputFile As String 'KRM

Dim sDATUM_DATENABZUG As String
Dim sID As String
Dim sNETTO_ENGAGEMENT As String
Dim sKUNDENGRUPPEN_NR As String
Dim sENGAGEMENTBEZ As String
Dim sKUNDENNUMMER As String
Dim sKUNDENNAME As String
Dim sKONTONUMMER As String
Dim sRISIKOGRUPPE As String
Dim sRISIKOGRUPPE_ENGA As String
Dim sBONITÄTSEINSTUFUNG As String
Dim sBONITÄTSEINST_ENGA As String
Dim sVR_RATINGART As String
Dim sVR_RATINGART_ENGA As String
Dim sVR_RATING As String
Dim sVR_RATING_ENGA As String
Dim sAUSFALLRATE_KUNDE As String
Dim sDATUM_LTZ_RATING As String
Dim sRISIKOVOLUMEN_EUR As String
Dim sNETTO_RISIKOVOLUMEN_EUR As String
Dim sEIGENANTEIL_EUR As String
Dim sNOM_VOL_EUR As String
Dim sGESAMTZUSAGE_EUR As String
Dim sBLANKOVOLUMEN_RV_EUR As String
Dim sBLANKOVOLUMEN_IA_EUR As String
Dim sNETTO_BLANKOVOL_RV_EUR As String
Dim sNETTO_BLANKOVOL_IA_EUR As String
Dim sBARWERT_BLANKOVOL_EUR As String
Dim sOFFENE_ZUSAGE_EUR As String
Dim sINTERNES_LIMIT_EUR As String
Dim sEWB_RST_GEBUCHT_EUR As String
Dim sEWB_RST_KALK_EUR As String
Dim sSUMME_SICHERHEIT_RV_EUR As String
Dim sSUMME_SICHERHEIT_IA_EUR As String
Dim sGRUNDPFANDRECHTE_RV_EUR As String
Dim sGRUNDPFANDRECHTE_IA_EUR As String
Dim sABTRET_GELDVERM_RV_EUR As String
Dim sABTRET_GELDVERM_IA_EUR As String
Dim sABTRET_SONSTIGES_RV_EUR As String
Dim sABTRET_SONSTIGES_IA_EUR As String
Dim sBÜRG_ÖFF_BANKEN_RV_EUR As String
Dim sBÜRG_ÖFF_BANKEN_IA_EUR As String
Dim sSONST_BÜRG_RV_EUR As String
Dim sSONST_BÜRG_IA_EUR As String
Dim sSICHERH_ÜBEREIG_RV_EUR As String
Dim sSICHERH_ÜBEREIG_IA_EUR As String
Dim sSONST_SICHERH_RV_EUR As String
Dim sSONST_SICHERH_IA_EUR As String
Dim sVERPF_GELDVERM_RV_EUR As String
Dim sVERPF_GELDVERM_IA_EUR As String
Dim sVERPF_SONSTIGES_RV_EUR As String
Dim sVERPF_SONSTIGES_IA_EUR As String
Dim sGK_ENGA_RV_EUR As String
Dim sGK_ENGA_EA_EUR As String
Dim sGK_ENGA_BVRV_EUR As String
Dim sGK_ENGA_BVIA_EUR As String
Dim sGK_KD_RV_EUR As String
Dim sGK_KD_EA_EUR As String
Dim sGK_KD_BVRV_EUR As String
Dim sGK_KD_BVIA_EUR As String
Dim sGK_KD_NTOBVRV_EUR As String
Dim sDIREKT_ABSCHREIBUNG_EUR As String
Dim sBERATER As String
Dim sGEWERBLICH_PRIVAT As String
Dim sRECHTSFORM As String
Dim sBRANCHE As String
Dim sKPM_BRANCHE As String
Dim sKPM_BERÜCKS_KD_RS As String
Dim sKONTOWÄHRUNG As String
Dim sLÄNDERSCHLÜSSEL As String
Dim sKUNDE_SEIT_DATUM As String
Dim sGEB_GRÜND_DATUM As String
Dim sGAB As String
Dim sAGREE_PRODUKTNUMMER As String
Dim sCVAR_EUR As String
Dim sEXPECTED_LOSS_EUR As String
Dim sRISIKOSTATUS_MAK As String
Dim sRISIKOKENNZEICHEN As String
Dim sKUNDEN_EIGENGESCHÄFT As String
Dim sÜBERZIEHUNG_KTO_EUR As String
Dim sTAGE_ÜBERZ_KTO As String
Dim sÜBERZ_KD_BASEL_EUR As String
Dim sTAGE_ÜBERZ_KD_BASEL As String
Dim sGK_KD_ÜBERZ_EUR As String
Dim sTAGE_ÜBERZ_KUNDE As String
Dim sÜBERZ_ENG_BASEL_EUR As String
Dim sTAGE_ÜBERZ_ENG_BASEL As String
Dim sGK_ENGA_ÜBERZ_EUR As String
Dim sTAGE_ÜBERZ_ENGA As String
Dim sJAHRESABSCHLUSSDATUM As String
Dim sDATUM_KTO_ERÖFF_SCHL As String
Dim sDATUM_LTZ_RISIKOKZ As String
Dim sVR_RATING_NUM As String
'#End Region

'#Region - Folder
Dim sWorkingFolderPath As String
Dim sWorkingFolderName As String
'#End Region

'#Region - temp files
Dim sRating_Evolution As String
'#End Region

'#Region - result files
Dim sMigrationsIntoCritStock As String
Dim sMigrationsDeletedRatings As String
'#End Region

'#Region - dialog
Dim bUseCritStock As Boolean
Dim sLowerLimitCritStock As String
Dim sUpperLimitCritStock As String
Dim nRisikovolumen As Long

'#End Region
Sub Main()
	On Error GoTo ErrHandler:
	
	SetCheckpoint "Begin of Sub Main()"
	
	SmartContext.Log.LogMessage "Audit test: '{0}'", SmartContext.TestName
	SmartContext.Log.LogMessage "Test version: {0}", SmartContext.TestVersion
	SmartContext.Log.LogMessage "Called at: {0}", Format(Now(), "yyyy-MM-dd hh:mm:ss")
	SmartContext.Log.LogMessage "Runs on server: {0}", SmartContext.IsServerTask
	
	' Please check whether the variables below are really needed.
	' Remove all unnecessary variables and this comment too
	Set oMC = SmartContext.MacroCommands
	Set oSC = oMC.SimpleCommands
	Set oTM = oMC.TagManagement
	Set oPip = oMC.ProtectIP
	Set oDialogPara = SmartContext.Parameters
	
	' **** Add your code below this line
	Call GetFileInformation
	Call GetParameters
	Call Analysis
	Call registerResult(sInputFile, INPUT_DATABASE, 0)
	Call registerResult(sMigrationsIntoCritStock, FINAL_RESULT, 1)
	'Call registerResult(sMigrationsDeletedRatings, FINAL_RESULT,1)
	' **** End of the user specific code
	
	SmartContext.ExecutionStatus = EXEC_STATUS_SUCCEEDED
	
	SetCheckpoint "End of Sub Main()"
	
	Set oMC = Nothing
	Set oSC = Nothing
	Set oTM = Nothing
	Set oPip = Nothing
	Set oDialogPara = Nothing
	
	SmartContext.Log.LogMessage "Audit test run ends at: {0}", Format(Now(), "yyyy-MM-dd hh:mm:ss")
	
	Exit Sub
	
ErrHandler:
	Call LogSmartAnalyzerError("")
	
	Call EndSequenze
End Sub
' --------------------------------------------------------------------------

' Gets the input file and the tags.
Function GetFileInformation
SetCheckpoint "GetFileInformation 1.0 - get primary input file"
	sInputFile = SmartContext.PrimaryInputfile
SetCheckpoint "GetFileInformation 1.1 - get working folder"
	Call GetWorkingFolder(sInputFile)
SetCheckpoint "GetFileInformation 2.0 - get tags"
	Set db = Client.OpenDatabase(sInputFile)
	sDATUM_DATENABZUG = oTM.GetFieldForTag(db, "acc!DATUM_DATENABZUG")
	'sID = oTM.GetFieldForTag(db, "acc!ID")
	'sNETTO_ENGAGEMENT = oTM.GetFieldForTag(db, "acc!NETTO_ENGAGEMENT")
	'sKUNDENGRUPPEN_NR = oTM.GetFieldForTag(db, "acc!KUNDENGRUPPEN_NR")
	'sENGAGEMENTBEZ = oTM.GetFieldForTag(db, "acc!ENGAGEMENTBEZ")
	sKUNDENNUMMER = oTM.GetFieldForTag(db, "acc!KUNDENNUMMER")
	'sKUNDENNAME = oTM.GetFieldForTag(db, "acc!KUNDENNAME")
	'sKONTONUMMER = oTM.GetFieldForTag(db, "acc!KONTONUMMER")
	'sRISIKOGRUPPE = oTM.GetFieldForTag(db, "acc!RISIKOGRUPPE")
	'sRISIKOGRUPPE_ENGA = oTM.GetFieldForTag(db, "acc!RISIKOGRUPPE_ENGA")
	'sBONITÄTSEINSTUFUNG = oTM.GetFieldForTag(db, "acc!BONITÄTSEINSTUFUNG")
	'sBONITÄTSEINST_ENGA = oTM.GetFieldForTag(db, "acc!BONITÄTSEINST_ENGA")
	'sVR_RATINGART = oTM.GetFieldForTag(db, "acc!VR_RATINGART")
	'sVR_RATINGART_ENGA = oTM.GetFieldForTag(db, "acc!VR_RATINGART_ENGA")
	sVR_RATING = oTM.GetFieldForTag(db, "acc!VR_RATING")
	'sVR_RATING_ENGA = oTM.GetFieldForTag(db, "acc!VR_RATING_ENGA")
	'sAUSFALLRATE_KUNDE = oTM.GetFieldForTag(db, "acc!AUSFALLRATE_KUNDE")
	'sDATUM_LTZ_RATING = oTM.GetFieldForTag(db, "acc!DATUM_LTZ_RATING")
	'sRISIKOVOLUMEN_EUR = oTM.GetFieldForTag(db, "acc!RISIKOVOLUMEN_EUR")
	'sNETTO_RISIKOVOLUMEN_EUR = oTM.GetFieldForTag(db, "acc!NETTO_RISIKOVOLUMEN_EUR")
	'sEIGENANTEIL_EUR = oTM.GetFieldForTag(db, "acc!EIGENANTEIL_EUR")
	'sNOM_VOL_EUR = oTM.GetFieldForTag(db, "acc!NOM_VOL_EUR")
	'sGESAMTZUSAGE_EUR = oTM.GetFieldForTag(db, "acc!GESAMTZUSAGE_EUR")
	'sBLANKOVOLUMEN_RV_EUR = oTM.GetFieldForTag(db, "acc!BLANKOVOLUMEN_RV_EUR")
	'sBLANKOVOLUMEN_IA_EUR = oTM.GetFieldForTag(db, "acc!BLANKOVOLUMEN_IA_EUR")
	'sNETTO_BLANKOVOL_RV_EUR = oTM.GetFieldForTag(db, "acc!NETTO_BLANKOVOL_RV_EUR")
	'sNETTO_BLANKOVOL_IA_EUR = oTM.GetFieldForTag(db, "acc!NETTO_BLANKOVOL_IA_EUR")
	'sBARWERT_BLANKOVOL_EUR = oTM.GetFieldForTag(db, "acc!BARWERT_BLANKOVOL_EUR")
	'sOFFENE_ZUSAGE_EUR = oTM.GetFieldForTag(db, "acc!OFFENE_ZUSAGE_EUR")
	'sINTERNES_LIMIT_EUR = oTM.GetFieldForTag(db, "acc!INTERNES_LIMIT_EUR")
	'sEWB_RST_GEBUCHT_EUR = oTM.GetFieldForTag(db, "acc!EWB_RST_GEBUCHT_EUR")
	'sEWB_RST_KALK_EUR = oTM.GetFieldForTag(db, "acc!EWB_RST_KALK_EUR")
	'sSUMME_SICHERHEIT_RV_EUR = oTM.GetFieldForTag(db, "acc!SUMME_SICHERHEIT_RV_EUR")
	'sSUMME_SICHERHEIT_IA_EUR = oTM.GetFieldForTag(db, "acc!SUMME_SICHERHEIT_IA_EUR")
	'sGRUNDPFANDRECHTE_RV_EUR = oTM.GetFieldForTag(db, "acc!GRUNDPFANDRECHTE_RV_EUR")
	'sGRUNDPFANDRECHTE_IA_EUR = oTM.GetFieldForTag(db, "acc!GRUNDPFANDRECHTE_IA_EUR")
	'sABTRET_GELDVERM_RV_EUR = oTM.GetFieldForTag(db, "acc!ABTRET_GELDVERM_RV_EUR")
	'sABTRET_GELDVERM_IA_EUR = oTM.GetFieldForTag(db, "acc!ABTRET_GELDVERM_IA_EUR")
	'sABTRET_SONSTIGES_RV_EUR = oTM.GetFieldForTag(db, "acc!ABTRET_SONSTIGES_RV_EUR")
	'sABTRET_SONSTIGES_IA_EUR = oTM.GetFieldForTag(db, "acc!ABTRET_SONSTIGES_IA_EUR")
	'sBÜRG_ÖFF_BANKEN_RV_EUR = oTM.GetFieldForTag(db, "acc!BÜRG_ÖFF_BANKEN_RV_EUR")
	'sBÜRG_ÖFF_BANKEN_IA_EUR = oTM.GetFieldForTag(db, "acc!BÜRG_ÖFF_BANKEN_IA_EUR")
	'sSONST_BÜRG_RV_EUR = oTM.GetFieldForTag(db, "acc!SONST_BÜRG_RV_EUR")
	'sSONST_BÜRG_IA_EUR = oTM.GetFieldForTag(db, "acc!SONST_BÜRG_IA_EUR")
	'sSICHERH_ÜBEREIG_RV_EUR = oTM.GetFieldForTag(db, "acc!SICHERH_ÜBEREIG_RV_EUR")
	'sSICHERH_ÜBEREIG_IA_EUR = oTM.GetFieldForTag(db, "acc!SICHERH_ÜBEREIG_IA_EUR")
	'sSONST_SICHERH_RV_EUR = oTM.GetFieldForTag(db, "acc!SONST_SICHERH_RV_EUR")
	'sSONST_SICHERH_IA_EUR = oTM.GetFieldForTag(db, "acc!SONST_SICHERH_IA_EUR")
	'sVERPF_GELDVERM_RV_EUR = oTM.GetFieldForTag(db, "acc!VERPF_GELDVERM_RV_EUR")
	'sVERPF_GELDVERM_IA_EUR = oTM.GetFieldForTag(db, "acc!VERPF_GELDVERM_IA_EUR")
	'sVERPF_SONSTIGES_RV_EUR = oTM.GetFieldForTag(db, "acc!VERPF_SONSTIGES_RV_EUR")
	'sVERPF_SONSTIGES_IA_EUR = oTM.GetFieldForTag(db, "acc!VERPF_SONSTIGES_IA_EUR")
	sGK_ENGA_RV_EUR = oTM.GetFieldForTag(db, "acc!GK_ENGA_RV_EUR")
	'sGK_ENGA_EA_EUR = oTM.GetFieldForTag(db, "acc!GK_ENGA_EA_EUR")
	'sGK_ENGA_BVRV_EUR = oTM.GetFieldForTag(db, "acc!GK_ENGA_BVRV_EUR")
	'sGK_ENGA_BVIA_EUR = oTM.GetFieldForTag(db, "acc!GK_ENGA_BVIA_EUR")
	sGK_KD_RV_EUR = oTM.GetFieldForTag(db, "acc!GK_KD_RV_EUR")
	'sGK_KD_EA_EUR = oTM.GetFieldForTag(db, "acc!GK_KD_EA_EUR")
	'sGK_KD_BVRV_EUR = oTM.GetFieldForTag(db, "acc!GK_KD_BVRV_EUR")
	'sGK_KD_BVIA_EUR = oTM.GetFieldForTag(db, "acc!GK_KD_BVIA_EUR")
	'sGK_KD_NTOBVRV_EUR = oTM.GetFieldForTag(db, "acc!GK_KD_NTOBVRV_EUR")
	'sDIREKT_ABSCHREIBUNG_EUR = oTM.GetFieldForTag(db, "acc!DIREKT_ABSCHREIBUNG_EUR")
	'sBERATER = oTM.GetFieldForTag(db, "acc!BERATER")
	'sGEWERBLICH_PRIVAT = oTM.GetFieldForTag(db, "acc!GEWERBLICH_PRIVAT")
	'sRECHTSFORM = oTM.GetFieldForTag(db, "acc!RECHTSFORM")
	'sBRANCHE = oTM.GetFieldForTag(db, "acc!BRANCHE")
	'sKPM_BRANCHE = oTM.GetFieldForTag(db, "acc!KPM_BRANCHE")
	'sKPM_BERÜCKS_KD_RS = oTM.GetFieldForTag(db, "acc!KPM_BERÜCKS_KD_RS")
	'sKONTOWÄHRUNG = oTM.GetFieldForTag(db, "acc!KONTOWÄHRUNG")
	'sLÄNDERSCHLÜSSEL = oTM.GetFieldForTag(db, "acc!LÄNDERSCHLÜSSEL")
	'sKUNDE_SEIT_DATUM = oTM.GetFieldForTag(db, "acc!KUNDE_SEIT_DATUM")
	'sGEB_GRÜND_DATUM = oTM.GetFieldForTag(db, "acc!GEB_GRÜND_DATUM")
	'sGAB = oTM.GetFieldForTag(db, "acc!GAB")
	'sAGREE_PRODUKTNUMMER = oTM.GetFieldForTag(db, "acc!AGREE_PRODUKTNUMMER")
	'sCVAR_EUR = oTM.GetFieldForTag(db, "acc!CVAR_EUR")
	'sEXPECTED_LOSS_EUR = oTM.GetFieldForTag(db, "acc!EXPECTED_LOSS_EUR")
	'sRISIKOSTATUS_MAK = oTM.GetFieldForTag(db, "acc!RISIKOSTATUS_MAK")
	'sRISIKOKENNZEICHEN = oTM.GetFieldForTag(db, "acc!RISIKOKENNZEICHEN")
	'sKUNDEN_EIGENGESCHÄFT = oTM.GetFieldForTag(db, "acc!KUNDEN_EIGENGESCHÄFT")
	'sÜBERZIEHUNG_KTO_EUR = oTM.GetFieldForTag(db, "acc!ÜBERZIEHUNG_KTO_EUR")
	'sTAGE_ÜBERZ_KTO = oTM.GetFieldForTag(db, "acc!TAGE_ÜBERZ_KTO")
	'sÜBERZ_KD_BASEL_EUR = oTM.GetFieldForTag(db, "acc!ÜBERZ_KD_BASEL_EUR")
	'sTAGE_ÜBERZ_KD_BASEL = oTM.GetFieldForTag(db, "acc!TAGE_ÜBERZ_KD_BASEL")
	'sGK_KD_ÜBERZ_EUR = oTM.GetFieldForTag(db, "acc!GK_KD_ÜBERZ_EUR")
	'sTAGE_ÜBERZ_KUNDE = oTM.GetFieldForTag(db, "acc!TAGE_ÜBERZ_KUNDE")
	'sÜBERZ_ENG_BASEL_EUR = oTM.GetFieldForTag(db, "acc!ÜBERZ_ENG_BASEL_EUR")
	'sTAGE_ÜBERZ_ENG_BASEL = oTM.GetFieldForTag(db, "acc!TAGE_ÜBERZ_ENG_BASEL")
	'sGK_ENGA_ÜBERZ_EUR = oTM.GetFieldForTag(db, "acc!GK_ENGA_ÜBERZ_EUR")
	'sTAGE_ÜBERZ_ENGA = oTM.GetFieldForTag(db, "acc!TAGE_ÜBERZ_ENGA")
	'sJAHRESABSCHLUSSDATUM = oTM.GetFieldForTag(db, "acc!JAHRESABSCHLUSSDATUM")
	'sDATUM_KTO_ERÖFF_SCHL = oTM.GetFieldForTag(db, "acc!DATUM_KTO_ERÖFF_SCHL")
	'sDATUM_LTZ_RISIKOKZ = oTM.GetFieldForTag(db, "acc!DATUM_LTZ_RISIKOKZ")
	sVR_RATING_NUM = oTM.GetFieldForTag(db, "acc!VR_RATING_NUM")
	db.Close
	Set db = Nothing
End Function
' --------------------------------------------------------------------------

' gets the folder name an path used for given file
Function GetWorkingFolder(ByVal sFileName As String)
SetCheckpoint "GetWorkingFolder 1.0 - get path"
	If sFileName <> "" Then
		sWorkingFolderPath = oSC.GetDirName(sFileName)
	Else
		' ToDo: Ausnahme definieren 27.10.2022
	End If
SetCheckpoint "GetWorkingFolder 2.0 - get folder name"	
	If sWorkingFolderPath = Client.WorkingDirectory or sWorkingFolderPath = "\" Then
		sWorkingfolderName = ""
	Else
		sWorkingfolderName = sWorkingFolderPath
		sWorkingfolderName = Left(sWorkingfolderName,Len(sWorkingfolderName)-1)
		While InStr(sWorkingfolderName, "\") > 0 
			sWorkingfolderName = Right(sWorkingfolderName, Len(sWorkingfolderName) - InStr(sWorkingfolderName, "\"))
		Wend
		sWorkingfolderName = sWorkingfolderName & "\"
	End If
End Function
' --------------------------------------------------------------------------

' gets and set nessesery paramter
Function GetParameters
SetCheckpoint "Preparation 1.0 - get dialog parameter"
	If oDialogPara.Contains("sCB_UseCritStock") Then bUseCritStock = oDialogPara.Item("sCB_UseCritStock").Checked
	If oDialogPara.Contains("sComB_LowerLimit") Then sLowerLimitCritStock = GetIndex(oDialogPara.Item("sComB_LowerLimit").Value)
	If oDialogPara.Contains("sComB_UpperLimit") Then sUpperLimitCritStock = GetIndex(oDialogPara.Item("sComB_UpperLimit").Value)
	If oDialogPara.Contains("nTB_Risikovolumen") Then nRisikovolumen = oDialogPara.Item("nTB_Risikovolumen").Value 
End Function
' --------------------------------------------------------------------------

' 
Function GetIndex(ByVal sValue As String) As String
Dim aRatingValues(25)
Dim i As Integer
aRatingValues(0) = "no value"
aRatingValues(1) = "0a"
aRatingValues(2) = "0b"
aRatingValues(3) = "0c"
aRatingValues(4) = "0d"
aRatingValues(5) = "0e"
aRatingValues(6) = "1a"
aRatingValues(7) = "1b"
aRatingValues(8) = "1c"
aRatingValues(9) = "1d"
aRatingValues(10) = "1e"
aRatingValues(11) = "2a"
aRatingValues(12) = "2b"
aRatingValues(13) = "2c"
aRatingValues(14) = "2d"
aRatingValues(15) = "2e"
aRatingValues(16) = "3a"
aRatingValues(17) = "3b"
aRatingValues(18) = "3c"
aRatingValues(19) = "3d"
aRatingValues(20) = "3e"
aRatingValues(21) = "4a"
aRatingValues(22) = "4b"
aRatingValues(23) = "4c"
aRatingValues(24) = "4d"
aRatingValues(25) = "4e"
	For i = 1 To UBound(aRatingValues)
		If aRatingValues(i) = sValue Then GetIndex = i
	Next
End Function
' --------------------------------------------------------------------------

' Filters the input table.
Function Analysis

SetCheckpoint "Analysis 1.0 - "
	Set db = Client.OpenDatabase(sInputFile)
	Set task = db.Summarization
	task.AddFieldToSummarize sKUNDENNUMMER
	task.AddFieldToSummarize sDATUM_DATENABZUG
	task.AddFieldToSummarize sVR_RATING
	task.AddFieldToSummarize sVR_RATING_NUM
	task.AddFieldToInc sGK_KD_RV_EUR
	task.AddFieldToInc sGK_ENGA_RV_EUR
	sRating_Evolution = oSC.UniqueFileName(sWorkingfolderName & "{Rating_Evolution}.IMD")
	task.OutputDBName = sRating_Evolution
	task.CreatePercentField = FALSE
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing

	
SetCheckpoint "Analysis 2.0 - "
Dim sEQN_RatingMigration As String
Dim sEQN_Kritisch  As String
Dim sEQN_Notleidend As String
	
	sEQN_Notleidend = "VR_RATING_NUM >= 21 .AND. @GetPreviousValue(""VR_RATING_NUM"")<21 .AND. KUNDENNUMMER==@GetPreviousValue(""KUNDENNUMMER"")"
	
	If bUseCritStock Then
		sEQN_Kritisch = "@between(VR_RATING_NUM;" & sLowerLimitCritStock & ";" & sUpperLimitCritStock & ") .AND. @GetPreviousValue(""VR_RATING_NUM"")<" & sLowerLimitCritStock & " .AND. KUNDENNUMMER==@GetPreviousValue(""KUNDENNUMMER"")"
		
		sEQN_RatingMigration = "@CompIf( " & sEQN_Notleidend  & "  .AND. "& sEQN_Kritisch  &";""Kritischer und notleidender Bereich"";" & _
		sEQN_Kritisch &";""Kritischer Bereich"";" & _
		sEQN_Notleidend & ";""Notleidender Bereich"";" & _
		"1;"""")"
	Else
		sEQN_RatingMigration = "@CompIf( " & sEQN_Notleidend & ";""Notleidender Bereich"";1;"""")"
	End If
SetCheckpoint "Analysis 2.1 - "
	Set db = Client.OpenDatabase(sRating_Evolution)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "WANDERUNG_IN"
	field.Description = ""
	field.Type = WI_VIRT_CHAR
	field.Equation = sEQN_RatingMigration
	field.Length = 35
	task.AppendField field
	task.PerformTask
SetCheckpoint "Analysis 2.2 - "
	field.Name = "VORHERIGE_NOTE"
	field.Description = ""
	field.Type = WI_VIRT_CHAR
	field.Equation = "@if(WANDERUNG_IN<> """";@GetPreviousValue(""VR_RATING"");"""")"
	field.Length = 2
	task.AppendField field
	task.PerformTask
SetCheckpoint "Analysis 2.3 - "
	field.Name = "VORHERIGER_ZEITRAUM"
	field.Description = ""
	field.Type = WI_VIRT_DATE
	field.Equation = "@if(WANDERUNG_IN<> """";@GetPreviousValue(""DATUM_DATENABZUG"");@ctod(""00000000"";""YYYYMMDD""))"
	task.AppendField field
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
SetCheckpoint "Analysis 3.0 - Erstellen der Ergebnisdateien"
	
	Set db = Client.OpenDatabase(sRating_Evolution)
	Set task = db.Extraction
	task.AddFieldToInc "KUNDENNUMMER"
	task.AddFieldToInc "WANDERUNG_IN"
	task.AddFieldToInc "DATUM_DATENABZUG"
	task.AddFieldToInc "VR_RATING"
	task.AddFieldToInc "VORHERIGER_ZEITRAUM"
	task.AddFieldToInc "VORHERIGE_NOTE"
	task.AddFieldToInc "GK_KD_RV_EUR"
	task.AddFieldToInc "GK_ENGA_RV_EUR"
	sMigrationsIntoCritStock = oSC.UniqueFileName(sWorkingfolderName & "Wanderungen in den kritischen oder notleidenden Bestand.IMD", FINAL_RESULT)
	task.AddExtraction sMigrationsIntoCritStock, "", "WANDERUNG_IN <> """" .AND. VR_RATING <> ""0"" .AND. GK_KD_RV_EUR >= " & nRisikovolumen 
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	
	' Dieses Ergebnis macht in dieser Analyse keinen Sinn. Es wird im Prüfschritt 15 abgebildet.
	'Set db = Client.OpenDatabase(sRating_Evolution)
	'Set task = db.Extraction
	'task.AddFieldToInc "KUNDENNUMMER"
	'task.AddFieldToInc "WANDERUNG_IN"
	'task.AddFieldToInc "DATUM_DATENABZUG"
	'task.AddFieldToInc "VR_RATING"
	'task.AddFieldToInc "VORHERIGER_ZEITRAUM"
	'task.AddFieldToInc "VORHERIGE_NOTE"
	'sMigrationsDeletedRatings = oSC.UniqueFileName(sWorkingFolderPath & "Gelöschte und entfernte Ratings.IMD", FINAL_RESULT)
	'task.AddExtraction sMigrationsDeletedRatings, "", "WANDERUNG_IN <> """" .AND. VR_RATING == ""0"""
	'task.PerformTask 1, db.Count
	'db.Close
	'Set task = Nothing
	'Set db = Nothing
	
End Function
' --------------------------------------------------------------------------

' register results
Function registerResult(ByVal dbNameResult As String, ByVal sResultType, ByVal iResultOrder As Integer)
SetCheckpoint "registerResult: " & dbNameResult
Dim oList As Object
	Set oList = oSC.CreateResultObject(dbNameResult, sResultType, True, iResultOrder)
	SmartContext.TestResultFiles.Add oList
	'oList.Extravalues.Add "Alias", dbNameResult
	
	SmartContext.Log.LogMessage dbNameResult & " registered."
	Set oList = Nothing
End Function
' --------------------------------------------------------------------------

' Sets the value of the global variable "m_checkpointName".
' Checkpoints are identifying a position in the code.
' In case of an error the last passed checkpoint name will be logged. 
Sub SetCheckpoint(ByVal checkpointName As String)
	m_checkpointName = checkpointName
End Sub
' --------------------------------------------------------------------------

' Logs an error and in case the user canceled the execution, it logs the cancel state.
' extraInfo: Only used in case special information shall be logged - usually it is empty.
Sub LogSmartAnalyzerError(ByVal extraInfo As String)
On Error Resume Next
	If SmartContext.IsCancellationRequested Then
		SmartContext.ExecutionStatus = EXEC_STATUS_CANCELED
		
		SmartContext.Log.LogMessage "Excecution was stopped by user."
	Else
		SmartContext.ExecutionStatus = EXEC_STATUS_FAILED
		
		SmartContext.Log.LogError "An error occurred in audit test '{0}'.{1}Error #{2}, Error Description: {3}{1}" + _
		                          "The last passed checkpoint was: {4}", _
		                          SmartContext.TestName, Chr(10), Err.Number, Err.Description, m_checkpointName

		If Len(extraInfo) > 0 Then
			SmartContext.Log.LogError "Additional error information: " & extraInfo
		End If
	End If
End Sub
' --------------------------------------------------------------------------

' cleans the memory and ends the script
Function EndSequenze
	Set oMC = Nothing
	Set oSC = Nothing
	Set oTM = Nothing
	Set oPip = Nothing
	Set oDialogPara = Nothing
	
	Stop
End Function

