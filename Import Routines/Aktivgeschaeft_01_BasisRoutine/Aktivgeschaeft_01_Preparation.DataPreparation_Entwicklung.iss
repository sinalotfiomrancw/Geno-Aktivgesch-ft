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
dim sKrm_Rdf as string
dim sKRM_FileName as string
dim sKRM_FinalFileName as string
Dim sKRM_SumFile As String
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
'#End Region

'#Region - CleanUp
Dim aFilesToDelete() As String
dim iFilesToDeleteCount as integer
'#End Region

'#Region - Files Alias
Const sKRM_FileAlias as string = "KRM_SUM"
Const sKBB_FileAlias as string = "KBB"
Const sSNM_FileAlias as string = "SNM"
'#End Region

'#Region - Files Valid
dim bKRM_FileValid as boolean
dim bKBB_FileValid as boolean
dim bSNM_FileValid as boolean
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
	Set mppTaskFactory = SmartContext.GetServiceById("RegisterTableForMppTaskFactory")
	If mppTaskFactory is Nothing Then
		SmartContext.Log.LogError "The SA service RegisterTableForMppTaskFactory is missing."
	End If
	
	IgnoreWarning(True)
	' **** Add your code below this line
	bKRM = oPara.Get4Project("PrepareKRM")
	bKGW = oPara.Get4Project("PrepareKGW")
	Call GetParameters
	' KRM file should always be prepared before KGW
	' if KRM file was prepared, KGW preparation do not has to do the same preparation
	If bKRM Or bKGW Then
		Call GetDatabasesKRM
		Call checkColumnsKRM
		Call GetWorkingFolder(sKRM_FileName)
		Call PreparationKRM
		'Call CleanUp
	End If
	
	If bKGW Then
		Call GetDatabasesKGW
		Call checkColumnsKBB
		Call SpecialPrep
		Call GetWorkingFolder(sKBB_FileName)
		Call PreparationKGW
		'Call CleanUp
		Call RegisterResult(sKBB_FinalFileName, FINAL_RESULT)
		Call RegisterResult(sSNM_OVERVIEW_FinalFileName, FINAL_RESULT)				 
	End If
	
	If bKRM And bKGW then
			PreparationKRMExtra
	End If
	
	If bKRM Or bKGW Then
		Call RegisterResult(sKRM_FinalFileName, FINAL_RESULT)
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

' Gets the imported databases for further prepartions
Function GetDatabasesKRM
SetCheckpoint "GetImportedDatabases 1.0 - get file names"
	sKRM_FileName = GetImportedDatabaseName(sKRM_FileAlias, bKRM_FileValid)
end function

Function GetDatabasesKGW
SetCheckpoint "GetImportedDatabases 1.0 - get file names"
	sKBB_FileName = GetImportedDatabaseName(sKBB_FileAlias, bKBB_FileValid)
	sSNM_FileName = GetImportedDatabaseName(sSNM_FileAlias, bSNM_FileValid)
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
	sJoinType = oPara.Get4Project("sJoinType")
	bBoni = oPara.Get4Project("bBoni")
	sBoni = oPara.Get4Project("sBoni")
	
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

	If sJoinType = "Es müssen alle gewählten Einträge gleichzeitig erfüllt sein (.AND.)" Then
		sJoinTypeIDEA = ".AND."
	ElseIf sJoinType = "Es muss mindestens ein gewählter Eintrag erfüllt sein (.OR.)" Then
		sJoinTypeIDEA = ".OR."
	Else
		sJoinTypeIDEA = ".OR."
	End If	
end function
' --------------------------------------------------------------------------

' change different column names and types for different import methods
function checkColumnsKRM
SetCheckpoint "checkColumnsKRM 1.0"
	Set db = Client.OpenDatabase(sKRM_FileName) 
	If not oSC.FieldExists(db, "ID") Then
		if oSC.FieldExists(db, "SPALTE") Then
			Set task = db.TableManagement
			Set field = db.TableDef.NewField
			field.Name = "ID"
			field.Description = ""
			field.Type = WI_CHAR_FIELD
			field.Equation = ""
			field.Length = 10
			task.ReplaceField "SPALTE", field
			task.PerformTask
			Set task = Nothing
			Set field = Nothing
		end if
	End If
	if oSC.FieldExists(db, "GEB_GRÜND_DATUM") Then
		Set task = db.TableManagement
		Set field = db.TableDef.NewField
		field.Name = "GEB_GRÜND_DATUM"
		field.Description = ""
		field.Type = WI_DATE_FIELD
		field.Equation = "DD.MM.YYYY"
		task.ReplaceField "GEB_GRÜND_DATUM", field
		task.PerformTask
		Set task = Nothing
		Set field = Nothing
	End If
	
	If oSC.FieldExists(db, "AUSFALLRATE_ENGA") Then 
		bExist_AUSFALLRATE_ENGA = True
	else
		bExist_AUSFALLRATE_ENGA = False
	End If
	
	db.Close 
	Set db = Nothing 
end function
' --------------------------------------------------------------------------

' change different column names and types for different import methods
Function checkColumnsKBB
SetCheckpoint "checkColumnsKBB 1.0"
	Set db = Client.OpenDatabase(sKBB_FileName) 
	If oSC.FieldExists(db, "SPALTE_2_BESCHLUSSFASSUNG_AM") Then oSC.RenField db, "SPALTE_2_BESCHLUSSFASSUNG_AM", "ZWEITE_BESCHLUSSFASSUNG_AM"
	If oSC.FieldExists(db, "SPALTE_2_BESCHLUSSFASSUNG_DURCH") Then oSC.RenField db, "SPALTE_2_BESCHLUSSFASSUNG_DURCH", "ZWEITE_BESCHLUSSFASSUNG_DURCH"
	If oSC.FieldExists(db, "MA_NAME_2_BESCHLUSSFASSUNG") Then oSC.RenField db, "MA_NAME_2_BESCHLUSSFASSUNG", "MA_NAME_ZWEITE_BESCHLUSSFASSUNG"
	db.Close 
	Set db = Nothing 
end function
' --------------------------------------------------------------------------

' function to change column types
Function SpecialPrep
Dim sBESCHLUSSFASSUNG_AM As String
Dim sBESCHLUSSFASSUNG_AM_OG As String
Dim sZWEITE_BESCHLUSSFASSUNG_AM As String
Dim sZWEITE_BESCHLUSSFASSUNG_AM_OG As String
Dim sGREMIUMSENTSCHEIDUNG_ERFASST_AM As String
Dim sGREMIUMSENTSCHEIDUNG_ERFASST_AM_OG As String

Dim sPERSON_ANGELEGT_AM As String
Dim sPERSON_ANGELEGT_AM_OG As String
Dim sERSTE_RATE_EREIGNISDAT_SCHUFAEINZEL As String
Dim sERSTE_RATE_EREIGNISDAT_SCHUFAEINZEL_OG As String
Dim sLETZTE_AKT_SCHUFAEINZELAUSKUN As String
Dim sLETZTE_AKT_SCHUFAEINZELAUSKUN_OG As String

Dim sEQN_DateColumn As String

sBESCHLUSSFASSUNG_AM = "BESCHLUSSFASSUNG_AM"
sBESCHLUSSFASSUNG_AM_OG = "BESCHLUSSFASSUNG_AM_OG"
sZWEITE_BESCHLUSSFASSUNG_AM = "ZWEITE_BESCHLUSSFASSUNG_AM"
sZWEITE_BESCHLUSSFASSUNG_AM_OG = "ZWEITE_BESCHLUSSFASSUNG_AM_OG"
sGREMIUMSENTSCHEIDUNG_ERFASST_AM = "GREMIUMSENTSCHEIDUNG_ERFASST_AM"
sGREMIUMSENTSCHEIDUNG_ERFASST_AM_OG = "GREMIUMSENTSCHEIDUNG_ERFASST_AM_OG"

sPERSON_ANGELEGT_AM = "PERSON_ANGELEGT_AM"
sPERSON_ANGELEGT_AM_OG = "PERSON_ANGELEGT_AM_OG"
sERSTE_RATE_EREIGNISDAT_SCHUFAEINZEL = "ERSTE_RATE_EREIGNISDATUM_SCHUFAEINZEL"
sERSTE_RATE_EREIGNISDAT_SCHUFAEINZEL_OG = "ERSTE_RATE_EREIGNISDATUM_SCHUFAEINZEL_OG"
sLETZTE_AKT_SCHUFAEINZELAUSKUN = "LETZTE_AKTUALISIERUNG_SCHUFAEINZELAUSKUN"
sLETZTE_AKT_SCHUFAEINZELAUSKUN_OG = "LETZTE_AKT_SCHUFAEINZELAUSKUN_OG"

SetCheckpoint "SpecialPrep 1.0 - check file names"
	if sKBB_FileName = "" or sSNM_FileName = "" then
		exit sub
	End If
SetCheckpoint "SpecialPrep 1.1 - create temp"
	Set db = Client.OpenDatabase(sKBB_FileName)
	Set task = db.Extraction
	task.IncludeAllFields
	sTemp_KBB_FileName = oSC.UniqueFileName(sWorkingFolderPath & "{Temp_Kreditbeschlussbuch}")
	task.AddExtraction sTemp_KBB_FileName, "", ""
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
SetCheckpoint "SpecialPrep 1.2 - create temp"
	Set db = Client.OpenDatabase(sSNM_FileName)
	Set task = db.Extraction
	task.IncludeAllFields
	sTemp_SNM_FileName = oSC.UniqueFileName(sWorkingFolderPath & "{Temp_Schufa Negativmerkmale}")
	task.AddExtraction sTemp_SNM_FileName, "", ""
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
SetCheckpoint "SpecialPrep 2.0 - change column names" & sKBB_FileName
	Set db = Client.OpenDatabase(sTemp_KBB_FileName) 
	Set sBESCHLUSSFASSUNG_AM_OG = oSC.RenField(db, sBESCHLUSSFASSUNG_AM, sBESCHLUSSFASSUNG_AM_OG, "")
	Set sZWEITE_BESCHLUSSFASSUNG_AM_OG = oSC.RenField(db, sZWEITE_BESCHLUSSFASSUNG_AM, sZWEITE_BESCHLUSSFASSUNG_AM_OG, "")
	Set sGREMIUMSENTSCHEIDUNG_ERFASST_AM_OG = oSC.RenField(db, sGREMIUMSENTSCHEIDUNG_ERFASST_AM, sGREMIUMSENTSCHEIDUNG_ERFASST_AM_OG, "")
	db.Close 
	Set db = Nothing
SetCheckpoint "SpecialPrep 2.0 - change column names" & sSNM_FileName
	Set db = Client.OpenDatabase(sTemp_SNM_FileName) 
	Set sPERSON_ANGELEGT_AM_OG = oSC.RenField(db, sPERSON_ANGELEGT_AM, sPERSON_ANGELEGT_AM_OG, "")
	Set sERSTE_RATE_EREIGNISDAT_SCHUFAEINZEL_OG = oSC.RenField(db, sERSTE_RATE_EREIGNISDAT_SCHUFAEINZEL, sERSTE_RATE_EREIGNISDAT_SCHUFAEINZEL_OG, "")
	Set sLETZTE_AKT_SCHUFAEINZELAUSKUN_OG = oSC.RenField(db, sLETZTE_AKT_SCHUFAEINZELAUSKUN, sLETZTE_AKT_SCHUFAEINZELAUSKUN_OG, "")
	db.Close 
	Set db = Nothing
SetCheckpoint "SpecialPrep 3.0 - change column names" & sSNM_FileName
	sEQN_DateColumn = "@compif(" & _
	"@match(@mid({0};3 ; 1); ""/""; ""-""; "".""); @ctod(@left({0}; 10); ""DD.MM.YYYY"");" & _
	"@match(@mid({0};5 ; 1); ""/""; ""-""; "".""); @ctod(@left({0}; 10); ""YYYY.MM.DD"");" & _
	"{0} = """"; @ctod(""0000.00.00""; ""YYYY.MM.DD"");" & _
	"1; @ctod(@left({0}; 8); ""YYYYMMDD"")) "
SetCheckpoint "SpecialPrep 3.1 - create new columns" & sKBB_FileName
	Set db = Client.OpenDatabase(sTemp_KBB_FileName)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = sBESCHLUSSFASSUNG_AM
	field.Description = "Hinzugefügtes Feld"
	field.Type = WI_VIRT_DATE
	field.Equation = oSC.FormatString(sEQN_DateColumn, sBESCHLUSSFASSUNG_AM_OG)
	task.AppendField field
	task.PerformTask
	
	field.Name = sZWEITE_BESCHLUSSFASSUNG_AM
	field.Description = "Hinzugefügtes Feld"
	field.Type = WI_VIRT_DATE
	field.Equation = oSC.FormatString(sEQN_DateColumn, sZWEITE_BESCHLUSSFASSUNG_AM_OG)
	task.AppendField field
	task.PerformTask
	
	field.Name = sGREMIUMSENTSCHEIDUNG_ERFASST_AM
	field.Description = "Hinzugefügtes Feld"
	field.Type = WI_VIRT_DATE
	field.Equation = oSC.FormatString(sEQN_DateColumn, sGREMIUMSENTSCHEIDUNG_ERFASST_AM_OG)
	task.AppendField field
	task.PerformTask
	db.close
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
SetCheckpoint "SpecialPrep 3.2 - create new columns" & sSNM_FileName
	Set db = Client.OpenDatabase(sTemp_SNM_FileName)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = sPERSON_ANGELEGT_AM
	field.Description = "Hinzugefügtes Feld"
	field.Type = WI_VIRT_DATE
	field.Equation = oSC.FormatString(sEQN_DateColumn, sPERSON_ANGELEGT_AM_OG)
	task.AppendField field
	task.PerformTask
	
	field.Name = sERSTE_RATE_EREIGNISDAT_SCHUFAEINZEL
	field.Description = "Hinzugefügtes Feld"
	field.Type = WI_VIRT_DATE
	field.Equation = oSC.FormatString(sEQN_DateColumn, sERSTE_RATE_EREIGNISDAT_SCHUFAEINZEL_OG)
	task.AppendField field
	task.PerformTask
	
	field.Name = sLETZTE_AKT_SCHUFAEINZELAUSKUN
	field.Description = "Hinzugefügtes Feld"
	field.Type = WI_VIRT_DATE
	field.Equation = oSC.FormatString(sEQN_DateColumn, sLETZTE_AKT_SCHUFAEINZELAUSKUN_OG)
	task.AppendField field
	task.PerformTask
	db.close
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
end function
' --------------------------------------------------------------------------

' preparation
Function PreparationKRM
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
SetCheckpoint "Preparation 1.2 - add numerical values for vr rating enga" ' 02.08.2023
	field.Name = "VR_RATING_ENGA_NUM"
	field.Description = "VR_Rating Enga in Numerischer Form."
	field.Type = WI_NUM_FIELD
	sEQNRating = "@compif(" & _
	"VR_RATING_ENGA=""0a"";1;" & _
	"VR_RATING_ENGA=""0b"";2;" & _
	"VR_RATING_ENGA=""0c"";3;" & _
	"VR_RATING_ENGA=""0d"";4;" & _
	"VR_RATING_ENGA=""0e"";5;" & _
	"VR_RATING_ENGA=""1a"";6;" & _
	"VR_RATING_ENGA=""1b"";7;" & _
	"VR_RATING_ENGA=""1c"";8;" & _
	"VR_RATING_ENGA=""1d"";9;" & _
	"VR_RATING_ENGA=""1e"";10;" & _
	"VR_RATING_ENGA=""2a"";11;" & _
	"VR_RATING_ENGA=""2b"";12;" & _
	"VR_RATING_ENGA=""2c"";13;" & _
	"VR_RATING_ENGA=""2d"";14;" & _
	"VR_RATING_ENGA=""2e"";15;" & _
	"VR_RATING_ENGA=""3a"";16;" & _
	"VR_RATING_ENGA=""3b"";17;" & _
	"VR_RATING_ENGA=""3c"";18;" & _
	"VR_RATING_ENGA=""3d"";19;" & _
	"VR_RATING_ENGA=""3e"";20;" & _
	"VR_RATING_ENGA=""4a"";21;" & _
	"VR_RATING_ENGA=""4b"";22;" & _
	"VR_RATING_ENGA=""4c"";23;" & _
	"VR_RATING_ENGA=""4d"";24;" & _
	"VR_RATING_ENGA=""4e"";25;" & _
	"1;99)"
	field.Equation = sEQNRating
	field.Decimals = 0
	task.AppendField field
	task.PerformTask
If bUseIdividualRiskRelevance Then
SetCheckpoint "Preparation 1.2 - individual rr" ' 14.02.2023
Dim sEQNRR As String
Dim sNum_Rating As String
	sNum_Rating = getIndex(aRatingGrades(), sRiskRating)
	field.Name = "RISIKOKENNZEICHEN_INDIV"
	field.Description = "individuelle Risikorelevanzegrenze"
	field.Type = WI_CHAR_FIELD
	sEQNRR = "@if("
	If bBoni Then sEQNRR = sEQNRR & "@Val(BONITÄTSEINSTUFUNG) >= " & sBoni & sJoinTypeIDEA
	If bRiskRating Then sEQNRR = sEQNRR & "VR_RATING_NUM >= " & sNum_Rating & sJoinTypeIDEA
	If bRiskVolume Then sEQNRR = sEQNRR & "GK_ENGA_RV_EUR >= " & sRiskVolume & sJoinTypeIDEA '1.500.000,01
	If bBlankVolume Then sEQNRR = sEQNRR & "GK_ENGA_BVRV_EUR >= " & sBlankVolume & sJoinTypeIDEA '750.000,01 mit oder verknüpft
	if bOverdraft then sEQNRR = sEQNRR & "GK_ENGA_ÜBERZ_EUR >= " & sOverdraft
	If Right(sEQNRR, 4) = ".OR." Then sEQNRR = Left(sEQNRR, Len(sEQNRR) - 4)
	If Right(sEQNRR, 5) = ".AND." Then sEQNRR = Left(sEQNRR, Len(sEQNRR) - 5)
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

' preparation KGW
' it is nessecary to execute the KRW preparation beforhand
Function PreparationKGW
SetCheckpoint "Preparation 0.0 - Datum Datenabzug"
	Set db = Client.OpenDatabase(sTemp_KBB_FileName)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "DATUM_DATENABZUG"
	field.Description = "Datum aus Eingabedialog"
	field.Type = WI_DATE_FIELD
	field.Equation = "@ctod(""" & sDataExportDate & """;""YYYY/MM/DD"")"
	task.AppendField field
	task.PerformTask
	db.Close
	Set db = nothing
	Set task = nothing
	Set field = nothing
SetCheckpoint "Preparation 1.0 - KBB PERSONENNUMMER"
	Set db = Client.OpenDatabase(sTemp_KBB_FileName)
	Set task = db.Extraction
	task.AddFieldToInc "DATUM_DATENABZUG" ' 04.10.2023
	task.AddFieldToInc "BESCHLUSSNUMMER_JAHR"
	task.AddFieldToInc "BESCHLUSSFASSUNG_AM"
	task.AddFieldToInc "BESCHLUSSFASSUNG_DURCH"
	task.AddFieldToInc "MA_NAME_BESCHLUSSFASSUNG_DURCH"
	task.AddFieldToInc "ZWEITE_BESCHLUSSFASSUNG_AM"
	task.AddFieldToInc "ZWEITE_BESCHLUSSFASSUNG_DURCH"
	task.AddFieldToInc "MA_NAME_ZWEITE_BESCHLUSSFASSUNG"
	task.AddFieldToInc "GREMIUMSENTSCHEIDUNG_ERFASST_AM"
	task.AddFieldToInc "GREMIUMSENTSCHEIDUNG_ERFASST_DURCH"
	task.AddFieldToInc "MA_NAME_GREMIUMSENTSCHEIDUNG_DURCH"
	task.AddFieldToInc "KREDIT_BISHER"
	task.AddFieldToInc "KREDITE_GESAMT_NEU"
	task.AddFieldToInc "PERSONENNUMMER"
	task.AddFieldToInc "EINHEITEN_NR"
	task.AddFieldToInc "RISIKOSTATUS_MARISK"
	task.AddFieldToInc "RISIKORELEVANZ_MARISK"
	task.AddFieldToInc "BESCHLUSSNUMMER_NR_BEREICH"
	task.AddFieldToInc "BESCHLUSSNUMMER_LFD_NR"
	task.AddFieldToInc "BLANKOANTEIL"
	task.AddFieldToInc "SICHERUNGSWERT"
	task.AddFieldToInc "LIQUIDITÄTSERGEBNIS"
	task.AddFieldToInc "ÜBERZIEHUNG"
	task.AddFieldToInc "EWB_BETRAG"
	task.AddFieldToInc "RATINGKLASSE"
	task.AddFieldToInc "ENTSCHEIDUNGSEMPFEHLUNG"
	task.AddFieldToInc "NUMMER"
	sTemp_KBB_PERSNR = oSC.UniqueFileName(sWorkingFolderPath & "{Kreditbeschlussbuch_PERSONENNUMMER}")
	task.AddExtraction sTemp_KBB_PERSNR, "", "PERSONENNUMMER <> """""
	task.DisableProgressNotification = True
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
SetCheckpoint "Preparation 1.1 - KBB PERSONENNUMMER new field"
	Set db = Client.OpenDatabase(sTemp_KBB_PERSNR)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "HERKUNFT"
	field.Description = "Gibt an, ob es sich bei diesem Kreditbeschluss um einen Kreditbeschluss für eine Person (Pers) oder ein Engagement (Enga) handelt."
	field.Type = WI_CHAR_FIELD
	field.Equation = """PERS"""
	field.Length = 4
	task.AppendField field
	task.DisableProgressNotification = True
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
SetCheckpoint "Preparation 2.0 - KBB EINHEITEN_NR"
	Set db = Client.OpenDatabase(sTemp_KBB_FileName)
	Set task = db.Extraction
	task.AddFieldToInc "DATUM_DATENABZUG" ' 04.10.2023
	task.AddFieldToInc "BESCHLUSSNUMMER_JAHR"
	task.AddFieldToInc "BESCHLUSSFASSUNG_AM"
	task.AddFieldToInc "BESCHLUSSFASSUNG_DURCH"
	task.AddFieldToInc "MA_NAME_BESCHLUSSFASSUNG_DURCH"
	task.AddFieldToInc "ZWEITE_BESCHLUSSFASSUNG_AM"
	task.AddFieldToInc "ZWEITE_BESCHLUSSFASSUNG_DURCH"
	task.AddFieldToInc "MA_NAME_ZWEITE_BESCHLUSSFASSUNG"
	task.AddFieldToInc "GREMIUMSENTSCHEIDUNG_ERFASST_AM"
	task.AddFieldToInc "GREMIUMSENTSCHEIDUNG_ERFASST_DURCH"
	task.AddFieldToInc "MA_NAME_GREMIUMSENTSCHEIDUNG_DURCH"
	task.AddFieldToInc "KREDIT_BISHER"
	task.AddFieldToInc "KREDITE_GESAMT_NEU"
	task.AddFieldToInc "PERSONENNUMMER"
	task.AddFieldToInc "EINHEITEN_NR"
	task.AddFieldToInc "RISIKOSTATUS_MARISK"
	task.AddFieldToInc "RISIKORELEVANZ_MARISK"
	task.AddFieldToInc "BESCHLUSSNUMMER_NR_BEREICH"
	task.AddFieldToInc "BESCHLUSSNUMMER_LFD_NR"
	task.AddFieldToInc "BLANKOANTEIL"
	task.AddFieldToInc "SICHERUNGSWERT"
	task.AddFieldToInc "LIQUIDITÄTSERGEBNIS"
	task.AddFieldToInc "ÜBERZIEHUNG"
	task.AddFieldToInc "EWB_BETRAG"
	task.AddFieldToInc "RATINGKLASSE"
	task.AddFieldToInc "ENTSCHEIDUNGSEMPFEHLUNG"
	task.AddFieldToInc "NUMMER"
	sTemp_KBB_EINHNR = oSC.UniqueFileName(sWorkingFolderPath & "{Kreditbeschlussbuch_EINHEITEN_NR}")
	task.AddExtraction sTemp_KBB_EINHNR, "", "EINHEITEN_NR <> """""
	task.DisableProgressNotification = True
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
SetCheckpoint "Preparation 2.1 - KBB EINHEITEN_NR new field"
	Set db = Client.OpenDatabase(sTemp_KBB_EINHNR)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "HERKUNFT"
	field.Description = "Gibt an, ob es sich bei diesem Kreditbeschluss um einen Kreditbeschluss für eine Person (Pers) oder ein Engagement (Enga) handelt."
	field.Type = WI_CHAR_FIELD
	field.Equation = """Enga"""
	field.Length = 4
	task.AppendField field
	task.DisableProgressNotification = True
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
SetCheckpoint "Preparation 3.0 - join KBB with KRM - PERS"
	Set db = Client.OpenDatabase(sTemp_KBB_PERSNR)
	Set task = db.JoinDatabase
	task.FileToJoin sKRM_FinalFileName
	task.IncludeAllPFields
	task.AddSFieldToInc "ENGAGEMENTBEZ"
	task.AddSFieldToInc "KUNDENNAME"
	task.AddSFieldToInc "RISIKOGRUPPE_ENGA"
	task.AddSFieldToInc "BONITÄTSEINST_ENGA"
	task.AddSFieldToInc "VR_RATINGART_ENGA"
	task.AddSFieldToInc "VR_RATING_ENGA"
	task.AddSFieldToInc "VR_RATING_ENGA_NUM" ' 02.08.2023
	If bExist_AUSFALLRATE_ENGA Then 
		task.AddSFieldToInc "AUSFALLRATE_ENGA"
	End If
	task.AddSFieldToInc "GK_ENGA_RV_EUR"
	task.AddSFieldToInc "GK_ENGA_EA_EUR"
	task.AddSFieldToInc "GK_ENGA_BVRV_EUR"
	task.AddSFieldToInc "GK_ENGA_BVIA_EUR"
	task.AddSFieldToInc "KUNDE_SEIT_DATUM"
	task.AddSFieldToInc "GEB_GRÜND_DATUM"
	task.AddSFieldToInc "ÜBERZ_ENG_BASEL_EUR"
	task.AddSFieldToInc "TAGE_ÜBERZ_ENG_BASEL"
	task.AddSFieldToInc "GK_ENGA_ÜBERZ_EUR"
	task.AddSFieldToInc "TAGE_ÜBERZ_ENGA"
	task.AddMatchKey "PERSONENNUMMER", "KUNDENNUMMER", "A"
	sTemp_KBB_KRM_KUNDE = oSC.UniqueFileName(sWorkingFolderPath & "{KBB_KRM_KUNDE}")
	task.DisableProgressNotification = True
	task.PerformTask sTemp_KBB_KRM_KUNDE, "", WI_JOIN_ALL_IN_PRIM
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	Call AddFileToFilesToDelete(sTemp_KBB_PERSNR)
SetCheckpoint "Preparation 3.1 - join KBB with KRM - ENGAGEMENT"
	Set db = Client.OpenDatabase(sTemp_KBB_EINHNR)
	Set task = db.JoinDatabase
	task.FileToJoin sKRM_FinalFileName
	task.IncludeAllPFields
	task.AddSFieldToInc "ENGAGEMENTBEZ"
	task.AddSFieldToInc "KUNDENNAME"
	task.AddSFieldToInc "RISIKOGRUPPE_ENGA"
	task.AddSFieldToInc "BONITÄTSEINST_ENGA"
	task.AddSFieldToInc "VR_RATINGART_ENGA"
	task.AddSFieldToInc "VR_RATING_ENGA"
	task.AddSFieldToInc "VR_RATING_ENGA_NUM" ' 02.08.2023
	If bExist_AUSFALLRATE_ENGA Then 
		task.AddSFieldToInc "AUSFALLRATE_ENGA"
	End If
	task.AddSFieldToInc "GK_ENGA_RV_EUR"
	task.AddSFieldToInc "GK_ENGA_EA_EUR"
	task.AddSFieldToInc "GK_ENGA_BVRV_EUR"
	task.AddSFieldToInc "GK_ENGA_BVIA_EUR"
	task.AddSFieldToInc "KUNDE_SEIT_DATUM"
	task.AddSFieldToInc "GEB_GRÜND_DATUM"
	task.AddSFieldToInc "ÜBERZ_ENG_BASEL_EUR"
	task.AddSFieldToInc "TAGE_ÜBERZ_ENG_BASEL"
	task.AddSFieldToInc "GK_ENGA_ÜBERZ_EUR"
	task.AddSFieldToInc "TAGE_ÜBERZ_ENGA"
	task.AddSFieldToInc "GEWERBLICH_PRIVAT"
	task.AddMatchKey "EINHEITEN_NR", "NETTO_ENGAGEMENT", "A"
	sTemp_KBB_KRM_ENGAGEMENT = oSC.UniqueFileName(sWorkingFolderPath & "{KBB_KRM_ENGA}")
	task.DisableProgressNotification = True
	task.PerformTask sTemp_KBB_KRM_ENGAGEMENT, "", WI_JOIN_ALL_IN_PRIM
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	Call AddFileToFilesToDelete(sTemp_KBB_EINHNR)
SetCheckpoint "Preparation 4.0 - append KBB_KRM files"
	Set db = Client.OpenDatabase(sTemp_KBB_KRM_KUNDE)
	Set task = db.AppendDatabase
	task.AddDatabase sTemp_KBB_KRM_ENGAGEMENT
	sTemp_KBB_KRM_GESAMT = oSC.UniqueFileName(sWorkingFolderPath & "{KBB_KRM_GESAMT}")
	task.DisableProgressNotification = True
	task.PerformTask sTemp_KBB_KRM_GESAMT, ""
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	Call AddFileToFilesToDelete(sTemp_KBB_KRM_KUNDE)
	Call AddFileToFilesToDelete(sTemp_KBB_KRM_ENGAGEMENT)
SetCheckpoint "Preparation 5.0 - create SCHUFA overview"
	Set db = Client.OpenDatabase(sTemp_SNM_FileName)
	Set task = db.Summarization
	task.AddFieldToSummarize "PERSONENNUMMER"
	task.AddFieldToSummarize "SCHUFAMERKMAL_SCHUFAEINZELAUSKUNFT"
	task.AddFieldToSummarize "SCHUFAMERKMAL_BEZEICHNUNG_SCHUFAEINZELAU"
	sSNM_OVERVIEW_FinalFileName = oSC.UniqueFileName(sWorkingFolderPath & "SCHUFA Übersicht Kunden mit Merkmalen")
	task.OutputDBName = sSNM_OVERVIEW_FinalFileName
	task.CreatePercentField = FALSE
	task.DisableProgressNotification = True
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
SetCheckpoint "Preparation 5.1 - create SCHUFA criteria per costumer"
	Set db = Client.OpenDatabase(sSNM_OVERVIEW_FinalFileName)
	Set task = db.Summarization
	task.AddFieldToSummarize "PERSONENNUMMER"
	sTemp_SNM_SCHUFA_Criteria_Count = oSC.UniqueFileName(sWorkingFolderPath & "{Anzahl SCHUFA Merkmale pro Kunde}")
	task.OutputDBName = sTemp_SNM_SCHUFA_Criteria_Count
	task.CreatePercentField = FALSE
	task.DisableProgressNotification = True
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
SetCheckpoint "Preparation 6.0 - join KBB_KRM and SCHUFA"
	Set db = Client.OpenDatabase(sTemp_KBB_KRM_GESAMT)
	Set task = db.JoinDatabase
	task.FileToJoin sTemp_SNM_SCHUFA_Criteria_Count
	task.IncludeAllPFields
	task.AddSFieldToInc "ANZ_SAETZE1"
	task.AddMatchKey "PERSONENNUMMER", "PERSONENNUMMER", "A"
	sKBB_FinalFileName = oSC.UniqueFileName(sWorkingFolderPath & "Kreditbeschlussbuch")
	task.DisableProgressNotification = True
	task.PerformTask sKBB_FinalFileName, "", WI_JOIN_ALL_IN_PRIM
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	Call AddFileToFilesToDelete(sTemp_SNM_SCHUFA_Criteria_Count)
SetCheckpoint "Preparation 6.1 - rename columns"
	Set db = Client.OpenDatabase(sKBB_FinalFileName)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "ANZ_SCHUFA_MERKM"
	field.Description = "Anzahl der unterschiedlichen SCHUFA Merkmale, die ein Kunde aufweist"
	field.Type = WI_NUM_FIELD
	field.Equation = ""
	field.Decimals = 0
	task.ReplaceField "ANZ_SAETZE1", field
	task.DisableProgressNotification = True
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
end function
' --------------------------------------------------------------------------

Function PreparationKRMExtra
SetCheckpoint "Preparation 6.0 - join KBB_KRM and SCHUFA"
	Set db = Client.OpenDatabase(sKRM_FinalFileName)
	Set task = db.JoinDatabase
	task.FileToJoin sTemp_SNM_SCHUFA_Criteria_Count
	task.IncludeAllPFields
	task.AddSFieldToInc "ANZ_SAETZE1"
	task.AddMatchKey "KUNDENNUMMER", "PERSONENNUMMER", "A"
	sKRM_FinalFileName_Temp = oSC.UniqueFileName(sWorkingFolderPath & "KRM mit SCHUFA Merkmale.IMD")
	task.DisableProgressNotification = True
	task.PerformTask sKRM_FinalFileName_Temp, "", WI_JOIN_ALL_IN_PRIM
	db.Close
	Set task = Nothing
	Set db = Nothing

SetCheckpoint "Preparation 6.1 - rename columns"
	Set db = Client.OpenDatabase(sKRM_FinalFileName_Temp)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = "ANZ_SCHUFA_MERKM"
	field.Description = "Anzahl der unterschiedlichen SCHUFA Merkmale, die ein Kunde aufweist"
	field.Type = WI_NUM_FIELD
	field.Equation = ""
	field.Decimals = 0
	task.ReplaceField "ANZ_SAETZE1", field
	task.DisableProgressNotification = True
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
	
	Set task = Client.ProjectManagement
	' Namen der Datei ändern.
	task.RenameDatabase sKRM_FinalFileName_Temp, sKRM_FinalFileName
	Set task = Nothing
	
	'Open the database.
	Set db = Client.OpenDatabase(sKRM_FinalFileName)
	'Remove the action field from field "ANZ_SCHUFA_MERKM"
	oSC.RemoveActionField db, "ANZ_SCHUFA_MERKM"
	'Close the database.
	db.Close
	Set db = Nothing
	
'	Set db = Client.OpenDatabase(sSNM_OVERVIEW_FinalFileName)
'	Set task = db.TableManagement
'	Set field = db.TableDef.NewField
'	field.Name = "KUNDENNUMMER" 
'	field.Description = ""
'	field.Type = WI_CHAR_FIELD
'	field.Equation = ""
'	field.Length = 8
'	task.ReplaceField "PERSONENNUMMER", field
'	
'	task.PerformTask
'	db.Close
'	Set task = Nothing
'	Set db = Nothing
'	Set field = Nothing
'	
'	
'	Set db = Client.OpenDatabase(sKRM_FinalFileName)
'	oSC.CreateActionField db, "ANZ_SCHUFA_MERKM", sSNM_OVERVIEW_FinalFileName, "KUNDENNUMMER"
'	'Close the database
'	db.close
'	Set db =Nothing
	
End Function

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
		Case sKRM_FinalFileName
			Set helper = oTM.AssociatingTagging(sResultFile)
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
			helper.SetTag "acc!BONITAETSEINSTUFUNG", "BONITÄTSEINSTUFUNG"
			helper.SetTag "acc!BONITAETSEINST_ENGA", "BONITÄTSEINST_ENGA"
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
			helper.SetTag "acc!BUERG_OEFF_BANKEN_RV_EUR", "BÜRG_ÖFF_BANKEN_RV_EUR"
			helper.SetTag "acc!BUERG_OEFF_BANKEN_IA_EUR", "BÜRG_ÖFF_BANKEN_IA_EUR"
			helper.SetTag "acc!SONST_BUERG_RV_EUR", "SONST_BÜRG_RV_EUR"
			helper.SetTag "acc!SONST_BUERG_IA_EUR", "SONST_BÜRG_IA_EUR"
			helper.SetTag "acc!SICHERH_UEBEREIG_RV_EUR", "SICHERH_ÜBEREIG_RV_EUR"
			helper.SetTag "acc!SICHERH_UEBEREIG_IA_EUR", "SICHERH_ÜBEREIG_IA_EUR"
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
			helper.SetTag "acc!KPM_BERUECKS_KD_RS", "KPM_BERÜCKS_KD_RS"
			helper.SetTag "acc!KONTOWAEHRUNG", "KONTOWÄHRUNG"
			helper.SetTag "acc!LAENDERSCHLUESSEL", "LÄNDERSCHLÜSSEL"
			helper.SetTag "acc!KUNDE_SEIT_DATUM", "KUNDE_SEIT_DATUM"
			helper.SetTag "acc!GEB_GRUEND_DATUM", "GEB_GRÜND_DATUM"
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
			helper.SetTag "acc!KUNDEN_EIGENGESCHAEFT", "KUNDEN_EIGENGESCHÄFT"
			helper.SetTag "acc!UEBERZIEHUNG_KTO_EUR", "ÜBERZIEHUNG_KTO_EUR"
			helper.SetTag "acc!TAGE_UEBERZ_KTO", "TAGE_ÜBERZ_KTO"
			helper.SetTag "acc!UEBERZ_KD_BASEL_EUR", "ÜBERZ_KD_BASEL_EUR"
			helper.SetTag "acc!TAGE_UEBERZ_KD_BASEL", "TAGE_ÜBERZ_KD_BASEL"
			helper.SetTag "acc!GK_KD_UEBERZ_EUR", "GK_KD_ÜBERZ_EUR"
			helper.SetTag "acc!TAGE_UEBERZ_KUNDE", "TAGE_ÜBERZ_KUNDE"
			helper.SetTag "acc!UEBERZ_ENG_BASEL_EUR", "ÜBERZ_ENG_BASEL_EUR"
			helper.SetTag "acc!TAGE_UEBERZ_ENG_BASEL", "TAGE_ÜBERZ_ENG_BASEL"
			helper.SetTag "acc!GK_ENGA_UEBERZ_EUR", "GK_ENGA_ÜBERZ_EUR"
			helper.SetTag "acc!TAGE_UEBERZ_ENGA", "TAGE_ÜBERZ_ENGA"
			helper.SetTag "acc!JAHRESABSCHLUSSDATUM", "JAHRESABSCHLUSSDATUM"
			helper.SetTag "acc!DATUM_KTO_EROEFF_SCHL", "DATUM_KTO_ERÖFF_SCHL"
			helper.SetTag "acc!DATUM_LTZ_RISIKOKZ", "DATUM_LTZ_RISIKOKZ"
			helper.SetTag "acc!VR_RATING_NUM", "VR_RATING_NUM" ' 13.02.2023
			helper.SetTag "acc!VR_RATING_ENGA_NUM", "VR_RATING_ENGA_NUM" ' 05.06.2024
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
			'Set filter = eqnBuilder.GetStandardTestFilter("MP_KRM")
			'helper.AssociatePrimary filter
		Case sKBB_FinalFileName
			Set helper = oTM.AssociatingTagging(sResultFile)
			helper.SetTag "acc!DATUM_DATENABZUG", "DATUM_DATENABZUG" ' 04.10.2023
			helper.SetTag "acc!BESCHLUSSFASSUNG_AM", "BESCHLUSSFASSUNG_AM"
			helper.SetTag "acc!BESCHLUSSFASSUNG_DURCH", "BESCHLUSSFASSUNG_DURCH"
			helper.SetTag "acc!MA_NAME_BESCHLUSSFASSUNG_DURCH", "MA_NAME_BESCHLUSSFASSUNG_DURCH"
			helper.SetTag "acc!ZWEITE_BESCHLUSSFASSUNG_AM", "ZWEITE_BESCHLUSSFASSUNG_AM"
			helper.SetTag "acc!ZWEITE_BESCHLUSSFASSUNG_DURCH", "ZWEITE_BESCHLUSSFASSUNG_DURCH"
			helper.SetTag "acc!MA_NAME_ZWEITE_BESCHLUSSFASSUNG", "MA_NAME_ZWEITE_BESCHLUSSFASSUNG"
			helper.SetTag "acc!GREMIUMSENTSCHEIDUNG_ERFASST_AM", "GREMIUMSENTSCHEIDUNG_ERFASST_AM"
			helper.SetTag "acc!GREMIUMSENTSCHEIDUNG_ERFASST_DURCH", "GREMIUMSENTSCHEIDUNG_ERFASST_DURCH"
			helper.SetTag "acc!MA_NAME_GREMIUMSENTSCHEIDUNG_DURCH", "MA_NAME_GREMIUMSENTSCHEIDUNG_DURCH"
			helper.SetTag "acc!KREDIT_BISHER", "KREDIT_BISHER"
			helper.SetTag "acc!KREDITE_GESAMT_NEU", "KREDITE_GESAMT_NEU"
			helper.SetTag "acc!PERSONENNUMMER", "PERSONENNUMMER"
			helper.SetTag "acc!EINHEITEN_NR", "EINHEITEN_NR"
			helper.SetTag "acc!RISIKOSTATUS_MARISK", "RISIKOSTATUS_MARISK"
			helper.SetTag "acc!RISIKORELEVANZ_MARISK", "RISIKORELEVANZ_MARISK"
			helper.SetTag "acc!BESCHLUSSNUMMER_NR_BEREICH", "BESCHLUSSNUMMER_NR_BEREICH"
			helper.SetTag "acc!BESCHLUSSNUMMER_LFD_NR", "BESCHLUSSNUMMER_LFD_NR"
			helper.SetTag "acc!BLANKOANTEIL", "BLANKOANTEIL"
			helper.SetTag "acc!SICHERUNGSWERT", "SICHERUNGSWERT"
			helper.SetTag "acc!LIQUIDITAETSERGEBNIS", "LIQUIDITÄTSERGEBNIS"
			helper.SetTag "acc!UEBERZIEHUNG", "ÜBERZIEHUNG"
			helper.SetTag "acc!EWB_BETRAG", "EWB_BETRAG"
			helper.SetTag "acc!RATINGKLASSE", "RATINGKLASSE"
			helper.SetTag "acc!ENTSCHEIDUNGSEMPFEHLUNG", "ENTSCHEIDUNGSEMPFEHLUNG"
			helper.SetTag "acc!NUMMER", "NUMMER"
			helper.SetTag "acc!HERKUNFT", "HERKUNFT"
			'helper.SetTag "acc!KUNDENNUMMER", "KUNDENNUMMER"
			'helper.SetTag "acc!ANZ_SAETZE", "ANZ_SAETZE"
			helper.SetTag "acc!KUNDENNAME", "KUNDENNAME"
			'helper.SetTag "acc!NETTO_ENGAGEMENT", "NETTO_ENGAGEMENT"
			'helper.SetTag "acc!KUNDENGRUPPEN_NR", "KUNDENGRUPPEN_NR"
			helper.SetTag "acc!ENGAGEMENTBEZ", "ENGAGEMENTBEZ"
			helper.SetTag "acc!RISIKOGRUPPE_ENGA", "RISIKOGRUPPE_ENGA"
			helper.SetTag "acc!BONITAETSEINST_ENGA", "BONITÄTSEINST_ENGA"
			helper.SetTag "acc!VR_RATINGART_ENGA", "VR_RATINGART_ENGA"
			helper.SetTag "acc!VR_RATING_ENGA", "VR_RATING_ENGA"
			helper.SetTag "acc!VR_RATING_ENGA_NUM", "VR_RATING_ENGA_NUM" ' 02.08.2023
			'helper.SetTag "acc!VR_RATING_ENGA1", "VR_RATING_ENGA1"
			if bExist_AUSFALLRATE_ENGA then
				helper.SetTag "acc!AUSFALLRATE_ENGA", "AUSFALLRATE_ENGA"
			end if
			'helper.SetTag "acc!DATUM_LTZ_RATING", "DATUM_LTZ_RATING"
			helper.SetTag "acc!GK_ENGA_RV_EUR", "GK_ENGA_RV_EUR"
			helper.SetTag "acc!GK_ENGA_EA_EUR", "GK_ENGA_EA_EUR"
			helper.SetTag "acc!GK_ENGA_BVRV_EUR", "GK_ENGA_BVRV_EUR"
			helper.SetTag "acc!GK_ENGA_BVIA_EUR", "GK_ENGA_BVIA_EUR"
			'helper.SetTag "acc!GK_KD_RV_EUR", "GK_KD_RV_EUR"
			'helper.SetTag "acc!GK_KD_EA_EUR", "GK_KD_EA_EUR"
			'helper.SetTag "acc!GK_KD_BVRV_EUR", "GK_KD_BVRV_EUR"
			'helper.SetTag "acc!GK_KD_BVIA_EUR", "GK_KD_BVIA_EUR"
			'helper.SetTag "acc!GK_KD_NTOBVRV_EUR", "GK_KD_NTOBVRV_EUR"
			'helper.SetTag "acc!BERATER", "BERATER"
			'helper.SetTag "acc!GEWERBLICH_PRIVAT", "GEWERBLICH_PRIVAT"
			'helper.SetTag "acc!RECHTSFORM", "RECHTSFORM"
			'helper.SetTag "acc!BRANCHE", "BRANCHE"
			'helper.SetTag "acc!KPM_BRANCHE", "KPM_BRANCHE"
			'helper.SetTag "acc!KPM_BERUECKS_KD_RS", "KPM_BERÜCKS_KD_RS"
			helper.SetTag "acc!KUNDE_SEIT_DATUM", "KUNDE_SEIT_DATUM"
			helper.SetTag "acc!GEB_GRUEND_DATUM", "GEB_GRÜND_DATUM"
			'helper.SetTag "acc!RISIKOSTATUS_MAK", "RISIKOSTATUS_MAK"
			'if bUseIdividualRiskRelevance then
			'	helper.SetTag "acc!RISIKOKENNZEICHEN", "RISIKOKENNZEICHEN_INDIV"
			'else
			'	helper.SetTag "acc!RISIKOKENNZEICHEN", "RISIKOKENNZEICHEN"
			'end if
			'helper.SetTag "acc!KUNDEN_EIGENGESCHAEFT", "KUNDEN_EIGENGESCHÄFT"
			'helper.SetTag "acc!UEBERZ_KD_BASEL_EUR", "ÜBERZ_KD_BASEL_EUR"
			'helper.SetTag "acc!TAGE_UEBERZ_KD_BASEL", "TAGE_ÜBERZ_KD_BASEL"
			'helper.SetTag "acc!GK_KD_UEBERZ_EUR", "GK_KD_ÜBERZ_EUR"
			'helper.SetTag "acc!TAGE_UEBERZ_KUNDE", "TAGE_ÜBERZ_KUNDE"
			helper.SetTag "acc!UEBERZ_ENG_BASEL_EUR", "ÜBERZ_ENG_BASEL_EUR"
			helper.SetTag "acc!TAGE_UEBERZ_ENG_BASEL", "TAGE_ÜBERZ_ENG_BASEL"
			helper.SetTag "acc!GK_ENGA_UEBERZ_EUR", "GK_ENGA_ÜBERZ_EUR"
			helper.SetTag "acc!TAGE_UEBERZ_ENGA", "TAGE_ÜBERZ_ENGA"
			helper.SetTag "acc!GEWERBLICH_PRIVAT", "GEWERBLICH_PRIVAT"
			'helper.SetTag "acc!DATUM_LTZ_RISIKOKZ", "DATUM_LTZ_RISIKOKZ"
			helper.SetTag "acc!ANZ_SCHUFA_MERKM", "ANZ_SCHUFA_MERKM"
			helper.Save
			
			Set oList = oSC.CreateResultObject(sResultFile, iResultType, True, 1)
			SmartContext.TestResultFiles.Add oList
			oList.ExtraValues.Add "MappedTestIds", eqnBuilder.GetStandardTestFilter("KGW")
			
			'Set mppTask = mppTaskFactory.NewRegisterTableForMppTask
			'mppTask.TableName = oList.Name
			'mppTask.ResultId = "KGW"
			'mppTask.ResultName = "Kreditbeschlussbuch" ' Name der erstellten IDEA Tabelle
			'mppTask.ResultDisplayName = "Kreditbeschlussbuch" ' Gruppenname im Workflowschritt Mehrperiodenaufbereitung
			'SmartContext.TestResultFiles.Add oList
			'mppTask.AuditTestsFilter = eqnBuilder.GetStandardTestFilter("MP_KGW") ' ContentAreaName
			'mppTask.PerformTask
			'Set mppTask = Nothing
			
			'Set filter = eqnBuilder.GetStandardTestFilter("MP_KGW")
			'helper.AssociateSecondary filter, "KBB_MP"
		Case sSNM_OVERVIEW_FinalFileName
			Set helper = oTM.AssociatingTagging(sResultFile)
			'helper.SetTag "acc!DATUM_DATENABZUG", "DATUM_DATENABZUG"
			helper.Save
			
			Set oList = oSC.CreateResultObject(sResultFile, iResultType, True, 1)
			SmartContext.TestResultFiles.Add oList
			oList.ExtraValues.Add "MappedTestIds", eqnBuilder.GetStandardTestFilter("KGW_SCHUFA")
			
			'Set mppTask = mppTaskFactory.NewRegisterTableForMppTask
			'mppTask.TableName = oList.Name
			'mppTask.ResultId = "KGW_SCHUFA"
			'mppTask.ResultName = "SCHUFA Übersicht Kunden mit Merkmalen" ' Name der erstellten IDEA Tabelle
			'mppTask.ResultDisplayName = "SCHUFA Übersicht Kunden mit Merkmalen" ' Gruppenname im Workflowschritt Mehrperiodenaufbereitung
			'SmartContext.TestResultFiles.Add oList
			'mppTask.AuditTestsFilter = eqnBuilder.GetStandardTestFilter("MP_KGW_SCHUFA") ' ContentAreaName
			'mppTask.PerformTask
			'Set mppTask = Nothing
			
			'Set filter = eqnBuilder.GetStandardTestFilter("MP_KGW_SCHUFA")
			'helper.AssociateSecondary filter, "SNM_MP"
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
