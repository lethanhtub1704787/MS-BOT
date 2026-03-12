#include <MsgBoxConstants.au3>
#include<Action.au3>
; Press Esc to terminate script, Pause/Break to "pause"

Global $g_bPaused = False

HotKeySet("{F2}", "Play")
HotKeySet("{F3}", "Test")
HotKeySet("{PAUSE}", "TogglePause")
HotKeySet("{F5}", "Terminate")
HotKeySet("+!d", "ShowMessage") ; Shift-Alt-d

Run_AI_Server()
Global $OverWatch = ShellExecute("OverWatch.exe","","","",@SW_HIDE)
WinMove("[CLASS:MapleStoryClass]", "", 0,0)

While 1
    Sleep(100)
WEnd

Func TogglePause()
	attack_off()
	Move_Off()
    $g_bPaused = Not $g_bPaused
    While $g_bPaused
        Sleep(100)
        ToolTip('Script is "Paused"', 0, 0)
    WEnd
    ToolTip("")
EndFunc   ;==>TogglePause

Func Terminate()
	attack_off()
	Move_Off()
	ProcessClose($OverWatch)
	ProcessClose($AI_Server)
    Exit
EndFunc   ;==>Terminate

Func ShowMessage()
    MsgBox($MB_SYSTEMMODAL, "", "This is a message.")
EndFunc   ;==>ShowMessage
