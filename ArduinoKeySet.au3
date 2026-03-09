#include <CommMG.au3>

Func release_all()
	_CommSendString("*")
EndFunc

Func Send_1()
	_CommSendString("1")
EndFunc

Func Send_2()
	_CommSendString("2")
EndFunc

Func Send_3()
	_CommSendString("3")
EndFunc

Func Send_4()
	_CommSendString("4")
EndFunc

Func Send_5()
	_CommSendString("5")
EndFunc

Func Send_6()
	_CommSendString("6")
EndFunc

Func arrow_blaster()
	_CommSendString("7")
EndFunc

Func left_jump_attack() ; Del
	_CommSendString("8")
EndFunc

Func right_jump_attack() ; Q
	_CommSendString("9")
EndFunc

Func Send_0() ; E
	_CommSendString("0")
EndFunc

Func Send_F3() ; => solve rune
	_CommSendString("$")
EndFunc

Func Send_F5() ; => eliminate all
	_CommSendString("%")
EndFunc

Func Send_F6() ; => pause bot
	_CommSendString("^")
EndFunc

Func Send_F7() ; => get rune
	_CommSendString("&")
EndFunc

Func jump_up() ; => pause rune check
	_CommSendString("(")
EndFunc

Func Send_F9() ; pause overwatch
	_CommSendString("!")
EndFunc

Func Send_PgDown()
	_CommSendString(",")
EndFunc

Func Send_PgUp()
	_CommSendString(".")
EndFunc

Func Send_Shift() ;
	_CommSendString("/")
EndFunc

Func Send_CTRL() ;
	_CommSendString("[")
EndFunc

Func Send_INSERT() ;
	_CommSendString("=")
EndFunc

Func Send_DEL() ;
	_CommSendString(";")
EndFunc

Func Send_HOME() ;
	_CommSendString("]")
EndFunc

Func Send_END() ;
	_CommSendString("-")
EndFunc

Func move_left()
	_CommSendString("w")
EndFunc

Func move_right()
	_CommSendString("z")
EndFunc

Func release_left()
	_CommSendString("<")
EndFunc

Func release_right()
	_CommSendString(">")
EndFunc

Func Send_Q() ;
	_CommSendString("q")
EndFunc

Func Send_E() ;
	_CommSendString("e")
EndFunc

Func Send_R() ;
	_CommSendString("r")
EndFunc

Func Send_T() ;
	_CommSendString("t")
EndFunc

Func Send_A() ;
	_CommSendString("a")
EndFunc

Func Send_S() ;
	_CommSendString("s")
EndFunc

Func Send_D() ;
	_CommSendString("d")
EndFunc

Func Send_F() ;
	_CommSendString("f")
EndFunc

Func Send_C() ;
	_CommSendString("c")
EndFunc

Func jump_up_short() ;
	_CommSendString("v")
EndFunc

Func left_jump() ; <- D
	_CommSendString("`")
EndFunc

Func right_jump() ; -> D
	_CommSendString("y")
EndFunc

Func jump_down()
	_commsendstring("u")
Endfunc

Func turn_left()
	_CommSendString("n")
EndFunc

Func turn_right()
	_CommSendString("m")
EndFunc

Func arrow_left()
	_CommSendString("j")
EndFunc

Func arrow_right()
	_CommSendString("l")
EndFunc

Func arrow_up()
	_CommSendString("i")
EndFunc

Func arrow_down()
	_CommSendString("k")
EndFunc

Func Send_SPACE() ;
	_CommSendString("b")
EndFunc

Func Send_ENTER() ;
	_CommSendString("o")
EndFunc

; ================ Custom Action ============ ;

Func attack()
	_CommSendString("+")
EndFunc

Func long_attack() ;
	_CommSendString("~")
EndFunc

Func left_flash()
	_CommSendString("{")
EndFunc

Func right_flash()
	_CommSendString("}")
EndFunc

Func down_flash()
	_CommSendString("h")
EndFunc

Func jump_flash()
	_CommSendString("p")
EndFunc

Func high_jump_flash()
	_CommSendString(")")
EndFunc
