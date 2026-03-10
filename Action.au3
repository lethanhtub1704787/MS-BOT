#include<VariableSet.au3>
#include <GDIPlus.au3>
#include <ScreenCapture.au3>
#include <Array.au3>

Func runePosition()
	$RunePosition = PixelSearch(9, 50, 220, 180,$runeColor)
	If IsArray($RunePosition) Then
		Return $RunePosition
	EndIf
EndFunc

Func myPosition()
	$MyPosition = PixelSearch(9, 50,220, 180,$charColor)
	If IsArray($MyPosition) Then
		Return $MyPosition
	EndIf
EndFunc

Func showMyPosition()
	$MyPosition = PixelSearch(9, 50,220, 180,$charColor)
	If IsArray($MyPosition) Then
		MouseMove($MyPosition[0],$MyPosition[1])
 		MsgBox("","",$MyPosition[0]&","&$MyPosition[1])
		Return $MyPosition
	Else
		MsgBox("","","Not found")
	EndIf
EndFunc

Func RuneCheck()
	$time = TimerInit()
	Do
		jump()
		Sleep(300)
		$rune_check = runePosition()
		If IsArray($rune_check) Then
			Return True
		EndIf
	Until TimerDiff($time) > 2000
	Return False
EndFunc

Func turn_left()
	Send("{LEFT down}")
	Sleep(50)
	Send("{LEFT up}")
EndFunc

Func turn_right()
	Send("{RIGHT down}")
	Sleep(50)
	Send("{RIGHT up}")
EndFunc

Func Run_AI_Server()
	$AI_Server = ShellExecute("AI_Server.py","","","",@SW_SHOW)
EndFunc

Func CaptureRegion($savePath, $x1, $y1, $x2, $y2)
    _GDIPlus_Startup()
    Local $bmp = _ScreenCapture_Capture("", $x1, $y1, $x2, $y2)
	_ScreenCapture_SaveImage($savePath, $bmp)
    _WinAPI_DeleteObject($bmp)
    _GDIPlus_Shutdown()
EndFunc

;~ $x1 = 280
;~ $y1 = 110
;~ $x2 = 1000
;~ $y2 = 400
;~ Local $imgPath = @ScriptDir & "\rune.png"
;~ CaptureRegion($imgPath, $x1, $y1, $x2, $y2)
Func GetRune()
	Send("{SPACE}")
	Sleep(1500)
	Local $imgName = "rune.png"
	Local $imgPath = @ScriptDir & "\" & $imgName
	$x1 = 280
	$y1 = 110
	$x2 = 1000
	$y2 = 400

	CaptureRegion($imgPath, $x1, $y1, $x2, $y2)

	TCPStartup()

	Local $sock = TCPConnect("127.0.0.1", 65432)
	If $sock = -1 Then
		MsgBox(16, "Lỗi", "Không kết nối được OCR server")
		Exit
	EndIf

	TCPSend($sock, $imgName)

	; ====== CHỜ KẾT QUẢ ======
	Local $recv = ""

	While $recv = ""
		$recv = TCPRecv($sock, 1024)
		Sleep(100)
	WEnd

	TCPCloseSocket($sock)
	TCPShutdown()

	If $recv = "ERR" Or $recv = "" Then
		MsgBox(16, "OCR", "OCR lỗi")
	EndIf

	Local $recvClean = StringTrimLeft($recv, 1) ; bỏ dấu [
	$recvClean = StringTrimRight($recvClean, 1) ; bỏ dấu ]

	Local $arr = StringSplit($recvClean, ",")

	For $i = 1 To $arr[0]
		$arr[$i] = Int($arr[$i])
		Select
			Case $arr[$i] == 0
				Send("{LEFT}")
			Case $arr[$i] == 1
				Send("{RIGHT}")
			Case $arr[$i] == 2
				Send("{UP}")
			Case $arr[$i] == 3
				Send("{DOWN}")
		EndSelect
		Sleep(150)
	Next

EndFunc

Func MoveTo($x,$y,$move_type="jump",$distance=2)
	$x1_box = $x - $distance
	$y1_box = $y - 2
	$x2_box = $x + $distance
	$y2_box = $y + 2

	Local $stuck_time = TimerInit()
	Local $oldPosition = myPosition()
	While 1
		$myPosition = myPosition()
		If Not IsArray($myPosition) Then
			Return
		EndIf
		$check_box = PixelSearch( $x1_box,  $y1_box, $x2_box, $y2_box,$charColor)

		If $myPosition[0] <> $oldPosition[0] Then
			$stuck_time = TimerInit()
		EndIf

		Select
;~ 			Case TimerDiff($time) > 10000
;~ 				right_jump()
;~ 				$time = TimerInit()

			Case TimerDiff($stuck_time) > 3000
				Move_Off()
				Right_Jump()
				$stuck_time = TimerInit()

			Case IsArray($check_box)
				Move_Off()
;~ 				Sleep(1000)
;~ 				$check_box = PixelSearch( $x1_box,  $y1_box, $x2_box, $y2_box,$charColor)
;~ 				If Not IsArray($check_box) Then
;~ 					ContinueLoop
;~ 				EndIf
				ExitLoop

			Case $myPosition[0] < $x1_box
				Left_Move_Off()
				If $x1_box - $myPosition[0] >= 30 Then
					If $move_type == "flash" Then
						Right_Flash()
					Else
						Right_Jump()
					EndIf
				Else
					Right_Move()
				EndIf

			Case $myPosition[0] > $x2_box
				Right_Move_Off()
				If $myPosition[0] - $x2_box >= 30 Then
					If $move_type == "flash" Then
						Left_Flash()
					Else
						Left_Jump()
					EndIf
				Else
					Left_Move()
				EndIf

			Case $myPosition[1] < $y1_box
				Move_Off()
				If $move_type == "flash" Then
					Down_Flash()
					Sleep(300)
				Else
					Jump_Down()
					Sleep(1000)
				EndIf

			Case $myPosition[1] > $y2_box
				Move_Off()
				If $move_type == "flash"  Then
					Up_Flash()
					Sleep(300)
				Else
					Rope_Lift()
					Sleep(1000)
				EndIf

		EndSelect
		$oldPosition = $myPosition
		Sleep(10)
	WEnd
EndFunc

; Hàm gửi phím bằng AutoIt
Func SendKey_AutoIt($key)
    Send($key)
EndFunc

; Hàm gửi phím qua COM tới Arduino
Func SendKey_Arduino($key)
;~     Local $port = ObjCreate("MSComm.MSComm")
;~     $port.CommPort = 3 ; ví dụ COM3
;~     $port.Settings = "9600,N,8,1"
;~     $port.PortOpen = True
;~     $port.Output = $key
;~     $port.PortOpen = False
EndFunc

; Hàm chung để gửi phím
Func SendKey($key)
    Switch $g_Method
        Case "AUTOIT"
            SendKey_AutoIt($key)
        Case "ARDUINO"
;~             SendKey_Arduino($key)
    EndSwitch
EndFunc

Func Attack()
    SendKey("x")
EndFunc

Func Jump()
    SendKey("c")
EndFunc

Func Left_Flash_Atk()
	Send("{LEFT down}")
	Sleep(50)
	Send("d")
	Sleep(50)
	Attack()
	Send("{LEFT up}")
EndFunc

Func Right_Flash_Atk()
	Send("{RIGHT down}")
	Sleep(50)
	Send("d")
	Sleep(50)
	Attack()
	Send("{RIGHT up}")
EndFunc


Func Right_Flash()
	Send("{RIGHT down}")
	Sleep(100)
	Send("d")
	Sleep(100)
	Send("{RIGHT up}")
EndFunc

Func Left_Flash()
	Send("{LEFT down}")
	Sleep(100)
	Send("d")
	Sleep(100)
	Send("{LEFT up}")
EndFunc

Func Down_Flash()
	Send("{DOWN down}")
	Sleep(50)
	Send("d")
	Sleep(50)
	Send("{DOWN up}")
EndFunc

Func Up_Flash()
	Send("{UP down}")
	Sleep(50)
	Send("d")
	Sleep(50)
	Send("{UP up}")
EndFunc

Func Jump_Up()
EndFunc

Func Jump_Down()
	Send("{DOWN down}")
	Sleep(50)
	Send("c")
	Sleep(50)
	Send("{DOWN up}")
EndFunc

Func Left_Move()
	Send("{LEFT down}")
EndFunc

Func Move_Off()
	Send("{LEFT up}")
	Send("{RIGHT up}")
EndFunc

Func Left_Move_Off()
	Send("{LEFT up}")
EndFunc

Func Right_Move()
	Send("{RIGHT down}")
EndFunc

Func Right_Move_Off()
	Send("{RIGHT up}")
EndFunc

Func Left_Jump_Atk_au3()
	Send("{LEFT down}")
	Send("c")
	Sleep(100)
	Send("{c 2}")
	Sleep(100)
	Send("{x down}")
 	Sleep(100)
 	Send("{x up}")
	Sleep(50)
	Send("{x down}")
 	Sleep(100)
 	Send("{x up}")
	Sleep(50)
	Send("{x down}")
 	Sleep(100)
 	Send("{x up}")
	Send("{LEFT up}")
EndFunc

Func Right_Jump_Atk_au3()
	Send("{RIGHT down}")
	Send("c")
	Sleep(100)
	Send("{c 2}")
	Sleep(100)
	Send("{x down}")
 	Sleep(100)
 	Send("{x up}")
	Sleep(50)
	Send("{x down}")
 	Sleep(100)
 	Send("{x up}")
	Sleep(50)
	Send("{x down}")
 	Sleep(100)
 	Send("{x up}")
	Send("{RIGHT up}")
EndFunc

;~ Func Right_Jump_Atk_au3()
;~ 	Send("{RIGHT down}")
;~ 	Send("c")
;~ 	Sleep(100)
;~ 	Send("{c 2}")
;~ 	Sleep(100)
;~ 	Opt("SendKeyDelay", 50)
;~ 	Send("{x 5}")
;~ 	Send("{RIGHT up}")
;~ 	Opt("SendKeyDelay", 5) ;5 milliseconds
;~ EndFunc

Func Left_Jump()
	Send("{LEFT down}")
;~ 	Sleep(100)
	Send("c")
	Sleep(100)
	Send("{c 2}")
;~ 	Sleep(100)
	Send("{LEFT up}")
EndFunc

Func Right_Jump()
	Send("{RIGHT down}")
;~ 	Sleep(100)
	Send("c")
	Sleep(100)
	Send("{c 2}")
;~ 	Sleep(100)
	Send("{RIGHT up}")
EndFunc

Func Rope_Lift()
	SendKey("t")
EndFunc