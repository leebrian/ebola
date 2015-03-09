Attribute VB_Name = "PrepForSAS"
Sub PrepareDailyExtract()
Attribute PrepareDailyExtract.VB_Description = "Many columns are not needed for additional analyses. This macro removed all columns that aren't used."
Attribute PrepareDailyExtract.VB_ProcData.VB_Invoke_Func = " \n14"
'
' PrepareDailyExtract Macro
' Many columns are not needed for additional analyses and both SAS and SQL will not accept spreadsheets with over 255 columns.
' This macro removes all columns that aren't used by CDC analyses. Also change date format. Also save off as a new file.
'

'
Dim i, cellValue
i = 1

ActiveWorkbook.SaveAs Left(ActiveWorkbook.FullName, Len(ActiveWorkbook.FullName) - 5) & "-smalled.xlsx"

cellValue = Cells(1, i)

'this is a hack because VB is ugly, faster to build an Array and join it together, than to just have lots of if statements
listOfFieldNamesArr = Array("SCRes", "DateSampleCollected1", "DateSampleTested1", "DateSampleCollected2", "DateSampleTested2", "DateSampleCollected3", "DateSampleTested3", "DateSampleCollected4", "DateSampleTested4", "DateSampleCollected5", "DateSampleTested5", "DateSampleCollected6", "DateSampleTested6", "DateSampleCollected7", "DateSampleTested7", _
    "DateIsolationCurrent", "DateHospitalCurrentAdmit", "FinalLabClass", "DateDeath", "FinalStatus", "HospitalCurrent", "DistrictRes", "DateOnset", "DateReport", "EpiCaseDef", "OtherNames", "Surname", "Age", "Gender", "HCW", "HCWposition", "HCWFacility", "PhoneNumber", "ID", "GlobalRecordID", "HCWpositiontrim", "PlaceDeath", "SampleInterpret1", "SampleInterpret2", "SampleInterpret3", "SampleInterpret4", "SampleInterpret5", "SampleInterpret6", "SampleInterpret7", "FieldLabSpecID1", "FieldLabSpecID2", "FieldLabSpecID3", "FieldLabSpecID4", "FieldLabSpecID5", "FieldLabSpecID6", "FieldLabSpecID7", "ThisCaseIsAlsoContact", "Surname", "OtherNames", "OtherOccupDetail", "SurnameLab1", "OtherNameLab1", "SurnameLab2", "OtherNameLab2", "SurnameLab3", "OtherNameLab3", "SurnameLab4", "OtherNameLab4", "SurnameLab5", "OtherNameLab5", "SurnameLab6", "OtherNameLab6", "SurnameLab7", "OtherNameLab7")

'Remove all Columns that aren't needed, needed columns are defined in the Relevant-Fields.xlsx notes file
While cellValue <> ""
'    If InStr(1, listOfFieldNamesStr, cellValue & ",") = 0 Then 'These ways are not as efficient or accurate
'    If UBound(Filter(listofFieldNamesArr, cellValue)) = -1 Then
    If IsError(Application.Match(cellValue, listOfFieldNamesArr, 0)) Then
        Columns(i).Select
        Selection.Delete Shift:=xlToLeft
    Else
        i = i + 1
    End If
    
    cellValue = Cells(1, i)
    
    'i = 1000
    
Wend

'While we are in here, format the dates the short format we want, make sure to check this each time you add columns
Dim topRow

Set topRow = ActiveWorkbook.Sheets(1).Range("1:1")

Columns(topRow.Find(What:="DateReport").Column).NumberFormat = "m/dd/yyyy" 'DateReport
Columns(topRow.Find(What:="DateDeath").Column).NumberFormat = "m/dd/yyyy" 'DateDeath
Columns(topRow.Find(What:="DateOnset").Column).NumberFormat = "m/dd/yyyy" 'DateOnset
Columns(topRow.Find(What:="DateHospitalCurrentAdmit").Column).NumberFormat = "m/dd/yyyy" 'DateHospitalCurrentAdmit
Columns(topRow.Find(What:="DateIsolationCurrent").Column).NumberFormat = "m/dd/yyyy" 'DateIsolationCurrent
Columns(topRow.Find(What:="DateSampleCollected1").Column).NumberFormat = "m/dd/yyyy"
Columns(topRow.Find(What:="DateSampleTested1").Column).NumberFormat = "m/dd/yyyy"
Columns(topRow.Find(What:="DateSampleCollected2").Column).NumberFormat = "m/dd/yyyy"
Columns(topRow.Find(What:="DateSampleTested2").Column).NumberFormat = "m/dd/yyyy"
Columns(topRow.Find(What:="DateSampleCollected3").Column).NumberFormat = "m/dd/yyyy"
Columns(topRow.Find(What:="DateSampleTested3").Column).NumberFormat = "m/dd/yyyy"
Columns(topRow.Find(What:="DateSampleCollected4").Column).NumberFormat = "m/dd/yyyy"
Columns(topRow.Find(What:="DateSampleTested4").Column).NumberFormat = "m/dd/yyyy"
Columns(topRow.Find(What:="DateSampleCollected5").Column).NumberFormat = "m/dd/yyyy"
Columns(topRow.Find(What:="DateSampleTested5").Column).NumberFormat = "m/dd/yyyy"
Columns(topRow.Find(What:="DateSampleCollected6").Column).NumberFormat = "m/dd/yyyy"
Columns(topRow.Find(What:="DateSampleTested6").Column).NumberFormat = "m/dd/yyyy"
Columns(topRow.Find(What:="DateSampleCollected7").Column).NumberFormat = "m/dd/yyyy"
Columns(topRow.Find(What:="DateSampleTested7").Column).NumberFormat = "m/dd/yyyy"

ActiveWorkbook.Save

End Sub
