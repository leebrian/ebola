Attribute VB_Name = "Module1"
'Excel macro written by Dirk Schumacher
'This function checks a range of dates with a cell following that contains the status of if a contact has been seen
'Vu means they have been seen, so Yes is output; else the current value is output as either "NonVu" or the reason the contact wasn't seen
Public Function HasContactBeenSeenToday(followUpRange) As String
    For Each cell In followUpRange
        If cell = Date Then
            If Trim(LCase(Cells(cell.Row, cell.Column + 1))) = "vu" Then
                HasContactBeenSeenToday = "Yes"
            Else
                HasContactBeenSeenToday = Cells(cell.Row, cell.Column + 1)
            End If
            Exit Function
        End If
    Next cell
    HasContactBeenSeenToday = "No"
End Function


