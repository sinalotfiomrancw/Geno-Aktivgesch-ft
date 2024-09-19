'--------------------------------------------------------------------------------
' changed by:	AS
' changed on:	09.02.2023
' description:	added column with export date which will be used in mp audit tests
'--------------------------------------------------------------------------------
' changed by:	AS
' changed on:	13.02.2023
' description:	added column with numerical values of the rating value
'--------------------------------------------------------------------------------
' changed by:	AS
' changed on:	14.02.2023
' description:	RR-Column
'--------------------------------------------------------------------------------
' changed by:	AS
' changed on:	15.07.2023
' description:	added datapreparation for KGW (Kreditgewährung)
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
Dim oPara As Object
dim mppTaskFactory as object
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

'#Region - Files
Dim sInputFile as string
dim sSB_FileName as string
dim sSBI_FileName as string
dim sSBH_FileName as string
dim sSZR_FileName as string
dim sSZS_FileName as string
Dim sSicherheiten_Bz_FileName As String
Dim sCodesBz_FileName As String
dim sSB_FileName_Final as string
dim sSBI_FileName_Final as string
dim sSBH_FileName_Final as string
dim sSZR_FileName_Final as string
dim sSZS_FileName_Final as string
Dim sSZRmitSBI_Final As String
Dim sSB_Join_SZS_Final As String
Dim sSBI_Join_SZS_Final As String
Dim sBASmitSBIuSBH_Final As String
'-----------------------------------------
Dim sTemp_KBB_PERSNR As String
Dim sTemp_KBB_EINHNR As String
Dim sTemp_KBB_KRM_KUNDE As String
Dim sTemp_KBB_KRM_ENGAGEMENT As String
Dim sTemp_KBB_KRM_GESAMT As String
Dim sTemp_SNM_SCHUFA_Criteria_Count As String
Dim sTemp_KBB_KRM_SNM As String
Dim sKBB_FileName As String
Dim sSNM_FileName As String
Dim sTemp_KBB_FileName As String
Dim sTemp_SNM_FileName As String
Dim sKBB_FinalFileName As String
Dim sSNM_OVERVIEW_FinalFileName As String
Dim sKRM_FinalFileName_Temp As String
Dim sRK_GA_SW_SN As String
'#End Region

'#Region - CleanUp
Dim aFilesToDelete() As String
dim iFilesToDeleteCount as integer
'#End Region

'#Region - Files Alias
Const sBas_FileAlias As String = "SB"
Const sBas_Immo_FileAlias As String = "SBI"
Const sBuerg_Haft_FileAlias As String = "SBH"
Const sZwek_RK_FileAlias As String = "SZR"
Const sZwek_Si_Wert_FileAlias As String = "SZS"
Const sZwek_RK_mit_SBI_FileAlias As String = "SZRmitSBI"
Const sBAS_mit_SBIuSBH_FileAlias As String = "BASmitSBIuSBH"
Const sCodes_Bezeichnungen_FileAlias As String = "CBZ"
Const sCodes_Sicherheitenart_FileAlias As String = "SBZ"
'#End Region

'#Region - Files Valid
dim bSB_FileValid as boolean
dim bSBI_FileValid as boolean
dim bSBH_FileValid as boolean
dim bSZR_FileValid as boolean
dim bSZS_FileValid as boolean
dim bCBZ_FileValid as boolean
dim bSBZ_FileValid as boolean
'#End Region

dim bSi_Bas as boolean
dim bSi_Bas_Immo as boolean
dim bSi_Buerg_Haft as boolean
dim bSi_Zwek_RK as boolean
dim bSi_Zwek_Si_Wert as boolean

'#Region - Folder
dim sWorkingFolderPath as string
Dim sWorkingFolderName As String
'#End Region

'#Region - Parameter
dim sVersionImportdefinition as string ' 13.02.2023
'Dim sDataExportDate As String ' 09.02.2023
dim aRatingGrades(25) as string' 14.02.2023

' 14.02.2023
dim bUseIdividualRiskRelevance as boolean
dim sRiskRating as string
dim sRiskVolume as string
dim sBlankVolume as string
dim sOverdraft as string
dim bRiskRating as boolean
dim bRiskVolume as boolean
dim bBlankVolume as boolean
Dim bOverdraft As Boolean
Dim sJoinType As String
Dim bBoni As Boolean
Dim sBoni As String
Dim sJoinTypeIDEA As String
Dim bExist_AUSFALLRATE_ENGA As Boolean

Dim bKRM As Boolean
Dim bKGW As Boolean
'#End Region
Sub Main()
	On Error GoTo ErrHandler:
	
	SetCheckpoint "Begin of Sub Main()"
	
	SmartContext.Log.LogMessage "Data preparation of the import routine '{0}'", SmartContext.TestName
	SmartContext.Log.LogMessage "Version: {0}", SmartContext.TestVersion
	SmartContext.Log.LogMessage "Called at: {0}", Format(Now(), "yyyy-MM-dd hh:mm:ss")
	SmartContext.Log.LogMessage "Runs on server: {0}", SmartContext.IsServerTask
	
	' Please check whether the variables below are really needed.
	' Remove all unnecessary variables and this comment too
	Set oMC = SmartContext.MacroCommands
	Set oSC = oMC.SimpleCommands
	Set oTM = oMC.TagManagement
	Set oPip = oMC.ProtectIP
	Set oPara = oMC.GlobalParameters
	
	IgnoreWarning(True)
	' **** Add your code below this line
	bSi_Bas = oPara.Get4Project("PrepareBAS")
	bSi_Bas_Immo = oPara.Get4Project("PrepareBASIMO")
	bSi_Buerg_Haft = oPara.Get4Project("PrepareBUEHAFT")
	bSi_Zwek_RK = oPara.Get4Project("PrepareZWERK")
	bSi_Zwek_Si_Wert = oPara.Get4Project("PrepareZWEWE")
	
	Call GetDatabasesCBZ
	Call RegisterResult(sCodesBz_FileName, FINAL_RESULT)
	
	Call GetDatabasesSBZ
	Call RegisterResult(sSicherheiten_Bz_FileName, FINAL_RESULT)
	
	' KRM file should always be prepared before KGW
	' if KRM file was prepared, KGW preparation do not has to do the same preparation
	If bSi_Bas Then
		Call GetDatabasesSB
		Call GetWorkingFolder(sSB_FileName)
		Call Prepare_BAS
		Call RegisterResult(sSB_FileName_Final, FINAL_RESULT)
	End If
	
	If bSi_Bas_Immo Then
		Call GetDatabasesSBI
		Call GetWorkingFolder(sSBI_FileName)
		Call Prepare_SBI
		Call RegisterResult(sSBI_FileName_Final, FINAL_RESULT)
	End If
	
	If bSi_Buerg_Haft Then
		Call GetDatabasesSBH
		Call GetWorkingFolder(sSBH_FileName)
		Call Prepare_SBH
		Call RegisterResult(sSBH_FileName_Final, FINAL_RESULT)
	End If
	
	If bSi_Zwek_RK Then
		Call GetDatabasesSZR
		Call GetWorkingFolder(sSZR_FileName)
		Call Prepare_SZR
		Call RegisterResult(sSZR_FileName_Final, FINAL_RESULT)
	End If
	
	If bSi_Zwek_Si_Wert Then
		Call GetDatabasesSZS
		Call GetWorkingFolder(sSZS_FileName)
		Call Prepare_SZS
		Call RegisterResult(sSZS_FileName_Final, FINAL_RESULT)
	End If
	
	If bSi_Bas_Immo And bSi_Zwek_RK Then
		Call Preparer_RK_with_Im
		Call RegisterResult(sSZRmitSBI_Final, FINAL_RESULT)
	End If
	
	If bSi_Bas_Immo And bSi_Zwek_Si_Wert Then
		Call Preparer_SBI_Join_SW
		Call RegisterResult(sSBI_Join_SZS_Final, FINAL_RESULT)
	End If
	
	If bSi_Bas And bSi_Zwek_Si_Wert Then
		Call Preparer_SB_Join_SW
		Call RegisterResult(sSB_Join_SZS_Final, FINAL_RESULT)
	End If
	
	If bSi_Bas And bSi_Bas_Immo And bSi_Buerg_Haft Then 
		Call Prepare_Join_BAS_IMM_HAF()
		Call RegisterResult(sBASmitSBIuSBH_Final, FINAL_RESULT)
	End If
	
	' **** End of the user specific code
	
	SmartContext.ExecutionStatus = EXEC_STATUS_SUCCEEDED
	
	SetCheckpoint "End of Sub Main()"
	
	Set oMC = nothing
	Set oSC = nothing
	Set oTM = nothing
	Set oPip = nothing
	Set oPara = nothing
	
	SmartContext.Log.LogMessage "Data preparation ends at: {0}", Format(Now(), "yyyy-MM-dd hh:mm:ss")
	
	Exit Sub
	
ErrHandler:
	Call LogSmartAnalyzerError("")
	
	Call EndSequenze
End Sub
' --------------------------------------------------------------------------

Function Prepare_BAS
'Dim sdbTemp1 As String

	Set db = Client.OpenDatabase(sSB_FileName)
	Set task = db.JoinDatabase
	task.FileToJoin sCodesBz_FileName
	task.IncludeAllPFields
	task.AddSFieldToInc "SICHERHEITENKATEGORIE_BEZEICHNUNG"
	task.AddMatchKey "SICHERHEITENKATEGORIE", "SICHERHEITENKATEGORIE", "A"
	sSB_FileName_Final = "{Sicherheiten_Basisdaten}_mit Bezeichnungen.IMD"
	task.PerformTask sSB_FileName_Final, "", WI_JOIN_ALL_IN_PRIM
	db.Close
	Set task = Nothing
	Set db = Nothing

	'Set task = Client.ProjectManagement
	'' Namen der Datei ändern.
	'task.RenameDatabase sdbTemp1, sSB_FileName
	'Set task = Nothing
	
	'Kill Client.WorkingDirectory & sdbTemp1

End Function
' --------------------------------------------------------------------------

Function Prepare_SBI
Dim sdbTemp1 As String
Dim sdbTemp2 As String
Dim sdbTemp3 As String

	Set db = Client.OpenDatabase(sSBI_FileName)
	Set task = db.JoinDatabase
	task.FileToJoin sCodesBz_FileName
	task.IncludeAllPFields
	task.AddSFieldToInc "BEWERTUNGSART_BEZEICHNUNG"
	task.AddMatchKey "BEWERTUNGSART", "BEWERTUNGSART", "A"
	sdbTemp1 = "{Sicherheiten_Basisdaten_Immo}_mit Bezeichnungen_temp1.IMD"
	task.PerformTask sdbTemp1, "", WI_JOIN_ALL_IN_PRIM
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	Set db = Client.OpenDatabase(sdbTemp1)
	Set task = db.JoinDatabase
	task.FileToJoin sCodesBz_FileName
	task.IncludeAllPFields
	task.AddSFieldToInc "BELEIHUNGSWERT_STATUS_BEZEICHNUNG"
	task.AddMatchKey "BELEIHUNGSWERT_STATUS", "BELEIHUNGSWERT_STATUS", "A"
	sdbTemp2 = "{Sicherheiten_Basisdaten_Immo}_mit Bezeichnungen_temp2.IMD"
	task.PerformTask sdbTemp2, "", WI_JOIN_ALL_IN_PRIM
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	Set db = Client.OpenDatabase(sdbTemp2)
	Set task = db.JoinDatabase
	task.FileToJoin sCodesBz_FileName
	task.IncludeAllPFields
	task.AddSFieldToInc "NUTZUNG_BEZEICHNUNG"
	task.AddMatchKey "NUTZUNG", "NUTZUNG", "A"
	sdbTemp3 = "{Sicherheiten_Basisdaten_Immo}_mit Bezeichnungen_temp3.IMD"
	task.PerformTask sdbTemp3, "", WI_JOIN_ALL_IN_PRIM
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	Set db = Client.OpenDatabase(sdbTemp3)
	Set task = db.JoinDatabase
	task.FileToJoin sCodesBz_FileName
	task.IncludeAllPFields
	task.AddSFieldToInc "NUTZUNGSART_BEZEICHNUNG"
	task.AddMatchKey "NUTZUNGSART", "NUTZUNGSART", "A"
	sSBI_FileName_Final = "{Sicherheiten_Basisdaten_Immo}_mit Bezeichnungen.IMD"
	task.PerformTask sSBI_FileName_Final, "", WI_JOIN_ALL_IN_PRIM
	db.Close
	Set task = Nothing
	Set db = Nothing

	'Set task = Client.ProjectManagement
	'' Namen der Datei ändern.
	'task.RenameDatabase sdbTemp4, sSBI_FileName
	'Set task = Nothing
	'
	'Kill sWorkingFolderPath & sdbTemp1
	'Kill sWorkingFolderPath & sdbTemp2
	'Kill sWorkingFolderPath & sdbTemp3

End Function
' --------------------------------------------------------------------------

Function Prepare_SZR
Dim sdbTemp1 As String
Dim sdbTemp2 As String

	Set db = Client.OpenDatabase(sSZR_FileName)
	Set task = db.JoinDatabase
	task.FileToJoin sCodesBz_FileName
	task.IncludeAllPFields
	task.AddSFieldToInc "SICHERUNGSWERT_AUF_BASIS_VON_BEZEICHNUNG"
	task.AddMatchKey "SICHERUNGSWERT_AUF_BASIS_VON", "SICHERUNGSWERT_AUF_BASIS_VON", "A"
	sdbTemp1 = "{Sicherheiten_Zweckerklärungen_Realkredit}_mit Bezeichnungen_temp1.IMD"
	task.PerformTask sdbTemp1, "", WI_JOIN_ALL_IN_PRIM
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	Set db = Client.OpenDatabase(sdbTemp1)
	Set task = db.JoinDatabase
	task.FileToJoin sCodesBz_FileName
	task.IncludeAllPFields
	task.AddSFieldToInc "TYP_DES_SICHERUNGSWERTES_BEZEICHNUNG"
	task.AddMatchKey "TYP_DES_SICHERUNGSWERTES", "TYP_DES_SICHERUNGSWERTES", "A"
	sdbTemp2 = "{Sicherheiten_Zweckerklärungen_Realkredit}_mit Bezeichnungen_temp2.IMD"
	task.PerformTask sdbTemp2, "", WI_JOIN_ALL_IN_PRIM
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	Set db = Client.OpenDatabase(sdbTemp2)
	Set task = db.JoinDatabase
	task.FileToJoin sCodesBz_FileName
	task.IncludeAllPFields
	task.AddSFieldToInc "RISIKOSTATUS_MARISK_BEZEICHNUNG"
	task.AddMatchKey "RISIKOSTATUS_MARISK", "RISIKOSTATUS_MARISK", "A"
	sSZR_FileName_Final = "{Sicherheiten_Zweckerklärungen_Realkredit}_mit Bezeichnungen.IMD"
	task.PerformTask sSZR_FileName_Final, "", WI_JOIN_ALL_IN_PRIM
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	'Set task = Client.ProjectManagement
	'' Namen der Datei ändern.
	'task.RenameDatabase sdbTemp3, sSZR_FileName
	'Set task = Nothing
	'
	'Kill sWorkingFolderPath & sdbTemp1
	'Kill sWorkingFolderPath & sdbTemp2

End Function
' --------------------------------------------------------------------------

Function Prepare_SZS
Dim sdbTemp1 As String
Dim sdbTemp2 As String
Dim sdbTemp3 As String

	Set db = Client.OpenDatabase(sSZS_FileName)
	Set task = db.JoinDatabase
	task.FileToJoin sCodesBz_FileName
	task.IncludeAllPFields
	task.AddSFieldToInc "SICHERUNGSWERT_AUF_BASIS_VON_BEZEICHNUNG"
	task.AddMatchKey "SICHERUNGSWERT_AUF_BASIS_VON", "SICHERUNGSWERT_AUF_BASIS_VON", "A"
	sdbTemp1 = "{Sicherheiten_Zweckerklärungen_Si-Wert}_mit Bezeichnungen_temp1.IMD"
	task.PerformTask sdbTemp1, "", WI_JOIN_ALL_IN_PRIM
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	Set db = Client.OpenDatabase(sdbTemp1)
	Set task = db.JoinDatabase
	task.FileToJoin sCodesBz_FileName
	task.IncludeAllPFields
	task.AddSFieldToInc "TYP_DES_SICHERUNGSWERTES_BEZEICHNUNG"
	task.AddMatchKey "TYP_DES_SICHERUNGSWERTES", "TYP_DES_SICHERUNGSWERTES", "A"
	sdbTemp2 = "{Sicherheiten_Zweckerklärungen_Si-Wert}_mit Bezeichnungen_temp2.IMD"
	task.PerformTask sdbTemp2, "", WI_JOIN_ALL_IN_PRIM
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	Set db = Client.OpenDatabase(sdbTemp2)
	Set task = db.JoinDatabase
	task.FileToJoin sCodesBz_FileName
	task.IncludeAllPFields
	task.AddSFieldToInc "RISIKOSTATUS_MARISK_BEZEICHNUNG"
	task.AddMatchKey "RISIKOSTATUS_MARISK", "RISIKOSTATUS_MARISK", "A"
	sSZS_FileName_Final = "{Sicherheiten_Zweckerklärungen_Si-Wert}_mit Bezeichnungen.IMD"
	task.PerformTask sSZS_FileName_Final, "", WI_JOIN_ALL_IN_PRIM
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	'Set task = Client.ProjectManagement
	'' Namen der Datei ändern.
	'task.RenameDatabase sdbTemp3, sSZS_FileName
	'Set task = Nothing
	'
	'Kill sWorkingFolderPath & sdbTemp1
	'Kill sWorkingFolderPath & sdbTemp2

End Function
' --------------------------------------------------------------------------

Function Preparer_RK_with_Im
Dim sGA_SW_SN As String
	Set db = Client.OpenDatabase(sSZR_FileName_Final)
	Set task = db.Summarization
	task.AddFieldToSummarize "PERSONENNUMMER_SICHERHEITENNEHMER"
	task.AddFieldToTotal "ANTEIL_SICHERUNGSWERT_GEMÄß_BERECHNUNGSA"
	sGA_SW_SN = "Summe Si-Wert Realkredite je Sicherheitennehmer.IMD"
	task.OutputDBName = sGA_SW_SN
	task.CreatePercentField = FALSE
	task.StatisticsToInclude = SM_SUM
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing


	Set db = Client.OpenDatabase(sSZR_FileName_Final)
	Set task = db.JoinDatabase
	task.FileToJoin sGA_SW_SN
	task.AddPFieldToInc "PERSONENNUMMER_SICHERHEITENGEBER"
	task.AddPFieldToInc "PERSONENNUMMER_SICHERHEITENNEHMER"
	task.AddPFieldToInc "SICHERHEITENNUMMER"
	task.AddPFieldToInc "SICHERHEITENUNTERNUMMER"
	task.AddPFieldToInc "KONTONUMMER_SICHERHEITENNEHMER"
	task.AddPFieldToInc "LETZTE_BERECHNUNG"
	task.AddPFieldToInc "SICHERUNGSWERT_AUF_BASIS_VON"
	task.AddPFieldToInc "TYP_DES_SICHERUNGSWERTES"
	task.AddPFieldToInc "PERSONENNUMMER"
	task.AddPFieldToInc "EINZELRATING"
	task.AddPFieldToInc "RISIKOSTATUS_MARISK"
	task.AddPFieldToInc "RISIKOSTATUS_MARISK_SEIT"
	task.AddPFieldToInc "KUNDENBERATER"
	task.AddPFieldToInc "SICHERUNGSWERT_AUF_BASIS_VON_BEZEICHNUNG"
	task.AddPFieldToInc "TYP_DES_SICHERUNGSWERTES_BEZEICHNUNG"
	task.AddPFieldToInc "RISIKOSTATUS_MARISK_BEZEICHNUNG"
	task.AddSFieldToInc "ANTEIL_SICHERUNGSWERT_GEMÄß_BERECHNUNGSA"
	task.AddMatchKey "PERSONENNUMMER_SICHERHEITENNEHMER", "PERSONENNUMMER_SICHERHEITENNEHMER", "A"
	sRK_GA_SW_SN = "Realkredit mit Summe Si-Wert je Sicherheitennehmer.IMD"
	task.PerformTask sRK_GA_SW_SN, "", WI_JOIN_ALL_IN_PRIM
	db.Close
	Set task = Nothing
	Set db = Nothing

	Set db = Client.OpenDatabase(sRK_GA_SW_SN)
	Set task = db.JoinDatabase
	task.FileToJoin sSBI_FileName_Final
	task.IncludeAllPFields
	task.AddSFieldToInc "STATUS_BEARBEITUNG"
	task.AddSFieldToInc "STATUS_SATZART"
	task.AddSFieldToInc "SICHERHEITENART"
	task.AddSFieldToInc "DIE_QUALITATIVEN_ANFORDERUNGEN_SIND_ERFÜ"
	task.AddSFieldToInc "EINGETRAGENER_BETRAG"
	task.AddSFieldToInc "SICHERHEITENART_BEZEICHNUNG"
	task.AddSFieldToInc "EIGENTÜMER_PERSONENNUMMER"
	task.AddSFieldToInc "IMMOBILIEN_NR"
	task.AddSFieldToInc "FEUERVERSICHERUNGSSCHEIN_NR"
	task.AddSFieldToInc "BEWERTUNGSART"
	task.AddSFieldToInc "BELEIHUNGSWERT"
	task.AddSFieldToInc "BELEIHUNGSWERT_PER"
	task.AddSFieldToInc "BELEIHUNGSWERT_STATUS"
	task.AddSFieldToInc "BELEIHUNGSWERT_STATUS_PER"
	task.AddSFieldToInc "BELEIHUNGSWERT_STATUS_VON"
	task.AddSFieldToInc "BELEIHUNGSWERT_STATUS_NUMMER_DES_BEDIENE"
	task.AddSFieldToInc "BELEIHUNGSWERT_WURDE_ÜBERPRÜFT_AM"
	task.AddSFieldToInc "BELEIHUNGSWERT_WURDE_ÜBERPRÜFT_VON"
	task.AddSFieldToInc "BELEIHUNGSGRENZE_IN_EURO"
	task.AddSFieldToInc "BELEIHUNGSGRENZE_IN_PROZENT"
	task.AddSFieldToInc "SICHERHEITENWERT_VERTEILT_JURISTISCH"
	task.AddSFieldToInc "NUTZUNG"
	task.AddSFieldToInc "NUTZUNGSART"
	task.AddSFieldToInc "OBJEKTART"
	task.AddSFieldToInc "OBJEKTART_BEZEICHNUNG"
	task.AddSFieldToInc "BEWERTUNGSART_BEZEICHNUNG"
	task.AddSFieldToInc "BELEIHUNGSWERT_STATUS_BEZEICHNUNG"
	task.AddSFieldToInc "NUTZUNG_BEZEICHNUNG"
	task.AddSFieldToInc "NUTZUNGSART_BEZEICHNUNG"
	task.AddMatchKey "PERSONENNUMMER_SICHERHEITENGEBER", "PERSONENNUMMER", "A"
	task.AddMatchKey "SICHERHEITENNUMMER", "SICHERHEITENNUMMER", "A"
	sSZRmitSBI_Final = "Zweckerklärungen Realkredit verknüpft mit Basisdaten-Immo.IMD"
	task.PerformTask sSZRmitSBI_Final, "", WI_JOIN_ALL_IN_PRIM
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	Dim New_Field As String
	Dim Old_Field As String
	New_Field = "SUMME_SI_WERT_JE_SICHERHEITENNEHMER"
	Old_Field = "ANTEIL_SICHERUNGSWERT_GEMÄß_BERECHNUNGSA"
	Set db = Client.OpenDatabase(sSZRmitSBI_Final) 
	Set New_Field = oSC.RenField(db, Old_Field, New_Field, "")
	db.Close 
	Set db = Nothing

End Function

' --------------------------------------------------------------------------

Function Preparer_SBI_Join_SW

		Set db = Client.OpenDatabase(sSBI_FileName_Final)
		Set task = db.JoinDatabase
		task.FileToJoin sSZS_FileName_Final
		task.IncludeAllPFields
		task.AddSFieldToInc "RISIKOSTATUS_MARISK"
		task.AddSFieldToInc "RISIKOSTATUS_MARISK_BEZEICHNUNG"
		task.AddSFieldToInc "RISIKOSTATUS_MARISK_SEIT"
		task.AddMatchKey "PERSONENNUMMER", "PERSONENNUMMER_SICHERHEITENGEBER", "A"
		task.AddMatchKey "SICHERHEITENNUMMER", "SICHERHEITENNUMMER", "A"
		sSBI_Join_SZS_Final = "Si-Basisdaten-Immo verknüpft mit Sicherheiten-Zweckerklärungen-Si-Wert.IMD"
		task.PerformTask sSBI_Join_SZS_Final, "", WI_JOIN_ALL_IN_PRIM
		db.Close
		Set task = Nothing
		Set db = Nothing
		
End Function

' --------------------------------------------------------------------------

Function Preparer_SB_Join_SW

		Set db = Client.OpenDatabase(sSB_FileName_Final)
		Set task = db.JoinDatabase
		task.FileToJoin sSZS_FileName_Final
		task.IncludeAllPFields
		task.AddSFieldToInc "RISIKOSTATUS_MARISK"
		task.AddSFieldToInc "RISIKOSTATUS_MARISK_BEZEICHNUNG"
		task.AddSFieldToInc "RISIKOSTATUS_MARISK_SEIT"
		task.AddMatchKey "PERSONENNUMMER", "PERSONENNUMMER_SICHERHEITENGEBER", "A"
		task.AddMatchKey "SICHERHEITENNUMMER", "SICHERHEITENNUMMER", "A"
		sSB_Join_SZS_Final = "Si-Basisdaten verknüpft mit Sicherheiten-Zweckerklärungen-Si-Wert.IMD"
		task.PerformTask sSB_Join_SZS_Final, "", WI_JOIN_ALL_IN_PRIM
		db.Close
		Set task = Nothing
		Set db = Nothing
		
End Function
' --------------------------------------------------------------------------

Function Prepare_Join_BAS_IMM_HAF
Dim sJoin3 As String
Dim SJoin3_trunc As String

	Set db = Client.OpenDatabase(sSB_FileName_Final)
	Set task = db.AppendDatabase
	task.AddDatabase sSBI_FileName_Final
	task.AddDatabase sSBH_FileName_Final
	sJoin3 = "Basisdaten mit Immobilien und Bürgschaften angehängt.IMD"
	task.PerformTask sJoin3, ""
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	Set db = Client.OpenDatabase(sJoin3)
	Set task = db.Extraction
	task.AddFieldToInc "PERSONENNUMMER"
	task.AddFieldToInc "NACHNAME_KURZ"
	task.AddFieldToInc "SICHERHEITENART"
	task.AddFieldToInc "SICHERHEITENART_BEZEICHNUNG"
	task.AddFieldToInc "SICHERHEITENWERT_VERTEILT_JURISTISCH"
	SJoin3_trunc = "Basisdaten mit Immobilien und Bürgschaften angehängt-mit Hauptfeldern.IMD"
	task.AddExtraction SJoin3_trunc, "", "STATUS_BEARBEITUNG = ""A""  .AND.  STATUS_SATZART = ""J"""
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	Set db = Client.OpenDatabase(SJoin3_trunc)
	Set task = db.Summarization
	task.AddFieldToSummarize "SICHERHEITENART"
	task.AddFieldToInc "SICHERHEITENART_BEZEICHNUNG"
	task.AddFieldToTotal "SICHERHEITENWERT_VERTEILT_JURISTISCH"
	sBASmitSBIuSBH_Final = "Basisdaten mit Immobilien und Bürgschaften angehängt-Sicherheitenwert je Sicherheitenart summiert.IMD"
	task.OutputDBName = sBASmitSBIuSBH_Final
	task.CreatePercentField = FALSE
	task.StatisticsToInclude = SM_SUM
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing

End Function

' --------------------------------------------------------------------------

Function Prepare_SBH()
'Dim sdbTemp1 As String

	Set db = Client.OpenDatabase(sSBH_FileName)
	Set task = db.JoinDatabase
	task.FileToJoin sCodesBz_FileName
	task.IncludeAllPFields
	task.AddSFieldToInc "SICHERHEITENKATEGORIE_BEZEICHNUNG"
	task.AddMatchKey "SICHERHEITENKATEGORIE", "SICHERHEITENKATEGORIE", "A"
	sSBH_FileName_Final = "{Sicherheiten_Bürgschaften_Haftungsfreistellungen}_mit Bezeichnungen.IMD"
	task.PerformTask sSBH_FileName_Final, "", WI_JOIN_ALL_IN_PRIM
	db.Close
	Set task = Nothing
	Set db = Nothing

	'Set task = Client.ProjectManagement
	'' Namen der Datei ändern.
	'task.RenameDatabase sdbTemp1, sSBH_FileName
	'Set task = Nothing
	
	'Kill Client.WorkingDirectory & sdbTemp1

'	Set db = Client.OpenDatabase(sSBH_FileName)
'	Set task = db.TableManagement
'	Set field = db.TableDef.NewField
'	field.Name = "SICHERHEITENART_NUMERISCH"
'	field.Description = "Hinzugefügtes Feld"
'	field.Type = WI_VIRT_NUM
'	field.Equation = "@Val(SICHERHEITENART)"
'	field.Decimals = 0
'	task.AppendField field
'	task.PerformTask
'	db.Close
'	Set task = Nothing
'	Set db = Nothing
'	Set field = Nothing

End function

' --------------------------------------------------------------------------
' Gets the imported databases for further prepartions
Function GetDatabasesCBZ
SetCheckpoint "GetImportedDatabases 1.0 - get file names"
	sCodesBz_FileName = GetImportedDatabaseName(sCodes_Bezeichnungen_FileAlias, bCBZ_FileValid)
end function

Function GetDatabasesSBZ
SetCheckpoint "GetImportedDatabases 1.0 - get file names"
	sSicherheiten_Bz_FileName = GetImportedDatabaseName(sCodes_Sicherheitenart_FileAlias, bSBZ_FileValid)
end function

Function GetDatabasesSB
SetCheckpoint "GetImportedDatabases 1.0 - get file names"
	sSB_FileName = GetImportedDatabaseName(sBas_FileAlias, bSB_FileValid)
end function

Function GetDatabasesSBI
SetCheckpoint "GetImportedDatabases 1.0 - get file names"
	sSBI_FileName = GetImportedDatabaseName(sBas_Immo_FileAlias, bSBI_FileValid)
end function

Function GetDatabasesSBH
SetCheckpoint "GetImportedDatabases 1.0 - get file names"
	sSBH_FileName = GetImportedDatabaseName(sBuerg_Haft_FileAlias, bSBH_FileValid)
end function

Function GetDatabasesSZR
SetCheckpoint "GetImportedDatabases 1.0 - get file names"
	sSZR_FileName = GetImportedDatabaseName(sZwek_RK_FileAlias, bSZR_FileValid)
end function

Function GetDatabasesSZS
SetCheckpoint "GetImportedDatabases 1.0 - get file names"
	sSZS_FileName = GetImportedDatabaseName(sZwek_Si_Wert_FileAlias, bSZS_FileValid)
end function
' --------------------------------------------------------------------------

' retrieves the database name with the given alias
Function GetImportedDatabaseName(ByVal logicalName As String, bvalid As Boolean) As String
Dim databaseName As String
On Error Resume Next
SetCheckpoint "GetImportedDatabaseName 1.0 - get file name for alias " & logicalName
	databaseName = SmartContext.ImportFiles.Item(logicalName).ImportedFileName
	On Error GoTo ErrorHandler
	If Len(databaseName) Then
		If oSC.FileIsValid(databaseName) Then
			bvalid = true
		Else
			bvalid = false
		End If
	Else
		databaseName = ""
		bvalid = false
		SmartContext.Log.LogWarning "The database " & logicalName & " was not imported." 
	End If	
	GetImportedDatabaseName = databaseName
	Exit Sub
	
ErrorHandler:
	Call LogSmartAnalyzerError("")
	
	Call EndSequenze
End Function
' --------------------------------------------------------------------------

' gets the folder name an path used for given file
Function GetWorkingFolder(ByVal sFileName As String)
SetCheckpoint "GetWorkingFolder 1.0 - get path"
	if sFileName <> "" then
		sWorkingFolderPath = oSC.GetDirName(sFileName)
	else
		' ToDo: Ausnahme definieren 27.10.2022
	End If
'SetCheckpoint "GetWorkingFolder 2.0 - get folder name"	
'	If sWorkingFolderPath = Client.WorkingDirectory Or sWorkingFolderPath = "\" Then
'		sWorkingfolderName = ""
'	Else
'		sWorkingfolderName = sWorkingFolderPath
'		sWorkingfolderName = Left(sWorkingfolderName,Len(sWorkingfolderName)-1)
'		While InStr(sWorkingfolderName, "\") > 0 
'			sWorkingfolderName = Right(sWorkingfolderName, Len(sWorkingfolderName) - InStr(sWorkingfolderName, "\"))
'		Wend
'		sWorkingfolderName = sWorkingfolderName & "\"
'	End If
end function
' --------------------------------------------------------------------------

' deletes files previously add to delete arrays
function CleanUp
dim i as integer
SetCheckpoint "CleanUp 1.0 - delete files from aFilesToDelete"
	for i = 0 to UBound(aFilesToDelete)
		kill aFilesToDelete(i)
	next i
end function
' --------------------------------------------------------------------------

' Registers final tables and sets tags.
function registerResult(sResultFile as string, iResultType as integer)
dim helper as object
dim eqnBuilder as object
Dim oList As Object
Dim mppTask As Object
Dim filter As Object
SetCheckpoint "registerResult 1.0 - set objects"
	set eqnBuilder = oMC.ContentEquationBuilder()
SetCheckpoint "registerResult 2.0 - set tags for " & sResultFile
	Select Case sResultFile
		Case sCodesBz_FileName
			Set helper = oTM.AssociatingTagging(sResultFile)
			helper.SetTag "acc!CBZ_SICHERHEITENKATEGORIE", "SICHERHEITENKATEGORIE"
			helper.SetTag "acc!CBZ_SICHERHEITENKATEGORIE_BEZEICHNUNG", "SICHERHEITENKATEGORIE_BEZEICHNUNG"
			helper.SetTag "acc!CBZ_BEWERTUNGSART", "BEWERTUNGSART"
			helper.SetTag "acc!CBZ_BEWERTUNGSART_BEZEICHNUNG", "BEWERTUNGSART_BEZEICHNUNG"
			helper.SetTag "acc!CBZ_BELEIHUNGSWERT_STATUS", "BELEIHUNGSWERT_STATUS"
			helper.SetTag "acc!CBZ_BELEIHUNGSWERT_STATUS_BEZEICHNUNG", "BELEIHUNGSWERT_STATUS_BEZEICHNUNG"
			helper.SetTag "acc!CBZ_NUTZUNG", "NUTZUNG"
			helper.SetTag "acc!CBZ_NUTZUNG_BEZEICHNUNG", "NUTZUNG_BEZEICHNUNG"
			helper.SetTag "acc!CBZ_NUTZUNGSART", "NUTZUNGSART"
			helper.SetTag "acc!CBZ_NUTZUNGSART_BEZEICHNUNG", "NUTZUNGSART_BEZEICHNUNG"
			helper.SetTag "acc!CBZ_SICHERUNGSWERT_AUF_BASIS_VON", "SICHERUNGSWERT_AUF_BASIS_VON"
			helper.SetTag "acc!CBZ_SICHERUNGSWERT_AUF_BASIS_VON_BEZEICH", "SICHERUNGSWERT_AUF_BASIS_VON_BEZEICHNUNG"
			helper.SetTag "acc!CBZ_TYP_DES_SICHERUNGSWERTES", "TYP_DES_SICHERUNGSWERTES"
			helper.SetTag "acc!CBZ_TYP_DES_SICHERUNGSWERTES_BEZEICHNUNG", "TYP_DES_SICHERUNGSWERTES_BEZEICHNUNG"
			helper.SetTag "acc!CBZ_RISIKOSTATUS_MARISK", "RISIKOSTATUS_MARISK"
			helper.SetTag "acc!CBZ_RISIKOSTATUS_MARISK_BEZEICHNUNG", "RISIKOSTATUS_MARISK_BEZEICHNUNG"
			helper.Save
			
			Set oList = oSC.CreateResultObject(sResultFile, iResultType, True, 1)
			SmartContext.TestResultFiles.Add oList
			oList.ExtraValues.Add "MappedTestIds", eqnBuilder.GetStandardTestFilter("CBZ")
			'Set filter = eqnBuilder.GetStandardTestFilter("CBZ")
			'helper.AssociatePrimary filter
		Case sSicherheiten_Bz_FileName
			Set helper = oTM.AssociatingTagging(sResultFile)
			helper.SetTag "acc!SBZ_SICHERHEITENARTENSCHLUESSEL", "SICHERHEITENARTENSCHLÜSSEL"
			helper.SetTag "acc!SBZ_SICHERHEITENARTENBEZEICHNUNG", "SICHERHEITENARTENBEZEICHNUNG"
			helper.Save
			
			Set oList = oSC.CreateResultObject(sResultFile, iResultType, True, 1)
			SmartContext.TestResultFiles.Add oList
			oList.ExtraValues.Add "MappedTestIds", eqnBuilder.GetStandardTestFilter("SBZ")
			'Set filter = eqnBuilder.GetStandardTestFilter("SBZ")
			'helper.AssociatePrimary filter
		Case sSB_FileName_Final
			Set helper = oTM.AssociatingTagging(sResultFile)
			helper.SetTag "acc!SB_PERSONENNUMMER", "PERSONENNUMMER"
			helper.SetTag "acc!SB_NACHNAME_KURZ", "NACHNAME_KURZ"
			helper.SetTag "acc!SB_SICHERHEITENNUMMER", "SICHERHEITENNUMMER"
			helper.SetTag "acc!SB_STATUS_BEARBEITUNG", "STATUS_BEARBEITUNG"
			helper.SetTag "acc!SB_STATUS_SATZART", "STATUS_SATZART"
			helper.SetTag "acc!SB_SICHERHEITENART", "SICHERHEITENART"
			helper.SetTag "acc!SB_SICHERHEITENKATEGORIE", "SICHERHEITENKATEGORIE"
			helper.SetTag "acc!SB_SICHERHEITENART_BEZEICHNUNG", "SICHERHEITENART_BEZEICHNUNG"
			helper.SetTag "acc!SB_DIE_QUALITATIVEN_ANFORDERUNGEN_SIND_E", "DIE_QUALITATIVEN_ANFORDERUNGEN_SIND_ERFÜ"
			helper.SetTag "acc!SB_DIE_QUALITATIVEN_ANFORDERUNGEN_FUER_D", "DIE_QUALITATIVEN_ANFORDERUNGEN_FÜR_DIE_G"
			helper.SetTag "acc!SB_RECHTSWIRKSAMKEITSDATUM", "RECHTSWIRKSAMKEITSDATUM"
			helper.SetTag "acc!SB_SICHERHEITENWERT_VERTEILT_JURISTISCH", "SICHERHEITENWERT_VERTEILT_JURISTISCH"
			helper.SetTag "acc!SB_BELEIHUNGSWERT", "BELEIHUNGSWERT"
			helper.SetTag "acc!SB_BELEIHUNGSGRENZE_ALS_BETRAG", "BELEIHUNGSGRENZE_ALS_BETRAG"
			helper.SetTag "acc!SB_BELEIHUNGSGRENZE_IN_PROZENT", "BELEIHUNGSGRENZE_IN_PROZENT"
			helper.SetTag "acc!SB_NACHGEWIESENER_WERT", "NACHGEWIESENER_WERT"
			helper.SetTag "acc!SB_NACHGEWIESENER_WERT_PER", "NACHGEWIESENER_WERT_PER"
			'helper.SetTag "acc!SB_SICHERHEITENKATEGORIE_BEZEICHNUNG", "SICHERHEITENKATEGORIE_BEZEICHNUNG"
			helper.Save
			
			Set oList = oSC.CreateResultObject(sResultFile, iResultType, True, 1)
			SmartContext.TestResultFiles.Add oList
			oList.ExtraValues.Add "MappedTestIds", eqnBuilder.GetStandardTestFilter("SB")
			'Set filter = eqnBuilder.GetStandardTestFilter("SB")
			'helper.AssociatePrimary filter
		Case sSBI_FileName_Final
			Set helper = oTM.AssociatingTagging(sResultFile)
			helper.SetTag "acc!SBI_PERSONENNUMMER", "PERSONENNUMMER"
			helper.SetTag "acc!SBI_NACHNAME_KURZ", "NACHNAME_KURZ"
			helper.SetTag "acc!SBI_SICHERHEITENNUMMER", "SICHERHEITENNUMMER"
			helper.SetTag "acc!SBI_STATUS_BEARBEITUNG", "STATUS_BEARBEITUNG"
			helper.SetTag "acc!SBI_STATUS_SATZART", "STATUS_SATZART"
			helper.SetTag "acc!SBI_SICHERHEITENART", "SICHERHEITENART"
			helper.SetTag "acc!SBI_DIE_QUALITATIVEN_ANFORDERUNGEN_SIND_", "DIE_QUALITATIVEN_ANFORDERUNGEN_SIND_ERFÜ"
			helper.SetTag "acc!SBI_EINGETRAGENER_BETRAG", "EINGETRAGENER_BETRAG"
			helper.SetTag "acc!SBI_SICHERHEITENART_BEZEICHNUNG", "SICHERHEITENART_BEZEICHNUNG"
			helper.SetTag "acc!SBI_EIGENTUEMER_PERSONENNUMMER", "EIGENTÜMER_PERSONENNUMMER"
			helper.SetTag "acc!SBI_IMMOBILIEN_NR", "IMMOBILIEN_NR"
			helper.SetTag "acc!SBI_FEUERVERSICHERUNGSSCHEIN_NR", "FEUERVERSICHERUNGSSCHEIN_NR"
			helper.SetTag "acc!SBI_BEWERTUNGSART", "BEWERTUNGSART"
			helper.SetTag "acc!SBI_BELEIHUNGSWERT", "BELEIHUNGSWERT"
			helper.SetTag "acc!SBI_BELEIHUNGSWERT_PER", "BELEIHUNGSWERT_PER"
			helper.SetTag "acc!SBI_BELEIHUNGSWERT_STATUS", "BELEIHUNGSWERT_STATUS"
			helper.SetTag "acc!SBI_BELEIHUNGSWERT_STATUS_PER", "BELEIHUNGSWERT_STATUS_PER"
			helper.SetTag "acc!SBI_BELEIHUNGSWERT_STATUS_VON", "BELEIHUNGSWERT_STATUS_VON"
			helper.SetTag "acc!SBI_BELEIHUNGSWERT_STATUS_NUMMER_DES_BED", "BELEIHUNGSWERT_STATUS_NUMMER_DES_BEDIENE"
			helper.SetTag "acc!SBI_BELEIHUNGSWERT_WURDE_UEBERPRUEFT_AM", "BELEIHUNGSWERT_WURDE_ÜBERPRÜFT_AM"
			helper.SetTag "acc!SBI_BELEIHUNGSWERT_WURDE_UEBERPRUEFT_VON", "BELEIHUNGSWERT_WURDE_ÜBERPRÜFT_VON"
			helper.SetTag "acc!SBI_BELEIHUNGSGRENZE_IN_EURO", "BELEIHUNGSGRENZE_IN_EURO"
			helper.SetTag "acc!SBI_BELEIHUNGSGRENZE_IN_PROZENT", "BELEIHUNGSGRENZE_IN_PROZENT"
			helper.SetTag "acc!SBI_SICHERHEITENWERT_VERTEILT_JURISTISCH", "SICHERHEITENWERT_VERTEILT_JURISTISCH"
			helper.SetTag "acc!SBI_NUTZUNG", "NUTZUNG"
			helper.SetTag "acc!SBI_NUTZUNGSART", "NUTZUNGSART"
			helper.SetTag "acc!SBI_OBJEKTART", "OBJEKTART"
			helper.SetTag "acc!SBI_OBJEKTART_BEZEICHNUNG", "OBJEKTART_BEZEICHNUNG"
			'helper.SetTag "acc!SBI_BEWERTUNGSART_BEZEICHNUNG", "BEWERTUNGSART_BEZEICHNUNG"
			'helper.SetTag "acc!SBI_BELEIHUNGSWERT_STATUS_BEZEICHNUNG", "BELEIHUNGSWERT_STATUS_BEZEICHNUNG"
			'helper.SetTag "acc!SBI_NUTZUNG_BEZEICHNUNG", "NUTZUNG_BEZEICHNUNG"
			'helper.SetTag "acc!SBI_NUTZUNGSART_BEZEICHNUNG", "NUTZUNGSART_BEZEICHNUNG"
			helper.Save
			
			Set oList = oSC.CreateResultObject(sResultFile, iResultType, True, 1)
			SmartContext.TestResultFiles.Add oList
			oList.ExtraValues.Add "MappedTestIds", eqnBuilder.GetStandardTestFilter("SBI")
			'Set filter = eqnBuilder.GetStandardTestFilter("SBI")
			'helper.AssociateSecondary filter, "Basisdaten-Immo"
		Case sSBH_FileName_Final
			Set helper = oTM.AssociatingTagging(sResultFile)
			helper.SetTag "acc!SBH_PERSONENNUMMER", "PERSONENNUMMER"
			helper.SetTag "acc!SBH_NACHNAME_KURZ", "NACHNAME_KURZ"
			helper.SetTag "acc!SBH_SICHERHEITENNUMMER", "SICHERHEITENNUMMER"
			helper.SetTag "acc!SBH_STATUS_BEARBEITUNG", "STATUS_BEARBEITUNG"
			helper.SetTag "acc!SBH_STATUS_SATZART", "STATUS_SATZART"
			helper.SetTag "acc!SBH_SICHERHEITENART", "SICHERHEITENART"
			helper.SetTag "acc!SBH_SICHERHEITENKATEGORIE", "SICHERHEITENKATEGORIE"
			helper.SetTag "acc!SBH_SICHERHEITENART_BEZEICHNUNG", "SICHERHEITENART_BEZEICHNUNG"
			helper.SetTag "acc!SBH_DIE_QUALITATIVEN_ANFORDERUNGEN_SIND_", "DIE_QUALITATIVEN_ANFORDERUNGEN_SIND_ERFÜ"
			helper.SetTag "acc!SBH_RECHTSWIRKSAMKEITSDATUM", "RECHTSWIRKSAMKEITSDATUM"
			helper.SetTag "acc!SBH_BUERGSCHAFTSBETRAG", "BÜRGSCHAFTSBETRAG"
			helper.SetTag "acc!SBH_SICHERHEITENWERT_VERTEILT_JURISTISCH", "SICHERHEITENWERT_VERTEILT_JURISTISCH"
			helper.SetTag "acc!SBH_VERFUEGBARER_SICHERUNGSWERT", "VERFÜGBARER_SICHERUNGSWERT"
			helper.SetTag "acc!SBH_VERFUEGBARER_SICHERUNGSWERT_PER", "VERFÜGBARER_SICHERUNGSWERT_PER"
			'helper.SetTag "acc!SBH_SICHERHEITENART_NUMERISCH", "SICHERHEITENART_NUMERISCH"
			helper.Save
			
			Set oList = oSC.CreateResultObject(sResultFile, iResultType, True, 1)
			SmartContext.TestResultFiles.Add oList
			oList.ExtraValues.Add "MappedTestIds", eqnBuilder.GetStandardTestFilter("SBH")
			'Set filter = eqnBuilder.GetStandardTestFilter("SBH")
			'helper.AssociateSecondary filter, "Bürgschaften-Haftungsfreistellungen"
		Case sSZR_FileName_Final
			Set helper = oTM.AssociatingTagging(sResultFile)
			helper.SetTag "acc!SZR_PERSONENNUMMER_SICHERHEITENGEBER", "PERSONENNUMMER_SICHERHEITENGEBER"
			helper.SetTag "acc!SZR_PERSONENNUMMER_SICHERHEITENNEHMER", "PERSONENNUMMER_SICHERHEITENNEHMER"
			helper.SetTag "acc!SZR_SICHERHEITENNUMMER", "SICHERHEITENNUMMER"
			helper.SetTag "acc!SZR_SICHERHEITENUNTERNUMMER", "SICHERHEITENUNTERNUMMER"
			helper.SetTag "acc!SZR_KONTONUMMER_SICHERHEITENNEHMER", "KONTONUMMER_SICHERHEITENNEHMER"
			helper.SetTag "acc!SZR_LETZTE_BERECHNUNG", "LETZTE_BERECHNUNG"
			helper.SetTag "acc!SZR_ANTEIL_SICHERUNGSWERT_GEMAESS_BERECH", "ANTEIL_SICHERUNGSWERT_GEMÄß_BERECHNUNGSA"
			helper.SetTag "acc!SZR_SICHERUNGSWERT_AUF_BASIS_VON", "SICHERUNGSWERT_AUF_BASIS_VON"
			helper.SetTag "acc!SZR_TYP_DES_SICHERUNGSWERTES", "TYP_DES_SICHERUNGSWERTES"
			helper.SetTag "acc!SZR_PERSONENNUMMER", "PERSONENNUMMER"
			helper.SetTag "acc!SZR_EINZELRATING", "EINZELRATING"
			helper.SetTag "acc!SZR_RISIKOSTATUS_MARISK", "RISIKOSTATUS_MARISK"
			helper.SetTag "acc!SZR_RISIKOSTATUS_MARISK_SEIT", "RISIKOSTATUS_MARISK_SEIT"
			helper.SetTag "acc!SZR_KUNDENBERATER", "KUNDENBERATER"
			'helper.SetTag "acc!SZR_SICHERUNGSWERT_AUF_BASIS_VON_BEZEICH", "SICHERUNGSWERT_AUF_BASIS_VON_BEZEICHNUNG"
			'helper.SetTag "acc!SZR_TYP_DES_SICHERUNGSWERTES_BEZEICHNUNG", "TYP_DES_SICHERUNGSWERTES_BEZEICHNUNG"
			'helper.SetTag "acc!SZR_RISIKOSTATUS_MARISK_BEZEICHNUNG", "RISIKOSTATUS_MARISK_BEZEICHNUNG"
			helper.Save
			
			Set oList = oSC.CreateResultObject(sResultFile, iResultType, True, 1)
			SmartContext.TestResultFiles.Add oList
			oList.ExtraValues.Add "MappedTestIds", eqnBuilder.GetStandardTestFilter("SZR")
			'Set filter = eqnBuilder.GetStandardTestFilter("SZR")
			'helper.AssociateSecondary filter, "Zweckerklärungen-Realkredit"
		Case sSZS_FileName_Final
			Set helper = oTM.AssociatingTagging(sResultFile)
			helper.SetTag "acc!SZS_PERSONENNUMMER_SICHERHEITENGEBER", "PERSONENNUMMER_SICHERHEITENGEBER"
			helper.SetTag "acc!SZS_PERSONENNUMMER_SICHERHEITENNEHMER", "PERSONENNUMMER_SICHERHEITENNEHMER"
			helper.SetTag "acc!SZS_SICHERHEITENNUMMER", "SICHERHEITENNUMMER"
			helper.SetTag "acc!SZS_SICHERHEITENUNTERNUMMER", "SICHERHEITENUNTERNUMMER"
			helper.SetTag "acc!SZS_SICHERHEITENKATEGORIE", "SICHERHEITENKATEGORIE"
			helper.SetTag "acc!SZS_KONTONUMMER_SICHERHEITENNEHMER", "KONTONUMMER_SICHERHEITENNEHMER"
			helper.SetTag "acc!SZS_LETZTE_BERECHNUNG", "LETZTE_BERECHNUNG"
			helper.SetTag "acc!SZS_ANTEIL_SICHERUNGSWERT_GEMAESS_BERECH", "ANTEIL_SICHERUNGSWERT_GEMÄß_BERECHNUNGSA"
			helper.SetTag "acc!SZS_SICHERUNGSWERT_AUF_BASIS_VON", "SICHERUNGSWERT_AUF_BASIS_VON"
			helper.SetTag "acc!SZS_TYP_DES_SICHERUNGSWERTES", "TYP_DES_SICHERUNGSWERTES"
			helper.SetTag "acc!SZS_PERSONENNUMMER", "PERSONENNUMMER"
			helper.SetTag "acc!SZS_EINZELRATING", "EINZELRATING"
			helper.SetTag "acc!SZS_RISIKOSTATUS_MARISK", "RISIKOSTATUS_MARISK"
			helper.SetTag "acc!SZS_RISIKOSTATUS_MARISK_SEIT", "RISIKOSTATUS_MARISK_SEIT"
			helper.SetTag "acc!SZS_KUNDENBERATER", "KUNDENBERATER"
			'helper.SetTag "acc!SZS_SICHERUNGSWERT_AUF_BASIS_VON_BEZEICH", "SICHERUNGSWERT_AUF_BASIS_VON_BEZEICHNUNG"
			'helper.SetTag "acc!SZS_TYP_DES_SICHERUNGSWERTES_BEZEICHNUNG", "TYP_DES_SICHERUNGSWERTES_BEZEICHNUNG"
			'helper.SetTag "acc!SZS_RISIKOSTATUS_MARISK_BEZEICHNUNG", "RISIKOSTATUS_MARISK_BEZEICHNUNG"
			helper.Save
			
			Set oList = oSC.CreateResultObject(sResultFile, iResultType, True, 1)
			SmartContext.TestResultFiles.Add oList
			oList.ExtraValues.Add "MappedTestIds", eqnBuilder.GetStandardTestFilter("SZS")
			'Set filter = eqnBuilder.GetStandardTestFilter("SZS")
			'helper.AssociateSecondary filter, "Zweckerklärungen-Si-Wert"
		Case sSZRmitSBI_Final
			Set helper = oTM.AssociatingTagging(sResultFile)
			helper.SetTag "acc!RIM_PERSONENNUMMER_SICHERHEITENGEBER", "PERSONENNUMMER_SICHERHEITENGEBER"
			helper.SetTag "acc!RIM_PERSONENNUMMER_SICHERHEITENNEHMER", "PERSONENNUMMER_SICHERHEITENNEHMER"
			helper.SetTag "acc!RIM_SICHERHEITENNUMMER", "SICHERHEITENNUMMER"
			helper.SetTag "acc!RIM_SICHERHEITENUNTERNUMMER", "SICHERHEITENUNTERNUMMER"
			helper.SetTag "acc!RIM_KONTONUMMER_SICHERHEITENNEHMER", "KONTONUMMER_SICHERHEITENNEHMER"
			helper.SetTag "acc!RIM_LETZTE_BERECHNUNG", "LETZTE_BERECHNUNG"
			helper.SetTag "acc!RIM_SICHERUNGSWERT_AUF_BASIS_VON", "SICHERUNGSWERT_AUF_BASIS_VON"
			helper.SetTag "acc!RIM_TYP_DES_SICHERUNGSWERTES", "TYP_DES_SICHERUNGSWERTES"
			helper.SetTag "acc!RIM_PERSONENNUMMER", "PERSONENNUMMER"
			helper.SetTag "acc!RIM_EINZELRATING", "EINZELRATING"
			helper.SetTag "acc!RIM_RISIKOSTATUS_MARISK", "RISIKOSTATUS_MARISK"
			helper.SetTag "acc!RIM_RISIKOSTATUS_MARISK_SEIT", "RISIKOSTATUS_MARISK_SEIT"
			helper.SetTag "acc!RIM_KUNDENBERATER", "KUNDENBERATER"
			helper.SetTag "acc!RIM_SUMME_SI_WERT_JE_SICHERHEITENNEHMER", "SUMME_SI_WERT_JE_SICHERHEITENNEHMER"
			helper.SetTag "acc!RIM_STATUS_BEARBEITUNG", "STATUS_BEARBEITUNG"
			helper.SetTag "acc!RIM_STATUS_SATZART", "STATUS_SATZART"
			helper.SetTag "acc!RIM_SICHERHEITENART", "SICHERHEITENART"
			helper.SetTag "acc!RIM_DIE_QUALITATIVEN_ANFORDERUNGEN_SIND_", "DIE_QUALITATIVEN_ANFORDERUNGEN_SIND_ERFÜ"
			helper.SetTag "acc!RIM_EINGETRAGENER_BETRAG", "EINGETRAGENER_BETRAG"
			helper.SetTag "acc!RIM_SICHERHEITENART_BEZEICHNUNG", "SICHERHEITENART_BEZEICHNUNG"
			helper.SetTag "acc!RIM_EIGENTEUMER_PERSONENNUMMER", "EIGENTÜMER_PERSONENNUMMER"
			helper.SetTag "acc!RIM_IMMOBILIEN_NR", "IMMOBILIEN_NR"
			helper.SetTag "acc!RIM_FEUERVERSICHERUNGSSCHEIN_NR", "FEUERVERSICHERUNGSSCHEIN_NR"
			helper.SetTag "acc!RIM_BEWERTUNGSART", "BEWERTUNGSART"
			helper.SetTag "acc!RIM_BELEIHUNGSWERT", "BELEIHUNGSWERT"
			helper.SetTag "acc!RIM_BELEIHUNGSWERT_PER", "BELEIHUNGSWERT_PER"
			helper.SetTag "acc!RIM_BELEIHUNGSWERT_STATUS", "BELEIHUNGSWERT_STATUS"
			helper.SetTag "acc!RIM_BELEIHUNGSWERT_STATUS_PER", "BELEIHUNGSWERT_STATUS_PER"
			helper.SetTag "acc!RIM_BELEIHUNGSWERT_STATUS_VON", "BELEIHUNGSWERT_STATUS_VON"
			helper.SetTag "acc!RIM_BELEIHUNGSWERT_WURDE_UEBERPRUEFT_AM", "BELEIHUNGSWERT_WURDE_ÜBERPRÜFT_AM"
			helper.SetTag "acc!RIM_BELEIHUNGSWERT_WURDE_UEBERPRUEFT_VON", "BELEIHUNGSWERT_WURDE_ÜBERPRÜFT_VON"
			helper.SetTag "acc!RIM_BELEIHUNGSGRENZE_IN_EURO", "BELEIHUNGSGRENZE_IN_EURO"
			helper.SetTag "acc!RIM_BELEIHUNGSGRENZE_IN_PROZENT", "BELEIHUNGSGRENZE_IN_PROZENT"
			helper.SetTag "acc!RIM_SICHERHEITENWERT_VERTEILT_JURISTISCH", "SICHERHEITENWERT_VERTEILT_JURISTISCH"
			helper.SetTag "acc!RIM_NUTZUNG", "NUTZUNG"
			helper.SetTag "acc!RIM_NUTZUNGSART", "NUTZUNGSART"
			helper.SetTag "acc!RIM_OBJEKTART", "OBJEKTART"
			helper.SetTag "acc!RIM_OBJEKTART_BEZEICHNUNG", "OBJEKTART_BEZEICHNUNG"
			'helper.SetTag "acc!RIM_BEWERTUNGSART_BEZEICHNUNG", "BEWERTUNGSART_BEZEICHNUNG"
			'helper.SetTag "acc!RIM_BELEIHUNGSWERT_STATUS_BEZEICHNUNG", "BELEIHUNGSWERT_STATUS_BEZEICHNUNG"
			'helper.SetTag "acc!RIM_NUTZUNG_BEZEICHNUNG", "NUTZUNG_BEZEICHNUNG"
			'helper.SetTag "acc!RIM_NUTZUNGSART_BEZEICHNUNG", "NUTZUNGSART_BEZEICHNUNG"
			'helper.SetTag "acc!RIM_SICHERUNGSWERT_AUF_BASIS_VON_BEZEICH", "SICHERUNGSWERT_AUF_BASIS_VON_BEZEICHNUNG"
			'helper.SetTag "acc!RIM_TYP_DES_SICHERUNGSWERTES_BEZEICHNUNG", "TYP_DES_SICHERUNGSWERTES_BEZEICHNUNG"
			'helper.SetTag "acc!RIM_RISIKOSTATUS_MARISK_BEZEICHNUNG", "RISIKOSTATUS_MARISK_BEZEICHNUNG"
			helper.Save
			
			Set oList = oSC.CreateResultObject(sResultFile, iResultType, True, 1)
			SmartContext.TestResultFiles.Add oList
			oList.ExtraValues.Add "MappedTestIds", eqnBuilder.GetStandardTestFilter("RIM")
			'Set filter = eqnBuilder.GetStandardTestFilter("RIM")
			'helper.AssociateSecondary filter, "ZweckerklärungenRealkredit-mit Basisdaten-Immo"
		Case sSBI_Join_SZS_Final
			Set helper = oTM.AssociatingTagging(sResultFile)
			helper.SetTag "acc!IMS_PERSONENNUMMER", "PERSONENNUMMER"
			helper.SetTag "acc!IMS_NACHNAME_KURZ", "NACHNAME_KURZ"
			helper.SetTag "acc!IMS_SICHERHEITENNUMMER", "SICHERHEITENNUMMER"
			helper.SetTag "acc!IMS_STATUS_BEARBEITUNG", "STATUS_BEARBEITUNG"
			helper.SetTag "acc!IMS_STATUS_SATZART", "STATUS_SATZART"
			helper.SetTag "acc!IMS_SICHERHEITENART", "SICHERHEITENART"
			helper.SetTag "acc!IMS_DIE_QUALITATIVEN_ANFORDERUNGEN_SIND_", "DIE_QUALITATIVEN_ANFORDERUNGEN_SIND_ERFÜ"
			helper.SetTag "acc!IMS_EINGETRAGENER_BETRAG", "EINGETRAGENER_BETRAG"
			helper.SetTag "acc!IMS_SICHERHEITENART_BEZEICHNUNG", "SICHERHEITENART_BEZEICHNUNG"
			helper.SetTag "acc!IMS_EIGENTUEMER_PERSONENNUMMER", "EIGENTÜMER_PERSONENNUMMER"
			helper.SetTag "acc!IMS_IMMOBILIEN_NR", "IMMOBILIEN_NR"
			helper.SetTag "acc!IMS_FEUERVERSICHERUNGSSCHEIN_NR", "FEUERVERSICHERUNGSSCHEIN_NR"
			helper.SetTag "acc!IMS_BEWERTUNGSART", "BEWERTUNGSART"
			helper.SetTag "acc!IMS_BELEIHUNGSWERT", "BELEIHUNGSWERT"
			helper.SetTag "acc!IMS_BELEIHUNGSWERT_PER", "BELEIHUNGSWERT_PER"
			helper.SetTag "acc!IMS_BELEIHUNGSWERT_STATUS", "BELEIHUNGSWERT_STATUS"
			helper.SetTag "acc!IMS_BELEIHUNGSWERT_STATUS_PER", "BELEIHUNGSWERT_STATUS_PER"
			helper.SetTag "acc!IMS_BELEIHUNGSWERT_STATUS_VON", "BELEIHUNGSWERT_STATUS_VON"
			helper.SetTag "acc!IMS_BELEIHUNGSWERT_STATUS_NUMMER_DES_BED", "BELEIHUNGSWERT_STATUS_NUMMER_DES_BEDIENE"
			helper.SetTag "acc!IMS_BELEIHUNGSWERT_WURDE_UEBERPRUEFT_AM", "BELEIHUNGSWERT_WURDE_ÜBERPRÜFT_AM"
			helper.SetTag "acc!IMS_BELEIHUNGSWERT_WURDE_UEBERPRUEFT_VON", "BELEIHUNGSWERT_WURDE_ÜBERPRÜFT_VON"
			helper.SetTag "acc!IMS_BELEIHUNGSGRENZE_IN_EURO", "BELEIHUNGSGRENZE_IN_EURO"
			helper.SetTag "acc!IMS_BELEIHUNGSGRENZE_IN_PROZENT", "BELEIHUNGSGRENZE_IN_PROZENT"
			helper.SetTag "acc!IMS_SICHERHEITENWERT_VERTEILT_JURISTISCH", "SICHERHEITENWERT_VERTEILT_JURISTISCH"
			helper.SetTag "acc!IMS_NUTZUNG", "NUTZUNG"
			helper.SetTag "acc!IMS_NUTZUNGSART", "NUTZUNGSART"
			helper.SetTag "acc!IMS_OBJEKTART", "OBJEKTART"
			helper.SetTag "acc!IMS_OBJEKTART_BEZEICHNUNG", "OBJEKTART_BEZEICHNUNG"
			helper.SetTag "acc!IMS_RISIKOSTATUS_MARISK", "RISIKOSTATUS_MARISK"
			helper.SetTag "acc!IMS_RISIKOSTATUS_MARISK_SEIT", "RISIKOSTATUS_MARISK_SEIT"
			'helper.SetTag "acc!IMS_BEWERTUNGSART_BEZEICHNUNG", "BEWERTUNGSART_BEZEICHNUNG"
			'helper.SetTag "acc!IMS_BELEIHUNGSWERT_STATUS_BEZEICHNUNG", "BELEIHUNGSWERT_STATUS_BEZEICHNUNG"
			'helper.SetTag "acc!IMS_NUTZUNG_BEZEICHNUNG", "NUTZUNG_BEZEICHNUNG"
			'helper.SetTag "acc!IMS_NUTZUNGSART_BEZEICHNUNG", "NUTZUNGSART_BEZEICHNUNG"
			'helper.SetTag "acc!IMS_RISIKOSTATUS_MARISK_BEZEICHNUNG", "RISIKOSTATUS_MARISK_BEZEICHNUNG"
			helper.Save
			
			Set oList = oSC.CreateResultObject(sResultFile, iResultType, True, 1)
			SmartContext.TestResultFiles.Add oList
			oList.ExtraValues.Add "MappedTestIds", eqnBuilder.GetStandardTestFilter("IMS")
			'Set filter = eqnBuilder.GetStandardTestFilter("IMS")
			'helper.AssociateSecondary filter, "Si-Basisdaten-Immo-mit Sicherheiten-Zweckerklärungen-Si-Wert"
		Case sSB_Join_SZS_Final
			Set helper = oTM.AssociatingTagging(sResultFile)
			helper.SetTag "acc!BAS_PERSONENNUMMER", "PERSONENNUMMER"
			helper.SetTag "acc!BAS_NACHNAME_KURZ", "NACHNAME_KURZ"
			helper.SetTag "acc!BAS_SICHERHEITENNUMMER", "SICHERHEITENNUMMER"
			helper.SetTag "acc!BAS_STATUS_BEARBEITUNG", "STATUS_BEARBEITUNG"
			helper.SetTag "acc!BAS_STATUS_SATZART", "STATUS_SATZART"
			helper.SetTag "acc!BAS_SICHERHEITENART", "SICHERHEITENART"
			helper.SetTag "acc!BAS_SICHERHEITENKATEGORIE", "SICHERHEITENKATEGORIE"
			helper.SetTag "acc!BAS_SICHERHEITENART_BEZEICHNUNG", "SICHERHEITENART_BEZEICHNUNG"
			helper.SetTag "acc!BAS_DIE_QUALITATIVEN_ANFORDERUNGEN_SIND_", "DIE_QUALITATIVEN_ANFORDERUNGEN_SIND_ERFÜ"
			helper.SetTag "acc!BAS_DIE_QUALITATIVEN_ANFORDERUNGEN_FUER_", "DIE_QUALITATIVEN_ANFORDERUNGEN_FÜR_DIE_G"
			helper.SetTag "acc!BAS_RECHTSWIRKSAMKEITSDATUM", "RECHTSWIRKSAMKEITSDATUM"
			helper.SetTag "acc!BAS_SICHERHEITENWERT_VERTEILT_JURISTISCH", "SICHERHEITENWERT_VERTEILT_JURISTISCH"
			helper.SetTag "acc!BAS_BELEIHUNGSWERT", "BELEIHUNGSWERT"
			helper.SetTag "acc!BAS_BELEIHUNGSGRENZE_ALS_BETRAG", "BELEIHUNGSGRENZE_ALS_BETRAG"
			helper.SetTag "acc!BAS_BELEIHUNGSGRENZE_IN_PROZENT", "BELEIHUNGSGRENZE_IN_PROZENT"
			helper.SetTag "acc!BAS_NACHGEWIESENER_WERT", "NACHGEWIESENER_WERT"
			helper.SetTag "acc!BAS_NACHGEWIESENER_WERT_PER", "NACHGEWIESENER_WERT_PER"
			helper.SetTag "acc!BAS_RISIKOSTATUS_MARISK", "RISIKOSTATUS_MARISK"
			helper.SetTag "acc!BAS_RISIKOSTATUS_MARISK_SEIT", "RISIKOSTATUS_MARISK_SEIT"
			'helper.SetTag "acc!BAS_SICHERHEITENKATEGORIE_BEZEICHNUNG", "SICHERHEITENKATEGORIE_BEZEICHNUNG"
			'helper.SetTag "acc!BAS_RISIKOSTATUS_MARISK_BEZEICHNUNG", "RISIKOSTATUS_MARISK_BEZEICHNUNG"
			helper.Save
			
			Set oList = oSC.CreateResultObject(sResultFile, iResultType, True, 1)
			SmartContext.TestResultFiles.Add oList
			oList.ExtraValues.Add "MappedTestIds", eqnBuilder.GetStandardTestFilter("BAS")
			'Set filter = eqnBuilder.GetStandardTestFilter("BAS")
			'helper.AssociateSecondary filter, "Si-Basisdaten-mit Sicherheiten-Zweckerklärungen-Si-Wert"
			
		Case sBASmitSBIuSBH_Final
			Set helper = oTM.AssociatingTagging(sResultFile)
			helper.SetTag "acc!BIH_SICHERHEITENART", "SICHERHEITENART"
			helper.SetTag "acc!BIH_SICHERHEITENART_BEZEICHNUNG", "SICHERHEITENART_BEZEICHNUNG"
			'helper.SetTag "acc!BIH_NACHNAME_KURZ", "ANZ_SAETZE"
			helper.SetTag "acc!BIH_SICHERHEITENWERT_VERTEILT_JURISTISCH", "SICHERHEITENWERT_VERTEILT_JURISTISCH_SUM"
			helper.Save
			
			Set oList = oSC.CreateResultObject(sResultFile, iResultType, True, 1)
			SmartContext.TestResultFiles.Add oList
			oList.ExtraValues.Add "MappedTestIds", eqnBuilder.GetStandardTestFilter("BIH")
			'Set filter = eqnBuilder.GetStandardTestFilter("BIH")
			'helper.AssociateSecondary filter, "Basisdaten mit Immo und Bürgschaften_summiert per Sicherheitenart"
		Case Else
	end select
	
	Set helper = Nothing
	Set eqnBuilder = nothing
	Set oList = nothing
end function
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
		
		SmartContext.Log.LogError "An error occurred in during the data preparation of '{0}'.{1}Error #{2}, Error Description: {3}{1}" + _
		                          "The last passed checkpoint was: {4}", _
		                          SmartContext.TestName, Chr(10), Err.Number, Err.Description, m_checkpointName

		If Len(extraInfo) > 0 Then
			SmartContext.Log.LogError "Additional error information: " & extraInfo
		End If
	End If
End Sub
' --------------------------------------------------------------------------

' adds files to an array
function AddFileToFilesToDelete(byval sFileName as string)
SetCheckpoint "AddFileToFilesToDelete 1.0 - add file " & sFileName
	iFilesToDeleteCount = iFilesToDeleteCount + 1
	If iFilesToDeleteCount > 0 Then ReDim Preserve aFilesToDelete(iFilesToDeleteCount)
	aFilesToDelete(iFilesToDeleteCount) = sFileName
end function
' --------------------------------------------------------------------------

' gets the index from a given index for a given value
Function getIndex(ByRef aArray() As String, ByVal sValue As String) As Integer
Dim i As Integer
	For i = 0 To UBound(aArray())
		If aArray(i) = sValue Then getIndex = i
	Next
End Function

' cleans the memory and ends the script
function EndSequenze
	Set oMC = nothing
	Set oSC = nothing
	Set oTM = nothing
	Set oPip = nothing
	Set oPara = nothing
	
	Stop
end function
