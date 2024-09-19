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

Dim sGEB_GRÜND_DATUM as string
dim sHERKUNFT as string
dim sGEWERBLICH_PRIVAT as string
Const sColumnConspicuous As String = "AUFFÄLLIG"
Dim sChangeOfRV As String
Dim sGK_KD_RV_EUR As String
Dim sDATUM_DATENABZUG As String
Dim sKUNDENNUMMER As String
Dim sEQN_SAMECUSTOMER As String
Dim sHigherRVWithRiskSector As String
Dim sGK_KD_ÜBERZ_EUR As String
Dim sZUSAGE As String
'#End Region

'#Region - Folder
dim sWorkingFolderPath as string
dim sWorkingFolderName as string
'#End Region

'#Region - result files
Dim sNew_Credits_For_Startups As String
Dim sNew_Credits_For_Startups_PC As String
'#End Region

'#Region - dialog
dim sFoundation_Date as string
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
	'Call Analysis
	Call Analysis_Per_Customer
	Call registerResult(sInputFile, INPUT_DATABASE, 0)
	'Call registerResult(sNew_Credits_For_Startups, FINAL_RESULT, 1)
	Call registerResult(sNew_Credits_For_Startups_PC, FINAL_RESULT, 1)
	' **** End of the user specific code
	
	SmartContext.ExecutionStatus = EXEC_STATUS_SUCCEEDED
	
	SetCheckpoint "End of Sub Main()"
	
	Set oMC = nothing
	Set oSC = nothing
	Set oTM = nothing
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
	sGEB_GRÜND_DATUM = oTM.GetFieldForTag(db, "acc!GEB_GRUEND_DATUM")
	sGEWERBLICH_PRIVAT = oTM.GetFieldForTag(db, "acc!GEWERBLICH_PRIVAT")
'	sHERKUNFT = oTM.GetFieldForTag(db, "acc!HERKUNFT")
	sGK_KD_RV_EUR = oTM.GetFieldForTag(db, "acc!GK_KD_RV_EUR")
	sDATUM_DATENABZUG = oTM.GetFieldForTag(db, "acc!DATUM_DATENABZUG")
	sKUNDENNUMMER = oTM.GetFieldForTag(db, "acc!KUNDENNUMMER")
	sGK_KD_ÜBERZ_EUR = oTM.GetFieldForTag(db, "acc!GK_KD_UEBERZ_EUR")
	sZUSAGE = "ZUSAGE"
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
	If oDialogPara.Contains("sTB_Geb_Gruend_Date") Then sFoundation_Date = Format$(oDialogPara.Item("sTB_Geb_Gruend_Date"), "yyyymmdd")
End Function
' --------------------------------------------------------------------------

' Filters the input table.
Function Analysis
SetCheckpoint "Analysis 1.0 - create "
	Set db = Client.OpenDatabase(sInputFile)
	Set task = db.Extraction
	'task.IncludeAllFields
	task.AddFieldToInc "DATUM_DATENABZUG"
	task.AddFieldToInc "NETTO_ENGAGEMENT"
	task.AddFieldToInc "KUNDENGRUPPEN_NR"
	task.AddFieldToInc "ENGAGEMENTBEZ"
	task.AddFieldToInc "KUNDENNUMMER"
	task.AddFieldToInc "KUNDENNAME"
	task.AddFieldToInc "RISIKOGRUPPE"
	task.AddFieldToInc "RISIKOGRUPPE_ENGA"
	task.AddFieldToInc "BONITÄTSEINSTUFUNG"
	task.AddFieldToInc "BONITÄTSEINST_ENGA"
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
	task.AddFieldToInc "KPM_BERÜCKS_KD_RS"
	task.AddFieldToInc "LÄNDERSCHLÜSSEL"
	task.AddFieldToInc "KUNDE_SEIT_DATUM"
	task.AddFieldToInc "GEB_GRÜND_DATUM"
	task.AddFieldToInc "RISIKOSTATUS_MAK"
	task.AddFieldToInc "RISIKOKENNZEICHEN"
	task.AddFieldToInc "ÜBERZ_ENG_BASEL_EUR"
	task.AddFieldToInc "TAGE_ÜBERZ_ENG_BASEL"
	task.AddFieldToInc "GK_ENGA_ÜBERZ_EUR"
	task.AddFieldToInc "TAGE_ÜBERZ_ENGA"
	task.AddFieldToInc "JAHRESABSCHLUSSDATUM"
	task.AddFieldToInc "VR_RATING_NUM"
	task.AddFieldToInc "VR_RATING_ENGA_NUM"
	sNew_Credits_For_Startups = oSC.UniqueFileName(sWorkingfolderName & "Kreditvergabe an Existenzgründer", FINAL_RESULT)
	task.AddExtraction sNew_Credits_For_Startups, "", sGEB_GRÜND_DATUM & " >= """ & sFoundation_Date & """ .AND. " & sGEWERBLICH_PRIVAT & " == ""Gewerblich"""
	task.DisableProgressNotification = True
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
end function
' --------------------------------------------------------------------------

Function Analysis_Per_Customer
sEQN_SAMECUSTOMER = " .AND. " & sKUNDENNUMMER & "==@GetPreviousValue(""" & sKUNDENNUMMER & """)"

	Set db = Client.OpenDatabase(sInputFile)
	If Not oSC.FieldExists(db, sZUSAGE) Then
		Set task = db.TableManagement
		Set field = db.TableDef.NewField
		field.Name = sZUSAGE
		field.Description = sGK_KD_RV_EUR & " - " & sGK_KD_ÜBERZ_EUR
		field.Type = WI_VIRT_NUM
		field.Equation = sGK_KD_RV_EUR & " - " & sGK_KD_ÜBERZ_EUR
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
	'task.AddFieldToInc "DATUM_DATENABZUG"
	task.AddFieldToInc "NETTO_ENGAGEMENT"
	task.AddFieldToInc "KUNDENGRUPPEN_NR"
	task.AddFieldToInc "ENGAGEMENTBEZ"
	task.AddFieldToInc "KUNDENNAME"
	task.AddFieldToInc "RISIKOGRUPPE"
	task.AddFieldToInc "RISIKOGRUPPE_ENGA"
	task.AddFieldToInc "BONITÄTSEINSTUFUNG"
	task.AddFieldToInc "BONITÄTSEINST_ENGA"
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
	task.AddFieldToInc "KPM_BERÜCKS_KD_RS"
	task.AddFieldToInc "LÄNDERSCHLÜSSEL"
	task.AddFieldToInc "KUNDE_SEIT_DATUM"
	task.AddFieldToInc "GEB_GRÜND_DATUM"
	task.AddFieldToInc "RISIKOSTATUS_MAK"
	task.AddFieldToInc "RISIKOKENNZEICHEN"
	task.AddFieldToInc "ÜBERZ_ENG_BASEL_EUR"
	task.AddFieldToInc "TAGE_ÜBERZ_ENG_BASEL"
	task.AddFieldToInc "GK_ENGA_ÜBERZ_EUR"
	task.AddFieldToInc "TAGE_ÜBERZ_ENGA"
	task.AddFieldToInc "JAHRESABSCHLUSSDATUM"
	task.AddFieldToInc "VR_RATING_NUM"
	task.AddFieldToInc "VR_RATING_ENGA_NUM"
	task.AddFieldToInc sZUSAGE
	sChangeOfRV = oSC.UniqueFileName(sWorkingFolderPath & "KRM-Übersicht pro Kundennummer und Datum_Datenabzug", INTERMEDIATE_RESULT)
	task.OutputDBName = sChangeOfRV
	task.CreatePercentField = FALSE
	task.UseFieldFromFirstOccurrence = TRUE
	task.DisableProgressNotification = True
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing
	
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
	
	SetCheckpoint "Analysis 2.3 - "
	field.Name = "VORHERIGES_ZUSAGE"
	field.Description = "ZUSAGE aus vorherigem Zeitpunkt"
	field.Type = WI_VIRT_NUM
	field.Equation = "@if(" & sColumnConspicuous & " = ""X""" & sEQN_SAMECUSTOMER & "; @GetPreviousValue(""" & sZUSAGE & """); 0)"
	field.Decimals = 2
	task.AppendField field
	task.DisableProgressNotification = True
	task.PerformTask
	
	Dim sEQN_HigherRVWithRiskSector As String
	sEQN_HigherRVWithRiskSector = "AUFFÄLLIG = ""X"" "
SetCheckpoint "Analysis 3.1 - "
	Set db = Client.OpenDatabase(sChangeOfRV)
	Set task = db.Extraction
	task.IncludeAllFields
	sHigherRVWithRiskSector = oSC.UniqueFileName(sWorkingFolderPath & "erhöhtes Zusage pro Kunde", INTERMEDIATE_RESULT)
	task.AddExtraction sHigherRVWithRiskSector, "", sEQN_HigherRVWithRiskSector
	task.DisableProgressNotification = True
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
	
	SetCheckpoint "Analysis 1.0 - create "
	Set db = Client.OpenDatabase(sHigherRVWithRiskSector)
	Set task = db.Extraction
	task.AddFieldToInc sKUNDENNUMMER
	task.AddFieldToInc sDATUM_DATENABZUG
	task.AddFieldToInc "ANZ_SAETZE"
	task.AddFieldToInc sZUSAGE
	task.AddFieldToInc "VORHERIGES_ZUSAGE"
	task.AddFieldToInc "GEB_GRÜND_DATUM"
	task.AddFieldToInc "GEWERBLICH_PRIVAT"
	task.AddFieldToInc "NETTO_ENGAGEMENT"
	task.AddFieldToInc "KUNDENGRUPPEN_NR"
	task.AddFieldToInc "ENGAGEMENTBEZ"
	task.AddFieldToInc "KUNDENNAME"
	task.AddFieldToInc "RISIKOGRUPPE"
	task.AddFieldToInc "RISIKOGRUPPE_ENGA"
	task.AddFieldToInc "BONITÄTSEINSTUFUNG"
	task.AddFieldToInc "BONITÄTSEINST_ENGA"
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
	task.AddFieldToInc "RECHTSFORM"
	task.AddFieldToInc "BRANCHE"
	task.AddFieldToInc "KPM_BRANCHE"
	task.AddFieldToInc "KPM_BERÜCKS_KD_RS"
	task.AddFieldToInc "LÄNDERSCHLÜSSEL"
	task.AddFieldToInc "KUNDE_SEIT_DATUM"
	task.AddFieldToInc "RISIKOSTATUS_MAK"
	task.AddFieldToInc "RISIKOKENNZEICHEN"
	task.AddFieldToInc "ÜBERZ_ENG_BASEL_EUR"
	task.AddFieldToInc "TAGE_ÜBERZ_ENG_BASEL"
	task.AddFieldToInc "GK_ENGA_ÜBERZ_EUR"
	task.AddFieldToInc "TAGE_ÜBERZ_ENGA"
	task.AddFieldToInc "JAHRESABSCHLUSSDATUM"
	task.AddFieldToInc "VR_RATING_NUM"
	task.AddFieldToInc "VR_RATING_ENGA_NUM"
	sNew_Credits_For_Startups_PC = oSC.UniqueFileName(sWorkingfolderName & "Neukreditvergaben an Existenzgründer aus mehrperiodigen KRM", FINAL_RESULT)
	task.AddExtraction sNew_Credits_For_Startups_PC, "", sGEB_GRÜND_DATUM & " >= """ & sFoundation_Date & """ .AND. " & sGEWERBLICH_PRIVAT & " == ""Gewerblich"""
	task.DisableProgressNotification = True
	task.PerformTask 1, db.Count
	db.Close
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
	Set oDialogPara = Nothing
	
	exit sub
end function
