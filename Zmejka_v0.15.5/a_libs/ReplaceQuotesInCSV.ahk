ReplaceQuotesInCSV(csvfilePath)
{
    dq := Chr(34)

    File := FileOpen(csvfilePath, "r")
    If !File
    {
        MsgBox, Невозможно найти файл:`n%csvfilePath%
        ;ExitApp
    }

    TempFilePath := csvfilePath . ".tmp"
    TempFile := FileOpen(TempFilePath, "w")
    If !TempFile
    {
        MsgBox, Не могу создать временный файл для записи в:`n%TempFilePath%
        File.Close()
        ;ExitApp
    }

    While, !File.AtEOF
    {
        Line := File.ReadLine()
        Line := StrReplace(Line, dq dq, dq, All)
        TempFile.Write(Line "")
    }

    File.Close()
    TempFile.Close()

    FileDelete, %csvfilePath%
    FileMove, %TempFilePath%, %csvfilePath%
}
