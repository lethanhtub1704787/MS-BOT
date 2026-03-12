#include<ImageSearch.au3>
#RequireAdmin
#include <MsgBoxConstants.au3>

; Press Esc to terminate script, Pause/Break to "pause"

Global $g_bPaused = False
Global $x,$y
HotKeySet("{9}", "TogglePause")
HotKeySet("{F10}", "Terminate")
HotKeySet("+!d", "ShowMessage") ; Shift-Alt-d

Func TogglePause()
	$g_bPaused = Not $g_bPaused
	While $g_bPaused
			Sleep(100)
			ToolTip('Script is "Paused"', 0, 0)
	WEnd
	ToolTip("")
EndFunc   ;==>TogglePause

Func Terminate()
        Exit
EndFunc   ;==>Terminate

Func ShowMessage()
        MsgBox($MB_SYSTEMMODAL, "", "This is a message.")
EndFunc   ;==>ShowMessage


While 1
	$confirm = _ImageSearch(@ScriptDir&'\confirm.bmp',1,$x,$y,50,30)
	If $confirm == 1 Then
		MouseClick("left",$x,$y)
	EndIf
	Sleep(1000)
WEnd