#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
ToolTip,building LinkRunner
FileDelete,NewOsk.exe
FileDelete,RJ_LinkRunner.exe
FileDelete,Setup.exe
RUnWait,"C:\Program Files\AutoHotKey\compiler\AHK2Exe.exe" /in "%A_ScriptDir%\RJ_LinkRunner.ahk" /icon "RJ_LinkRunner.ico" /bin "C:\Program Files\AutoHotKey\compiler\Unicode 64-bit.bin" /out "%A_ScriptDir%\RJ_LinkRunner.exe",%A_ScriptDir%,hide
ToolTip,building Setup
RUnWait,"C:\Program Files\AutoHotKey\compiler\AHK2Exe.exe" /in "%A_ScriptDir%\Setup.ahk" /icon "RJ_Setup.ico" /bin "C:\Program Files\AutoHotKey\compiler\Unicode 64-bit.bin" /out "%A_ScriptDir%\Setup.exe",%A_ScriptDir%,hide
ToolTip,Building NewOSK
RUnWait,"C:\Program Files\AutoHotKey\compiler\AHK2Exe.exe" /in "%A_ScriptDir%\NewOSK.ahk" /icon "NewOSK.ico" /bin "C:\Program Files\AutoHotKey\compiler\Unicode 64-bit.bin" /out "%A_ScriptDir%\NewOSK.exe",%A_ScriptDir%,hide
;ToolTip,building Shortcuts
;RUnWait,"C:\Program Files\AutoHotKey\compiler\AHK2Exe.exe" /in "%A_ScriptDir%\RJ_Shortcuts.ahk" /icon "RJ_Shortcuts.ico" /bin "C:\Program Files\AutoHotKey\compiler\Unicode 64-bit.bin" /out "%A_ScriptDir%\RJ_Shortcuts.exe",%A_ScriptDir%,hide
ToolTip,complete
sleep,2000

