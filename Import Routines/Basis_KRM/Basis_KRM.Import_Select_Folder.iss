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
dim oPara as object
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
'#End Region

'#Region - Importdefinitions

'#End Region

'#Region - Files Alias
Const sKRM_FileAlias as string = "KRM_SUM"
'#End Region
Sub Main()
	On Error GoTo ErrHandler:
	
	SetCheckpoint "Begin of Sub Main()"
	
	SmartContext.Log.LogMessage "A special routine of '{0}'", SmartContext.TestName
	SmartContext.Log.LogMessage "Import routine version: {0}", SmartContext.TestVersion
	SmartContext.Log.LogMessage "Called at: {0}", Format(Now(), "yyyy-MM-dd hh:mm:ss")
	
	' Please check whether the variables below are really needed.
	' Remove all unnecessary variables and this comment too
	Set oMC = SmartContext.MacroCommands
	Set oSC = oMC.SimpleCommands
	Set oTM = oMC.TagManagement
	Set oPip = oMC.ProtectIP
	Set oPara = oMC.GlobalParameters
	
	' **** Add your code below this line
	Call GetParameters
	Call Import
	Call SelectFolder
	' **** End of the user specific code
	
	SmartContext.ExecutionStatus = EXEC_STATUS_SUCCEEDED
	
	SetCheckpoint "End of Sub Main()"
	
	Set oMC = nothing
	Set oSC = nothing
	Set oTM = nothing
	Set oPip = nothing
	Set oPara = nothing
	
	SmartContext.Log.LogMessage "The special routine ends at: {0}", Format(Now(), "yyyy-MM-dd hh:mm:ss")
	
	Exit Sub
	
ErrHandler:
	Call LogSmartAnalyzerError("")
	
	If SmartContext.ExecutionStatus = EXEC_STATUS_FAILED Or _
	          SmartContext.ExecutionStatus = EXEC_STATUS_CANCELED Then
		SmartContext.AbortImport = True
	End If
	
	Call EndSequenze
End Sub
' --------------------------------------------------------------------------

' Gets the Parameter from the pre routine.
' Checks whether the files exist should be implemented. 17.10.2022
function GetParameters
dim sVersionImportdefinition as string
dim sColumnDelimiter as string
dim dicImportdefinitions as object
dim sVersionImportdefinition_forPath as string
dim sColumnDelimiter_forPath as string
dim bVersionNotFound as boolean
Dim bDelimiterNotFound As Boolean
Dim sNotFoundMessage As String
SetCheckpoint "GetParameters 1.0 - get project parameter"
	bVersionNotFound = false
	bDelimiterNotFound = false
	sInputFile = oPara.Get4Project("FolderPath")
SetCheckpoint "GetParameters 2.0 - get parameter from appdata"
	sVersionImportdefinition = oPara.Get4Project("ImpDef")
	sColumnDelimiter = oPara.Get4Project("ColDel")
SetCheckpoint "GetParameters 3.0 - create dictionary"
	Set dicImportdefinitions = CreateObject("Scripting.Dictionary")
	dicImportdefinitions.Add "VR-Control KRM Stand dd.mm.2021", "ddmm2021"
	dicImportdefinitions.Add "VR-Control KRM Stand 17.05.2022", "17052022"
	dicImportdefinitions.Add "Semikolon", "Semicolon"
	dicImportdefinitions.Add "Tab", "Tab"
SetCheckpoint "GetParameters 4.0 - get dictionary entries"
	If dicImportdefinitions.Exists(sVersionImportdefinition) Then
		sVersionImportdefinition_forPath = dicImportdefinitions(sVersionImportdefinition)
	else
		bVersionNotFound = True
		sNotFoundMessage = "'" & sVersionImportdefinition & "'"
	end if
	
	If dicImportdefinitions.Exists(sColumnDelimiter) Then
		sColumnDelimiter_forPath = dicImportdefinitions(sColumnDelimiter)
	else
		bDelimiterNotFound = True
		If sNotFoundMessage = "" Then
			sNotFoundMessage = "'" & sColumnDelimiter & "'"
		Else
			sNotFoundMessage = sNotFoundMessage & " and " & "'" & sColumnDelimiter & "'"
		End If
	end if
	
	If bVersionNotFound Or bDelimiterNotFound Then
		Err.Raise Number:= 1000, Description:= "Unable to find dictionary entry for " & sNotFoundMessage & "."
	End If
SetCheckpoint "GetParameters 4.0 - get rdf"
	sKrm_Rdf = oSC.GetKnownLocationPath(11) & "\KRM_" & sVersionImportdefinition_forPath & "_" & sColumnDelimiter_forPath & ".rdf"
	if FileExists(sKrm_Rdf) = false then
		Err.Raise Number:= 1001, Description:= "Rdf-File could not be found: '" & sKrm_Rdf & "'"
	end if
	SmartContext.Log.LogMessage "Verwendete Importvorlage: " & sKrm_Rdf
	
	Set dicImportdefinitions = Nothing
end function
' --------------------------------------------------------------------------

' gets the file extension
function GetFileExtension(byval sFilePath as string) as string
dim fso as object
SetCheckpoint "GetFileExtension 1.0 - get extension for " & sFilePath
	Set fso = CreateObject("Scripting.FileSystemObject")
	GetFileExtension = UCase(fso.GetExtensionName(sFilePath))
	Set fso = nothing
end function
' --------------------------------------------------------------------------

' Start the import of the chosen file.
function Import
SetCheckpoint "Import 1.0 - create file name"
	sKRM_FileName = oSC.UniqueFileName("{KRM_mit_Summenzeile}.IMD")
SetCheckpoint "Import 1.1 - import file"
	Client.ImportCSVFile sInputFile, sKRM_FileName, FALSE, "", sKrm_Rdf, TRUE
SetCheckpoint "Import 1.2 - add imported file to ImportFiles"
	If Not SmartContext.ImportFiles.Contains(sKRM_FileAlias) Then SmartContext.RegisterDatabase sKRM_FileName, sKRM_FileAlias
end function
' --------------------------------------------------------------------------

' call the page setting service for select audit folder
Function SelectFolder
dim oPageSettingsService as object
Dim oSelectAuditFolderPageSettings As Object
SetCheckpoint "SelectFolder 1.0 - set objects"
	Set oPageSettingsService = SmartContext.GetServiceById("CirWizardPageSettingsService")
	Set oSelectAuditFolderPageSettings = oPageSettingsService.GetCirWizardPageSettings("SelectAuditFolder")	
	
	If oSelectAuditFolderPageSettings is Nothing Then
		SmartContext.Log.LogWarning "The settings object for the page SelectAuditFolder was not found."
	Else	
		oSelectAuditFolderPageSettings.Enabled = true
		'oSelectAuditFolderPageSettings.Inputs.Add "PeriodStart", ""
		'oSelectAuditFolderPageSettings.Inputs.Add "PeriodEnd", ""
	End If
	set oSelectAuditFolderPageSettings = Nothing
	set oPageSettingsService = Nothing
end function
' --------------------------------------------------------------------------

' checks whether a give file can be found
Function FileExists(ByVal sFileName As String) As Boolean
Dim oFso As Object
	FileExists = FALSE
	Set oFso = CreateObject("Scripting.FileSystemObject")
	If oFso.FileExists(sFileName) = TRUE Then
		FileExists = TRUE
	Else
		FileExists = FALSE
	End If
	Set oFso = Nothing
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
		
		SmartContext.Log.LogError "An error occurred in a special routine of '{0}'.{1}Error #{2}, Error Description: {3}{1}" + _
		                          "The last passed checkpoint was: {4}", _
		                          SmartContext.TestName, Chr(10), Err.Number, Err.Description, m_checkpointName

		If Len(extraInfo) > 0 Then
			SmartContext.Log.LogError "Additional error information: " & extraInfo
		End If
	End If
	
	Call EndSequenze
End Sub
' --------------------------------------------------------------------------

' cleans the memory and ends the script
Function EndSequenze
	Set oMC = Nothing
	Set oSC = Nothing
	Set oTM = Nothing
	Set oPip = Nothing
	Set oPara = Nothing
	
	stop
End Function

