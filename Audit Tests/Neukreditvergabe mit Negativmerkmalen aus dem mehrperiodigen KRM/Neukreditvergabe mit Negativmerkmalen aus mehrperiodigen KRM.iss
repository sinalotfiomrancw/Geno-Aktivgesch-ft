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
Dim sKUNDENNUMMER As String
Dim sKONTONUMMER As String
Dim sÜBERZ_KD_BASEL_EUR As string
Dim sEWB_RST_GEBUCHT_EUR As string
Dim GK_KD_RV_EUR As string
Dim sKUNDE_SEIT_DATUM As String
Dim sTAGE_ÜBERZ_ENG_BASEL As String
Dim sGK_ENGA_ÜBERZ_EUR As string
Dim sVR_RATING_ENGA_NUM As String
Dim sGK_KD_RV_EUR As String
Dim sGK_ENGA_ÜERZ_EUR As String
Dim sVR_RATING_ENGA As String
Dim sNew_Credits_With_Neg_Character As String
Dim sNew_Credits_With_Neg_Character_PC_TEMP As String
Dim sNew_Credits_With_Neg_Character_PC_NS As String
Dim sNew_Credits_With_Neg_Character_PC As String
Dim sGK_KD_ÜBERZ_EUR As String
Dim sZUSAGE As String

'#End Region

Const sColumnConspicuous As String = "AUFFÄLLIG"
Const sSNM_FileAlias as string = "SNM"
Const Aliases_SNM as string = "SNM_MP"
Const sANZ_SCHUFA_MERKM As String = "ANZ_SCHUFA_MERKM"
Dim bSCHUFA_EXIST As Boolean

dim bKBB_FileValid as boolean
dim bSNM_FileValid as boolean
Dim bSNMFileExist as Boolean

'#Region - Folder
Dim sWorkingFolderPath As String
Dim sWorkingFolderName As String
'#End Region

'#Region - temp files

'#End Region

'#Region - result files
Dim sChangeOfRV As String
Dim sHigherRVWithRiskSector As String
Dim sEQN_SAMECUSTOMER As String
Dim sTemp_SNM_SCHUFA_Criteria_Count  As String
Dim sKRM_FinalFileName As String
Dim sKRM_FinalFileName_PC As String
'Dim sInputFile_SNM As String
'#End Region

'#Region - dialog
Dim aTempColumnNames() As String
Dim sEQN_RiskSector As String
Dim sCustomerSince  As String
Dim sRating As String
Dim sOverdraft  As String
Dim sOverdraftDays  As String
Dim sEWBValue As String
Dim bRating  As Boolean
Dim bOverdraft  As Boolean
Dim bOverdraftDays As Boolean
Dim bEWBValue  As Boolean
Dim bCustomerSince  As Boolean
Dim bSchufa As Boolean
Dim sEQN_Credits_With_Neg_Character As String
Dim sEQN_Credits_With_Neg_Character_PC As String
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
	Call Analysis_Per_Customer
	Call registerResult(sInputFile, INPUT_DATABASE, 0)
	'Call registerResult(sChangeOfRV, INTERMEDIATE_RESULT, 1)
	'Call registerResult(sNew_Credits_With_Neg_Character, FINAL_RESULT,1)
	Call registerResult(sNew_Credits_With_Neg_Character_PC, FINAL_RESULT,1)
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
'	sInputFile_SNM = SmartContext.InputFileByAlias(Aliases_SNM)
SetCheckpoint "GetFileInformation 1.1 - get working folder"
	Call GetWorkingFolder(sInputFile)
SetCheckpoint "GetFileInformation 2.0 - get tags"
	Set db = Client.OpenDatabase(sInputFile)
	sDATUM_DATENABZUG = oTM.GetFieldForTag(db, "acc!DATUM_DATENABZUG")
	sKUNDENNUMMER = oTM.GetFieldForTag(db, "acc!KUNDENNUMMER")
	sEWB_RST_GEBUCHT_EUR = oTM.GetFieldForTag(db, "acc!EWB_RST_GEBUCHT_EUR")
	sGK_KD_RV_EUR = oTM.GetFieldForTag(db, "acc!GK_KD_RV_EUR")
	sKUNDE_SEIT_DATUM = oTM.GetFieldForTag(db, "acc!KUNDE_SEIT_DATUM")
	sTAGE_ÜBERZ_ENG_BASEL = oTM.GetFieldForTag(db, "acc!TAGE_UEBERZ_ENG_BASEL")
	sGK_ENGA_ÜBERZ_EUR = oTM.GetFieldForTag(db, "acc!GK_ENGA_UEBERZ_EUR")
	sVR_RATING_ENGA = oTM.GetFieldForTag(db, "acc!VR_RATING_ENGA")
	sVR_RATING_ENGA_NUM = oTM.GetFieldForTag(db, "acc!VR_RATING_ENGA_NUM")
	sGK_KD_ÜBERZ_EUR = oTM.GetFieldForTag(db, "acc!GK_KD_UEBERZ_EUR")
	sZUSAGE = "ZUSAGE"
	'sVR_RATING_ENGA_NUM = "VR_RATING_ENGA_NUM"
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
'SetCheckpoint "GetWorkingFolder 2.0 - get folder name"	
'	If sWorkingFolderPath = Client.WorkingDirectory or sWorkingFolderPath = "\" Then
'		sWorkingfolderName = ""
'	Else
'		sWorkingfolderName = sWorkingFolderPath
'		sWorkingfolderName = Left(sWorkingfolderName,Len(sWorkingfolderName)-1)
'		While InStr(sWorkingfolderName, "\") > 0 
'			sWorkingfolderName = Right(sWorkingfolderName, Len(sWorkingfolderName) - InStr(sWorkingfolderName, "\"))
'		Wend
'		sWorkingfolderName = sWorkingfolderName & "\"
'	End If
End Function
' --------------------------------------------------------------------------

' gets and set nessesery paramter
Function GetParameters
SetCheckpoint "Preparation 1.0 - get dialog parameter"
	If oDialogPara.Contains("sCheckB_CustomerSince") Then
		bCustomerSince = oDialogPara.Item("sCheckB_CustomerSince").Checked
		If oDialogPara.Contains("sTB_CustomerSince") Then sCustomerSince = Format$(oDialogPara.Item("sTB_CustomerSince"), "yyyymmdd")
	End If
	If oDialogPara.Contains("sCheckB_Rating") Then
		bRating = oDialogPara.Item("sCheckB_Rating").Checked
		If oDialogPara.Contains("sCB_Rating") Then sRating = GetIndex(oDialogPara.Item("sCB_Rating").Value)
	End If
	If oDialogPara.Contains("sCheckB_Overdraft") Then
		bOverdraft = oDialogPara.Item("sCheckB_Overdraft").Checked
		If oDialogPara.Contains("sTB_Overdraft") Then sOverdraft = oDialogPara.Item("sTB_Overdraft")
	End If
	If oDialogPara.Contains("sCheckB_OverdraftDays") Then
		bOverdraftDays = oDialogPara.Item("sCheckB_OverdraftDays").Checked
		If oDialogPara.Contains("sTB_OverdraftDays") Then sOverdraftDays = oDialogPara.Item("sTB_OverdraftDays")
	end if
	If oDialogPara.Contains("sCheckB_EWBValue") Then
		bEWBValue = oDialogPara.Item("sCheckB_EWBValue").Checked
		If oDialogPara.Contains("sTB_EWBValue") Then sEWBValue = oDialogPara.Item("sTB_EWBValue")
	end if
	If oDialogPara.Contains("sCheckB_Schufa") Then bSchufa= oDialogPara.Item("sCheckB_Schufa").Checked
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

Function Analysis_Per_Customer

sEQN_SAMECUSTOMER = " .AND. " & sKUNDENNUMMER & "==@GetPreviousValue(""" & sKUNDENNUMMER & """)"

	Set db = Client.OpenDatabase(sInputFile)
	bSCHUFA_EXIST = oSC.FieldExists(db, sANZ_SCHUFA_MERKM)
	If ((Not bSCHUFA_EXIST) And bSchufa) Then
		bSchufa = False
		MsgBox "keine Schufa-Negativmerkmalsdatei angegeben ist, wird das Kontrollkästchen Schufa-Merkmale im Eingabedialog ignoriert." 
	End If
	db.Close 
	Set db = Nothing 
	
	Set db = Client.OpenDatabase(sInputFile)
	If Not oSC.FieldExists(db, sZUSAGE) Then
		Set task = db.TableManagement
		Set field = db.TableDef.NewField
		field.Name = sZUSAGE
		field.Description = sGK_KD_RV_EUR  & " - " & sGK_KD_ÜBERZ_EUR
		field.Type = WI_VIRT_NUM
		field.Equation = sGK_KD_RV_EUR  & " - " & sGK_KD_ÜBERZ_EUR
		field.Decimals = 2
		task.AppendField field
		task.PerformTask
		Set task = Nothing
		Set field = Nothing
	End If
	db.Close
	Set db = Nothing

	
SetCheckpoint "Analysis 1.0 - "
	Set db = Client.OpenDatabase(sInputFile)
	Set task = db.Summarization
	task.AddFieldToSummarize sKUNDENNUMMER
	task.AddFieldToSummarize sDATUM_DATENABZUG
	task.AddFieldToInc sZUSAGE
	task.AddFieldToInc sKUNDE_SEIT_DATUM
	task.AddFieldToInc sVR_RATING_ENGA
	task.AddFieldToInc sVR_RATING_ENGA_NUM
	task.AddFieldToInc sGK_ENGA_ÜBERZ_EUR
	task.AddFieldToInc sTAGE_ÜBERZ_ENG_BASEL
	task.AddFieldToTotal sEWB_RST_GEBUCHT_EUR
	if bSchufa then
		task.AddFieldToInc sANZ_SCHUFA_MERKM
	end if
	sChangeOfRV = oSC.UniqueFileName(sWorkingFolderPath & "KRM-Übersicht pro Kundennummer und Datum_Datenabzug", INTERMEDIATE_RESULT)
	task.OutputDBName = sChangeOfRV
	task.CreatePercentField = FALSE
	task.UseFieldFromFirstOccurrence = TRUE
	task.StatisticsToInclude = SM_SUM
	task.DisableProgressNotification = True
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	Set db = Client.OpenDatabase(sChangeOfRV) 
	Set sEWB_RST_GEBUCHT_EUR = oSC.RenField(db, sEWB_RST_GEBUCHT_EUR & "_SUMME", sEWB_RST_GEBUCHT_EUR, "")
	db.Close 
	Set db = Nothing 
	
'	SetCheckpoint "Analysis 3.2 - join KRM and SCHUFA"
'	Set db = Client.OpenDatabase(sChangeOfRV)
'	Set task = db.JoinDatabase
'	task.FileToJoin sTemp_SNM_SCHUFA_Criteria_Count
'	task.IncludeAllPFields
'	task.AddSFieldToInc "ANZ_SAETZE1"
'	task.AddMatchKey sKUNDENNUMMER, "PERSONENNUMMER", "A"
'	sKRM_FinalFileName_PC = oSC.UniqueFileName(sWorkingFolderPath & "KRM-Übersicht per Datum_Datenabzug und Kundennummer mit SCHUFA Merkmale")
'	task.DisableProgressNotification = True
'	task.PerformTask sKRM_FinalFileName_PC, "", WI_JOIN_ALL_IN_PRIM
'	db.Close
'	Set task = Nothing
'	Set db = Nothing
'
'SetCheckpoint "Analysis 3.2 - rename columns"
'	Set db = Client.OpenDatabase(sKRM_FinalFileName_PC)
'	Set task = db.TableManagement
'	Set field = db.TableDef.NewField
'	field.Name = sANZ_SCHUFA_MERKM
'	field.Description = "Anzahl der unterschiedlichen SCHUFA Merkmale, die ein Kunde aufweist"
'	field.Type = WI_NUM_FIELD
'	field.Equation = ""
'	field.Decimals = 0
'	task.ReplaceField "ANZ_SAETZE1", field
'	task.DisableProgressNotification = True
'	task.PerformTask
'	db.Close
'	Set task = Nothing
'	Set db = Nothing
'	Set field = Nothing

SetCheckpoint "Analysis 2.0 - "
	Set db = Client.OpenDatabase(sChangeOfRV)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	field.Name = sColumnConspicuous
	field.Description = "wird mit X markiert, wenn Zusage erhöht ist"
	field.Type = WI_VIRT_CHAR
	field.Equation = "@if(" & sZUSAGE & " > @GetPreviousValue(""" & sZUSAGE & """)" & sEQN_SAMECUSTOMER & "; ""X""; """")"
	task.AppendField field
	task.DisableProgressNotification = True
	task.PerformTask
SetCheckpoint "Analysis 2.1 - "
	field.Name = "VORHERIGER_ZEITRAUM"
	field.Description = "DATUM_DATENABZUG aus vorherigem Zeitpunkt"
	field.Type = WI_VIRT_DATE
	field.Equation = "@if(" & sColumnConspicuous & " = ""X""" & sEQN_SAMECUSTOMER & "; @GetPreviousValue(""" & sDATUM_DATENABZUG & """); @ctod(""00000000"";""YYYYMMDD""))"
	task.AppendField field
	task.DisableProgressNotification = True
	task.PerformTask
SetCheckpoint "Analysis 2.2 - "
	'field.Name = "VORHERIGE_ANZ_SAETZE"
	'field.Description = "ANZ_SAETZE aus vorherigem Zeitpunkt"
	'field.Type = WI_VIRT_NUM
	'field.Equation = "@if(" & sColumnConspicuous & " = ""X""; @GetPreviousValue(""ANZ_SAETZE""); 0)"
	'field.Decimals = 0
	'task.AppendField field
	'task.DisableProgressNotification = True
	'task.PerformTask
SetCheckpoint "Analysis 2.3 - "
	field.Name = "VORHERIGES_ZUSAGE"
	field.Description = "ZUSAGE aus vorherigem Zeitpunkt"
	field.Type = WI_VIRT_NUM
	field.Equation = "@if(" & sColumnConspicuous & " = ""X""" & sEQN_SAMECUSTOMER & "; @GetPreviousValue(""" & sZUSAGE & """); 0)"
	field.Decimals = 2
	task.AppendField field
	task.DisableProgressNotification = True
	task.PerformTask
SetCheckpoint "Analysis 2.3 - "
	if bSchufa then
		field.Name = "VORHERIGES_ANZ_SCHUFA_MERKM"
		field.Description = "ANZ_SCHUFA_MERKM aus vorherigem Zeitpunkt"
		field.Type = WI_VIRT_NUM
		field.Equation = "@if(" & sColumnConspicuous & " = ""X""" & sEQN_SAMECUSTOMER & "; @GetPreviousValue(""" & sANZ_SCHUFA_MERKM & """); 0)"
		field.Length = 8
		field.Decimals = 0
		task.AppendField field
		task.DisableProgressNotification = True
		task.PerformTask
	end if
SetCheckpoint "Analysis 2.3 - "
	field.Name = "VORHERIGES_KUNDE_SEIT_DATUM"
	field.Description = "KUNDE_SEIT_DATUM aus vorherigem Zeitpunkt"
	field.Type = WI_VIRT_DATE
	field.Equation = "@if(" & sColumnConspicuous & " = ""X""" & sEQN_SAMECUSTOMER & "; @GetPreviousValue(""" & sKUNDE_SEIT_DATUM & """); @ctod(""00000000"";""YYYYMMDD""))"
	task.AppendField field
	task.DisableProgressNotification = True
	task.PerformTask
'SetCheckpoint "Analysis 2.3 - "
'	field.Name = "VORHERIGES_VR_RATING"
'	field.Description = "VR_RATING aus vorherigem Zeitpunkt"
'	field.Type = WI_VIRT_CHAR
'	field.Equation = "@if(" & sColumnConspicuous & " = ""X""" & sEQN_SAMECUSTOMER & "; @GetPreviousValue(""" & sVR_RATING & """); """")"
'	field.Length = 5
'	task.AppendField field
'	task.DisableProgressNotification = True
'	task.PerformTask
SetCheckpoint "Analysis 2.3 - "
	field.Name = "VORHERIGES_VR_RATING_ENGA"
	field.Description = "VR_RATING_ENGA aus vorherigem Zeitpunkt"
	field.Type = WI_VIRT_CHAR
	field.Equation = "@if(" & sColumnConspicuous & " = ""X""" & sEQN_SAMECUSTOMER & "; @GetPreviousValue(""" & sVR_RATING_ENGA & """); """")"
	field.Length = 5
	task.AppendField field
	task.DisableProgressNotification = True
	task.PerformTask
SetCheckpoint "Analysis 2.3 - "
	field.Name = "VORHERIGES_VR_RATING_ENGA_NUM"
	field.Description = "VR_RATING_ENGA_NUM aus vorherigem Zeitpunkt"
	field.Type = WI_VIRT_NUM
	field.Equation = "@if(" & sColumnConspicuous & " = ""X""" & sEQN_SAMECUSTOMER & "; @GetPreviousValue(""" & sVR_RATING_ENGA_NUM & """); 0)"
	field.Length = 8
	field.Decimals = 0
	task.AppendField field
	task.DisableProgressNotification = True
	task.PerformTask
SetCheckpoint "Analysis 2.3 - "
	field.Name = "VORHERIGES_TAGE_ÜBERZ_ENG_BASEL"
	field.Description = "TAGE_ÜBERZ_ENG_BASEL aus vorherigem Zeitpunkt"
	field.Type = WI_VIRT_NUM
	field.Equation = "@if(" & sColumnConspicuous & " = ""X""" & sEQN_SAMECUSTOMER & "; @GetPreviousValue(""" & sTAGE_ÜBERZ_ENG_BASEL & """); 0)"
	field.Length = 8
	field.Decimals = 0
	task.AppendField field
	task.DisableProgressNotification = True
	task.PerformTask
SetCheckpoint "Analysis 2.3 - "
	field.Name = "VORHERIGES_GK_ENGA_ÜBERZ_EUR"
	field.Description = "GK_ENGA_ÜBERZ_EUR aus vorherigem Zeitpunkt"
	field.Type = WI_VIRT_NUM
	field.Equation = "@if(" & sColumnConspicuous & " = ""X""" & sEQN_SAMECUSTOMER & "; @GetPreviousValue(""" & sGK_ENGA_ÜBERZ_EUR & """); 0)"
	field.Length = 8
	field.Decimals = 2
	task.AppendField field
	task.DisableProgressNotification = True
	task.PerformTask
SetCheckpoint "Analysis 2.3 - "
	field.Name = "VORHERIGES_EWB_RST_GEBUCHT_EUR"
	field.Description = "EWB_RST_GEBUCHT_EUR aus vorherigem Zeitpunkt"
	field.Type = WI_VIRT_NUM
	field.Equation = "@if(" & sColumnConspicuous & " = ""X""" & sEQN_SAMECUSTOMER & "; @GetPreviousValue(""" & sEWB_RST_GEBUCHT_EUR & """); 0)"
	field.Length = 8
	field.Decimals = 2
	task.AppendField field
	task.DisableProgressNotification = True
	task.PerformTask
SetCheckpoint "Analysis 2.4 - "
	field.Name = "ÄNDERUNG_ZUSAGE"
	field.Description = sZUSAGE & " - " & "VORHERIGES_ZUSAGE"
	field.Type = WI_VIRT_NUM
	field.Equation = "@if(" & sColumnConspicuous & " = ""X""; " & sZUSAGE & " - VORHERIGES_ZUSAGE; 0)"
	field.Decimals = 2
	task.AppendField field
	task.DisableProgressNotification = True
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
SetCheckpoint "Analysis 3.0 - create equation"
Dim sEQN_HigherRVWithRiskSector As String
	sEQN_HigherRVWithRiskSector = "AUFFÄLLIG = ""X"" "
SetCheckpoint "Analysis 3.1 - "
	Set db = Client.OpenDatabase(sChangeOfRV)
	Set task = db.Extraction
	task.AddFieldToInc sKUNDENNUMMER
	task.AddFieldToInc "ÄNDERUNG_ZUSAGE"
	task.AddFieldToInc sDATUM_DATENABZUG
	task.AddFieldToInc "ANZ_SAETZE"
	task.AddFieldToInc sZUSAGE
'	task.AddFieldToInc "VORHERIGES_RV"
	if bSchufa then
		task.AddFieldToInc sANZ_SCHUFA_MERKM
	end if
	'task.AddFieldToInc sGK_KD_RV_EUR
	if bCustomerSince then
		task.AddFieldToInc sKUNDE_SEIT_DATUM
	end if
	if bRating then
		task.AddFieldToInc sVR_RATING_ENGA
		task.AddFieldToInc sVR_RATING_ENGA_NUM
	end if
	if bOverdraft then	
		task.AddFieldToInc sGK_ENGA_ÜBERZ_EUR
	end if
	if bOverdraftDays then
		task.AddFieldToInc sTAGE_ÜBERZ_ENG_BASEL
	end if
	if bEWBValue then
		task.AddFieldToInc sEWB_RST_GEBUCHT_EUR
	end if
	task.AddFieldToInc "VORHERIGER_ZEITRAUM"
	'task.AddFieldToInc "VORHERIGE_ANZ_SAETZE"
	task.AddFieldToInc "VORHERIGES_ZUSAGE"
	'task.AddFieldToInc "VORHERIGES_KUNDE_SEIT_DATUM"
	if bSchufa then
		task.AddFieldToInc "VORHERIGES_ANZ_SCHUFA_MERKM"
	end if
	if bRating then
		task.AddFieldToInc "VORHERIGES_VR_RATING_ENGA"
		task.AddFieldToInc "VORHERIGES_VR_RATING_ENGA_NUM"
	end if
	if bOverdraft then
		task.AddFieldToInc "VORHERIGES_GK_ENGA_ÜBERZ_EUR"
	end if
	if bOverdraftDays then	
		task.AddFieldToInc "VORHERIGES_TAGE_ÜBERZ_ENG_BASEL"
	end if
	if bEWBValue then
		task.AddFieldToInc "VORHERIGES_EWB_RST_GEBUCHT_EUR"
	end if
	sHigherRVWithRiskSector = oSC.UniqueFileName(sWorkingFolderPath & "erhöhtes Zusage pro Kunde", INTERMEDIATE_RESULT)
	task.AddExtraction sHigherRVWithRiskSector, "", sEQN_HigherRVWithRiskSector
	task.DisableProgressNotification = True
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
SetCheckpoint "Analysis 3.2 - create action field"
	'Set db = Client.OpenDatabase(sHigherRVWithRiskSector)
	'oSC.CreateActionField db, "VORHERIGE_ANZ_SAETZE", sInputFile, sKUNDENNUMMER, "VORHERIGER_ZEITRAUM"
	'db.close
	'Set db =Nothing
	
	Call CreateCriteria_PC
	
	SetCheckpoint "Analysis 1.0 - extract credits with negativ characteristics"
	Set db = Client.OpenDatabase(sHigherRVWithRiskSector)
	Set task = db.Extraction
	task.IncludeAllFields
	sNew_Credits_With_Neg_Character_PC_NS = oSC.UniqueFileName(sWorkingfolderName & "Neukreditvergabe mit Negativmerkmalen aus mehrperiodigen KRM (nicht sortiert)", INTERMEDIATE_RESULT)
	task.AddExtraction sNew_Credits_With_Neg_Character_PC_NS, "", sEQN_Credits_With_Neg_Character_PC
	task.DisableProgressNotification = True
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	SetCheckpoint "Analysis 2.0 - create columns"
	Set db = Client.OpenDatabase(sNew_Credits_With_Neg_Character_PC_NS)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	if bCustomerSince then
		field.Name = "KUNDE_SEIT_ÜBERSCHRITTEN"
		field.Description = ""
		field.Type = WI_CHAR_FIELD
		field.Equation = "@if(" & sKUNDE_SEIT_DATUM & " >= """ & sCustomerSince & """; ""X""; """")"
		field.Length = 1
		task.AppendField field
		task.PerformTask
	end if
	
	if bSchufa then
		field.Name = "SCHUFA_ÜBERSCHRITTEN"
		field.Description = ""
		field.Type = WI_CHAR_FIELD
		field.Equation = "@if(" & sANZ_SCHUFA_MERKM & " > 0; ""X""; """")"
		field.Length = 1
		task.AppendField field
		task.PerformTask
		
		field.Name = "VORHERIGES_SCHUFA_ÜBERSCHRITTEN"
		field.Description = ""
		field.Type = WI_CHAR_FIELD
		field.Equation = "@if(" & "VORHERIGES_ANZ_SCHUFA_MERKM" & " > 0; ""X""; """")"
		field.Length = 1
		task.AppendField field
		task.PerformTask
	end if

	if bRating then
		field.Name = "RATING_ÜBERSCHRITTEN"
		field.Description = ""
		field.Type = WI_CHAR_FIELD
		field.Equation = "@if(" & sVR_RATING_ENGA_NUM & " >= " & sRating & "; ""X""; """")"
		field.Length = 1
		task.AppendField field
		task.PerformTask
		
		field.Name = "VORHERIGES_RATING_ÜBERSCHRITTEN"
		field.Description = ""
		field.Type = WI_CHAR_FIELD
		field.Equation = "@if(" & "VORHERIGES_VR_RATING_ENGA_NUM" & " >= " & sRating & "; ""X""; """")"
		field.Length = 1
		task.AppendField field
		task.PerformTask
	end if
	if bOverdraft then
		field.Name = "ÜBERZIEHUNG_ÜBERSCHRITTEN"
		field.Description = ""
		field.Type = WI_CHAR_FIELD
		field.Equation = "@if(" & sGK_ENGA_ÜBERZ_EUR & " >= " & sOverdraft & "; ""X""; """")"
		field.Length = 1
		task.AppendField field
		task.PerformTask
		
		field.Name = "VORHERIGES_ÜBERZIEHUNG_ÜBERSCHRITTEN"
		field.Description = ""
		field.Type = WI_CHAR_FIELD
		field.Equation = "@if(" & "VORHERIGES_GK_ENGA_ÜBERZ_EUR" & " >= " & sOverdraft & "; ""X""; """")"
		field.Length = 1
		task.AppendField field
		task.PerformTask
	end if
	if bOverdraftDays then
		field.Name = "ÜBERZIEHUNGSTAGE_ÜBERSCHRITTEN"
		field.Description = ""
		field.Type = WI_CHAR_FIELD
		field.Equation = "@if(" & sTAGE_ÜBERZ_ENG_BASEL & " >= " & sOverdraftDays & "; ""X""; """")"
		field.Length = 1
		task.AppendField field
		task.PerformTask
		
		field.Name = "VORHERIGES_ÜBERZIEHUNGSTAGE_ÜBERSCHRITTEN"
		field.Description = ""
		field.Type = WI_CHAR_FIELD
		field.Equation = "@if(" & "VORHERIGES_TAGE_ÜBERZ_ENG_BASEL" & " >= " & sOverdraftDays & "; ""X""; """")"
		field.Length = 1
		task.AppendField field
		task.PerformTask
	end if
	if bEWBValue then
		field.Name = "EWB_ÜBERSCHRITTEN"
		field.Description = ""
		field.Type = WI_CHAR_FIELD
		field.Equation = "@if(" & sEWB_RST_GEBUCHT_EUR & " >= " & sEWBValue & "; ""X""; """")"
		field.Length = 1
		task.AppendField field
		task.PerformTask
		
		field.Name = "VORHERIGES_EWB_ÜBERSCHRITTEN"
		field.Description = ""
		field.Type = WI_CHAR_FIELD
		field.Equation = "@if(" & "VORHERIGES_EWB_RST_GEBUCHT_EUR" & " >= " & sEWBValue & "; ""X""; """")"
		field.Length = 1
		task.AppendField field
		task.PerformTask
	end if
	db.Close
	
	
	' Datei öffnen.
	Set db = Client.OpenDatabase(sNew_Credits_With_Neg_Character_PC_NS)
	' Vorgang erstellen.
	Set task = db.Sort
	' Sortierungsschlüssel hinzufügen.
	task.AddKey "ÄNDERUNG_ZUSAGE", "D"
	' Den Namen der Ausgabedatei definieren und den Vorgang ausführen.
	sNew_Credits_With_Neg_Character_PC = oSC.UniqueFileName(sWorkingfolderName & "Neukreditvergabe mit Negativmerkmalen aus mehrperiodigen KRM", FINAL_RESULT)
	task.PerformTask sNew_Credits_With_Neg_Character_PC
	db.Close
	' Speicherplatz freigeben.
	
'	Set db = Client.OpenDatabase(sNew_Credits_With_Neg_Character_PC_TEMP)
'	Set task = db.Extraction
'	task.AddFieldToInc "KUNDENNUMMER"
'	task.AddFieldToInc "DATUM_DATENABZUG"
'	task.AddFieldToInc "ANZ_SAETZE"
'	if bCustomerSince then
'		task.AddFieldToInc "KUNDE_SEIT_DATUM"
'	end if
'	If bSchufa then
'		task.AddFieldToInc "ANZ_SCHUFA_MERKM"
'	end if
'	if bRating then
'		task.AddFieldToInc "VR_RATING_ENGA"
'	end if
'	if bOverdraft then
'		task.AddFieldToInc "GK_ENGA_ÜBERZ_EUR"
'	end if
'	if bOverdraftDays then
'		task.AddFieldToInc "TAGE_ÜBERZ_ENG_BASEL"
'	end if
'	if bEWBValue then
'		task.AddFieldToInc "EWB_RST_GEBUCHT_EUR"
'	end if
'	task.AddFieldToInc "VORHERIGER_ZEITRAUM"
'	if bRating then
'		task.AddFieldToInc "VORHERIGES_VR_RATING_ENGA"
'	end if
'	if bOverdraft then
'		task.AddFieldToInc "VORHERIGES_GK_ENGA_ÜBERZ_EUR"
'	end if
'	if bOverdraftDays then
'		task.AddFieldToInc "VORHERIGES_TAGE_ÜBERZ_ENG_BASEL"
'	end if
'	if bEWBValue then
'		task.AddFieldToInc "VORHERIGES_EWB_RST_GEBUCHT_EUR"
'	end if
'	if bCustomerSince then
'		task.AddFieldToInc "KUNDE_SEIT_ÜBERSCHRITTEN"
'	end if
'	If bSchufa then
'		task.AddFieldToInc "SCHUFA_ÜBERSCHRITTEN"
'	End If
'	if bRating then
'		task.AddFieldToInc "RATING_ÜBERSCHRITTEN"
'		task.AddFieldToInc "VORHERIGES_RATING_ÜBERSCHRITTEN"
'	end if
'	if bOverdraft then
'		task.AddFieldToInc "ÜBERZIEHUNG_ÜBERSCHRITTEN"
'		task.AddFieldToInc "VORHERIGES_ÜBERZIEHUNG_ÜBERSCHRITTEN"
'	end if
'	if bOverdraftDays then
'		task.AddFieldToInc "ÜBERZIEHUNGSTAGE_ÜBERSCHRITTEN"
'		task.AddFieldToInc "VORHERIGES_ÜBERZIEHUNGSTAGE_ÜBERSCHRITTE"
'	end if
'	if bEWBValue then
'		task.AddFieldToInc "EWB_ÜBERSCHRITTEN"
'		task.AddFieldToInc "VORHERIGES_EWB_ÜBERSCHRITTEN"
'	end if
'	sNew_Credits_With_Neg_Character_PC = oSC.UniqueFileName(sWorkingfolderName & "Neukreditvergabe mit Negativmerkmal pro Kunde", FINAL_RESULT)
'	task.AddExtraction sNew_Credits_With_Neg_Character_PC, "", ""
'	task.PerformTask 1, db.Count
'	Set task = Nothing
'	Set db = Nothing
	
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
	
End Function

Function CreateCriteria
SetCheckpoint "Preparation 2.0 - create function"
	sEQN_Credits_With_Neg_Character = ""
	If bCustomerSince Then sEQN_Credits_With_Neg_Character = sEQN_Credits_With_Neg_Character & sKUNDE_SEIT_DATUM & " >= """ & sCustomerSince & """ .OR. "
	If bRating Then sEQN_Credits_With_Neg_Character = sEQN_Credits_With_Neg_Character & sVR_RATING_ENGA_NUM & " >= " & sRating & " .OR. "
	If bOverdraft Then sEQN_Credits_With_Neg_Character = sEQN_Credits_With_Neg_Character & sGK_ENGA_ÜBERZ_EUR & " >= " & sOverdraft & " .OR. "
	If bOverdraftDays Then sEQN_Credits_With_Neg_Character = sEQN_Credits_With_Neg_Character & sTAGE_ÜBERZ_ENG_BASEL & " >= " & sOverdraftDays & " .OR. "
	If bEWBValue Then sEQN_Credits_With_Neg_Character = sEQN_Credits_With_Neg_Character & sEWB_RST_GEBUCHT_EUR & " >= " & sEWBValue & " .OR. "
	If bSchufa Then sEQN_Credits_With_Neg_Character = sEQN_Credits_With_Neg_Character & sANZ_SCHUFA_MERKM & " > 0 .OR. "
	If Right(sEQN_Credits_With_Neg_Character, 6) = " .OR. " Then sEQN_Credits_With_Neg_Character = Left(sEQN_Credits_With_Neg_Character, Len(sEQN_Credits_With_Neg_Character) - 6)
End Function
' --------------------------------------------------------------------------

Function CreateCriteria_PC
SetCheckpoint "Preparation 2.0 - create function"
	sEQN_Credits_With_Neg_Character_PC = ""
	If bCustomerSince Then sEQN_Credits_With_Neg_Character_PC = sEQN_Credits_With_Neg_Character_PC & sKUNDE_SEIT_DATUM & " >= """ & sCustomerSince & """ .OR. "
	If bRating Then sEQN_Credits_With_Neg_Character_PC = sEQN_Credits_With_Neg_Character_PC & sVR_RATING_ENGA_NUM & " >= " & sRating & " .OR. " & "VORHERIGES_VR_RATING_ENGA_NUM" & " >= " & sRating & " .OR. "
	If bOverdraft Then sEQN_Credits_With_Neg_Character_PC = sEQN_Credits_With_Neg_Character_PC & sGK_ENGA_ÜBERZ_EUR & " >= " & sOverdraft & " .OR. " & "VORHERIGES_GK_ENGA_ÜBERZ_EUR" & " >= " & sOverdraft & " .OR. "
	If bOverdraftDays Then sEQN_Credits_With_Neg_Character_PC = sEQN_Credits_With_Neg_Character_PC & sTAGE_ÜBERZ_ENG_BASEL & " >= " & sOverdraftDays & " .OR. " & "VORHERIGES_TAGE_ÜBERZ_ENG_BASEL" & " >= " & sOverdraftDays & " .OR. "
	If bEWBValue Then sEQN_Credits_With_Neg_Character_PC = sEQN_Credits_With_Neg_Character_PC & sEWB_RST_GEBUCHT_EUR & " >= " & sEWBValue & " .OR. " & "VORHERIGES_EWB_RST_GEBUCHT_EUR" & " >= " & sEWBValue & " .OR. "
	If bSchufa Then sEQN_Credits_With_Neg_Character_PC = sEQN_Credits_With_Neg_Character_PC & sANZ_SCHUFA_MERKM & " > 0 " & " .OR. " & "VORHERIGES_ANZ_SCHUFA_MERKM" & " > 0 " & " .OR. "
	If Right(sEQN_Credits_With_Neg_Character_PC, 6) = " .OR. " Then sEQN_Credits_With_Neg_Character_PC = Left(sEQN_Credits_With_Neg_Character_PC, Len(sEQN_Credits_With_Neg_Character_PC) - 6)

End Function

' --------------------------------------------------------------------------

' Filters the input table.
Function Analysis

sEQN_SAMECUSTOMER = " .AND. " & sKUNDENNUMMER & "==@GetPreviousValue(""" & sKUNDENNUMMER & """)"

'	bSNMFileExist = FileOrDirExists(sWorkingFolderPath & "{Anzahl SCHUFA Merkmale pro Kunde}.IMD")
'	
'	if bSNMFileExist then
'		sTemp_SNM_SCHUFA_Criteria_Count = sWorkingFolderPath & "{Anzahl SCHUFA Merkmale pro Kunde}.IMD"
'	else
'		SetCheckpoint "Preparation 5.1 - create SCHUFA criteria per costumer"
'		Set db = Client.OpenDatabase(sInputFile_SNM)
'		Set task = db.Summarization
'		task.AddFieldToSummarize "PERSONENNUMMER"
'		sTemp_SNM_SCHUFA_Criteria_Count = oSC.UniqueFileName(sWorkingFolderPath & "{Anzahl SCHUFA Merkmale pro Kunde}")
'		task.OutputDBName = sTemp_SNM_SCHUFA_Criteria_Count
'		task.CreatePercentField = FALSE
'		task.DisableProgressNotification = True
'		task.PerformTask
'		db.Close
'		Set task = Nothing
'		Set db = Nothing
'	end if
	Set db = Client.OpenDatabase(sInputFile)
	bSCHUFA_EXIST = oSC.FieldExists(db, sANZ_SCHUFA_MERKM)
	If ((Not bSCHUFA_EXIST) And bSchufa) Then
		bSchufa = False
		MsgBox "keine Schufa-Negativmerkmalsdatei angegeben ist, wird das Kontrollkästchen Schufa-Merkmale im Eingabedialog ignoriert." 
	End If
	db.Close 
	Set db = Nothing 

	Call CreateCriteria
	
'SetCheckpoint "Analysis 3.2 - join KRM and SCHUFA"
'	Set db = Client.OpenDatabase(sInputFile)
'	Set task = db.JoinDatabase
'	task.FileToJoin sTemp_SNM_SCHUFA_Criteria_Count
'	task.IncludeAllPFields
'	task.AddSFieldToInc "ANZ_SAETZE1"
'	task.AddMatchKey sKUNDENNUMMER, "PERSONENNUMMER", "A"
'	sKRM_FinalFileName = oSC.UniqueFileName(sWorkingFolderPath & "KRM-Übersicht mit SCHUFA Merkmale")
'	task.DisableProgressNotification = True
'	task.PerformTask sKRM_FinalFileName, "", WI_JOIN_ALL_IN_PRIM
'	db.Close
'	Set task = Nothing
'	Set db = Nothing
'
'SetCheckpoint "Analysis 3.2 - rename columns"
'	Set db = Client.OpenDatabase(sKRM_FinalFileName)
'	Set task = db.TableManagement
'	Set field = db.TableDef.NewField
'	field.Name = sANZ_SCHUFA_MERKM
'	field.Description = "Anzahl der unterschiedlichen SCHUFA Merkmale, die ein Kunde aufweist"
'	field.Type = WI_NUM_FIELD
'	field.Equation = ""
'	field.Decimals = 0
'	task.ReplaceField "ANZ_SAETZE1", field
'	task.DisableProgressNotification = True
'	task.PerformTask
'	db.Close
'	Set task = Nothing
'	Set db = Nothing
'	Set field = Nothing
	
	SetCheckpoint "Analysis 1.0 - extract credits with negativ characteristics"
	Set db = Client.OpenDatabase(sInputFile)
	Set task = db.Extraction
	task.IncludeAllFields
	sNew_Credits_With_Neg_Character = oSC.UniqueFileName(sWorkingfolderName & "Kreditvergabe mit Negativmerkmal", FINAL_RESULT)
	task.AddExtraction sNew_Credits_With_Neg_Character, "", sEQN_Credits_With_Neg_Character
	task.DisableProgressNotification = True
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	SetCheckpoint "Analysis 2.0 - create columns"
	Set db = Client.OpenDatabase(sNew_Credits_With_Neg_Character)
	Set task = db.TableManagement
	Set field = db.TableDef.NewField
	if bCustomerSince then
		field.Name = "KUNDE_SEIT_ÜBERSCHRITTEN"
		field.Description = ""
		field.Type = WI_CHAR_FIELD
		field.Equation = "@if(" & sKUNDE_SEIT_DATUM & " >= """ & sCustomerSince & """; ""X""; """")"
		field.Length = 1
		task.AppendField field
		task.PerformTask
	end if
	if bRating then
		field.Name = "RATING_ÜBERSCHRITTEN"
		field.Description = ""
		field.Type = WI_CHAR_FIELD
		field.Equation = "@if(" & sVR_RATING_ENGA_NUM & " >= " & sRating & "; ""X""; """")"
		field.Length = 1
		task.AppendField field
		task.PerformTask
	end if
	if bOverdraft then
		field.Name = "ÜBERZIEHUNG_ÜBERSCHRITTEN"
		field.Description = ""
		field.Type = WI_CHAR_FIELD
		field.Equation = "@if(" & sGK_ENGA_ÜBERZ_EUR & " >= " & sOverdraft & "; ""X""; """")"
		field.Length = 1
		task.AppendField field
		task.PerformTask
	end if
	if bOverdraftDays then
		field.Name = "ÜBERZIEHUNGSTAGE_ÜBERSCHRITTEN"
		field.Description = ""
		field.Type = WI_CHAR_FIELD
		field.Equation = "@if(" & sTAGE_ÜBERZ_ENG_BASEL & " >= " & sOverdraftDays & "; ""X""; """")"
		field.Length = 1
		task.AppendField field
		task.PerformTask
	end if
	if bEWBValue then
		field.Name = "EWB_ÜBERSCHRITTEN"
		field.Description = ""
		field.Type = WI_CHAR_FIELD
		field.Equation = "@if(" & sEWB_RST_GEBUCHT_EUR  & " >= " & sEWBValue & "; ""X""; """")"
		field.Length = 1
		task.AppendField field
		task.PerformTask
	end if
	if bSchufa then
		field.Name = "SCHUFA_ÜBERSCHRITTEN"
		field.Description = ""
		field.Type = WI_CHAR_FIELD
		field.Equation = "@if(" & sANZ_SCHUFA_MERKM & " > 0; ""X""; """")"
		field.Length = 1
		task.AppendField field
		task.PerformTask
	end if
	db.Close
	Set task = Nothing
	Set db = Nothing
	Set field = Nothing
	
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
	SmartContext.ExecutionStatus = EXEC_STATUS_FAILED
	
	SetCheckpoint "End of Sub Main()"
	
	Set oMC = Nothing
	Set oSC = Nothing
	Set oTM = Nothing
	Set oPip = Nothing
	Set oDialogPara = Nothing
	
	SmartContext.Log.LogMessage "Audit test run ends at: {0}", Format(Now(), "yyyy-MM-dd hh:mm:ss")
	Stop
End Function
' --------------------------------------------------------------------------

Function FileOrDirExists(PathName As String) As Boolean
    'Macro Purpose: Function returns TRUE if the specified file
    '               or folder exists, false if not.
    'PathName     : Supports Windows mapped drives or UNC
    '             : Supports Macintosh paths
    'File usage   : Provide full file path and extension
    'Folder usage : Provide full folder path
    '               Accepts with/without trailing "\" (Windows)
    '               Accepts with/without trailing ":" (Macintosh)
    
    Dim iTemp As Integer
    
	'Ignore errors to allow for error evaluation
    On Error Resume Next
    iTemp = GetAttr(PathName)
    
    'Check if error exists and set response appropriately
    Select Case Err.Number
        Case Is = 0
            FileOrDirExists = True
        Case Else
            FileOrDirExists = False
    End Select
    Err.Number = 0
    
    'Resume error checking
    On Error GoTo 0
End Function
' --------------------------------------------------------------------------