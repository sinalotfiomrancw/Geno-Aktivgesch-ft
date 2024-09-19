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
Dim sInputFolder as string
dim sTempFolder as string
' --- KRM ---
dim sKRM_FileName as string
' --- Kreditgewährung ---
dim sKreditbeschlussbuch_FileName as string
dim sSchufaNegativmerkmale_FileName as string
'#End Region

'#Region - Importdefinitions
Const sAuxAppFolder as string = "\Geno_Aktivgeschaeft"
dim sKrm_Rdf as string
dim sKBB_Rdf as string
dim sSNM_Rdf as string
'#End Region

'#Region - Files Alias
Const sKRM_FileAlias As String = "KRM_SUM"
Const sKreditbeschlussbuch_FileAlias as string = "KBB"
Const sSchufaNegativmerkmale_FileAlias as string = "SNM"
'#End Region

'#Region - File Search Pattern
Const sKRM_Pattern as string = "*KRM*"
Const sKreditbeschlussbuch_Pattern as string = "*Kreditbeschl*"
Const sSchufaNegativmerkmale_Pattern as string = "*Schufa*"
'#End Region

'#Region - imported files
dim sKBB_FileName as string
dim sSNM_FileName as string
Const sKBB_FileAlias as string = "KBB"
Const sSNM_FileAlias as string = "SNM"
dim bKBB_FileValid as boolean
dim bSNM_FileValid as boolean
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
	Call SearchForFiles
	Call SelectFolder
	if sTempFolder <> "" then Call DeleteTempFolder()
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
	sInputFolder = oPara.Get4Project("FolderPath")
	sTempFolder = oPara.Get4Project("TempFolder")
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
	sKrm_Rdf = oSC.GetKnownLocationPath(11) & sAuxAppFolder & "\KRM_" & sVersionImportdefinition_forPath & "_" & sColumnDelimiter_forPath & ".rdf"
	if FileExists(sKrm_Rdf) = false then
		Err.Raise Number:= 1001, Description:= "Rdf-File could not be found: '" & sKrm_Rdf & "'"
	end if
	SmartContext.Log.LogMessage "Verwendete Importvorlage KRM: " & sKrm_Rdf
	'---------------------------------------------------------------------------------------------------------------------------------
	sKBB_Rdf = oSC.GetKnownLocationPath(11) & sAuxAppFolder & "\KBB_" & "11092023" & "_" & sColumnDelimiter_forPath & ".rdf"
	if FileExists(sKBB_Rdf) = false then
		Err.Raise Number:= 1001, Description:= "Rdf-File could not be found: '" & sKBB_Rdf & "'"
	end if
	SmartContext.Log.LogMessage "Verwendete Importvorlage KBB: " & sKBB_Rdf
	'---------------------------------------------------------------------------------------------------------------------------------
	sSNM_Rdf = oSC.GetKnownLocationPath(11) & sAuxAppFolder & "\SNM_" & "11092023" & "_" & sColumnDelimiter_forPath & ".rdf"
	if FileExists(sSNM_Rdf) = false then
		Err.Raise Number:= 1001, Description:= "Rdf-File could not be found: '" & sSNM_Rdf & "'"
	end if
	SmartContext.Log.LogMessage "Verwendete Importvorlage SNM: " & sSNM_Rdf
	'---------------------------------------------------------------------------------------------------------------------------------
	Set dicImportdefinitions = Nothing
end function
' --------------------------------------------------------------------------

' searches the selected folder for files that can be prepared with the cir
function SearchForFiles
'--------------------------------------------------------------------------------
	sKRM_FileName = sInputFolder & "\" & Dir(sInputFolder & "\" & sKRM_Pattern & ".*")
	if FileExists(sKRM_FileName) then
		Call Import(sKRM_FileName, GetFileExtension(sKRM_FileName), "@{KRM_mit_Summenzeile}", sKRM_FileAlias, sKRM_RDF)
	Else
		SmartContext.Log.LogWarning "KRM file not found."
	end if
'--------------------------------------------------------------------------------
	sKreditbeschlussbuch_FileName = sInputFolder & "\" & Dir(sInputFolder & "\" & sKreditbeschlussbuch_Pattern & ".*")
	if FileExists(sKreditbeschlussbuch_FileName) then
		Call Import(sKreditbeschlussbuch_FileName, GetFileExtension(sKreditbeschlussbuch_FileName), "@{Kreditbeschlussbuch}", sKreditbeschlussbuch_FileAlias, sKBB_Rdf)
	else
		SmartContext.Log.LogWarning "Kreditbeschlussbuch file not found."
	end if
'--------------------------------------------------------------------------------
	sSchufaNegativmerkmale_FileName = sInputFolder & "\" & Dir(sInputFolder & "\" & sSchufaNegativmerkmale_Pattern & ".*")
	if FileExists(sSchufaNegativmerkmale_FileName) then
		Call Import(sSchufaNegativmerkmale_FileName, GetFileExtension(sSchufaNegativmerkmale_FileName), "@{Schufa Negativmerkmale}", sSchufaNegativmerkmale_FileAlias, sSNM_Rdf)
	else
		SmartContext.Log.LogWarning "SchufaNegativmerkmale file not found."
	end if
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
Function Import(ByVal sFile As String, ByVal sFileExtension, ByVal sIDEAFileName As String, ByVal sAlias As String, ByVal sImportDefinition As String)
SetCheckpoint "Import 1.0 - Check File Format for Import"
	select Case sFileExtension
		Case "csv", "txt"
			SetCheckpoint "Import 1.1 - import file (csv)"
			Client.ImportCSVFile sFile, oSC.UniqueFileName(sIDEAFileName), FALSE, "", sImportDefinition, TRUE
		Case "xlsx", "xls"
			Set task = Client.GetImportTask("ImportExcel")
			task.FileToImport = sFile
			task.SheetToImport = "Tabelle1"
			task.OutputFilePrefix = sIDEAFileName
			task.FirstRowIsFieldName = "TRUE"
			task.EmptyNumericFieldAsZero = "TRUE"
			task.UniqueFilePrefix
			task.PerformTask
			sIDEAFileName = task.OutputFilePath("Tabelle1")
			Set task = Nothing
		Case else
			SmartContext.Log.LogError sFile & " : Format ist not supported. File could not be imported."
	end select

SetCheckpoint "Import 1.2 - add imported file to ImportFiles"
	If Not SmartContext.ImportFiles.Contains(sAlias) Then SmartContext.RegisterDatabase sIDEAFileName, sAlias
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
End Function
' --------------------------------------------------------------------------

' if temp folder was created to import utf 16 files it has to be deleted
function DeleteTempFolder
Dim oFso As Object
dim oFolder as Object
Dim oFile As Object
Dim sFileName As String
On Error Resume Next
	Set oFso = CreateObject("Scripting.FileSystemObject")
	Set oFolder = oFso.GetFolder(sTempFolder)
	For Each oFile In oFolder.Files
		sFileName = sTempFolder & "\" & oFile.Name
		Kill sFileName
	Next
	set oFso = nothing
	Set oFolder = Nothing
	Set oFile = Nothing
	RmDir sTempFolder
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

