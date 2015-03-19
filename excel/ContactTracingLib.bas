'Excel macro written by Dirk Schumacher
Attribute VB_Name = "Module1"
Public Function HasContactBeenSeenToday(followUpRange) As String
    For Each cell In followUpRange
        If cell = Date And Trim(LCase(Cells(cell.Row, cell.Column + 1))) = "vu" Then
            HasContactBeenSeenToday = "Yes"
            Exit Function
        End If
    Next cell
    HasContactBeenSeenToday = "No"
End Function


