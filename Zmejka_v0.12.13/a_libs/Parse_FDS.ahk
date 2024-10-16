Parse_FDS(file)
{
    ;	Initialize the count
    count := 0
    ;	Read the file line by line
    Loop, Read, %file%
    {
        ;	Check if the current line starts with "&MESH" and ends with "/"
        if (SubStr(A_LoopReadLine, 1, 5) = "&MESH" AND SubStr(A_LoopReadLine, 0) = "/")
		{
            ;	Increment the count
            count++
        }
    }
    ;	Return the total count
    return count
}

;file_location := "E:\trash\bulk3\untitled\ahktest\ahktest2.fds"
;total_count := Parse_FDS(file_location)

;	Show the total count
;MsgBox, % "Total count: " total_count