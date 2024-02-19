
#Requires Autohotkey v2
;AutoGUI 2.5.8 creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter
;Easy_AutoGUI_for_AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2

TraySetIcon("shell32.dll","242")
myGui := Gui()
myGui.Add("GroupBox", "x8 y112 w202 h125", "GroupBox")
myGui.Add("Text", "x8 y96 w604 h13 +0x10")
ogcButtonAddline := myGui.Add("Button", "x16 y128 w80 h23", "&Add line")
ogcButtonBrowse := myGui.Add("Button", "x520 y32 w80 h23", "&Browse")
ogcButtonStart := myGui.Add("Button", "x16 y184 w80 h23", "&Start")
ogcButtonPause := myGui.Add("Button", "x16 y208 w80 h23", "&Pause")
ogcButtonStop := myGui.Add("Button", "x120 y184 w80 h23", "&Stop")
ogcButtonKill := myGui.Add("Button", "x120 y208 w80 h23", "&Kill")
myGui.Add("GroupBox", "x216 y112 w393 h123", "GroupBox")
myGui.Add("Progress", "x224 y208 w369 h20 -Smooth", "33")
SB := myGui.Add("StatusBar", , "Status Bar")
Edit1 := myGui.Add("Edit", "x8 y16 w500 h21")
Edit2 := myGui.Add("Edit", "x8 y48 w500 h21")
myGui.Add("Text", "x8 y80 w498 h7 +0x10")
myGui.Add("ListBox", "x224 y128 w370 h69", ["ListBox"])
ogcButtonAddline.OnEvent("Click", OnEventHandler)
ogcButtonBrowse.OnEvent("Click", OnEventHandler)
ogcButtonStart.OnEvent("Click", OnEventHandler)
ogcButtonPause.OnEvent("Click", OnEventHandler)
ogcButtonStop.OnEvent("Click", OnEventHandler)
ogcButtonKill.OnEvent("Click", OnEventHandler)
Edit1.OnEvent("Change", OnEventHandler)
Edit2.OnEvent("Change", OnEventHandler)
myGui.OnEvent('Close', (*) => ExitApp())
myGui.Title := "Window"
myGui.Show("w620 h275")

OnEventHandler(*)
{
	ToolTip("Click! This is a sample action.`n"
	. "Active GUI element values include:`n"  
	. "ogcButtonAddline => " ogcButtonAddline.Value "`n" 
	. "ogcButtonBrowse => " ogcButtonBrowse.Value "`n" 
	. "ogcButtonStart => " ogcButtonStart.Value "`n" 
	. "ogcButtonPause => " ogcButtonPause.Value "`n" 
	. "ogcButtonStop => " ogcButtonStop.Value "`n" 
	. "ogcButtonKill => " ogcButtonKill.Value "`n" 
	. "Edit1 => " Edit1.Value "`n" 
	. "Edit2 => " Edit2.Value "`n", 77, 277)
	SetTimer () => ToolTip(), -3000 ; tooltip timer
}
