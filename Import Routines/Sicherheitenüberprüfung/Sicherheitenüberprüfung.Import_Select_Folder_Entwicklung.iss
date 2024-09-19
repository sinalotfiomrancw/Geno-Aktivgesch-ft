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
' --- Files ---
dim sSB_FileName as string
dim sSBI_FileName as string
dim sSBH_FileName as string
dim sSZR_FileName as string
dim sSZS_FileName as string
'#End Region

'#Region - Files
dim bSi_Bas as boolean
dim bSi_Bas_Immo as boolean
dim bSi_Buerg_Haft as boolean
dim bSi_Zwek_RK as boolean
dim bSi_Zwek_Si_Wert as boolean
'#End Region

'#Region - Importdefinitions
Const sAuxAppFolder As String = "\Geno_Aktivgeschaeft"
Dim vbTab As String
Dim sSB_Rdf As String
Dim sSBI_Rdf As String
dim sSBH_Rdf as string
dim sSZR_Rdf as string
dim sSZS_Rdf as string
Dim sCBZ_Rdf As String
Dim sSBZ_Rdf As String
Dim sColumnDelimiter_SB As String
Dim sColumnDelimiter_SBI As String
Dim sColumnDelimiter_SBH As String
Dim sColumnDelimiter_SZR As String
Dim sColumnDelimiter_SZS As String
'#End Region

'#Region - Files Alias
Const sBas_FileAlias As String = "SB"
Const sBas_Immo_FileAlias As String = "SBI"
Const sBuerg_Haft_FileAlias As String = "SBH"
Const sZwek_RK_FileAlias As String = "SZR"
Const sZwek_Si_Wert_FileAlias As String = "SZS"
Const sCodes_Bezeichnungen_FileAlias As String = "CBZ"
Const sCodes_Sicherheitenart_FileAlias As String = "SBZ"
'#End Region

'#Region - File Search Pattern
Const sBas_Pattern as string = "*Basisdaten*"
Const sBas_Immo_Pattern as string = "*Immo*"
Const sBuerg_Haft_Pattern as string = "*Bürgschaften*"
Const sZwek_RK_Pattern as string = "*Realkredit*"
Const sZwek_Si_Wert_Pattern as string = "*Si-Wert*"
Dim sFirstSBFileName As String
Dim sCodesBzFileName as String
Dim sSBzFileName as String
'#End Region

'#Region - imported files

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
	IgnoreWarning(True)
	Call GetParameters
	Call SearchForFiles
	'Call SelectFolder
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
	bSi_Bas = oPara.Get4Project("PrepareBAS")
	bSi_Bas_Immo = oPara.Get4Project("PrepareBASIMO")
	bSi_Buerg_Haft = oPara.Get4Project("PrepareBUEHAFT")
	bSi_Zwek_RK = oPara.Get4Project("PrepareZWERK")
	bSi_Zwek_Si_Wert = oPara.Get4Project("PrepareZWEWE")
end function
' --------------------------------------------------------------------------

' searches the selected folder for files that can be prepared with the cir
function SearchForFiles
'--------------------------------------------------------------------------------
	sCBZ_Rdf = oSC.GetKnownLocationPath(11) & sAuxAppFolder & "\Codes und Bezeichnungen aus den Sicherheiten.RDF"
	sCodesBzFileName = oSC.GetKnownLocationPath(11) & sAuxAppFolder & "\Codes und Bezeichnungen aus den Sicherheiten.csv"
	If FileExists(sCodesBzFileName) Then
		Call Import(sCodesBzFileName, GetFileExtension(sCodesBzFileName), "{Codes und Bezeichnungen aus den Sicherheiten}.IMD", sCodes_Bezeichnungen_FileAlias, sCBZ_Rdf)
	Else
		SmartContext.Log.LogWarning "Codes_Bezeichnungen file not found."
	End if
'--------------------------------------------------------------------------------
	sSBZ_Rdf = oSC.GetKnownLocationPath(11) & sAuxAppFolder & "\Sicherheitenartenschlüssel mit Bezeichnung.RDF"
	sSBzFileName = oSC.GetKnownLocationPath(11) & sAuxAppFolder & "\Sicherheitenartenschlüssel mit Bezeichnung.csv"
	If FileExists(sSBzFileName) Then
		Call Import(sSBzFileName, GetFileExtension(sSBzFileName), "{Sicherheitenartenschlüssel mit Bezeichnung}.IMD", sCodes_Sicherheitenart_FileAlias, sSBZ_Rdf)
	Else
		SmartContext.Log.LogWarning "Codes_Bezeichnungen file not found."
	End if
'--------------------------------------------------------------------------------
	If bSi_Bas Then
		sFirstSBFileName = GetFirstSBFile(sInputFolder, "Basis", "Immo")
		sSB_FileName = sInputFolder & "\" & sFirstSBFileName
		SmartContext.Log.LogMessage "Found SB-File: " & sSB_FileName
		If FileExists(sSB_FileName) Then
			Call GetParametersSB(sSB_FileName, GetFileExtension(sSB_FileName))
			Call Import(sSB_FileName, GetFileExtension(sSB_FileName), "{Sicherheiten_Basisdaten}.IMD", sBas_FileAlias, sSB_Rdf)
		Else
			SmartContext.Log.LogWarning "SB file not found."
		end if
	End If
'--------------------------------------------------------------------------------
	If bSi_Bas_Immo Then
		sSBI_FileName = sInputFolder & "\" & Dir(sInputFolder & "\" & sBas_Immo_Pattern & ".*")
		SmartContext.Log.LogMessage "Found SBI-File: " & sSBI_FileName
		If FileExists(sSBI_FileName) Then
			Call GetParametersSBI(sSBI_FileName, GetFileExtension(sSBI_FileName))
			Call Import(sSBI_FileName, GetFileExtension(sSBI_FileName), "{Sicherheiten_Basisdaten_Immo}.IMD", sBas_Immo_FileAlias, sSBI_Rdf)
		Else
			SmartContext.Log.LogWarning "SBI file not found."
		End If
	End If
'--------------------------------------------------------------------------------
	If bSi_Buerg_Haft Then
		sSBH_FileName = sInputFolder & "\" & Dir(sInputFolder & "\" & sBuerg_Haft_Pattern & ".*")
		SmartContext.Log.LogMessage "Found SBH-File: " & sSBH_FileName
		If FileExists(sSBH_FileName) Then
			Call GetParametersSBH(sSBH_FileName, GetFileExtension(sSBH_FileName))
			Call Import(sSBH_FileName, GetFileExtension(sSBH_FileName), "{Sicherheiten_Bürgschaften_Haftungsfreistellungen}.IMD", sBuerg_Haft_FileAlias, sSBH_Rdf)
		Else
			SmartContext.Log.LogWarning "SBH file not found."
		End If
	End If
'--------------------------------------------------------------------------------
	If bSi_Zwek_RK Then
		sSZR_FileName = sInputFolder & "\" & Dir(sInputFolder & "\" & sZwek_RK_Pattern & ".*")
		SmartContext.Log.LogMessage "Found SZR-File: " & sSZR_FileName
		If FileExists(sSZR_FileName) Then
			Call GetParametersSZR(sSZR_FileName, GetFileExtension(sSZR_FileName))
			Call Import(sSZR_FileName, GetFileExtension(sSZR_FileName), "{Sicherheiten_Zweckerklärungen_Realkredit}.IMD", sZwek_RK_FileAlias, sSZR_Rdf)
		Else
			SmartContext.Log.LogWarning "SZR file not found."
		End If
	End If
'--------------------------------------------------------------------------------
	If bSi_Zwek_Si_Wert Then
		sSZS_FileName = sInputFolder & "\" & Dir(sInputFolder & "\" & sZwek_Si_Wert_Pattern & ".*")
		SmartContext.Log.LogMessage "Found SZS-File: " & sSZS_FileName
		If FileExists(sSZS_FileName) Then
			Call GetParametersSZS(sSZS_FileName, GetFileExtension(sSZS_FileName))
			Call Import(sSZS_FileName, GetFileExtension(sSZS_FileName), "{Sicherheiten_Zweckerklärungen_Si-Wert}.IMD", sZwek_Si_Wert_FileAlias, sSZS_Rdf)
		Else
			SmartContext.Log.LogWarning "SZS file not found."
		End If
	End If
'--------------------------------------------------------------------------------
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
Dim fileNameXLS As String
Dim sSheetName As String
SetCheckpoint "Import 1.0 - Check File Format for Import"
	select Case sFileExtension
		Case "csv", "txt"
			SetCheckpoint "Import 1.1 - import file (csv)"
			Client.ImportDelimFile sFile, sIDEAFileName, FALSE, "", sImportDefinition, TRUE
		Case "xlsx", "xls"
			msgbox("Das Excel-Format wird nicht unterstützt. Datei konnte nicht importiert werden.")
			'fileNameXLS = ExtractFileNameWithoutExtension(sFile)
			'Set task = Client.GetImportTask("ImportExcel")
			'task.FileToImport = sFile
			'sSheetName = Left(fileNameXLS, 31)
			'task.SheetToImport = sSheetName
			'task.OutputFilePrefix = sIDEAFileName
			'task.FirstRowIsFieldName = "TRUE"
			'task.EmptyNumericFieldAsZero = "TRUE"
			'task.UniqueFilePrefix
			'task.PerformTask
			'sIDEAFileName = task.OutputFilePath(sSheetName)
			'Set task = Nothing
		Case else
			SmartContext.Log.LogError sFile & " : Format ist not supported. File could not be imported."
	end select

SetCheckpoint "Import 1.2 - add imported file to ImportFiles"
	If Not SmartContext.ImportFiles.Contains(sAlias) Then SmartContext.RegisterDatabase sIDEAFileName, sAlias
	'SmartContext.RegisterDatabase sIDEAFileName, sAlias
End Function
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

Function GetParametersSB(ByVal filePath As String, ByVal sFileExtension As String)
Dim sContainer As String
Dim Filenum As Integer
Dim currentLine As String
	select Case sFileExtension
		Case "csv", "txt"
			SetCheckpoint "GetParametersSB 1.0 - get rdf"
			SmartContext.Log.LogMessage "Beginning of GetParametersSB"
			vbTab = Chr(9)
			Filenum = FreeFile
			SmartContext.Log.LogMessage "FreeFile Done"
			Open filePath For Input As Filenum
			SmartContext.Log.LogMessage "Openning File Done"
			Line Input #Filenum, currentLine
			SmartContext.Log.LogMessage "Reading the first line Done: " & currentLine
			sContainer = currentLine
			Close Filenum
			SmartContext.Log.LogMessage "Closing the File is Done"
			
			If InStr(1, sContainer, ";") > 0 Then
				sColumnDelimiter_SB = "Semicolon"
			Elseif InStr(1, sContainer, vbTab) > 0 Then
				sColumnDelimiter_SB = "Tab"
			Else
				SmartContext.Log.LogMessage "Weder Semikolons noch Tabs werden als Trennzeichen für SNM-Dateien erkannt"
			End If
			
			SetCheckpoint "GetParametersSB 2.0 - get rdf"
			sSB_Rdf = oSC.GetKnownLocationPath(11) & sAuxAppFolder & "\Sicherheiten_Basisdaten" & "_" & sColumnDelimiter_SB & ".rdf"
			
			if FileExists(sSB_Rdf) = false then
				Err.Raise Number:= 1001, Description:= "Rdf-File could not be found: '" & sSB_Rdf & "'"
			end if
			SmartContext.Log.LogMessage "Verwendete Importvorlage SB: " & sSB_Rdf
		Case else
			SmartContext.Log.LogMessage "SB-Format ist not csv or txt. skip this step."
	end select
'---------------------------------------------------------------------------------------------------------------------------------
End Function
' --------------------------------------------------------------------------

Function GetParametersSBI(ByVal filePath As String, ByVal sFileExtension As String)
Dim sContainer As String
Dim Filenum As Integer
Dim currentLine As String
	select Case sFileExtension
		Case "csv", "txt"
			SetCheckpoint "GetParametersSBI 1.0 - get rdf"
			SmartContext.Log.LogMessage "Beginning of GetParametersSBI"
			vbTab = Chr(9)
			Filenum = FreeFile
			SmartContext.Log.LogMessage "FreeFile Done"
			Open filePath For Input As Filenum
			SmartContext.Log.LogMessage "Openning File Done"
			Line Input #Filenum, currentLine
			SmartContext.Log.LogMessage "Reading the first line Done: " & currentLine
			sContainer = currentLine
			Close Filenum
			SmartContext.Log.LogMessage "Closing the File is Done"
			
			If InStr(1, sContainer, ";") > 0 Then
				sColumnDelimiter_SBI = "Semicolon"
			Elseif InStr(1, sContainer, vbTab) > 0 Then
				sColumnDelimiter_SBI = "Tab"
			Else
				SmartContext.Log.LogMessage "Weder Semikolons noch Tabs werden als Trennzeichen für SNM-Dateien erkannt"
			End If
			
			SetCheckpoint "GetParametersSBI 2.0 - get rdf"
			sSBI_Rdf = oSC.GetKnownLocationPath(11) & sAuxAppFolder & "\Sicherheiten_Basisdaten_Immo" & "_" & sColumnDelimiter_SBI & ".rdf"
			
			if FileExists(sSBI_Rdf) = false then
				Err.Raise Number:= 1001, Description:= "Rdf-File could not be found: '" & sSBI_Rdf & "'"
			end if
			SmartContext.Log.LogMessage "Verwendete Importvorlage SBI: " & sSBI_Rdf
		Case else
			SmartContext.Log.LogMessage "SBI-Format ist not csv or txt. skip this step."
	end select
'---------------------------------------------------------------------------------------------------------------------------------
End Function
' --------------------------------------------------------------------------

Function GetParametersSBH(ByVal filePath As String, ByVal sFileExtension As String)
Dim sContainer As String
Dim Filenum As Integer
Dim currentLine As String
	select Case sFileExtension
		Case "csv", "txt"
			SetCheckpoint "GetParametersSBH 1.0 - get rdf"
			SmartContext.Log.LogMessage "Beginning of GetParametersSBH"
			vbTab = Chr(9)
			Filenum = FreeFile
			SmartContext.Log.LogMessage "FreeFile Done"
			Open filePath For Input As Filenum
			SmartContext.Log.LogMessage "Openning File Done"
			Line Input #Filenum, currentLine
			SmartContext.Log.LogMessage "Reading the first line Done: " & currentLine
			sContainer = currentLine
			Close Filenum
			SmartContext.Log.LogMessage "Closing the File is Done"
			
			If InStr(1, sContainer, ";") > 0 Then
				sColumnDelimiter_SBH = "Semicolon"
			Elseif InStr(1, sContainer, vbTab) > 0 Then
				sColumnDelimiter_SBH = "Tab"
			Else
				SmartContext.Log.LogMessage "Weder Semikolons noch Tabs werden als Trennzeichen für SNM-Dateien erkannt"
			End If
			
			SetCheckpoint "GetParametersSBH 2.0 - get rdf"
			sSBH_Rdf = oSC.GetKnownLocationPath(11) & sAuxAppFolder & "\Sicherheiten_Bürgschaften_Haftungsfreistellungen" & "_" & sColumnDelimiter_SBH & ".rdf"
			
			if FileExists(sSBH_Rdf) = false then
				Err.Raise Number:= 1001, Description:= "Rdf-File could not be found: '" & sSBH_Rdf & "'"
			end if
			SmartContext.Log.LogMessage "Verwendete Importvorlage SBH: " & sSBH_Rdf
		Case else
			SmartContext.Log.LogMessage "SBH-Format ist not csv or txt. skip this step."
	end select
'---------------------------------------------------------------------------------------------------------------------------------
End Function
' --------------------------------------------------------------------------

Function GetParametersSZR(ByVal filePath As String, ByVal sFileExtension As String)
Dim sContainer As String
Dim Filenum As Integer
Dim currentLine As String
	select Case sFileExtension
		Case "csv", "txt"
			SetCheckpoint "GetParametersSZR 1.0 - get rdf"
			SmartContext.Log.LogMessage "Beginning of GetParametersSZR"
			vbTab = Chr(9)
			Filenum = FreeFile
			SmartContext.Log.LogMessage "FreeFile Done"
			Open filePath For Input As Filenum
			SmartContext.Log.LogMessage "Openning File Done"
			Line Input #Filenum, currentLine
			SmartContext.Log.LogMessage "Reading the first line Done: " & currentLine
			sContainer = currentLine
			Close Filenum
			SmartContext.Log.LogMessage "Closing the File is Done"
			
			If InStr(1, sContainer, ";") > 0 Then
				sColumnDelimiter_SZR = "Semicolon"
			Elseif InStr(1, sContainer, vbTab) > 0 Then
				sColumnDelimiter_SZR = "Tab"
			Else
				SmartContext.Log.LogMessage "Weder Semikolons noch Tabs werden als Trennzeichen für SNM-Dateien erkannt"
			End If
			
			SetCheckpoint "GetParametersSZR 2.0 - get rdf"
			sSZR_Rdf = oSC.GetKnownLocationPath(11) & sAuxAppFolder & "\Sicherheiten_Zweckerklärungen_Realkredit" & "_" & sColumnDelimiter_SZR & ".rdf"
			
			if FileExists(sSZR_Rdf) = false then
				Err.Raise Number:= 1001, Description:= "Rdf-File could not be found: '" & sSZR_Rdf & "'"
			end if
			SmartContext.Log.LogMessage "Verwendete Importvorlage SZR: " & sSZR_Rdf
		Case else
			SmartContext.Log.LogMessage "SZR-Format ist not csv or txt. skip this step."
	end select
'---------------------------------------------------------------------------------------------------------------------------------
End Function
' --------------------------------------------------------------------------

Function GetParametersSZS(ByVal filePath As String, ByVal sFileExtension As String)
Dim sContainer As String
Dim Filenum As Integer
Dim currentLine As String
	select Case sFileExtension
		Case "csv", "txt"
			SetCheckpoint "GetParametersSZS 1.0 - get rdf"
			
			SetCheckpoint "GetParametersSZS 1.0 - get rdf"
			SmartContext.Log.LogMessage "Beginning of GetParametersSZS"
			vbTab = Chr(9)
			Filenum = FreeFile
			SmartContext.Log.LogMessage "FreeFile Done"
			Open filePath For Input As Filenum
			SmartContext.Log.LogMessage "Openning File Done"
			Line Input #Filenum, currentLine
			SmartContext.Log.LogMessage "Reading the first line Done: " & currentLine
			sContainer = currentLine
			Close Filenum
			SmartContext.Log.LogMessage "Closing the File is Done"
			
			If InStr(1, sContainer, ";") > 0 Then
				sColumnDelimiter_SZS = "Semicolon"
			Elseif InStr(1, sContainer, vbTab) > 0 Then
				sColumnDelimiter_SZS = "Tab"
			Else
				SmartContext.Log.LogMessage "Weder Semikolons noch Tabs werden als Trennzeichen für SNM-Dateien erkannt"
			End If
			
			SetCheckpoint "GetParametersSZS 2.0 - get rdf"
			sSZS_Rdf = oSC.GetKnownLocationPath(11) & sAuxAppFolder & "\Sicherheiten_Zweckerklärungen_Si-Wert" & "_" & sColumnDelimiter_SZS & ".rdf"
			
			if FileExists(sSZS_Rdf) = false then
				Err.Raise Number:= 1001, Description:= "Rdf-File could not be found: '" & sSZS_Rdf & "'"
			end if
			SmartContext.Log.LogMessage "Verwendete Importvorlage SB: " & sSZS_Rdf
		Case else
			SmartContext.Log.LogMessage "SZS-Format ist not csv or txt. skip this step."
	end select
'---------------------------------------------------------------------------------------------------------------------------------
End Function
' --------------------------------------------------------------------------

Function GetFirstSBFile(path As String, includeStr As String, excludeStr As String) As String
    Dim filename As String
    Dim resultFilename As String
    
    ' Initialize the result filename to an empty string
    resultFilename = ""
    
    ' Initialize the search
    filename = Dir(path & "\" & "*")
    
    ' Loop through the directory
    Do While filename <> ""
        ' Check if the filename includes the specific string and does not include the other specific string
        If (InStr(1, LCase(filename), LCase(includeStr)) > 0) And (InStr(1, LCase(filename), LCase(excludeStr)) = 0) Then
            ' Save the matching filename and exit the loop
            resultFilename = filename
            Exit Do
        End If
        ' Get the next file
        filename = Dir
    Loop
    
    ' Return the result filename
    GetFirstSBFile = resultFilename
End Function
' --------------------------------------------------------------------------

Function NotValidKRMFormat() As String
dim dialogInvoker as object
dim args as object
dim dict as object
dim result as object
Dim sComboboxValue As String

SetCheckpoint "NotValidKRMFormat 1.0 - Set MacroDialogInvoker"
	
	Set dialogInvoker = SmartContext.GetServiceById("MacroDialogInvoker")
	if dialogInvoker is nothing then
		SmartContext.Log.LogError "The MacroDialogInvoker is missing."
		
		Set dialogInvoker = nothing
		Call EndSequenze
	end if
	
SetCheckpoint "NotValidKRMFormat 2.0 - pass additional args"
	
	Set args = dialogInvoker.NewTaskParameters
	Set dict = oSC.CreateHashtable
	dict.Add "SmartContextKey", SmartContext
	
	args.Inputs.Add "smartDataExchanger", dict
	
SetCheckpoint "NotValidKRMFormat 3.0 - open dialog"
	
	Set result = dialogInvoker.PerformTask("NotValidKRMFormat", args)
	
	if result.ALLOK then
SetCheckpoint "NotValidKRMFormat 4.1 - result ALLOK"
		sComboboxValue = result.Outputs.Item("smartComboBox1")
		If InStr(1, sComboboxValue, "2021") > 0 Then
			NotValidKRMFormat = "ddmm2021"
		Else
			NotValidKRMFormat = "17052022"
		End If
	else
SetCheckpoint "NotValidKRMFormat 4.2 - result abort"
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
End Function
' --------------------------------------------------------------------------

Function ExtractFileNameWithoutExtension(ByVal filePath As String) As String
    Dim pos As Integer
    Dim dotPos As Integer
    Dim fileName As String
    
    ' Find the position of the last backslash using CustomInStrRev
    pos = CustomInStrRev(filePath, "\")
    
    ' Extract the file name from that position
    If pos > 0 Then
        fileName = Mid(filePath, pos + 1)
    Else
        fileName = filePath
    End If
    
    ' Find the position of the last dot in the file name
    dotPos = CustomInStrRev(fileName, ".")
    
    ' If a dot is found, remove the extension
    If dotPos > 0 Then
        fileName = Left(fileName, dotPos - 1)
    End If
    
    ' Return the file name without extension
    ExtractFileNameWithoutExtension = fileName
End Function

' --------------------------------------------------------------------------
Function CustomInStrRev(ByVal s As String, ByVal subString As String) As Integer
    Dim i As Integer
    CustomInStrRev = 0
    For i = Len(s) To 1 Step -1
        If Mid(s, i, Len(subString)) = subString Then
            CustomInStrRev = i
            Exit Function
        End If
    Next i
End Function
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

