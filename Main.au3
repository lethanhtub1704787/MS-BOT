#RequireAdmin
#include<HotKey.au3>
; Khai báo biến toàn cục để chọn phương thức


Func Play()
	Local $drug_time = TimerInit()
	Local $orb_time = TimerInit()
	Local $janus_time = TimerInit()
	Local $atk_direct = True

	Local $left_x = 40, $left_y = 152
	Local $right_x = 155, $right_y = 152

	Local $orb_x = 44, $orb_y = 136
	Local $janus_1_x = 97, $janus_1_y = 136
	Local $janus_2_x = 142, $janus_2_y = 136
	While 1
		$myLocation = myPosition()
		$runeLocation = runePosition()
		$left = PixelSearch(0,$left_y-5,$left_x,$left_y+5,$charColor)
		$right = PixelSearch($right_x,$right_y-5,$right_x+20,$right_y+5,$charColor)
		If IsArray($left) And $atk_direct == False Then
			$atk_direct = True
		EndIf

		If IsArray($right) And $atk_direct == True Then
			$atk_direct = False
		EndIf

		Select
			Case TimerDiff($orb_time) > 40000
				MoveTo($orb_x,$orb_y)
				turn_right()
				Sleep(300)
				jump()
				Sleep(100)
				Send("r")
				$orb_time = TimerInit()
				Sleep(200)

			Case TimerDiff($janus_time) > 65000
				MoveTo($janus_1_x,$janus_1_y)
				Send("a")
				MoveTo($janus_2_x,$janus_2_y)
				Send("a")
				$janus_time = TimerInit()

			Case $atk_direct == False
				Left_Jump_Atk_au3()

			Case $atk_direct == True
				Right_Jump_Atk_au3()
		EndSelect
		Sleep(100)
	WEnd
EndFunc

;~ 44,136
;97,136
;~ 142,135
Func Test()
;~ 	Left_Jump_Atk_au3()
;~ 	turn_left()
	showMyPosition()
;~ 	$runePosition = runePosition()
;~ 	If IsArray($runePosition) Then
;~ 		GetRune($runePosition[0],$runePosition[1])
;~ 	EndIf

EndFunc