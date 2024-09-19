'--------------------------------------------------------------------------------
' changed by:	
' changed on:	
' description:	
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
Dim oPara as object
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

'#Region - Dialog
Dim sInputFolder as string
dim sTempFolder as string
dim sVersion_ImportDefinition as string
dim sColumnDelimiter as string
dim sDataExportDate as string
dim bKRM as boolean
dim bKGW as boolean
'#End Region
Sub Main()
	On Error GoTo ErrHandler:
	
	SetCheckpoint "Begin of Sub Main()"
	
	SmartContext.Log.LogMessage "Pre-Macro of Import Routine '{0}'", SmartContext.TestName
	SmartContext.Log.LogMessage "Import Routine Version = {0}", SmartContext.TestVersion
	SmartContext.Log.LogMessage "Starting Time: {0}", Format(Now(), "yyyy-MM-dd hh:mm:ss")
	
	' Please check whether the variables below are really needed.
	' Remove all unnecessary variables and this comment too
	Set oMC = SmartContext.MacroCommands
	Set oSC = oMC.SimpleCommands
	Set oTM = oMC.TagManagement
	Set oPip = oMC.ProtectIP
	Set oPara = oMC.GlobalParameters

	' **** Add your code below this line
	Call FileSearchDialog
	Call SaveParameters
	
	' **** End of the user specific code
	Dim CompareResult As Long
	If oSC.TryCompareVersions("12.0.0", oSC.IDEAVersion, CompareResult) Then
		Select Case CompareResult
			Case -1, 0
			SmartContext.TriggerImport = True
			Case Else
			MsgBox("Ihre Eingaben wurden gespeichert." & Chr(13) & _
		"Bitte klicken Sie auf Importieren, um die Aufbereitung zu starten.")
		End Select
	End If
	SmartContext.Log.LogMessage "Execution Time End: " & Now()
	
	SmartContext.ExecutionStatus = EXEC_STATUS_SUCCEEDED
	
	SetCheckpoint "End of Sub Main()"
	
	Set oMC = nothing
	Set oSC = nothing
	Set oTM = nothing
	Set oPip = nothing
	Set oPara = nothing
	
	SmartContext.Log.LogMessage "Pre-macro ends at: {0}", Format(Now(), "yyyy-MM-dd hh:mm:ss")
	
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

' Opens the dialog to choose a text file

function FileSearchDialog
dim dialogInvoker as object
dim args as object
dim dict as object
dim result as object
	
SetCheckpoint "FileSearchDialog 1.0 - Set MacroDialogInvoker"
	
	Set dialogInvoker = SmartContext.GetServiceById("MacroDialogInvoker")
	if dialogInvoker is nothing then
		SmartContext.Log.LogError "The MacroDialogInvoker is missing."
		
		Set dialogInvoker = nothing
		Call EndSequenze
	end if
	
SetCheckpoint "FileSearchDialog 2.0 - pass additional args"
	
	Set args = dialogInvoker.NewTaskParameters
	Set dict = oSC.CreateHashtable
	dict.Add "SmartContextKey", SmartContext
	
	args.Inputs.Add "smartDataExchanger", dict
	
SetCheckpoint "FileSearchDialog 3.0 - open dialog"
	
	Set result = dialogInvoker.PerformTask("FileSearch", args)
	
	if result.ALLOK then
SetCheckpoint "FileSearchDialog 4.1 - result ALLOK"
		sInputFolder = result.Outputs.Item("sTB_FilePath")
		sDataExportDate = result.Outputs.Item("sTB_DataExportDate")
		bKRM = result.Outputs.Item("sCB_KRM").Checked
		bKGW = result.Outputs.Item("sCB_KGW").Checked
		if result.Outputs.Contains("smartDataExchanger") then
			dim sde as object
			set sde = result.Outputs.Item("smartDataExchanger").Value
			if sde.Contains("ImpDef") then sVersion_ImportDefinition = sde.Item("ImpDef")
			if sde.Contains("ColDel") then sColumnDelimiter = sde.Item("ColDel")
			If sde.Contains("TempFolder") And sde.Item("TempFolder") <> "" Then 
				sInputFolder = sde.Item("TempFolder")
				sTempFolder = sde.Item("TempFolder")
			end if
			set sde = nothing
		end if
	else
SetCheckpoint "FileSearchDialog 4.2 - result abort"
		msgbox("Die Importroutine wurde abgebrochen.")
		SmartContext.ExecutionStatus = EXEC_STATUS_CANCELED
		SmartContext.Log.LogWarning "User closed dialog."
		SmartContext.AbortImport = True
		
		Stop
	end if
	
	Set dialogInvoker = nothing
	Set args = nothing
	Set dict = nothing
	Set result = nothing
end function

' --------------------------------------------------------------------------

function SaveParameters
SetCheckpoint "SaveParameters 1.0 - delete project parameters"
	oPara.Delete4Project "FolderPath"
	oPara.Delete4Project "ImpDef"
	oPara.Delete4Project "ColDel"
	oPara.Delete4Project "ExportDate"
	oPara.Delete4Project "PrepareKRM"
	oPara.Delete4Project "PrepareKGW"
	oPara.Delete4Project "TempFolder"
SetCheckpoint "SaveParameters 2.0 - save project parameters"
	oPara.Set4Project "FolderPath", sInputFolder
	oPara.Set4Project "ImpDef", sVersion_ImportDefinition
	oPara.Set4Project "ColDel", sColumnDelimiter
	oPara.Set4Project "ExportDate", sDataExportDate
	oPara.Set4Project "PrepareKRM", bKRM
	oPara.Set4Project "PrepareKGW", bKGW
	oPara.Set4Project "TempFolder", sTempFolder
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
		
		SmartContext.Log.LogError "An error occurred in the pre-macro of '{0}'.{1}Error #{2}, Error Description: {3}{1}" + _
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
	Set oPip = nothing
	Set oPara = nothing
	
	stop
end function
