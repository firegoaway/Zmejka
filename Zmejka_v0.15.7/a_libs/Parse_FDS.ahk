Parse_FDS(file)
{
    count := 0

    Loop, Read, %file%
    {
        if (SubStr(A_LoopReadLine, 1, 5) = "&MESH" AND SubStr(A_LoopReadLine, 0) = "/")
            count++
    }
    
    return count
}
