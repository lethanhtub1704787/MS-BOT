#RequireAdmin
#include<HotKey.au3>
; Khai báo biến toàn cục để chọn phương thức


Func Play()
	Local $drug_time = TimerInit()
	Local $orb_time = TimerInit()
	Local $janus_time = TimerInit()
	Local $rune_time = TimerInit()
	Local $atk_direct = True
	Local $first_rune = False

	Local $left_x = 65, $left_y = 151
	Local $right_x = 160, $right_y = 151

	Local $orb_x = 44, $orb_y = 136
	Local $janus_1_x = 75, $janus_1_y = 140
	Local $janus_2_x = 110, $janus_2_y = 140
	Local $janus_3_x = 145, $janus_3_y = 140

	While 1
		$myPosition = myPosition()
		$runeCheck = runePosition()
		$left = PixelSearch(0,$left_y-5,$left_x,$left_y+5,$charColor)
		$right = PixelSearch($right_x,$right_y-5,$right_x+50,$right_y+5,$charColor)
		If IsArray($left) And $atk_direct == False Then
			$atk_direct = True
		EndIf

		If IsArray($right) And $atk_direct == True Then
			$atk_direct = False
		EndIf

		Select
			Case (IsArray($runeCheck) And TimerDiff($rune_time) > 15*60*1000) Or $first_rune == True
				MoveTo($runeCheck[0],$runeCheck[1],"jump")
				GetRune()
				$rune_check = RuneCheck()
				If $rune_check == False Then
					$rune_time = TimerInit()
					$first_rune = False
				EndIf

			Case TimerDiff($drug_time) > 30 * 60 * 1000
				Sleep(500)
				Send("1")
				Sleep(500)
				Send("2")
				Sleep(500)
				Send("3")
				$drug_time = TimerInit()
			Case TimerDiff($orb_time) > 40000 And IsArray($left)
				turn_right()
				Sleep(100)
				jump()
				Sleep(100)
				Send("r")
				$orb_time = TimerInit()

			Case TimerDiff($janus_time) > 60000
				MoveTo($janus_1_x,$janus_1_y,"jump",3)
				Send("a")
				MoveTo($janus_2_x,$janus_2_y,"jump",3)
				Send("a")
				MoveTo($janus_3_x,$janus_3_y,"jump",3)
				Send("a")
				$janus_time = TimerInit()

			Case $atk_direct == False
				Left_Jump_Atk_au3()

			Case $atk_direct == True
				Right_Jump_Atk_au3()
		EndSelect
		Sleep(50)
	WEnd
EndFunc

;~ 60,160
;~ 165,160
;~ 75,147
;~ 121,147
;~ 151,147


Func Test()
	showMyPosition()
;~ 	LittleJumpUp()
EndFunc