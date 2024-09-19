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
Dim oParameters As Object
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
Dim sInputFile As String
Dim sWorkingFolderPath As String
Dim sWorkingfolderName As String
Dim sSourceName As String
'#End Region

'#Region tags
Dim sPERSONEN_NR_SICHERHEITENGEBER As String
Dim sNAME_SICHERHEITENGEBER As String
Dim sSICHERHEIT_NR As String
Dim sSTATUS_BEARBEITUNG As String
Dim sSTATUS_SATZART As String
Dim sSICHERHEIT_ART As String
Dim sSICHERHEITENART_BEZEICHNUNG As String
Dim sSICHERHEITENWERT_VERTEILT_JURISTISCH As String
Dim sBELEIHUNGSWERT As String
Dim sBELEIHUNGSGRENZE_BETRAG As String
Dim sBELEIHUNGSGRENZE As String
Dim sBELEIHUNGSWERT_PER As String
Dim sBELEIHUNGSWERT_STATUS As String
Dim sBELEIHUNGSWERT_STATUS_PER As String
Dim sBELEIHUNGSWERT_WURDE_UEBERPRUEFT_AM As String
Dim sBELEIHUNGSWERT_UEBERPRUEFT_VON As String
Dim sEINZELRATING_DES_SICHERHEITENNEHMERS As String
Dim sNACHGEWIESENER_WERT As String
Dim sNACHGEWIESENER_WERT_PER As String
Dim sBW As String
Dim sANTEIL_SI_WERT_BWRK_1 As String
Dim sBERECHNETES_FELD_SUMME_JE_PERSON_AUS_FEL As String
Dim sKOMMENTAR_FREITEXTFELD_IN_DER_SICHERHEIT As String
Dim sBLANKOVOLUMEN_IA_EUR As String
Dim sRISIKOSTATUS_MARISK As String
Dim sRISIKOSTATUS_MARISK_SEIT As String
Dim sNUTZUNG As String
Dim sNUTZUNGSART As String
Dim sOBJEKTART As String
Dim sOBJEKTART_BEZEICHNUNG As String
Dim sIMMOBILIEN_NR As String
Dim sEINGETRAGENER_BETRAG_DER_GRUNDSCHULD_NOM As String
Dim sERMITTLUNG_KLEINDARLEHENSGRENZE_JA_NEIN  As String
Dim sVERFUEGBARER_SICHERUNGSWERT As String
Dim sVERFUEGBARER_SICHERUNGSWERT_VOM As String
Dim sFEUERVERSICHERUNGSSCHEIN_NR As String
Dim sDIE_QUALITATIVEN_ANFORDERUNGEN_SIND_ERFU As String
'#End Region

'#Region Analysis and Result
Dim sSicherheiten_MaRisk_Immobilien As String
Dim sSicherheiten_MaRisk_Immobilien_Filter_Sicherheitenart As String
Dim sSicherheitenart As String
Dim sBWBR As String
Dim sUEDBR As String
Dim sSum_BG_ImNr As String
Dim sFilterParam As String
'#Region Analysis and Result

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
	
	' **** Add your code below this line
	IgnoreWarning(True)
	sSourceName = SmartContext.PrimaryInputFile
	Call GetFileInformation
	Call Analysis
	Call registerResult(sSourceName, INPUT_DATABASE, 0)
	Call registerResult(sSicherheiten_MaRisk_Immobilien, FINAL_RESULT, 1)
	
	' **** End of the user specific code
	
	SmartContext.ExecutionStatus = EXEC_STATUS_SUCCEEDED
	
	SmartContext.Log.LogMessage "Audit test run ends at: {0}", Format(Now(), "yyyy-MM-dd hh:mm:ss")
	
	Exit Sub
	
ErrHandler:
	Call LogSmartAnalyzerError("")
End Sub
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

' Gets the input file and the tags.
Function GetFileInformation
SetCheckpoint "GetFileInformation 1.0 - get primary input file"
	sInputFile = SmartContext.PrimaryInputfile
SetCheckpoint "GetFileInformation 1.1 - get working folder"
	Call GetWorkingFolder(sInputFile)
SetCheckpoint "GetFileInformation 2.0 - get tags"
	Set db = Client.OpenDatabase(sInputFile)
	'sPERSONEN_NR_SICHERHEITENGEBER = oTM.GetFieldForTag(db, "acc!PERSONEN_NR_SICHERHEITENGEBER")
	'sNAME_SICHERHEITENGEBER = oTM.GetFieldForTag(db, "acc!NAME_SICHERHEITENGEBER")
	'sSICHERHEIT_NR = oTM.GetFieldForTag(db, "acc!SICHERHEIT_NR")
	sSTATUS_BEARBEITUNG = oTM.GetFieldForTag(db, "acc!SBI_STATUS_BEARBEITUNG")
	sSTATUS_SATZART = oTM.GetFieldForTag(db, "acc!SBI_STATUS_SATZART")
	sSICHERHEIT_ART = oTM.GetFieldForTag(db, "acc!SBI_SICHERHEITENART")
	'sSICHERHEITENART_BEZEICHNUNG = oTM.GetFieldForTag(db, "acc!SICHERHEITENART_BEZEICHNUNG")
	sSICHERHEITENWERT_VERTEILT_JURISTISCH = oTM.GetFieldForTag(db, "acc!SBI_SICHERHEITENWERT_VERTEILT_JURISTISCH")
	'sBELEIHUNGSWERT = oTM.GetFieldForTag(db, "acc!SBI_BELEIHUNGSWERT")
	'sBELEIHUNGSGRENZE_BETRAG = oTM.GetFieldForTag(db, "acc!BELEIHUNGSGRENZE_BETRAG")
	'sBELEIHUNGSGRENZE = oTM.GetFieldForTag(db, "acc!SBI_BELEIHUNGSGRENZE_IN_EURO")
	sBELEIHUNGSWERT_PER = oTM.GetFieldForTag(db, "acc!SBI_BELEIHUNGSWERT_PER")
	'sBELEIHUNGSWERT_STATUS = oTM.GetFieldForTag(db, "acc!BELEIHUNGSWERT_STATUS")
	'sBELEIHUNGSWERT_STATUS_PER = oTM.GetFieldForTag(db, "acc!BELEIHUNGSWERT_STATUS_PER")
	sBELEIHUNGSWERT_WURDE_UEBERPRUEFT_AM = oTM.GetFieldForTag(db, "acc!SBI_BELEIHUNGSWERT_WURDE_UEBERPRUEFT_AM")
	'sBELEIHUNGSWERT_UEBERPRUEFT_VON = oTM.GetFieldForTag(db, "acc!BELEIHUNGSWERT_UEBERPRUEFT_VON")
	'sEINZELRATING_DES_SICHERHEITENNEHMERS = oTM.GetFieldForTag(db, "acc!EINZELRATING_DES_SICHERHEITENNEHMERS")
	'sNACHGEWIESENER_WERT = oTM.GetFieldForTag(db, "acc!NACHGEWIESENER_WERT")
	'sNACHGEWIESENER_WERT_PER = oTM.GetFieldForTag(db, "acc!NACHGEWIESENER_WERT_PER")
	'sBW = oTM.GetFieldForTag(db, "acc!BW")
	'sANTEIL_SI_WERT_BWRK_1 = oTM.GetFieldForTag(db, "acc!ANTEIL_SI_WERT_BWRK_1")
	'sBERECHNETES_FELD_SUMME_JE_PERSON_AUS_FEL = oTM.GetFieldForTag(db, "acc!BERECHNETES_FELD_SUMME_JE_PERSON_AUS_FEL")
	'sKOMMENTAR_FREITEXTFELD_IN_DER_SICHERHEIT = oTM.GetFieldForTag(db, "acc!KOMMENTAR_FREITEXTFELD_IN_DER_SICHERHEIT")
	'sBLANKOVOLUMEN_IA_EUR = oTM.GetFieldForTag(db, "acc!BLANKOVOLUMEN_IA_EUR")
	'sRISIKOSTATUS_MARISK = oTM.GetFieldForTag(db, "acc!RISIKOSTATUS_MARISK")
	'sRISIKOSTATUS_MARISK_SEIT = oTM.GetFieldForTag(db, "acc!RISIKOSTATUS_MARISK_SEIT")
	'sNUTZUNG = oTM.GetFieldForTag(db, "acc!NUTZUNG")
	'sNUTZUNGSART = oTM.GetFieldForTag(db, "acc!NUTZUNGSART")
	'sOBJEKTART = oTM.GetFieldForTag(db, "acc!OBJEKTART")
	'sOBJEKTART_BEZEICHNUNG = oTM.GetFieldForTag(db, "acc!OBJEKTART_BEZEICHNUNG")
	sIMMOBILIEN_NR = oTM.GetFieldForTag(db, "acc!SBI_IMMOBILIEN_NR")
	'sEINGETRAGENER_BETRAG_DER_GRUNDSCHULD_NOM = oTM.GetFieldForTag(db, "acc!EINGETRAGENER_BETRAG_DER_GRUNDSCHULD_NOM")
	'sERMITTLUNG_KLEINDARLEHENSGRENZE_JA_NEIN = oTM.GetFieldForTag(db, "acc!ERMITTLUNG_KLEINDARLEHENSGRENZE_JA_NEIN")
	'sVERFUEGBARER_SICHERUNGSWERT = oTM.GetFieldForTag(db, "acc!VERFUEGBARER_SICHERUNGSWERT")
	'sVERFUEGBARER_SICHERUNGSWERT_VOM = oTM.GetFieldForTag(db, "acc!VERFUEGBARER_SICHERUNGSWERT_VOM")
	'sFEUERVERSICHERUNGSSCHEIN_NR = oTM.GetFieldForTag(db, "acc!FEUERVERSICHERUNGSSCHEIN_NR")
	'sDIE_QUALITATIVEN_ANFORDERUNGEN_SIND_ERFUE = oTM.GetFieldForTag(db, "acc!DIE_QUALITATIVEN_ANFORDERUNGEN_SIND_ERFUE")
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

' Filters the input table.
Function Analysis
Dim sEqn_0 As String
Dim sEqnReserved As String
Dim sEqFilter As String
Dim sEqFinal As String
SetCheckpoint "Analysis 1.0 - create Wesentliche Sicherheiten nach MaRisk-Immobilien"


	'//Sicherheitenart
	sEqn_0 = "1"
	sEqnReserved = ""
	sEqnReserved = sEqn_0
	
	Set oParameters = SmartContext.Parameters
	If oParameters.Contains("smartFromToList1") Then
		sSicherheitenart = BuildEquation_FromToList(sSourceName)
	End If
	
	If Len(sSicherheitenart) > 0 Then 
	sEqn_0 = sEqnReserved & " .AND. (" & sSicherheitenart & ")"
	End If
	
	Set db = Client.OpenDatabase(sInputFile)
	Set task = db.Extraction
	task.IncludeAllFields
	sSicherheiten_MaRisk_Immobilien_Filter_Sicherheitenart = oSC.UniqueFileName(sWorkingfolderName & "Wesentliche Sicherheiten nach MaRisk-Immobilien-Gefiltert nach Sicherheitenart.IMD", INTERMEDIATE_RESULT)
	task.AddExtraction sSicherheiten_MaRisk_Immobilien_Filter_Sicherheitenart, "", sEqn_0
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	

	Set db = Client.OpenDatabase(sSicherheiten_MaRisk_Immobilien_Filter_Sicherheitenart)
	Set task = db.Summarization
	task.AddFieldToSummarize sIMMOBILIEN_NR
	task.AddFieldToInc "PERSONENNUMMER"
	task.AddFieldToInc "NACHNAME_KURZ"
	task.AddFieldToInc "BELEIHUNGSWERT"
	task.AddFieldToInc "BELEIHUNGSWERT_PER"
	task.AddFieldToInc "BELEIHUNGSWERT_STATUS"
	task.AddFieldToInc "BELEIHUNGSWERT_STATUS_PER"
	task.AddFieldToInc "BELEIHUNGSWERT_WURDE_�BERPR�FT_AM"
	task.AddFieldToInc "BELEIHUNGSWERT_WURDE_�BERPR�FT_VON"
	task.AddFieldToInc "BELEIHUNGSGRENZE_IN_EURO"
	task.AddFieldToInc "BELEIHUNGSGRENZE_IN_PROZENT"
	task.AddFieldToInc "NUTZUNG"
	task.AddFieldToInc "NUTZUNGSART"
	task.AddFieldToInc "OBJEKTART"
	task.AddFieldToInc "OBJEKTART_BEZEICHNUNG"
	task.AddFieldToTotal sSICHERHEITENWERT_VERTEILT_JURISTISCH
	sSum_BG_ImNr = oSC.UniqueFileName(sWorkingfolderName & "Summierung des Sicherheitenwerts f�r jede Immobiliennummer.IMD", INTERMEDIATE_RESULT)
	task.OutputDBName = sSum_BG_ImNr
	task.CreatePercentField = FALSE
	task.UseFieldFromFirstOccurrence = TRUE
	task.StatisticsToInclude = SM_SUM
	task.PerformTask
	db.Close
	Set task = Nothing
	Set db = Nothing

'	Set db = Client.OpenDatabase(sInputFile)
'	Set task = db.Summarization
'	task.AddFieldToSummarize sIMMOBILIEN_NR
'	task.AddFieldToInc sBELEIHUNGSWERT_PER
'	task.AddFieldToInc sBELEIHUNGSWERT_WURDE_UEBERPRUEFT_AM
'	task.AddFieldToTotal sBELEIHUNGSGRENZE
'	sSum_BG_ImNr = oSC.UniqueFileName(sWorkingfolderName & "Summierung der Beleihungsgrenze f�r jede Immobiliennummer.IMD", INTERMEDIATE_RESULT)
'	task.OutputDBName = sSum_BG_ImNr
'	task.CreatePercentField = FALSE
'	task.UseFieldFromFirstOccurrence = TRUE
'	task.StatisticsToInclude = SM_SUM
'	task.PerformTask
'	Set task = Nothing
'	Set db = Nothing

		
	sFilterParam = sSICHERHEITENWERT_VERTEILT_JURISTISCH & "_SUM"
	
	sBWBR = oParameters.Item("smartTextBox1").Value
	sUEDBR = oParameters.Item("smartTextBox2").Value
	
	sEqFinal = sFilterParam & "  >  " & sBWBR & " .AND. @AGE(@Date(); @if(@AGE( " & sBELEIHUNGSWERT_PER & ";" & sBELEIHUNGSWERT_WURDE_UEBERPRUEFT_AM & ") >= 0; " & sBELEIHUNGSWERT_PER & "; " & sBELEIHUNGSWERT_WURDE_UEBERPRUEFT_AM & " )) >  " & sUEDBR
	
	SmartContext.Log.LogMessage "Final Equation = {0}", sEqFinal
	Set oParameters = Nothing

	Set db = Client.OpenDatabase(sSum_BG_ImNr)
	Set task = db.Extraction
	task.IncludeAllFields
	sSicherheiten_MaRisk_Immobilien = oSC.UniqueFileName(sWorkingfolderName & "Wesentliche Sicherheiten nach MaRisk-Immobilien-Basis Sicherungswert je Immobilie.IMD", FINAL_RESULT)
	task.AddExtraction sSicherheiten_MaRisk_Immobilien, "", sEqFinal
	task.PerformTask 1, db.Count
	db.Close
	Set task = Nothing
	Set db = Nothing
end function
' --------------------------------------------------------------------------

Function BuildEquation_FromToList(ByVal dbName As String) As String
SetCheckpoint "BuildEquation_FromToList_0"

	BuildEquation_FromToList = ""
			
	Dim accountNumberName As String
	accountNumberName = sSICHERHEIT_ART
	
	Dim accountNumberRanges As Object
	Set accountNumberRanges = oParameters.Item("smartFromToList1")

	' Create a new column filter builder
	Dim filterBuilder As Object
	Set filterBuilder = oMC.NewColumnFilterBuilder
	
	' Initialize its properties 
	
	' Note: The database property is optional. 
	' The builder uses this information only in case the 'regular' filter expression exceeds 
	' IDEA's max. equation length to append helper columns on which the filter expression will be constructed.
	' The database can be specified by using its path or the result of Client.OpenDatabase
	filterBuilder.Database = dbName
	filterBuilder.ColumnName = accountNumberName
	
	' Initialize the Values object
	' Valid types: ContentOfSingleList and ContentOfFromToList
	' Note: The builder assumes that the element type of the list of values matches the type of the specified column.
	filterBuilder.Values = accountNumberRanges
	
	'filterBuilder.IgnoreCase = oParameters.Item("IgnoreCaseOption").Checked
	filterBuilder.IgnoreCase = True
	'filterBuilder.GetMatchingRecords = not oParameters.Item("SelectNonMatchingRowsOption").Checked
	filterBuilder.GetMatchingRecords = True
	
	' Execute the task of creating an equation based on the accountNumberName column and 
	' the list of account number ranges accountNumberRanges
	Dim result As Long
	result = filterBuilder.PerformTask
	
	' Examine the result
	Dim filterExpression As String
	filterExpression = ""
	If result = 1 Then
SetCheckpoint "BuildEquation_FromToList_1"	
		' A filter expression is available in Equation
		filterExpression = filterBuilder.Equation
		SmartContext.Log.LogMessage "Filter = {0}", filterExpression
	
		BuildEquation_FromToList = filterExpression
				
	ElseIf result > 0 Then
SetCheckpoint "BuildEquation_FromToList_2"	
		' The filter expression exceeded the max. allowed length -> result contains the length of the expression
		' Note: In this case the Equation property of the builder is empty!
		Dim ErrorMessageFilterLength As String
		ErrorMessageFilterLength = "�berpr�fen Sie die Liste der Sachkontonummernbereiche. Ein Filterausdruck, der die f�r IDEA festgelegte maximale L�nge einer Gleichung �berschreitet, kann nicht generiert werden."
		SmartContext.Log.LogMessageWithID "LengthOfFilterExpression", result
		err.Raise 16, "AKT-021", ErrorMessageFilterLength
	
	ElseIf result = 0 Then
SetCheckpoint "BuildEquation_FromToList_3"	
		' PerformTask returns 0 in case the 'regular' expression exceeded IDEA's max. equation length.
		' A filter expression was constructed, however helper columns were added to the source database.
		' The names of these columns are available in the builder's array TempColumnNames.
		' Note: To enable this behavior, the builder must be initialzed with the source database (path or database object)
		' A filter expression is available in Equation
		filterExpression = filterBuilder.Equation
		SmartContext.Log.LogMessage "Filter = {0}", filterExpression
		BuildEquation_FromToList = filterExpression
	
	End If
		
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