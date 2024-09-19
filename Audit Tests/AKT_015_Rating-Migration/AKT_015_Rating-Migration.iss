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
dim oDialogPara as object
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
Dim sInputFile as string 'KRM

Dim sDATUM_DATENABZUG as string
Dim sID as string
Dim sNETTO_ENGAGEMENT as string
Dim sKUNDENGRUPPEN_NR as string
Dim sENGAGEMENTBEZ as string
Dim sKUNDENNUMMER As String
Dim sKUNDENNAME as string
Dim sKONTONUMMER as string
Dim sRISIKOGRUPPE as string
Dim sRISIKOGRUPPE_ENGA as string
Dim sBONITÄTSEINSTUFUNG as string
Dim sBONITÄTSEINST_ENGA as string
Dim sVR_RATINGART as string
Dim sVR_RATINGART_ENGA as string
Dim sVR_RATING as string
Dim sVR_RATING_ENGA as string
Dim sAUSFALLRATE_KUNDE as string
Dim sDATUM_LTZ_RATING as string
Dim sRISIKOVOLUMEN_EUR as string
Dim sNETTO_RISIKOVOLUMEN_EUR as string
Dim sEIGENANTEIL_EUR as string
Dim sNOM_VOL_EUR as string
Dim sGESAMTZUSAGE_EUR as string
Dim sBLANKOVOLUMEN_RV_EUR as string
Dim sBLANKOVOLUMEN_IA_EUR as string
Dim sNETTO_BLANKOVOL_RV_EUR as string
Dim sNETTO_BLANKOVOL_IA_EUR as string
Dim sBARWERT_BLANKOVOL_EUR as string
Dim sOFFENE_ZUSAGE_EUR as string
Dim sINTERNES_LIMIT_EUR as string
Dim sEWB_RST_GEBUCHT_EUR as string
Dim sEWB_RST_KALK_EUR as string
Dim sSUMME_SICHERHEIT_RV_EUR as string
Dim sSUMME_SICHERHEIT_IA_EUR as string
Dim sGRUNDPFANDRECHTE_RV_EUR as string
Dim sGRUNDPFANDRECHTE_IA_EUR as string
Dim sABTRET_GELDVERM_RV_EUR as string
Dim sABTRET_GELDVERM_IA_EUR as string
Dim sABTRET_SONSTIGES_RV_EUR as string
Dim sABTRET_SONSTIGES_IA_EUR as string
Dim sBÜRG_ÖFF_BANKEN_RV_EUR as string
Dim sBÜRG_ÖFF_BANKEN_IA_EUR as string
Dim sSONST_BÜRG_RV_EUR as string
Dim sSONST_BÜRG_IA_EUR as string
Dim sSICHERH_ÜBEREIG_RV_EUR as string
Dim sSICHERH_ÜBEREIG_IA_EUR as string
Dim sSONST_SICHERH_RV_EUR as string
Dim sSONST_SICHERH_IA_EUR as string
Dim sVERPF_GELDVERM_RV_EUR as string
Dim sVERPF_GELDVERM_IA_EUR as string
Dim sVERPF_SONSTIGES_RV_EUR as string
Dim sVERPF_SONSTIGES_IA_EUR as string
Dim sGK_ENGA_RV_EUR as string
Dim sGK_ENGA_EA_EUR as string
Dim sGK_ENGA_BVRV_EUR as string
Dim sGK_ENGA_BVIA_EUR as string
Dim sGK_KD_RV_EUR as string
Dim sGK_KD_EA_EUR as string
Dim sGK_KD_BVRV_EUR as string
Dim sGK_KD_BVIA_EUR as string
Dim sGK_KD_NTOBVRV_EUR as string
Dim sDIREKT_ABSCHREIBUNG_EUR as string
Dim sBERATER as string
Dim sGEWERBLICH_PRIVAT as string
Dim sRECHTSFORM as string
Dim sBRANCHE as string
Dim sKPM_BRANCHE as string
Dim sKPM_BERÜCKS_KD_RS as string
Dim sKONTOWÄHRUNG as string
Dim sLÄNDERSCHLÜSSEL as string
Dim sKUNDE_SEIT_DATUM as string
Dim sGEB_GRÜND_DATUM as string
Dim sGAB as string
Dim sAGREE_PRODUKTNUMMER as string
Dim sCVAR_EUR as string
Dim sEXPECTED_LOSS_EUR as string
Dim sRISIKOSTATUS_MAK as string
Dim sRISIKOKENNZEICHEN as string
Dim sKUNDEN_EIGENGESCHÄFT as string
Dim sÜBERZIEHUNG_KTO_EUR as string
Dim sTAGE_ÜBERZ_KTO as string
Dim sÜBERZ_KD_BASEL_EUR as string
Dim sTAGE_ÜBERZ_KD_BASEL as string
Dim sGK_KD_ÜBERZ_EUR as string
Dim sTAGE_ÜBERZ_KUNDE as string
Dim sÜBERZ_ENG_BASEL_EUR as string
Dim sTAGE_ÜBERZ_ENG_BASEL as string
Dim sGK_ENGA_ÜBERZ_EUR as string
Dim sTAGE_ÜBERZ_ENGA as string
Dim sJAHRESABSCHLUSSDATUM as string
Dim sDATUM_KTO_ERÖFF_SCHL as string
Dim sDATUM_LTZ_RISIKOKZ as string
dim sVR_RATING_NUM as string
'#End Region

'#Region - Folder
dim sWorkingFolderPath as string
dim sWorkingFolderName as string
'#End Region

'#Region - temp files
Dim sTemp_MP_Ueb_VR_Rating As String
dim sTemp_MP_Ueb_Datenabzug as string
Dim sMP_JoinAuditPeriods As String
'#End Region

Dim bOnlyOnePeriod As Boolean

'#Region - result files
Dim sRating_Migration As String
Dim sRating_neg_Migration As String
Dim sRating_pos_Migration As String
Dim sRating_del_Migration As String
Dim sRating_crit_Migration As String
Dim sRating_neu_ausg_Enga As String
Dim sRating_new_Migration As String
'#End Region

'#Region - dialog
Dim sCritRatingMigration As String
Dim bPosVeränderungen As Boolean
dim sRisikovolumen as string
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
	If bOnlyOnePeriod = false Then
		'Call registerResult(sRating_Migration, INTERMEDIATE_RESULT, 1)
		Call registerResult(sRating_neg_Migration, FINAL_RESULT,1)
		Call registerResult(sRating_del_Migration, FINAL_RESULT,2)
		Call registerResult(sRating_neu_ausg_Enga, FINAL_RESULT,3)
		Call registerResult(sRating_new_Migration, FINAL_RESULT,4)
	
		If bPosVeränderungen Then Call registerResult(sRating_pos_Migration, FINAL_RESULT, 3)
		If sCritRatingMigration <> "" Then Call registerResult(sRating_crit_Migration, FINAL_RESULT, 4)
	End If
	' **** End of the user specific code
	
	SmartContext.ExecutionStatus = EXEC_STATUS_SUCCEEDED
	
	SetCheckpoint "End of Sub Main()"
	
	Set oMC = nothing
	Set oSC = nothing
	Set oTM = nothing
	Set oPip = Nothing
	Set oDialogPara = nothing
	
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
	'sGK_ENGA_RV_EUR = oTM.GetFieldForTag(db, "acc!GK_ENGA_RV_EUR")
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
end function
' --------------------------------------------------------------------------

' gets the folder name an path used for given file
Function GetWorkingFolder(ByVal sFileName As String)
SetCheckpoint "GetWorkingFolder 1.0 - get path"
	if sFileName <> "" then
		sWorkingFolderPath = oSC.GetDirName(sFileName)
	else
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
end function
' --------------------------------------------------------------------------
' gets and set nessesery paramter
Function GetParameters
SetCheckpoint "Preparation 1.0 - get dialog parameter"
	If oDialogPara.Contains("sTB_RatingMigration") Then sCritRatingMigration = oDialogPara.Item("sTB_RatingMigration").Value
	If oDialogPara.Contains("sCheckB_PosVeränderungen") Then bPosVeränderungen = oDialogPara.Item("sCheckB_PosVeränderungen").Checked
	If oDialogPara.Contains("sTB_Risikovolumen") Then sRisikovolumen = oDialogPara.Item("sTB_Risikovolumen").Value
End Function
' --------------------------------------------------------------------------

' Filters the input table.
Function Analysis
dim iCountAuditPeriods as integer
Dim aAuditPeriod()
dim aAuditPeriodFiles()
dim i as integer
Dim sColumnValue As String
SetCheckpoint "Analysis 1.0 - "
	Set db = Client.OpenDatabase(sInputFile)
	Set task = db.Summarization
	task.AddFieldToSummarize sDATUM_DATENABZUG
	sTemp_MP_Ueb_Datenabzug = oSC.UniqueFileName(sWorkingfolderName & "{MP_UEBERSICHT_DATENABZUG}.IMD")
	task.OutputDBName = sTemp_MP_Ueb_Datenabzug
	task.CreatePercentField = FALSE
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
SetCheckpoint "Analysis 2.0 - Befüllen des aAuditPeriot Arrays"
	Set db = Client.OpenDatabase(sTemp_MP_Ueb_Datenabzug)
	iCountAuditPeriods = db.Count
	ReDim aAuditPeriod(iCountAuditPeriods - 1)
	ReDim aAuditPeriodFiles(iCountAuditPeriods - 1)
	Set rs = db.RecordSet
	rs.ToFirst
	Set rec = rs.ActiveRecord
	For i = 0 To iCountAuditPeriods - 1
		rs.Next
		sColumnValue = rec.GetDateValue(sDATUM_DATENABZUG)
		aAuditPeriod(i) = sColumnValue
	Next
	Set rec = Nothing
	Set rs = Nothing
	db.Close
	Set db = Nothing
SetCheckpoint "Analysis 3.0 - "
	Set db = Client.OpenDatabase(sInputFile)
	Set task = db.Summarization
	task.AddFieldToSummarize sDATUM_DATENABZUG
	task.AddFieldToSummarize sKUNDENNUMMER
	task.AddFieldToInc sVR_RATING
	task.AddFieldToInc sVR_RATING_NUM
	task.AddFieldToInc sGK_KD_RV_EUR
	'if sRisikovolumen <> "" then task.Criteria = sGK_KD_RV_EUR & " >= " & sRisikovolumen
	sTemp_MP_Ueb_VR_Rating = oSC.UniqueFileName(sWorkingfolderName & "{MP_UEBERSICHT_VR_RATING}.IMD")
	task.OutputDBName = sTemp_MP_Ueb_VR_Rating
	task.CreatePercentField = FALSE
	task.UseFieldFromFirstOccurrence = TRUE
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
SetCheckpoint "Analysis 4.0 - "
Dim sCurrentDate As String
Dim sCurrentFileName As String
	Set db = Client.OpenDatabase(sTemp_MP_Ueb_VR_Rating)
	Set task = db.Extraction
	task.IncludeAllFields
	for i = 0 to ubound(aAuditPeriod)
		sCurrentDate = aAuditPeriod(i)
		sCurrentFileName = oSC.UniqueFileName(sWorkingfolderName & "{" & sCurrentDate & "_KRM}.IMD")
		aAuditPeriodFiles(i) = sCurrentFileName
		task.AddExtraction sCurrentFileName, "", "DATUM_DATENABZUG == """ & sCurrentDate & """"
	next
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
SetCheckpoint "Analysis 4.1 - "
dim iAuditPeriodFilesRenameCount as integer
dim oRenameTableDef as object
dim iMaxRenameFieldCount as integer
dim iFieldCount as integer
dim sOldFieldName as string
dim sNewFieldName as string
	for iAuditPeriodFilesRenameCount = 0 to ubound(aAuditPeriodFiles)
		Set db = Client.OpenDatabase(aAuditPeriodFiles(iAuditPeriodFilesRenameCount))
		Set oRenameTableDef = db.TableDef
		iMaxRenameFieldCount = oRenameTableDef.Count
		for iFieldCount = 1 to iMaxRenameFieldCount
			sOldFieldName = oRenameTableDef.GetFieldAt(iFieldCount).Name
			sNewFieldName = sOldFieldName & "_" & aAuditPeriod(iAuditPeriodFilesRenameCount)
			oSC.RenameFieldAt db, iFieldCount, sNewFieldName, ""
		next
		db.Close
		set oRenameTableDef = nothing
		set db = nothing
	next
SetCheckpoint "Analysis 5.0 - "
dim sFirstFile as string
dim sFirstFileMatchKey as string
dim sSecondFile as string
dim iJoinCount as integer
	if ubound(aAuditPeriodFiles) = 0 then
		SmartContext.Log.LogMessage "Input File only contains one audit Period."
		bOnlyOnePeriod = true
	else
		sFirstFile = aAuditPeriodFiles(0)
		sFirstFileMatchKey = sKUNDENNUMMER & "_" & aAuditPeriod(0)
		For iJoinCount = 1 To UBound(aAuditPeriodFiles)
			sSecondFile = aAuditPeriodFiles(iJoinCount)
SetCheckpoint "Analysis 5.1 - Join " & iJoinCount			
			Set db = Client.OpenDatabase(sFirstFile)
			Set task = db.JoinDatabase
			task.FileToJoin sSecondFile
			If iJoinCount = 1 Then
				task.AddPFieldToInc sKUNDENNUMMER & "_" & aAuditPeriod(iJoinCount - 1)
				'task.AddPFieldToInc "ANZ_SAETZE" & "_" & aAuditPeriod(iJoinCount - 1)
				task.AddPFieldToInc sVR_RATING & "_" & aAuditPeriod(iJoinCount - 1)
				task.AddPFieldToInc sVR_RATING_NUM & "_" & aAuditPeriod(iJoinCount - 1)
				task.AddPFieldToInc sGK_KD_RV_EUR & "_" & aAuditPeriod(iJoinCount - 1)
			Else
				task.IncludeAllPFields
			End If
			'-----------------------------------------
			task.AddSFieldToInc sKUNDENNUMMER & "_" & aAuditPeriod(iJoinCount)
			'task.AddSFieldToInc "ANZ_SAETZE" & "_" & aAuditPeriod(iJoinCount)
			task.AddSFieldToInc sVR_RATING & "_" & aAuditPeriod(iJoinCount)
			task.AddSFieldToInc sVR_RATING_NUM & "_" & aAuditPeriod(iJoinCount)
			task.AddSFieldToInc sGK_KD_RV_EUR & "_" & aAuditPeriod(iJoinCount)
			task.AddMatchKey sFirstFileMatchKey, sKUNDENNUMMER & "_" & aAuditPeriod(iJoinCount), "A"
			sMP_JoinAuditPeriods = oSC.UniqueFileName(sWorkingfolderName & "{Audit Period Join " & iJoinCount & "}.IMD")
			task.PerformTask sMP_JoinAuditPeriods, "", WI_JOIN_ALL_REC
			db.Close
			Set task = Nothing
			Set db = Nothing
SetCheckpoint "Analysis 5.2 - Join " & iJoinCount & " append KNR"		
			Set db = Client.OpenDatabase(sMP_JoinAuditPeriods)
			Set task = db.TableManagement
			Set field = db.TableDef.NewField
			field.Name = "KNR_" & aAuditPeriod(iJoinCount)
			field.Description = "alle bis zur angegebenen Periode enthaltenen Kundennummern"
			field.Type = WI_CHAR_FIELD
			field.Equation = "@if(" & sFirstFileMatchKey & "<>"""";" & sFirstFileMatchKey & ";" & sKUNDENNUMMER & "_" & aAuditPeriod(iJoinCount) & ")"
			field.Length = 10
			task.AppendField field
			task.PerformTask
SetCheckpoint "Analysis 5.3 - Join " & iJoinCount & " append single period migration"
			field.Name = "RATINGÄNDERUNG_" & aAuditPeriod(iJoinCount - 1) & "_" & aAuditPeriod(iJoinCount)
			field.Description = ""
			field.Type = WI_NUM_FIELD
			field.Equation = "VR_RATING_NUM_" & aAuditPeriod(iJoinCount - 1) & "-VR_RATING_NUM_" & aAuditPeriod(iJoinCount)
			field.Decimals = 0
			task.AppendField field
			task.PerformTask
			db.Close
			Set task = Nothing
			Set db = Nothing
			Set field = Nothing
	
			sFirstFile = sMP_JoinAuditPeriods
			sFirstFileMatchKey = "KNR_" & aAuditPeriod(iJoinCount) 
		Next
SetCheckpoint "Analysis 5.4 - append migration"
		Set db = Client.OpenDatabase(sMP_JoinAuditPeriods)
		Set task = db.TableManagement
		Set field = db.TableDef.NewField
		field.Name = "RATINGÄNDERUNG_GESAMTER_ZEITRAUM"
		field.Description = ""
		field.Type = WI_NUM_FIELD
		field.Equation = "VR_RATING_NUM_" & aAuditPeriod(0) & "-VR_RATING_NUM_" & aAuditPeriod(UBound(aAuditPeriod))
		field.Decimals = 0
		task.AppendField field
		task.PerformTask
		oSC.RenameField db, "KNR_" & aAuditPeriod(UBound(aAuditPeriod)), "KUNDENNUMMER", ""
		db.Close
		Set task = Nothing
		Set db = Nothing
		Set field = Nothing
		
SetCheckpoint "Analysis 5.5 - extract final files"
dim sEQNRiskVolume as string
	sEQNRiskVolume = ""
	'Datei mit gesamten Rating-Veränderungen werden angezeigt
		Dim iRatingMigrationCount As Integer		
		Set db = Client.OpenDatabase(sMP_JoinAuditPeriods)
		Set task = db.Extraction
		task.AddFieldToInc "KUNDENNUMMER"
		For iRatingMigrationCount = 0 To UBound(aAuditPeriod) - 1
			task.AddFieldToInc "RATINGÄNDERUNG_" & aAuditPeriod(iRatingMigrationCount) & "_" & aAuditPeriod(iRatingMigrationCount + 1)
		Next
		task.AddFieldToInc "RATINGÄNDERUNG_GESAMTER_ZEITRAUM"
		For iRatingMigrationCount = 0 To UBound(aAuditPeriod)
			'task.AddFieldToInc "ANZ_SAETZE_" & aAuditPeriod(iRatingMigrationCount)
			task.AddFieldToInc "VR_RATING_" & aAuditPeriod(iRatingMigrationCount)
			task.AddFieldToInc "VR_RATING_NUM_" & aAuditPeriod(iRatingMigrationCount)
			task.AddFieldToInc sGK_KD_RV_EUR & "_" & aAuditPeriod(iRatingMigrationCount)
		Next
		sRating_Migration = oSC.UniqueFileName(sWorkingfolderName & "{Rating-Migration}.IMD")
		If sRisikovolumen <> "" Then sEQNRiskVolume = sGK_KD_RV_EUR  & "_" & aAuditPeriod(UBound(aAuditPeriod)) & " >= " & sRisikovolumen
		task.AddExtraction sRating_Migration, "", sEQNRiskVolume
		task.PerformTask 1, db.Count
		db.Close
		Set task = Nothing
		Set db = Nothing
		
		'Create Action Field
		Set db = Client.OpenDatabase(sRating_Migration)
		oSC.CreateActionField db, "KUNDENNUMMER", sInputFile, "KUNDENNUMMER"
		db.Close
		Set db = Nothing
		
		
	'Neue und ausgelaufene Engagements werden als Ergebnis ausgegeben
		Dim sEQN_Kill_DeletedRatings As String
		
		Set db = Client.OpenDatabase(sRating_Migration)
		Set task = db.Extraction
		task.IncludeAllFields
		sRating_neu_ausg_Enga = oSC.UniqueFileName(sWorkingfolderName & "Neue und ausgelaufene Engagements.IMD", FINAL_RESULT)
		
		'Zusammenstellen der Extraktionsgleichung
		sEQN_Kill_DeletedRatings = "("
		For iRatingMigrationCount = 0 To UBound(aAuditPeriod) 
			If iRatingMigrationCount <> UBound(aAuditPeriod) Then
				sEQN_Kill_DeletedRatings = sEQN_Kill_DeletedRatings & "@If(VR_RATING_" & aAuditPeriod(iRatingMigrationCount) & "<> """";1;0) +"
			Else
				sEQN_Kill_DeletedRatings = ".NOT.(" & sEQN_Kill_DeletedRatings & "@If(VR_RATING_" & aAuditPeriod(iRatingMigrationCount) & "<> """";1;0)) > 1)"
			End If
		Next

		
		task.AddExtraction sRating_neu_ausg_Enga, "", sEQN_Kill_DeletedRatings 
		task.PerformTask 1, db.Count
		Set task = Nothing
		Set db = Nothing
		
		'Create Action Field
		Set db = Client.OpenDatabase(sRating_neu_ausg_Enga)
		oSC.CreateActionField db, "KUNDENNUMMER", sInputFile, "KUNDENNUMMER"
		db.Close
		Set db = Nothing
		
	'Negative Rating-Bewegungen werden als Ergebnis ausgegeben
		Set db = Client.OpenDatabase(sRating_Migration)
		Set task = db.Extraction
		task.IncludeAllFields
		sRating_neg_Migration = oSC.UniqueFileName(sWorkingfolderName & "Negative Rating-Migration.IMD", FINAL_RESULT)
		
		'Zusammenstellen der Extraktionsgleichung
		sEQN_Kill_DeletedRatings = "("
		For iRatingMigrationCount = 0 To UBound(aAuditPeriod) 
			If iRatingMigrationCount <> UBound(aAuditPeriod) Then
				sEQN_Kill_DeletedRatings = sEQN_Kill_DeletedRatings & "@If(VR_RATING_" & aAuditPeriod(iRatingMigrationCount) & "<> """";1;0) +"
			Else
				sEQN_Kill_DeletedRatings = sEQN_Kill_DeletedRatings & "@If(VR_RATING_" & aAuditPeriod(iRatingMigrationCount) & "<> """";1;0)) > 1 .AND. RATINGÄNDERUNG_GESAMTER_ZEITRAUM < 0 .AND. RATINGÄNDERUNG_GESAMTER_ZEITRAUM > -26 "
			End If
		Next

		
		task.AddExtraction sRating_neg_Migration , "", sEQN_Kill_DeletedRatings 
		task.PerformTask 1, db.Count
		Set task = Nothing
		Set db = Nothing
		
		'Create Action Field
		Set db = Client.OpenDatabase(sRating_neg_Migration )
		oSC.CreateActionField db, "KUNDENNUMMER", sInputFile, "KUNDENNUMMER"
		db.Close
		Set db = Nothing
		
			

	'Wenn optional ein Kritisch Raiting im Dialog angegeben wurde, dann erstelle ein gesondertes Ergebnis, welche nur die Kunden mit einer Veränderung von größer als sCritRatingMigration vorweisen
		If sCritRatingMigration <> "" Then
		Dim sEQN_crit_RatingMigration As String
			For iRatingMigrationCount = 0 To UBound(aAuditPeriod) - 1
				sEQN_crit_RatingMigration = sEQN_crit_RatingMigration & "@abs(RATINGÄNDERUNG_" & aAuditPeriod(iRatingMigrationCount) & "_" & aAuditPeriod(iRatingMigrationCount + 1) & ") >= " & sCritRatingMigration & " .OR. "
			Next
			sEQN_crit_RatingMigration = sEQN_crit_RatingMigration & "@abs(RATINGÄNDERUNG_GESAMTER_ZEITRAUM) >= " & sCritRatingMigration
	
			Set db = Client.OpenDatabase(sRating_neg_Migration)
			'Set db = Client.OpenDatabase(sRating_Migration)
			Set task = db.Extraction
			task.IncludeAllFields
			sRating_crit_Migration = oSC.UniqueFileName(sWorkingfolderName & "kritische Rating-Migration.IMD", FINAL_RESULT)
			task.AddExtraction sRating_crit_Migration, "",  "(" & sEQN_crit_RatingMigration  & ") .AND. " & sEQN_Kill_DeletedRatings 
			task.PerformTask 1, db.Count
			db.Close
			Set task = Nothing
			Set db = Nothing
			
			'Create Action Field
			Set db = Client.OpenDatabase(sRating_crit_Migration)
			oSC.CreateActionField db, "KUNDENNUMMER", sInputFile, "KUNDENNUMMER"
			db.Close
			Set db = Nothing

		End If

		
		
	'Wenn die optionale Checkbox angewählt wurde, dann werden die positiven Veränderungen in einem gesondertem Ergebnis ausgegeben:
		If bPosVeränderungen Then
			Set db = Client.OpenDatabase(sRating_Migration)
			Set task = db.Extraction
			task.IncludeAllFields
			sRating_pos_Migration = oSC.UniqueFileName(sWorkingfolderName & "Positive Rating-Migration.IMD", FINAL_RESULT)
		
			'Zusammenstellen der Extraktionsgleichung
			sEQN_Kill_DeletedRatings = "("
			For iRatingMigrationCount = 0 To UBound(aAuditPeriod) 
				If iRatingMigrationCount <> UBound(aAuditPeriod) Then
					sEQN_Kill_DeletedRatings = sEQN_Kill_DeletedRatings & "@If(VR_RATING_" & aAuditPeriod(iRatingMigrationCount) & "<> """";1;0) +"
				Else
					sEQN_Kill_DeletedRatings = sEQN_Kill_DeletedRatings & "@If(VR_RATING_" & aAuditPeriod(iRatingMigrationCount) & "<> """";1;0)) > 1 .AND. RATINGÄNDERUNG_GESAMTER_ZEITRAUM > 0.And. RATINGÄNDERUNG_GESAMTER_ZEITRAUM < 26 "
				End If
			Next
			
			task.AddExtraction sRating_pos_Migration , "", sEQN_Kill_DeletedRatings 
			task.PerformTask 1, db.Count
			Set task = Nothing
			Set db = Nothing
			
			'Create Action Field
			Set db = Client.OpenDatabase(sRating_pos_Migration)
			oSC.CreateActionField db, "KUNDENNUMMER", sInputFile, "KUNDENNUMMER"
			db.Close
			Set db = Nothing

		End If
			
			
			
	'Gelöschte Ratings werden als Ergebnis ausgegeben
		Set db = Client.OpenDatabase(sRating_Migration)
		Set task = db.Extraction
		task.IncludeAllFields
		sRating_del_Migration = oSC.UniqueFileName(sWorkingfolderName & "Gelöschte Ratings.IMD", FINAL_RESULT)
		
		'Zusammenstellen der Extraktionsgleichung
		sEQN_Kill_DeletedRatings = "("
		For iRatingMigrationCount = 0 To UBound(aAuditPeriod) 
			If iRatingMigrationCount <> UBound(aAuditPeriod) Then
				sEQN_Kill_DeletedRatings = sEQN_Kill_DeletedRatings & "@If(VR_RATING_" & aAuditPeriod(iRatingMigrationCount) & "<> """";1;0) +"
			Else
				sEQN_Kill_DeletedRatings = sEQN_Kill_DeletedRatings & "@If(VR_RATING_" & aAuditPeriod(iRatingMigrationCount) & "<> """";1;0)) > 1 .AND. RATINGÄNDERUNG_GESAMTER_ZEITRAUM < -26"
			End If
		Next

		
		task.AddExtraction sRating_del_Migration, "", sEQN_Kill_DeletedRatings 
		task.PerformTask 1, db.Count
		Set task = Nothing
		Set db = Nothing
		
		'Create Action Field
		Set db = Client.OpenDatabase(sRating_del_Migration)
		oSC.CreateActionField db, "KUNDENNUMMER", sInputFile, "KUNDENNUMMER"
		db.Close
		Set db = Nothing
		
		
		
		
	'Neue Ratings werden als Ergebnis ausgegeben
		Set db = Client.OpenDatabase(sRating_Migration)
		Set task = db.Extraction
		task.IncludeAllFields
		sRating_new_Migration = oSC.UniqueFileName(sWorkingfolderName & "Neue Ratings.IMD", FINAL_RESULT)
		
		'Zusammenstellen der Extraktionsgleichung
		sEQN_Kill_DeletedRatings = "("
		For iRatingMigrationCount = 0 To UBound(aAuditPeriod) 
			If iRatingMigrationCount <> UBound(aAuditPeriod) Then
				sEQN_Kill_DeletedRatings = sEQN_Kill_DeletedRatings & "@If(VR_RATING_" & aAuditPeriod(iRatingMigrationCount) & "<> """";1;0) +"
			Else
				sEQN_Kill_DeletedRatings = sEQN_Kill_DeletedRatings & "@If(VR_RATING_" & aAuditPeriod(iRatingMigrationCount) & "<> """";1;0)) > 1 .AND. RATINGÄNDERUNG_GESAMTER_ZEITRAUM > 26"
			End If
		Next

		
		task.AddExtraction sRating_new_Migration, "", sEQN_Kill_DeletedRatings 
		task.PerformTask 1, db.Count
		Set task = Nothing
		Set db = Nothing
		
		'Create Action Field
		Set db = Client.OpenDatabase(sRating_new_Migration)
		oSC.CreateActionField db, "KUNDENNUMMER", sInputFile, "KUNDENNUMMER"
		db.Close
		Set db = Nothing

	End If

End Function
' --------------------------------------------------------------------------

' register results
Function registerResult(ByVal dbNameResult As String, ByVal sResultType, byval iResultOrder as integer)
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
function EndSequenze
	Set oMC = nothing
	Set oSC = nothing
	Set oTM = nothing
	Set oPip = Nothing
	Set oDialogPara = nothing
	
	Stop
end function
