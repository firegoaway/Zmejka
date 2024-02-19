; Define the global array to store imported .fds files
global fdsFiles := []

; Function to handle adding .fds files
AddFDSFile() {
    ; Open file explorer to select .fds file
    FileSelectFile, filePath, 3, , Select .fds File
    if (filePath) {
        ; Add the file to the array
        fdsFiles.Push(filePath)
        
        ; Create a button for the imported file
        Gui Add, Button, xm y+10 w100, % "FDS File " fdsFiles.Length()
        
        ; Update the GUI
        Gui Show
    }
}

; Create the GUI window
Gui +Resize
Gui Margin, 10, 10

; Add a text box for path input
Gui Add, Edit, x10 y10 w300 h25 vFilePath, 

; Add the button to import .fds files
Gui Add, Button, x10 y+10 w150, Import FDS File
GuiControl, +g, Import FDS File, AddFDSFile

; Show the GUI window
Gui Show
