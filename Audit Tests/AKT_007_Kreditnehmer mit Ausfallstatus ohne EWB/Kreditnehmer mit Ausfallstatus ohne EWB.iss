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
'#End Region

'#Region - Input file
' Include the primary input file an all tag names
Dim sInputFile as string 'KRM

Dim sID as string
Dim sNETTO_ENGAGEMENT as string
Dim sKUNDENGRUPPEN_NR as string
Dim sENGAGEMENTBEZ as string
Dim sKUNDENNUMMER as string
Dim sKUNDENNAME as string
Dim sKONTONUMMER as string
Dim sRISIKOGRUPPE as string
Dim sRISIKOGRUPPE_ENGA as string
Dim sBONIT�TSEINSTUFUNG as string
Dim sBONIT�TSEINST_ENGA as string
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
Dim sB�RG_�FF_BANKEN_RV_EUR as string
Dim sB�RG_�FF_BANKEN_IA_EUR as string
Dim sSONST_B�RG_RV_EUR as string
Dim sSONST_B�RG_IA_EUR as string
Dim sSICHERH_�BEREIG_RV_EUR as string
Dim sSICHERH_�BEREIG_IA_EUR as string
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
Dim sKPM_BER�CKS_KD_RS as string
Dim sKONTOW�HRUNG as string
Dim sL�NDERSCHL�SSEL as string
Dim sKUNDE_SEIT_DATUM as string
Dim sGEB_GR�ND_DATUM as string
Dim sGAB as string
Dim sAGREE_PRODUKTNUMMER as string
Dim sCVAR_EUR as string
Dim sEXPECTED_LOSS_EUR as string
Dim sRISIKOSTATUS_MAK as string
Dim sRISIKOKENNZEICHEN as string
Dim sKUNDEN_EIGENGESCH�FT as string
Dim s�BERZIEHUNG_KTO_EUR as string
Dim sTAGE_�BERZ_KTO as string
Dim s�BERZ_KD_BASEL_EUR as string
Dim sTAGE_�BERZ_KD_BASEL as string
Dim sGK_KD_�BERZ_EUR as string
Dim sTAGE_�BERZ_KUNDE as string
Dim s�BERZ_ENG_BASEL_EUR as string
Dim sTAGE_�BERZ_ENG_BASEL as string
Dim sGK_ENGA_�BERZ_EUR as string
Dim sTAGE_�BERZ_ENGA as string
Dim sJAHRESABSCHLUSSDATUM as string
Dim sDATUM_KTO_ER�FF_SCHL as string
Dim sDATUM_LTZ_RISIKOKZ As String
Dim sVR_RATING_NUM As String
'#End Region

'#Region - Folder
dim sWorkingFolderPath as string
dim sWorkingFolderName as string
'#End Region

'#Region - temp files
dim sKreditnehmMitIA as string
dim sENGA_EWB_RST_IA as string
dim sJoinMitIAundSummeEWBRST as string

dim sKreditnehmMitRV as string
dim sENGA_EWB_RST_RV as string
dim sJoinMitRVundSummeEWBRST as string

dim sKreditnehmMitIAundRV as string
dim sENGA_EWB_RST_IA_RV as string
dim sJoinMitRVIAundSummeEWBRST as string
'#End Region

'#Region - new field names
dim sFIELD_ENGA_EWB_RST_IA as string
dim sFIELD_ENGA_EWB_RST_RV as string
dim sFIELD_ENGA_EWB_RST_IARV as string
'#End Region

'#Region - result files
dim sKreditnehmMitAusfall_OhneEWB as string
dim sKreditnehmMitAusfall_OhneRST as string
dim sKreditnehmMitAusfall_OhneEWBundRST as string
dim sKreditnehmMitAusfall_OhneEWB_per_Person as string
dim sKreditnehmMitAusfall_OhneRST_per_Person as string
dim sKreditnehmMitAusfall_OhneEWBundRST_per_Person as string
'#End Region

'#Region - dialog
Dim sCritBlankRiskVolume As String
Dim sEQN_Ausfall As String
dim sEQN as string
dim sEQN_EWB as string
dim sEQN_RST as string
dim sEQN_EWB_RST as string
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
	Call Analysis_per_Person
	call registerResult(sInputFile, INPUT_DATABASE, 0)
	call registerResult(sKreditnehmMitAusfall_OhneEWB, FINAL_RESULT, 1)
	call registerResult(sKreditnehmMitAusfall_OhneRST, FINAL_RESULT, 2)
	call registerResult(sKreditnehmMitAusfall_OhneEWBundRST, FINAL_RESULT, 3)
	call registerResult(sKreditnehmMitAusfall_OhneEWB_per_Person, FINAL_RESULT, 4)
	call registerResult(sKreditnehmMitAusfall_OhneRST_per_Person, FINAL_RESULT, 5)
	call registerResult(sKreditnehmMitAusfall_OhneEWBundRST_per_Person, FINAL_RESULT, 6)
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
	'sID = oTM.GetFieldForTag(db, "acc!ID")
	sNETTO_ENGAGEMENT = oTM.GetFieldForTag(db, "acc!NETTO_ENGAGEMENT")
	'sKUNDENGRUPPEN_NR = oTM.GetFieldForTag(db, "acc!KUNDENGRUPPEN_NR")
	'sENGAGEMENTBEZ = oTM.GetFieldForTag(db, "acc!ENGAGEMENTBEZ")
	'sKUNDENNUMMER = oTM.GetFieldForTag(db, "acc!KUNDENNUMMER")
	'sKUNDENNAME = oTM.GetFieldForTag(db, "acc!KUNDENNAME")
	'sKONTONUMMER = oTM.GetFieldForTag(db, "acc!KONTONUMMER")
	'sRISIKOGRUPPE = oTM.GetFieldForTag(db, "acc!RISIKOGRUPPE")
	'sRISIKOGRUPPE_ENGA = oTM.GetFieldForTag(db, "acc!RISIKOGRUPPE_ENGA")
	'sBONIT�TSEINSTUFUNG = oTM.GetFieldForTag(db, "acc!BONIT�TSEINSTUFUNG")
	'sBONIT�TSEINST_ENGA = oTM.GetFieldForTag(db, "acc!BONIT�TSEINST_ENGA")
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
	sEWB_RST_GEBUCHT_EUR = oTM.GetFieldForTag(db, "acc!EWB_RST_GEBUCHT_EUR")
	'sEWB_RST_KALK_EUR = oTM.GetFieldForTag(db, "acc!EWB_RST_KALK_EUR")
	'sSUMME_SICHERHEIT_RV_EUR = oTM.GetFieldForTag(db, "acc!SUMME_SICHERHEIT_RV_EUR")
	'sSUMME_SICHERHEIT_IA_EUR = oTM.GetFieldForTag(db, "acc!SUMME_SICHERHEIT_IA_EUR")
	'sGRUNDPFANDRECHTE_RV_EUR = oTM.GetFieldForTag(db, "acc!GRUNDPFANDRECHTE_RV_EUR")
	'sGRUNDPFANDRECHTE_IA_EUR = oTM.GetFieldForTag(db, "acc!GRUNDPFANDRECHTE_IA_EUR")
	'sABTRET_GELDVERM_RV_EUR = oTM.GetFieldForTag(db, "acc!ABTRET_GELDVERM_RV_EUR")
	'sABTRET_GELDVERM_IA_EUR = oTM.GetFieldForTag(db, "acc!ABTRET_GELDVERM_IA_EUR")
	'sABTRET_SONSTIGES_RV_EUR = oTM.GetFieldForTag(db, "acc!ABTRET_SONSTIGES_RV_EUR")
	'sABTRET_SONSTIGES_IA_EUR = oTM.GetFieldForTag(db, "acc!ABTRET_SONSTIGES_IA_EUR")
	'sB�RG_�FF_BANKEN_RV_EUR = oTM.GetFieldForTag(db, "acc!B�RG_�FF_BANKEN_RV_EUR")
	'sB�RG_�FF_BANKEN_IA_EUR = oTM.GetFieldForTag(db, "acc!B�RG_�FF_BANKEN_IA_EUR")
	'sSONST_B�RG_RV_EUR = oTM.GetFieldForTag(db, "acc!SONST_B�RG_RV_EUR")
	'sSONST_B�RG_IA_EUR = oTM.GetFieldForTag(db, "acc!SONST_B�RG_IA_EUR")
	'sSICHERH_�BEREIG_RV_EUR = oTM.GetFieldForTag(db, "acc!SICHERH_�BEREIG_RV_EUR")
	'sSICHERH_�BEREIG_IA_EUR = oTM.GetFieldForTag(db, "acc!SICHERH_�BEREIG_IA_EUR")
	'sSONST_SICHERH_RV_EUR = oTM.GetFieldForTag(db, "acc!SONST_SICHERH_RV_EUR")
	'sSONST_SICHERH_IA_EUR = oTM.GetFieldForTag(db, "acc!SONST_SICHERH_IA_EUR")
	'sVERPF_GELDVERM_RV_EUR = oTM.GetFieldForTag(db, "acc!VERPF_GELDVERM_RV_EUR")
	'sVERPF_GELDVERM_IA_EUR = oTM.GetFieldForTag(db, "acc!VERPF_GELDVERM_IA_EUR")
	'sVERPF_SONSTIGES_RV_EUR = oTM.GetFieldForTag(db, "acc!VERPF_SONSTIGES_RV_EUR")
	'sVERPF_SONSTIGES_IA_EUR = oTM.GetFieldForTag(db, "acc!VERPF_SONSTIGES_IA_EUR")
	'sGK_ENGA_RV_EUR = oTM.GetFieldForTag(db, "acc!GK_ENGA_RV_EUR")
	'sGK_ENGA_EA_EUR = oTM.GetFieldForTag(db, "acc!GK_ENGA_EA_EUR")
	sGK_ENGA_BVRV_EUR = oTM.GetFieldForTag(db, "acc!GK_ENGA_BVRV_EUR")
	sGK_ENGA_BVIA_EUR = oTM.GetFieldForTag(db, "acc!GK_ENGA_BVIA_EUR")
	'sGK_KD_RV_EUR = oTM.GetFieldForTag(db, "acc!GK_KD_RV_EUR")
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
	'sKPM_BER�CKS_KD_RS = oTM.GetFieldForTag(db, "acc!KPM_BER�CKS_KD_RS")
	'sKONTOW�HRUNG = oTM.GetFieldForTag(db, "acc!KONTOW�HRUNG")
	'sL�NDERSCHL�SSEL = oTM.GetFieldForTag(db, "acc!L�NDERSCHL�SSEL")
	'sKUNDE_SEIT_DATUM = oTM.GetFieldForTag(db, "acc!KUNDE_SEIT_DATUM")
	'sGEB_GR�ND_DATUM = oTM.GetFieldForTag(db, "acc!GEB_GR�ND_DATUM")
	'sGAB = oTM.GetFieldForTag(db, "acc!GAB")
	'sAGREE_PRODUKTNUMMER = oTM.GetFieldForTag(db, "acc!AGREE_PRODUKTNUMMER")
	'sCVAR_EUR = oTM.GetFieldForTag(db, "acc!CVAR_EUR")
	'sEXPECTED_LOSS_EUR = oTM.GetFieldForTag(db, "acc!EXPECTED_LOSS_EUR")
	'sRISIKOSTATUS_MAK = oTM.GetFieldForTag(db, "acc!RISIKOSTATUS_MAK")
	'sRISIKOKENNZEICHEN = oTM.GetFieldForTag(db, "acc!RISIKOKENNZEICHEN")
	'sKUNDEN_EIGENGESCH�FT = oTM.GetFieldForTag(db, "acc!KUNDEN_EIGENGESCH�FT")
	's�BERZIEHUNG_KTO_EUR = oTM.GetFieldForTag(db, "acc!�BERZIEHUNG_KTO_EUR")
	'sTAGE_�BERZ_KTO = oTM.GetFieldForTag(db, "acc!TAGE_�BERZ_KTO")
	's�BERZ_KD_BASEL_EUR = oTM.GetFieldForTag(db, "acc!�BERZ_KD_BASEL_EUR")
	'sTAGE_�BERZ_KD_BASEL = oTM.GetFieldForTag(db, "acc!TAGE_�BERZ_KD_BASEL")
	'sGK_KD_�BERZ_EUR = oTM.GetFieldForTag(db, "acc!GK_KD_�BERZ_EUR")
	'sTAGE_�BERZ_KUNDE = oTM.GetFieldForTag(db, "acc!TAGE_�BERZ_KUNDE")
	's�BERZ_ENG_BASEL_EUR = oTM.GetFieldForTag(db, "acc!�BERZ_ENG_BASEL_EUR")
	'sTAGE_�BERZ_ENG_BASEL = oTM.GetFieldForTag(db, "acc!TAGE_�BERZ_ENG_BASEL")
	'sGK_ENGA_�BERZ_EUR = oTM.GetFieldForTag(db, "acc!GK_ENGA_�BERZ_EUR")
	'sTAGE_�BERZ_ENGA = oTM.GetFieldForTag(db, "acc!TAGE_�BERZ_ENGA")
	'sJAHRESABSCHLUSSDATUM = oTM.GetFieldForTag(db, "acc!JAHRESABSCHLUSSDATUM")
	'sDATUM_KTO_ER�FF_SCHL = oTM.GetFieldForTag(db, "acc!DATUM_KTO_ER�FF_SCHL")
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
	If oDialogPara.Contains("sTB_crit_blank_risk_volume") Then sCritBlankRiskVolume = oDialogPara.Item("sTB_crit_blank_risk_volume").Value
	'---------------------------------------------
	sEQN_Ausfall = " = 0 .and. VR_RATING_NUM >= 22 .and. VR_RATING_NUM <> 99"
	'---------------------------------------------
	if sCritBlankRiskVolume <> "" then
		sEQN_EWB = sGK_ENGA_BVIA_EUR & " >= " & sCritBlankRiskVolume
		sEQN_RST = sGK_ENGA_BVRV_EUR & " > 0 .AND. " & sEQN_EWB
		sEQN_EWB_RST = sEQN_RST
	else
		sEQN_EWB = sGK_ENGA_BVIA_EUR & " > 0"
		sEQN_RST = sGK_ENGA_BVRV_EUR & " > 0"
		sEQN_EWB_RST = sEQN_EWB & " .AND. " & sEQN_RST
	end if
End Function
' --------------------------------------------------------------------------

' Filters the input table.
Function Analysis
SetCheckpoint "Analysis 1.0 - create sKreditnehmMitIA"
	Set db = Client.OpenDatabase(sInputFile)
	Set task = db.Extraction
	task.IncludeAllFields
	sKreditnehmMitIA = oSC.UniqueFileName(sWorkingfolderName & "{Konten mit ENGA_BVIA}.IMD")
	task.AddExtraction sKreditnehmMitIA, "", sEQN_EWB
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
SetCheckpoint "Analysis 1.1 - create sENGA_EWB_RST"
	Set db = Client.OpenDatabase(sKreditnehmMitIA)
	Set task = db.Summarization
	task.AddFieldToSummarize sNETTO_ENGAGEMENT
	task.AddFieldToTotal sEWB_RST_GEBUCHT_EUR
	sENGA_EWB_RST_IA = oSC.UniqueFileName(sWorkingfolderName & "{SUMME EWB_RST f�r IA}.IMD")
	task.OutputDBName = sENGA_EWB_RST_IA
	task.CreatePercentField = FALSE
	task.StatisticsToInclude = SM_SUM
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
SetCheckpoint "Analysis 1.2 - rename column"
	Set db = Client.OpenDatabase(sENGA_EWB_RST_IA)
	Set sFIELD_ENGA_EWB_RST_IA = oSC.RenField(db, sEWB_RST_GEBUCHT_EUR & "_SUMME", "ENGA_EWB_RST_EUR")
	db.Close
	Set db = nothing
SetCheckpoint "Analysis 1.3 - join"
	Set db = Client.OpenDatabase(sKreditnehmMitIA)
	Set task = db.JoinDatabase
	task.FileToJoin sENGA_EWB_RST_IA
	task.IncludeAllPFields
	task.AddSFieldToInc sFIELD_ENGA_EWB_RST_IA
	task.AddMatchKey sNETTO_ENGAGEMENT, sNETTO_ENGAGEMENT, "A"
	sJoinMitIAundSummeEWBRST = oSC.UniqueFileName(sWorkingfolderName & "{Konten mit ENGA_BVIA & SUMME EWB_RST f�r IA}.IMD")
	task.PerformTask sJoinMitIAundSummeEWBRST, "", WI_JOIN_ALL_IN_PRIM
	db.Close
	Set task = Nothing
	Set db = Nothing
SetCheckpoint "Analysis 1.4 - create"
	Set db = Client.OpenDatabase(sJoinMitIAundSummeEWBRST)
	Set task = db.Extraction
	task.IncludeAllFields
	sKreditnehmMitAusfall_OhneEWB = oSC.UniqueFileName(sWorkingfolderName & "Kreditnehmer mit Ausfallstatus ohne EWB.IMD", FINAL_RESULT)
	task.AddExtraction sKreditnehmMitAusfall_OhneEWB, "", sFIELD_ENGA_EWB_RST_IA & sEQN_Ausfall
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
' @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
SetCheckpoint "Analysis 2.0 - create sKreditnehmMitRV"
	Set db = Client.OpenDatabase(sInputFile)
	Set task = db.Extraction
	task.IncludeAllFields
	sKreditnehmMitRV = oSC.UniqueFileName(sWorkingfolderName & "{Konten mit ENGA_BVRV}.IMD")
	task.AddExtraction sKreditnehmMitRV, "", sEQN_RST
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
SetCheckpoint "Analysis 2.1 - create sENGA_EWB_RST_RV"
	Set db = Client.OpenDatabase(sKreditnehmMitRV)
	Set task = db.Summarization
	task.AddFieldToSummarize sNETTO_ENGAGEMENT
	task.AddFieldToTotal sEWB_RST_GEBUCHT_EUR
	sENGA_EWB_RST_RV = oSC.UniqueFileName(sWorkingfolderName & "{SUMME EWB_RST f�r RV}.IMD")
	task.OutputDBName = sENGA_EWB_RST_RV
	task.CreatePercentField = FALSE
	task.StatisticsToInclude = SM_SUM
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
SetCheckpoint "Analysis 2.2 - rename column"
	Set db = Client.OpenDatabase(sENGA_EWB_RST_RV)
	Set sFIELD_ENGA_EWB_RST_RV = oSC.RenField(db, sEWB_RST_GEBUCHT_EUR & "_SUMME", "ENGA_EWB_RST_EUR")
	db.Close
	Set db = nothing
SetCheckpoint "Analysis 2.3 - join"
	Set db = Client.OpenDatabase(sKreditnehmMitRV)
	Set task = db.JoinDatabase
	task.FileToJoin sENGA_EWB_RST_RV
	task.IncludeAllPFields
	task.AddSFieldToInc sFIELD_ENGA_EWB_RST_RV
	task.AddMatchKey sNETTO_ENGAGEMENT, sNETTO_ENGAGEMENT, "A"
	sJoinMitRVundSummeEWBRST = oSC.UniqueFileName(sWorkingfolderName & "{Konten mit ENGA_BVIA & SUMME EWB_RST f�r RV}.IMD")
	task.PerformTask sJoinMitRVundSummeEWBRST, "", WI_JOIN_ALL_IN_PRIM
	db.Close
	Set task = Nothing
	Set db = Nothing
SetCheckpoint "Analysis 2.4 - create"
	Set db = Client.OpenDatabase(sJoinMitRVundSummeEWBRST)
	Set task = db.Extraction
	task.IncludeAllFields
	sKreditnehmMitAusfall_OhneRST = oSC.UniqueFileName(sWorkingfolderName & "Kreditnehmer mit Ausfallstatus ohne RST.IMD", FINAL_RESULT)
	task.AddExtraction sKreditnehmMitAusfall_OhneRST, "", sFIELD_ENGA_EWB_RST_RV & sEQN_Ausfall
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
' @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
SetCheckpoint "Analysis 3.0 - create sKreditnehmMitRV"
	Set db = Client.OpenDatabase(sInputFile)
	Set task = db.Extraction
	task.IncludeAllFields
	sKreditnehmMitIAundRV = oSC.UniqueFileName(sWorkingfolderName & "{Konten mit ENGA_BVIA und ENGA_BVRV}.IMD")
	task.AddExtraction sKreditnehmMitIAundRV, "", sEQN_EWB_RST
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
SetCheckpoint "Analysis 3.1 - create sENGA_EWB_RST_RV"
	Set db = Client.OpenDatabase(sKreditnehmMitIAundRV)
	Set task = db.Summarization
	task.AddFieldToSummarize sNETTO_ENGAGEMENT
	task.AddFieldToTotal sEWB_RST_GEBUCHT_EUR
	sENGA_EWB_RST_IA_RV = oSC.UniqueFileName(sWorkingfolderName & "{SUMME EWB_RST f�r IA und RV}.IMD")
	task.OutputDBName = sENGA_EWB_RST_IA_RV
	task.CreatePercentField = FALSE
	task.StatisticsToInclude = SM_SUM
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
SetCheckpoint "Analysis 3.2 - rename column"
	Set db = Client.OpenDatabase(sENGA_EWB_RST_IA_RV)
	Set sFIELD_ENGA_EWB_RST_IARV = oSC.RenField(db, sEWB_RST_GEBUCHT_EUR & "_SUMME", "ENGA_EWB_RST_EUR")
	db.Close
	Set db = nothing
SetCheckpoint "Analysis 3.3 - join"
	Set db = Client.OpenDatabase(sKreditnehmMitIAundRV)
	Set task = db.JoinDatabase
	task.FileToJoin sENGA_EWB_RST_IA_RV
	task.IncludeAllPFields
	task.AddSFieldToInc sFIELD_ENGA_EWB_RST_IARV
	task.AddMatchKey sNETTO_ENGAGEMENT, sNETTO_ENGAGEMENT, "A"
	sJoinMitRVIAundSummeEWBRST = oSC.UniqueFileName(sWorkingfolderName & "{Konten mit ENGA_BVIA & SUMME EWB_RST f�r IA und RV}.IMD")
	task.PerformTask sJoinMitRVIAundSummeEWBRST, "", WI_JOIN_ALL_IN_PRIM
	db.Close
	Set task = Nothing
	Set db = Nothing
SetCheckpoint "Analysis 3.4 - create"
	Set db = Client.OpenDatabase(sJoinMitRVIAundSummeEWBRST)
	Set task = db.Extraction
	task.IncludeAllFields
	sKreditnehmMitAusfall_OhneEWBundRST = oSC.UniqueFileName(sWorkingfolderName & "Kreditnehmer mit Ausfallstatus ohne EWB und ohne RST.IMD", FINAL_RESULT)
	task.AddExtraction sKreditnehmMitAusfall_OhneEWBundRST, "", sFIELD_ENGA_EWB_RST_IARV & sEQN_Ausfall
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
end function
' --------------------------------------------------------------------------
Function Analysis_per_Person
SetCheckpoint "Analysis_Sum_Person 1.0 - sKreditnehmMitAusfall_OhneEWB_pro Kunde"
	Set db = Client.OpenDatabase(sKreditnehmMitAusfall_OhneEWB)
	Set task = db.Summarization
	task.AddFieldToSummarize "KUNDENNUMMER"
	task.AddFieldToInc "DATUM_DATENABZUG"
	task.AddFieldToInc "NETTO_ENGAGEMENT"
	task.AddFieldToInc "KUNDENGRUPPEN_NR"
	task.AddFieldToInc "ENGAGEMENTBEZ"
	task.AddFieldToInc "KUNDENNAME"
	task.AddFieldToInc "RISIKOGRUPPE"
	task.AddFieldToInc "RISIKOGRUPPE_ENGA"
	task.AddFieldToInc "BONIT�TSEINSTUFUNG"
	task.AddFieldToInc "BONIT�TSEINST_ENGA"
	task.AddFieldToInc "VR_RATINGART"
	task.AddFieldToInc "VR_RATINGART_ENGA"
	task.AddFieldToInc "VR_RATING"
	task.AddFieldToInc "VR_RATING_ENGA"
	If oSC.FieldExists(db, "VR_RATING_ENGA2") Then 
		task.AddFieldToInc "VR_RATING_ENGA2"
	End If
	task.AddFieldToInc "AUSFALLRATE_KUNDE"
	If oSC.FieldExists(db, "AUSFALLRATE_ENGA") Then 
		task.AddFieldToInc "AUSFALLRATE_ENGA"
	End If
	task.AddFieldToInc "DATUM_LTZ_RATING"
	task.AddFieldToInc "GK_ENGA_RV_EUR"
	task.AddFieldToInc "GK_ENGA_EA_EUR"
	task.AddFieldToInc "GK_ENGA_BVRV_EUR"
	task.AddFieldToInc "GK_ENGA_BVIA_EUR"
	task.AddFieldToInc "GK_KD_RV_EUR"
	task.AddFieldToInc "GK_KD_EA_EUR"
	task.AddFieldToInc "GK_KD_BVRV_EUR"
	task.AddFieldToInc "GK_KD_BVIA_EUR"
	task.AddFieldToInc "GK_KD_NTOBVRV_EUR"
	task.AddFieldToInc "BERATER"
	task.AddFieldToInc "GEWERBLICH_PRIVAT"
	task.AddFieldToInc "RECHTSFORM"
	task.AddFieldToInc "BRANCHE"
	task.AddFieldToInc "KPM_BRANCHE"
	task.AddFieldToInc "KPM_BER�CKS_KD_RS"
	task.AddFieldToInc "L�NDERSCHL�SSEL"
	task.AddFieldToInc "KUNDE_SEIT_DATUM"
	task.AddFieldToInc "GEB_GR�ND_DATUM"
	task.AddFieldToInc "RISIKOSTATUS_MAK"
	task.AddFieldToInc "RISIKOKENNZEICHEN"
	task.AddFieldToInc "�BERZ_ENG_BASEL_EUR"
	task.AddFieldToInc "TAGE_�BERZ_ENG_BASEL"
	task.AddFieldToInc "GK_ENGA_�BERZ_EUR"
	task.AddFieldToInc "TAGE_�BERZ_ENGA"
	task.AddFieldToInc "JAHRESABSCHLUSSDATUM"
	task.AddFieldToInc "VR_RATING_NUM"
	task.AddFieldToInc "VR_RATING_ENGA_NUM"
	task.AddFieldToInc sFIELD_ENGA_EWB_RST_IA
	sKreditnehmMitAusfall_OhneEWB_per_Person = oSC.UniqueFileName(sWorkingfolderName & "Kreditnehmer mit Ausfallstatus ohne EWB_pro Kunde.IMD", FINAL_RESULT)
	task.OutputDBName = sKreditnehmMitAusfall_OhneEWB_per_Person
	task.CreatePercentField = FALSE
	task.UseFieldFromFirstOccurrence = TRUE
	task.PerformTask
	db.close
	Set task = Nothing
	Set db = Nothing
	
SetCheckpoint "Analysis_Sum_Person 1.0 - sKreditnehmMitAusfall_OhneRST_pro Kunde"
	Set db = Client.OpenDatabase(sKreditnehmMitAusfall_OhneRST)
	Set task = db.Summarization
	task.AddFieldToSummarize "KUNDENNUMMER"
	task.AddFieldToInc "DATUM_DATENABZUG"
	task.AddFieldToInc "NETTO_ENGAGEMENT"
	task.AddFieldToInc "KUNDENGRUPPEN_NR"
	task.AddFieldToInc "ENGAGEMENTBEZ"
	task.AddFieldToInc "KUNDENNAME"
	task.AddFieldToInc "RISIKOGRUPPE"
	task.AddFieldToInc "RISIKOGRUPPE_ENGA"
	task.AddFieldToInc "BONIT�TSEINSTUFUNG"
	task.AddFieldToInc "BONIT�TSEINST_ENGA"
	task.AddFieldToInc "VR_RATINGART"
	task.AddFieldToInc "VR_RATINGART_ENGA"
	task.AddFieldToInc "VR_RATING"
	task.AddFieldToInc "VR_RATING_ENGA"
	If oSC.FieldExists(db, "VR_RATING_ENGA2") Then 
		task.AddFieldToInc "VR_RATING_ENGA2"
	End If
	task.AddFieldToInc "AUSFALLRATE_KUNDE"
	If oSC.FieldExists(db, "AUSFALLRATE_ENGA") Then 
		task.AddFieldToInc "AUSFALLRATE_ENGA"
	End If
	task.AddFieldToInc "DATUM_LTZ_RATING"
	task.AddFieldToInc "GK_ENGA_RV_EUR"
	task.AddFieldToInc "GK_ENGA_EA_EUR"
	task.AddFieldToInc "GK_ENGA_BVRV_EUR"
	task.AddFieldToInc "GK_ENGA_BVIA_EUR"
	task.AddFieldToInc "GK_KD_RV_EUR"
	task.AddFieldToInc "GK_KD_EA_EUR"
	task.AddFieldToInc "GK_KD_BVRV_EUR"
	task.AddFieldToInc "GK_KD_BVIA_EUR"
	task.AddFieldToInc "GK_KD_NTOBVRV_EUR"
	task.AddFieldToInc "BERATER"
	task.AddFieldToInc "GEWERBLICH_PRIVAT"
	task.AddFieldToInc "RECHTSFORM"
	task.AddFieldToInc "BRANCHE"
	task.AddFieldToInc "KPM_BRANCHE"
	task.AddFieldToInc "KPM_BER�CKS_KD_RS"
	task.AddFieldToInc "L�NDERSCHL�SSEL"
	task.AddFieldToInc "KUNDE_SEIT_DATUM"
	task.AddFieldToInc "GEB_GR�ND_DATUM"
	task.AddFieldToInc "RISIKOSTATUS_MAK"
	task.AddFieldToInc "RISIKOKENNZEICHEN"
	task.AddFieldToInc "�BERZ_ENG_BASEL_EUR"
	task.AddFieldToInc "TAGE_�BERZ_ENG_BASEL"
	task.AddFieldToInc "GK_ENGA_�BERZ_EUR"
	task.AddFieldToInc "TAGE_�BERZ_ENGA"
	task.AddFieldToInc "JAHRESABSCHLUSSDATUM"
	task.AddFieldToInc "VR_RATING_NUM"
	task.AddFieldToInc "VR_RATING_ENGA_NUM"
	task.AddFieldToInc sFIELD_ENGA_EWB_RST_IA
	sKreditnehmMitAusfall_OhneRST_per_Person = oSC.UniqueFileName(sWorkingfolderName & "Kreditnehmer mit Ausfallstatus ohne RST_pro Kunde.IMD", FINAL_RESULT)
	task.OutputDBName = sKreditnehmMitAusfall_OhneRST_per_Person
	task.CreatePercentField = FALSE
	task.UseFieldFromFirstOccurrence = TRUE
	task.PerformTask
	db.close
	Set task = Nothing
	Set db = Nothing
	
	SetCheckpoint "Analysis_Sum_Person 1.0 - sKreditnehmMitAusfall_OhneEWBundRST_pro Kunde"
	Set db = Client.OpenDatabase(sKreditnehmMitAusfall_OhneEWBundRST)
	Set task = db.Summarization
	task.AddFieldToSummarize "KUNDENNUMMER"
	task.AddFieldToInc "DATUM_DATENABZUG"
	task.AddFieldToInc "NETTO_ENGAGEMENT"
	task.AddFieldToInc "KUNDENGRUPPEN_NR"
	task.AddFieldToInc "ENGAGEMENTBEZ"
	task.AddFieldToInc "KUNDENNAME"
	task.AddFieldToInc "RISIKOGRUPPE"
	task.AddFieldToInc "RISIKOGRUPPE_ENGA"
	task.AddFieldToInc "BONIT�TSEINSTUFUNG"
	task.AddFieldToInc "BONIT�TSEINST_ENGA"
	task.AddFieldToInc "VR_RATINGART"
	task.AddFieldToInc "VR_RATINGART_ENGA"
	task.AddFieldToInc "VR_RATING"
	task.AddFieldToInc "VR_RATING_ENGA"
	If oSC.FieldExists(db, "VR_RATING_ENGA2") Then 
		task.AddFieldToInc "VR_RATING_ENGA2"
	End If
	task.AddFieldToInc "AUSFALLRATE_KUNDE"
	If oSC.FieldExists(db, "AUSFALLRATE_ENGA") Then 
		task.AddFieldToInc "AUSFALLRATE_ENGA"
	End If
	task.AddFieldToInc "DATUM_LTZ_RATING"
	task.AddFieldToInc "GK_ENGA_RV_EUR"
	task.AddFieldToInc "GK_ENGA_EA_EUR"
	task.AddFieldToInc "GK_ENGA_BVRV_EUR"
	task.AddFieldToInc "GK_ENGA_BVIA_EUR"
	task.AddFieldToInc "GK_KD_RV_EUR"
	task.AddFieldToInc "GK_KD_EA_EUR"
	task.AddFieldToInc "GK_KD_BVRV_EUR"
	task.AddFieldToInc "GK_KD_BVIA_EUR"
	task.AddFieldToInc "GK_KD_NTOBVRV_EUR"
	task.AddFieldToInc "BERATER"
	task.AddFieldToInc "GEWERBLICH_PRIVAT"
	task.AddFieldToInc "RECHTSFORM"
	task.AddFieldToInc "BRANCHE"
	task.AddFieldToInc "KPM_BRANCHE"
	task.AddFieldToInc "KPM_BER�CKS_KD_RS"
	task.AddFieldToInc "L�NDERSCHL�SSEL"
	task.AddFieldToInc "KUNDE_SEIT_DATUM"
	task.AddFieldToInc "GEB_GR�ND_DATUM"
	task.AddFieldToInc "RISIKOSTATUS_MAK"
	task.AddFieldToInc "RISIKOKENNZEICHEN"
	task.AddFieldToInc "�BERZ_ENG_BASEL_EUR"
	task.AddFieldToInc "TAGE_�BERZ_ENG_BASEL"
	task.AddFieldToInc "GK_ENGA_�BERZ_EUR"
	task.AddFieldToInc "TAGE_�BERZ_ENGA"
	task.AddFieldToInc "JAHRESABSCHLUSSDATUM"
	task.AddFieldToInc "VR_RATING_NUM"
	task.AddFieldToInc "VR_RATING_ENGA_NUM"
	task.AddFieldToInc sFIELD_ENGA_EWB_RST_IARV
	sKreditnehmMitAusfall_OhneEWBundRST_per_Person = oSC.UniqueFileName(sWorkingfolderName & "Kreditnehmer mit Ausfallstatus ohne EWB und ohne RST_pro Kunde.IMD", FINAL_RESULT)
	task.OutputDBName = sKreditnehmMitAusfall_OhneEWBundRST_per_Person
	task.CreatePercentField = FALSE
	task.UseFieldFromFirstOccurrence = TRUE
	task.PerformTask
	db.close
	Set task = Nothing
	Set db = Nothing
	
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
	
	exit sub
end function
