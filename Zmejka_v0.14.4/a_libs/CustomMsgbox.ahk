CustomMsgBox(Message, Title, Button1Text := "OK", Button2Text := "", Button3Text := "")
{
    global CustomMsgBox_Result
    
    ; Clean up previous GUI if exists
    Gui, CustomMsgBox:Destroy
    
    ; Reset result for this instance
    CustomMsgBox_Result := 0
    
    ; Create GUI
    Gui, CustomMsgBox:-MinimizeBox -MaximizeBox +AlwaysOnTop +ToolWindow +Owner
    Gui, CustomMsgBox:Font, s9, Segoe UI
    Gui, CustomMsgBox:Add, Text, w300 h60, %Message%
    
    ; Calculate button positions
    btnWidth := 85, btnHeight := 35, btnSpacing := 15
    guiWidth := 340
    activeButtons := 0
    Loop, 3 {
        if (Button%A_Index%Text != "")
            activeButtons++
    }
    totalBtnWidth := activeButtons * btnWidth + (activeButtons - 1) * btnSpacing
    startX := (guiWidth - totalBtnWidth) // 2
    
    ; Create buttons
    Loop, 3 {
        if (Button%A_Index%Text != "") {
            xPos := startX + (A_Index - 1) * (btnWidth + btnSpacing)
            Gui, CustomMsgBox:Add, Button, x%xPos% y100 w%btnWidth% h%btnHeight% gCustomMsgBox_Btn%A_Index%, % Button%A_Index%Text
        }
    }
    
    ; Show GUI
    Gui, CustomMsgBox:Show, w%guiWidth% h140, %Title%
    
    ; Wait for user interaction
    While (CustomMsgBox_Result = 0) {
        Sleep, 10
    }
    
    ; Get result and clean up
    result := CustomMsgBox_Result
    Gui, CustomMsgBox:Destroy
    CustomMsgBox_Result := 0
    
    return result
}
/*
; Button event handlers
CustomMsgBox_Btn1:
    CustomMsgBox_Result := 1

CustomMsgBox_Btn2:
    CustomMsgBox_Result := 2

CustomMsgBox_Btn3:
    CustomMsgBox_Result := 3

; Example usage:
; result := CustomMsgBox("Confirm", "Save changes?", "Save", "Don't Save")
; MsgBox, You clicked button %result%
*/
