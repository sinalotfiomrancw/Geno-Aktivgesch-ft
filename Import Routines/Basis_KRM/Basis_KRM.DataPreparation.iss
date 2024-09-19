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
dim sKrm_Rdf as string
dim sKRM_FileName as string
dim sKRM_FinalFileName as string
dim sKRM_SumFile as string
'#End Region

'#Region - CleanUp
Dim aFilesToDelete() As String
dim iFilesToDeleteCount as integer
'#End Region

'#Region - Files Alias
Const sKRM_FileAlias as string = "KRM_SUM"
'#End Region

'#Region - Files Valid
dim bKRM_FileValid as boolean
'#End Region

'#Region - Folder
dim sWorkingFolderPath as string
Dim sWorkingFolderName As String
'#End Region

'#Region - Parameter
dim sVersionImportdefinition as string ' 13.02.2023
Dim sDataExportDate As String ' 09.02.2023
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
dim bOverdraft as boolean
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
	Set mppTaskFactory = SmartContext.GetServiceById("RegisterTableForMppTaskFactory")
	If mppTaskFactory is Nothing Then
		SmartContext.Log.LogError "The SA service RegisterTableForMppTaskFactory is missing."
	End If
	
	' **** Add your code below this line
	Call GetImportedDatabases
	Call GetWorkingFolder(sKRM_FileName)
	Call GetParameters
	Call Preparation
	'Call CleanUp
	Call RegisterResult(sKRM_FinalFileName, FINAL_RESULT)
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

' Gets the imported databases for further prepartions
Function GetImportedDatabases
SetCheckpoint "GetImportedDatabases 1.0 - get file names"
	sKRM_FileName = GetImportedDatabaseName(sKRM_FileAlias, bKRM_FileValid)
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

' gets and set paramter
function GetParameters
SetCheckpoint "Preparation 1.0 - get global parameter"
	sVersionImportdefinition = oPara.Get4Project("ImpDef") '13.02.2023
	sDataExportDate = oPara.Get4Project("ExportDate") ' 09.02.2023
	'14.02.2023
	bUseIdividualRiskRelevance = oPara.Get4Project("bUseIdividualRiskRelevance")
	sRiskRating = oPara.Get4Project("sRiskRating")
	sRiskVolume = oPara.Get4Project("sRiskVolume")
	sBlankVolume = oPara.Get4Project("sBlankVolume")
	sOverdraft = oPara.Get4Project("sOverdraft")
	bRiskRating = oPara.Get4Project("bRiskRating")
	bRiskVolume = oPara.Get4Project("bRiskVolume")
	bBlankVolume = oPara.Get4Project("bBlankVolume")
	bOverdraft = oPara.Get4Project("bOverdraft")
SetCheckpoint "Preparation 2.0 - set start parameter"
	Redim aFilesToDelete(0)
	iFilesToDeleteCount = -1
	
	aRatingGrades(0) = "keine Note"
	aRatingGrades(1) = "0a"
	aRatingGrades(2) = "0b"
	aRatingGrades(3) = "0c"
	aRatingGrades(4) = "0d"
	aRatingGrades(5) = "0e"
	aRatingGrades(6) = "1a"
	aRatingGrades(7) = "1b"
	aRatingGrades(8) = "1c"
	aRatingGrades(9) = "1d"
	aRatingGrades(10) = "1e"
	aRatingGrades(11) = "2a"
	aRatingGrades(12) = "2b"
	aRatingGrades(13) = "2c"
	aRatingGrades(14) = "2d"
	aRatingGrades(15) = "2e"
	aRatingGrades(16) = "3a"
	aRatingGrades(17) = "3b"
	aRatingGrades(18) = "3c"
	aRatingGrades(19) = "3d"
	aRatingGrades(20) = "3e"
	aRatingGrades(21) = "4a"
	aRatingGrades(22) = "4b"
	aRatingGrades(23) = "4c"
	aRatingGrades(24) = "4d"
	aRatingGrades(25) = "4e"
end function
' --------------------------------------------------------------------------

' preparation
Function Preparation
dim sEQNRating as string
SetCheckpoint "Preparation 1.0 - add data export date" ' 09.02.2023
	Set db = Client.OpenDatabase(sKRM_FileName)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "DATUM_DATENABZUG"
	field.Description = "Datum aus Eingabedialog"
	field.Type = WI_DATE_FIELD
	field.Equation = "@ctod(""" & sDataExportDate & """;""YYYY/MM/DD"")"
	task.AppendField field
	task.PerformTask
SetCheckpoint "Preparation 1.1 - add numerical values for vr rating" ' 13.02.2023
	field.Name = "VR_RATING_NUM"
	field.Description = "VR_Rating in Numerischer Form."
	field.Type = WI_NUM_FIELD
	sEQNRating = "@compif(" & _
	"VR_RATING=""0a"";1;" & _
	"VR_RATING=""0b"";2;" & _
	"VR_RATING=""0c"";3;" & _
	"VR_RATING=""0d"";4;" & _
	"VR_RATING=""0e"";5;" & _
	"VR_RATING=""1a"";6;" & _
	"VR_RATING=""1b"";7;" & _
	"VR_RATING=""1c"";8;" & _
	"VR_RATING=""1d"";9;" & _
	"VR_RATING=""1e"";10;" & _
	"VR_RATING=""2a"";11;" & _
	"VR_RATING=""2b"";12;" & _
	"VR_RATING=""2c"";13;" & _
	"VR_RATING=""2d"";14;" & _
	"VR_RATING=""2e"";15;" & _
	"VR_RATING=""3a"";16;" & _
	"VR_RATING=""3b"";17;" & _
	"VR_RATING=""3c"";18;" & _
	"VR_RATING=""3d"";19;" & _
	"VR_RATING=""3e"";20;" & _
	"VR_RATING=""4a"";21;" & _
	"VR_RATING=""4b"";22;" & _
	"VR_RATING=""4c"";23;" & _
	"VR_RATING=""4d"";24;" & _
	"VR_RATING=""4e"";25;" & _
	"1;99)"
	field.Equation = sEQNRating
	field.Decimals = 0
	task.AppendField field
	task.PerformTask
if bUseIdividualRiskRelevance then
SetCheckpoint "Preparation 1.2 - individual rr" ' 14.02.2023
Dim sEQNRR As String
Dim sNum_Rating As String
	sNum_Rating = getIndex(aRatingGrades(), sRiskRating)
	field.Name = "RISIKOKENNZEICHEN_INDIV"
	field.Description = "individuelle Risikorelevanzegrenze"
	field.Type = WI_CHAR_FIELD
	sEQNRR = "@if("
	If bRiskRating Then sEQNRR = sEQNRR & "VR_RATING_NUM >= " & sNum_Rating & " .OR. "
	if bRiskVolume then sEQNRR = sEQNRR & "GK_ENGA_RV_EUR >= " & sRiskVolume & " .OR. "
	if bBlankVolume then sEQNRR = sEQNRR & "GK_ENGA_BVRV_EUR >= " & sBlankVolume & " .OR. "
	if bOverdraft then sEQNRR = sEQNRR & "GK_ENGA_ÜBERZ_EUR >= " & sOverdraft
	if right(sEQNRR, 6) = " .OR. " then sEQNRR = left(sEQNRR, len(sEQNRR) - 6)
	sEQNRR = sEQNRR & ";""Risikorelevant"";"""")"
	field.Equation = sEQNRR
	field.Length = 20
	task.AppendField field
	task.PerformTask
end if
SetCheckpoint "Preparation 1.3 - finish append field" ' 14.02.2023
	db.Close
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
SetCheckpoint "Preparation 2.0 - create KRM.IMD"
dim aColumnNamesKRM() as string
dim iNumberOfColumns as integer
Dim iColumnCountKRM As Integer
Dim sCurrentColumnName As String
	' 13.02.2023 changed the order of the columns so that the data export date is the first column
	Set db = Client.OpenDatabase(sKRM_FileName)
	Set table = db.TableDef
	iNumberOfColumns = table.Count
	ReDim aColumnNamesKRM(iNumberOfColumns - 1)
	For iColumnCountKRM = 0 To iNumberOfColumns - 1
		sCurrentColumnName = table.GetFieldAt(iColumnCountKRM + 1).Name
		aColumnNamesKRM(iColumnCountKRM) = sCurrentColumnName
	Next
	Set table = nothing
	Set task = db.Extraction
	task.AddFieldToInc "DATUM_DATENABZUG"
	For iColumnCountKRM = 0 To UBound(aColumnNamesKRM)
		If aColumnNamesKRM(iColumnCountKRM) <> "DATUM_DATENABZUG" Then
			task.AddFieldToInc aColumnNamesKRM(iColumnCountKRM)
		End If
	next
	sKRM_FinalFileName = oSC.UniqueFileName(sWorkingFolderPath & "KRM.IMD")
	task.AddExtraction sKRM_FinalFileName, "", "ID <> ""Gesamt"""
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
	Call AddFileToFilesToDelete(sKRM_FileName)
'SetCheckpoint "GetWorkingFolder 2.0 - create KRM Summen.IMD"
'	Set db = Client.OpenDatabase(sKRM_FileName)
'	Set task = db.Extraction
'	task.IncludeAllFields
'	sKRM_SumFile = oSC.UniqueFileName("KRM Summen.IMD")
'	task.AddExtraction sKRM_SumFile, "", "ID = ""Gesamt"""
'	task.PerformTask 1, db.Count
'	db.Close
'	Set task = Nothing
'	Set db = Nothing
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
SetCheckpoint "registerResult 1.0 - set objects"
	set eqnBuilder = oMC.ContentEquationBuilder()
SetCheckpoint "registerResult 2.0 - set tags for " & sResultFile
	Select Case sResultFile
		Case sKRM_FinalFileName
			Set helper = oTM.Tagging(sResultFile)
			helper.SetTag "acc!DATUM_DATENABZUG", "DATUM_DATENABZUG" ' 09.02.2023
			helper.SetTag "acc!ID", "ID"
			helper.SetTag "acc!NETTO_ENGAGEMENT", "NETTO_ENGAGEMENT"
			helper.SetTag "acc!KUNDENGRUPPEN_NR", "KUNDENGRUPPEN_NR"
			helper.SetTag "acc!ENGAGEMENTBEZ", "ENGAGEMENTBEZ"
			helper.SetTag "acc!KUNDENNUMMER", "KUNDENNUMMER"
			helper.SetTag "acc!KUNDENNAME", "KUNDENNAME"
			helper.SetTag "acc!KONTONUMMER", "KONTONUMMER"
			helper.SetTag "acc!RISIKOGRUPPE", "RISIKOGRUPPE"
			helper.SetTag "acc!RISIKOGRUPPE_ENGA", "RISIKOGRUPPE_ENGA"
			helper.SetTag "acc!BONITÄTSEINSTUFUNG", "BONITÄTSEINSTUFUNG"
			helper.SetTag "acc!BONITÄTSEINST_ENGA", "BONITÄTSEINST_ENGA"
			helper.SetTag "acc!VR_RATINGART", "VR_RATINGART"
			helper.SetTag "acc!VR_RATINGART_ENGA", "VR_RATINGART_ENGA"
			helper.SetTag "acc!VR_RATING", "VR_RATING"
			helper.SetTag "acc!VR_RATING_ENGA", "VR_RATING_ENGA"
			helper.SetTag "acc!AUSFALLRATE_KUNDE", "AUSFALLRATE_KUNDE"
			helper.SetTag "acc!DATUM_LTZ_RATING", "DATUM_LTZ_RATING"
			helper.SetTag "acc!RISIKOVOLUMEN_EUR", "RISIKOVOLUMEN_EUR"
			helper.SetTag "acc!NETTO_RISIKOVOLUMEN_EUR", "NETTO_RISIKOVOLUMEN_EUR"
			helper.SetTag "acc!EIGENANTEIL_EUR", "EIGENANTEIL_EUR"
			helper.SetTag "acc!NOM_VOL_EUR", "NOM_VOL_EUR"
			helper.SetTag "acc!GESAMTZUSAGE_EUR", "GESAMTZUSAGE_EUR"
			helper.SetTag "acc!BLANKOVOLUMEN_RV_EUR", "BLANKOVOLUMEN_RV_EUR"
			helper.SetTag "acc!BLANKOVOLUMEN_IA_EUR", "BLANKOVOLUMEN_IA_EUR"
			helper.SetTag "acc!NETTO_BLANKOVOL_RV_EUR", "NETTO_BLANKOVOL_RV_EUR"
			helper.SetTag "acc!NETTO_BLANKOVOL_IA_EUR", "NETTO_BLANKOVOL_IA_EUR"
			helper.SetTag "acc!BARWERT_BLANKOVOL_EUR", "BARWERT_BLANKOVOL_EUR"
			helper.SetTag "acc!OFFENE_ZUSAGE_EUR", "OFFENE_ZUSAGE_EUR"
			helper.SetTag "acc!INTERNES_LIMIT_EUR", "INTERNES_LIMIT_EUR"
			helper.SetTag "acc!EWB_RST_GEBUCHT_EUR", "EWB_RST_GEBUCHT_EUR"
			helper.SetTag "acc!EWB_RST_KALK_EUR", "EWB_RST_KALK_EUR"
			helper.SetTag "acc!SUMME_SICHERHEIT_RV_EUR", "SUMME_SICHERHEIT_RV_EUR"
			helper.SetTag "acc!SUMME_SICHERHEIT_IA_EUR", "SUMME_SICHERHEIT_IA_EUR"
			helper.SetTag "acc!GRUNDPFANDRECHTE_RV_EUR", "GRUNDPFANDRECHTE_RV_EUR"
			helper.SetTag "acc!GRUNDPFANDRECHTE_IA_EUR", "GRUNDPFANDRECHTE_IA_EUR"
			helper.SetTag "acc!ABTRET_GELDVERM_RV_EUR", "ABTRET_GELDVERM_RV_EUR"
			helper.SetTag "acc!ABTRET_GELDVERM_IA_EUR", "ABTRET_GELDVERM_IA_EUR"
			helper.SetTag "acc!ABTRET_SONSTIGES_RV_EUR", "ABTRET_SONSTIGES_RV_EUR"
			helper.SetTag "acc!ABTRET_SONSTIGES_IA_EUR", "ABTRET_SONSTIGES_IA_EUR"
			helper.SetTag "acc!BÜRG_ÖFF_BANKEN_RV_EUR", "BÜRG_ÖFF_BANKEN_RV_EUR"
			helper.SetTag "acc!BÜRG_ÖFF_BANKEN_IA_EUR", "BÜRG_ÖFF_BANKEN_IA_EUR"
			helper.SetTag "acc!SONST_BÜRG_RV_EUR", "SONST_BÜRG_RV_EUR"
			helper.SetTag "acc!SONST_BÜRG_IA_EUR", "SONST_BÜRG_IA_EUR"
			helper.SetTag "acc!SICHERH_ÜBEREIG_RV_EUR", "SICHERH_ÜBEREIG_RV_EUR"
			helper.SetTag "acc!SICHERH_ÜBEREIG_IA_EUR", "SICHERH_ÜBEREIG_IA_EUR"
			helper.SetTag "acc!SONST_SICHERH_RV_EUR", "SONST_SICHERH_RV_EUR"
			helper.SetTag "acc!SONST_SICHERH_IA_EUR", "SONST_SICHERH_IA_EUR"
			helper.SetTag "acc!VERPF_GELDVERM_RV_EUR", "VERPF_GELDVERM_RV_EUR"
			helper.SetTag "acc!VERPF_GELDVERM_IA_EUR", "VERPF_GELDVERM_IA_EUR"
			helper.SetTag "acc!VERPF_SONSTIGES_RV_EUR", "VERPF_SONSTIGES_RV_EUR"
			helper.SetTag "acc!VERPF_SONSTIGES_IA_EUR", "VERPF_SONSTIGES_IA_EUR"
			helper.SetTag "acc!GK_ENGA_RV_EUR", "GK_ENGA_RV_EUR"
			helper.SetTag "acc!GK_ENGA_EA_EUR", "GK_ENGA_EA_EUR"
			helper.SetTag "acc!GK_ENGA_BVRV_EUR", "GK_ENGA_BVRV_EUR"
			helper.SetTag "acc!GK_ENGA_BVIA_EUR", "GK_ENGA_BVIA_EUR"
			helper.SetTag "acc!GK_KD_RV_EUR", "GK_KD_RV_EUR"
			helper.SetTag "acc!GK_KD_EA_EUR", "GK_KD_EA_EUR"
			helper.SetTag "acc!GK_KD_BVRV_EUR", "GK_KD_BVRV_EUR"
			helper.SetTag "acc!GK_KD_BVIA_EUR", "GK_KD_BVIA_EUR"
			helper.SetTag "acc!GK_KD_NTOBVRV_EUR", "GK_KD_NTOBVRV_EUR"
			helper.SetTag "acc!DIREKT_ABSCHREIBUNG_EUR", "DIREKT_ABSCHREIBUNG_EUR"
			helper.SetTag "acc!BERATER", "BERATER"
			helper.SetTag "acc!GEWERBLICH_PRIVAT", "GEWERBLICH_PRIVAT"
			helper.SetTag "acc!RECHTSFORM", "RECHTSFORM"
			helper.SetTag "acc!BRANCHE", "BRANCHE"
			helper.SetTag "acc!KPM_BRANCHE", "KPM_BRANCHE"
			helper.SetTag "acc!KPM_BERÜCKS_KD_RS", "KPM_BERÜCKS_KD_RS"
			helper.SetTag "acc!KONTOWÄHRUNG", "KONTOWÄHRUNG"
			helper.SetTag "acc!LÄNDERSCHLÜSSEL", "LÄNDERSCHLÜSSEL"
			helper.SetTag "acc!KUNDE_SEIT_DATUM", "KUNDE_SEIT_DATUM"
			helper.SetTag "acc!GEB_GRÜND_DATUM", "GEB_GRÜND_DATUM"
			helper.SetTag "acc!GAB", "GAB"
			helper.SetTag "acc!AGREE_PRODUKTNUMMER", "AGREE_PRODUKTNUMMER"
			helper.SetTag "acc!CVAR_EUR", "CVAR_EUR"
			helper.SetTag "acc!EXPECTED_LOSS_EUR", "EXPECTED_LOSS_EUR"
			helper.SetTag "acc!RISIKOSTATUS_MAK", "RISIKOSTATUS_MAK"
			if bUseIdividualRiskRelevance then
				helper.SetTag "acc!RISIKOKENNZEICHEN", "RISIKOKENNZEICHEN_INDIV"
			else
				helper.SetTag "acc!RISIKOKENNZEICHEN", "RISIKOKENNZEICHEN"
			end if
			helper.SetTag "acc!KUNDEN_EIGENGESCHÄFT", "KUNDEN_EIGENGESCHÄFT"
			helper.SetTag "acc!ÜBERZIEHUNG_KTO_EUR", "ÜBERZIEHUNG_KTO_EUR"
			helper.SetTag "acc!TAGE_ÜBERZ_KTO", "TAGE_ÜBERZ_KTO"
			helper.SetTag "acc!ÜBERZ_KD_BASEL_EUR", "ÜBERZ_KD_BASEL_EUR"
			helper.SetTag "acc!TAGE_ÜBERZ_KD_BASEL", "TAGE_ÜBERZ_KD_BASEL"
			helper.SetTag "acc!GK_KD_ÜBERZ_EUR", "GK_KD_ÜBERZ_EUR"
			helper.SetTag "acc!TAGE_ÜBERZ_KUNDE", "TAGE_ÜBERZ_KUNDE"
			helper.SetTag "acc!ÜBERZ_ENG_BASEL_EUR", "ÜBERZ_ENG_BASEL_EUR"
			helper.SetTag "acc!TAGE_ÜBERZ_ENG_BASEL", "TAGE_ÜBERZ_ENG_BASEL"
			helper.SetTag "acc!GK_ENGA_ÜBERZ_EUR", "GK_ENGA_ÜBERZ_EUR"
			helper.SetTag "acc!TAGE_ÜBERZ_ENGA", "TAGE_ÜBERZ_ENGA"
			helper.SetTag "acc!JAHRESABSCHLUSSDATUM", "JAHRESABSCHLUSSDATUM"
			helper.SetTag "acc!DATUM_KTO_ERÖFF_SCHL", "DATUM_KTO_ERÖFF_SCHL"
			helper.SetTag "acc!DATUM_LTZ_RISIKOKZ", "DATUM_LTZ_RISIKOKZ"
			helper.SetTag "acc!VR_RATING_NUM", "VR_RATING_NUM" ' 13.02.2023
			helper.Save
			
			Set oList = oSC.CreateResultObject(sResultFile, iResultType, True, 1)
			SmartContext.TestResultFiles.Add oList
			oList.ExtraValues.Add "MappedTestIds", eqnBuilder.GetStandardTestFilter("KRM")
			
			Set mppTask = mppTaskFactory.NewRegisterTableForMppTask
			mppTask.TableName = oList.Name
			mppTask.ResultId = "KRM"
			mppTask.ResultName = "KRM" ' Name der erstellten IDEA Tabelle
			mppTask.ResultDisplayName = "KRM" ' Gruppenname im Workflowschritt Mehrperiodenaufbereitung
			SmartContext.TestResultFiles.Add oList
			mppTask.AuditTestsFilter = eqnBuilder.GetStandardTestFilter("MP_KRM") ' ContentAreaName
			mppTask.PerformTask
			Set mppTask = Nothing
		case else
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
