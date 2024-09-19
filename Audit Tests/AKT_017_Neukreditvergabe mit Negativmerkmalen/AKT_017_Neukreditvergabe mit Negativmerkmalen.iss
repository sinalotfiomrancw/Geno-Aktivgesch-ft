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
Dim sInputFile As String 'KBB

Dim sDATUM_DATENABZUG As String
Dim sKUNDENNAME As String
Dim sENGAGEMENTBEZ As String
Dim sKUNDE_SEIT_DATUM As String
Dim sVR_RATING_ENGA_NUM As String
Dim sGK_ENGA_ÜBERZ_EUR As String
Dim sTAGE_ÜBERZ_ENG_BASEL As String
Dim sEWB_BETRAG As String
Dim sANZ_SCHUFA_MERKM As String
'#End Region

'#Region - Folder
dim sWorkingFolderPath as string
dim sWorkingFolderName as string
'#End Region

'#Region - result files
Dim sNew_Credits_With_Neg_Character As String
'#End Region

'#Region - dialog
dim bCustomerSince as boolean
dim bRating as boolean
dim bOverdraft as boolean
dim bOverdraftDays as boolean
dim bEWBValue as boolean
dim bSchufa as boolean

dim sCustomerSince as string
dim sRating as string
dim sOverdraft as string
dim sOverdraftDays as string
Dim sEWBValue As String

Dim sEQN_Credits_With_Neg_Character As String
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
	Call registerResult(sNew_Credits_With_Neg_Character, FINAL_RESULT, 1)
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
	sKUNDENNAME = oTM.GetFieldForTag(db, "acc!KUNDENNAME")
	sENGAGEMENTBEZ = oTM.GetFieldForTag(db, "acc!ENGAGEMENTBEZ")
	sKUNDE_SEIT_DATUM = oTM.GetFieldForTag(db, "acc!KUNDE_SEIT_DATUM")
	sVR_RATING_ENGA_NUM = oTM.GetFieldForTag(db, "acc!VR_RATING_ENGA_NUM")
	sGK_ENGA_ÜBERZ_EUR = oTM.GetFieldForTag(db, "acc!GK_ENGA_UEBERZ_EUR")
	sTAGE_ÜBERZ_ENG_BASEL = oTM.GetFieldForTag(db, "acc!TAGE_UEBERZ_ENG_BASEL")
	sEWB_BETRAG = oTM.GetFieldForTag(db, "acc!EWB_BETRAG")
	sANZ_SCHUFA_MERKM = oTM.GetFieldForTag(db, "acc!ANZ_SCHUFA_MERKM")
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
SetCheckpoint "Preparation 2.0 - create function"
	sEQN_Credits_With_Neg_Character = ""
	If bCustomerSince Then sEQN_Credits_With_Neg_Character = sEQN_Credits_With_Neg_Character & sKUNDE_SEIT_DATUM & " >= """ & sCustomerSince & """ .OR. "
	If bRating Then sEQN_Credits_With_Neg_Character = sEQN_Credits_With_Neg_Character & sVR_RATING_ENGA_NUM & " >= " & sRating & " .OR. "
	If bOverdraft Then sEQN_Credits_With_Neg_Character = sEQN_Credits_With_Neg_Character & sGK_ENGA_ÜBERZ_EUR & " >= " & sOverdraft & " .OR. "
	If bOverdraftDays Then sEQN_Credits_With_Neg_Character = sEQN_Credits_With_Neg_Character & sTAGE_ÜBERZ_ENG_BASEL & " >= " & sOverdraftDays & " .OR. "
	If bEWBValue Then sEQN_Credits_With_Neg_Character = sEQN_Credits_With_Neg_Character & sEWB_BETRAG & " >= " & sEWBValue & " .OR. "
	If bSchufa Then sEQN_Credits_With_Neg_Character = sEQN_Credits_With_Neg_Character & sANZ_SCHUFA_MERKM & " > 0 .OR. "
	If Right(sEQN_Credits_With_Neg_Character, 6) = " .OR. " Then sEQN_Credits_With_Neg_Character = Left(sEQN_Credits_With_Neg_Character, Len(sEQN_Credits_With_Neg_Character) - 6)
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
SetCheckpoint "Analysis 1.0 - extract credits with negativ characteristics"
	Set db = Client.OpenDatabase(sInputFile)
	Set task = db.Extraction
	task.IncludeAllFields
	sNew_Credits_With_Neg_Character = oSC.UniqueFileName(sWorkingfolderName & "Neukreditvergabe mit Negativmerkmal aus Kreditbeschlussbuch", FINAL_RESULT)
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
		field.Equation = "@if(" & sEWB_BETRAG & " >= " & sEWBValue & "; ""X""; """")"
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
end function
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
	SmartContext.ExecutionStatus = EXEC_STATUS_FAILED
	
	SetCheckpoint "End of Sub Main()"
	
	Set oMC = Nothing
	Set oSC = Nothing
	Set oTM = Nothing
	Set oPip = Nothing
	Set oDialogPara = Nothing
	
	SmartContext.Log.LogMessage "Audit test run ends at: {0}", Format(Now(), "yyyy-MM-dd hh:mm:ss")
	Stop
end function
