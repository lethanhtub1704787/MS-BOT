#include <ArduinoKeySet.au3>
Global $CMPort = 3
Global $CmBoBaud = 9600
Global $sportSetError = ''
Global $CmboDataBits = 8
Global $CmBoParity = "none"
Global $CmBoStop = 1
Global $setflow = 2

_CommSetPort($CMPort, $sportSetError, $CmBoBaud, $CmboDataBits, $CmBoParity, $CmBoStop, $setflow)

If @error Then
    MsgBox(16, "Error!", "Can't connect to Arduino on port - " & $CMPort)
    Exit
EndIf

_CommSetRTS(0)
_CommSetDTR(0)