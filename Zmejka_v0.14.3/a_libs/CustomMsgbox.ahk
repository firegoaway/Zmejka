CustomMsgBox(Title, Message, Button1Text := "OK", Button2Text := "", Button3Text := "")
{
    global
    static hGUI := 0, hText := 0, hButton1 := 0, hButton2 := 0, hButton3 := 0
    
    ; Clean up previous GUI if exists
    if (hGUI)
        Gui, CustomMsgBox:Destroy
    
    ; Create GUI
    Gui, CustomMsgBox:-MinimizeBox -MaximizeBox +AlwaysOnTop +ToolWindow +Owner
    Gui, CustomMsgBox:Font, s9, Segoe UI
    Gui, CustomMsgBox:Add, Text, w300 h60 vMsgText, %Message%
    
    ; Calculate button positions
    btnWidth := 85, btnHeight := 36, btnSpacing := 15
    guiWidth := 340
    activeButtons := 0
    Loop, 3 {
        if (Button%A_Index%Text != "")
            activeButtons++
    }
    totalBtnWidth := activeButtons * btnWidth + (activeButtons - 1) * btnSpacing
    startX := (guiWidth - totalBtnWidth) // 2
    
    ; Create buttons
    result := 0
    Loop, 3 {
        if (Button%A_Index%Text != "") {
            xPos := startX + (A_Index - 1) * (btnWidth + btnSpacing)
            Gui, CustomMsgBox:Add, Button, x%xPos% y100 w%btnWidth% h%btnHeight% gBtn%A_Index% vBtn%A_Index%, % Button%A_Index%Text
        }
    }
    
    ; Show GUI
    Gui, CustomMsgBox:Show, w%guiWidth% h140, %Title%
    Gui, CustomMsgBox:+LastFound
    hGUI := WinExist()
    
    ; Wait for user interaction
    While (result = 0) {
        Sleep, 10
    }
    
    ; Clean up and return result
    Gui, CustomMsgBox:Destroy
    hGUI := 0
    return result
}

; Button event handlers
Btn1:
    result := 1

Btn2:
    result := 2

Btn3:
    result := 3

; Example usage:
; ButtonIndex := CustomMsgBox("Title", "Message", "Yes", "No", "Cancel")
; MsgBox, You clicked button %ButtonIndex%

