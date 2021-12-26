#NoEnv  
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance Force
#Persistent
Loop %0%  
	{
		GivenPath := %A_Index%
		Loop %GivenPath%,
			{
				if (plink = "")
					{
						plink = %A_LoopFileLongPath%
						continue
					}
			}
		IF (!INSTR(LinkOptions,GivenPath)&& !instr(LinkOptions,plink)&& (GivenPath <> plink))
			{
				LinkOptions.= GivenPath . a_SpACE
			}
	}
splitpath,plink,scname,scpath,scextn,gmname,gmd
ExtID := FileExt
IconNumber:= 0				
if ((plink = "") or !fileExist(plink) or (scextn = ""))
	{
		Tooltip, No Item Detected
		Sleep, 3000
		exitapp
	}
home= %A_ScriptDir%
Splitpath,A_ScriptDir,tstidir,tstipth
if ((tstidir = "src")or(tstidir = "bin")or(tstidir = "binaries"))
	{
		home= %tstipth%
	}
source= %home%\src
binhome= %home%\bin
curpidf= %home%\rjpids.ini
filedelete,%curpidf%
Tooltip,Keyboad/Mouse Disabled`n::Please Be Patient::`n
Blockinput, on
if (GetKeyState("Alt")&&(scextn = "exe"))
	{
		FindName= 1
	}
;;LinkOptions= 
inif= %home%\RJDB.ini
scpini= %scpath%\Game.ini
if fileexist(scpini)
	{
		inif= %scpini%
	}
READINI:
sect= GENERAL|JOYSTICKS
Loop,parse,sect,|
	{
		if (A_LoopField = "")
			{
				continue
			}
		section= %A_LoopField%
		IniRead,rjtbl,%inif%,%section%
		Loop,parse,rjtbl,`n`r
			{
				stringsplit,fi,A_LoopField,=
				iniread,vi,%inif%,%section%,%fi1%
				if (vi = "ERROR")
					{
						vi= 
					}
				if (vi <> "")
					{
						%fi1%= %vi%
					}
			}
	}
if (MULTIMONITOR_TOOL <> "")
	{
		splitpath,multimonitor_tool,mmtof,mmpath
	}
Loop, 4
	{
		stringleft,dhf,LinkOptions,1
		if ((dhf = A_Space)or(dhf = A_Tab))
			{
				stringtrimleft,linkoptions,linkoptions,1
			}
		stringright,dhg,LinkOptions,1
		if ((dhg = A_Space)or(dhg = A_Tab))
			{
				stringtrimright,linkoptions,linkoptions,1
			}
	}
	
linkoptions:= A_Space . LinkOptions

IniRead,rjtgl,%INIF%,CONFIG
if (MONH = "")
	{
		MONH= %A_ScreenHeight%
	}	
if (MONW = "")	
	{
		MONW= %A_ScreenWidth%
	}
stringreplace,rjtgl,rjtgl,[XRZ],%MonW%,All
stringreplace,rjtgl,rjtgl,[YRZ],%MonH%,All
Loop,parse,rjtgl,`n`r
	{
		if (A_LoopField = "")
			{
				continue
			}
		varit= %A_LoopField%
		Loop,6
			{
				dpro=
				dus= 
				stringsplit,fi,varit,=
				if instr(fi1,"extapp")
					{
						iniread,vi,%inif%,CONFIG,%fi1%
						dpro:= % extapp%A_Index%
						stringreplace,rjtgl,rjtgl,[extapp%A_Index%],%dpro%,All
					}
			}
	}


Loop,10
	{
		kvl:= A_Index + 1
		arin= %A_Index%
		DSPI:= % DISPLAY%A_Index%
		DSPN:= % DISPLAY%kvl%
		vpr:= % extapp%A_Index%		
		stringreplace,rjtgl,rjtgl,[disp%A_Index%],%DSPI%,All
		stringreplace,rjtgl,rjtgl,[disp%kvl%],%DSPN%,All
		stringreplace,rjtgl,rjtgl,[extapp%A_Index%],%vpr%,All
	}
Loop,parse,rjtgl,`n`r
	{	
		ein= %A_LoopField%
		stringsplit,fn,ein,=
		stringreplace,evi,ein,%fn1%=,,All
		if ((evi <> "")&&(evi <> "ERROR"))
			{
				%fn1%= %evi%
			}
	}
if (disprogd = 1)
	{
		mmpath= %multimonitor_path%
		if (multimonitor_path = "")
			{
				splitpath,MultiMonitor_Tool,,mmpath
			}
	}
if (scextn = "lnk")
	{
		FileGetShortcut, %plink%, plfp, pldr, plarg
		if (plarg <> "")
			{
				plarg:= A_Space . plarg
				LinkOptions= 
			}	
	}
	else {
		plfp= %plink%
		splitpath,plfp,,pldr,,plfname
	}
splitpath,plfp,pfilef,pfdir,plxtn,plnkn
tempn= %gmname%	
if (FindName = 1)
	{
		gosub, NameTuning
		GoSub, AltKey
	}
	else {
		gmnamex= %tempn%
	}
if (Game_Profile = "")
	{
		Game_Profile= %scpath%\Game.ini
		Game_Profiles= %scpath%
		ifnotexist,%game_profile%
			{
				Game_Profile= %GAME_PROFILES%\%gmnamex%\game.ini
				Game_Profiles= %Game_Profiles%\%gmnamex%
				}
	}
if (fileexist(Game_Profile)&&(gbar <> 1))
	{
		gbar = 1
		inif= %Game_Profile%
		Tooltip,::Please Be Patient::`nReading Configuration
		goto, readini
	}
else {
	if !fileexist(Game_Profile)
		{			
			gosub, NameTuning
			gosub, SetupINIT
		}
}	


/*	

*/
stringsplit,prestk,1_Pre,<
stringright,lnky,prestk2,4
runhow= 
if (prestk2 <> "")
	{
		if (lnky = ".lnk")
			{
				Filegetshortcut,%prestk2%,,,argm,,,,lsrst
				if (lsrst = 7)
					{
						runhow= hide
					}			
				if (lsrst = 3)
					{
						runhow= Max
					}
			}
		if instr(prestk1,"W")
			{
				RunWait,%prestk2%,%A_ScriptDir%,%runhow%,preapid
				gosub,nonmres
			}
		Run,%prestk2%,%A_ScriptDir%,,preapid	
		iniwrite,%preapid%,%home%/rjpids.ini,1_Pre,pid
	}
acwchk=
GMGDBCHK= %gmnamex%	
Tooltip, Configuration Created`n:::running %gmnamx% preferences:::
if (fileexist(Borderless_Gaming_Program)&&(Borderless_Gaming_Program <> ""))
	{
		bgpon= 1
		gosub, nonmres
	}

pgmonchk:
if (MonitorMode > 0)
	{
		if (instr(MULTIMONITOR_TOOL,"multimonitortool")&& fileexist(MM_Game_Config)&& fileexist(MM_MEDIACENTER_Config))
			{
				RunWait,%MultiMonitor_Tool% /LoadConfig "%MM_Game_Config%",%mmpath%,hide,mmpid
			}
		else {
				Run,%MultiMonitor_Tool%,%mmpath%,hide,mmpid
			}
		iniwrite,%mmpid%,%curpidf%,MultiMonitor_Tool,pid
	}
Gui, Color, Black

Gui, +ToolWindow -Caption +AlwaysOnTop

Gui, show, x0 y0 w%A_ScreenWidth% h%A_ScreenHeight%, NA
sleep, 1200
Mapper_Extension:= % Mapper_Extension

;regRead,curwlp,HKCU\Control Panel\Desktop, WallPaper
;regWrite, REG_SZ,HKCU\Control Panel\Desktop,WallPaper," "
;RunWait, Rundll32.exe user32.dll`, UpdatePerUserSystemParameters

Tooltip,
WinGet, WindowList, List
Loop, %WindowList%
	{
		WinMinimize, % "ahk_id " . WindowList%A_Index%
	}
Send {LCtrl Down}&{LAlt Down}&B	
Send {LCtrl Up}&{LAlt Up}
stringsplit,prestk,2_Pre,<
stringright,lnky,prestk2,4
runhow= 
if (prestk2 <> "")
	{
		if (lnky = ".lnk")
			{
				Filegetshortcut,%prestk2%,,,argm,,,,lsrst
				if (lsrst = 7)
					{
						runhow= hide
					}			
				if (lsrst = 3)
					{
						runhow= Max
					}
			}
		if instr(prestk1,"W")
			{
				RunWait,%prestk2%,%A_ScriptDir%,%runhow%,prebpid
				goto, premapper
			}
		Run,%prestk2%,%A_ScriptDir%,%runhow%,prebpid
		iniwrite,%prebpid%,%curpidf%,2_Pre,pid
	}
premapper:	
if (Mapper > 0)
	{
		ToolTip,Running %gmnamx% preferences`n:::Loading Joystick Configurations:::
		joyncnt=
		joycnt=	
		Loop, 16
			{
				player%A_Index%n=
				player%A_Index%t=
			}
		stringreplace,MEDIACENTER_Profilen,MEDIACENTER_PROFILE,%mapper_extension%,,All
		splitpath,MEDIACENTER_Profilen,mcnm,mcntp,mcnxtn,mcntrn	
		splitpath,Player1,p1fn,pl1pth,,plgetat
		loop, 16 
			{
				joypartX:= % joyGetName(A_Index)
				joypart%A_Index%:= joypartX
				if (joypartX = "failed")
					{
						PlayerVX= 
						player%A_Index%n=
						player%A_Index%t=
						;msgbox,,,% joypart%A_Index%
						continue
					}
				joycount+= 1
				if (2 > JoyCount)
					{
						continue
					}
				playerVX:= % player%JoyCount%	
				player%JoyCount%X:= % player%JoyCount%	
				player%JoyCount%n= "%playerVX%"
				player%JoyCount%t:= A_Space . (player%JoyCount%n)
				iniwrite,%PlayerVX%,%inif%,GENERAL,Player%JoyCount%
			}
		Joycnt= %joycount%
		if (JMap = "joytokey")
			{
				process,close,.exe
				sleep,600
			}
		if (JMap = "xpadder")
			{
				process,close,xpadder.exe
				sleep,600
			}
		if (JMap = "antimicro")
			{
				unload:= "" . antimicro_executable . "" . A_Space . "--unload"
				Run, %unload%,%mapperp%,hide
				process,close,antimicro.exe
				sleep,600
			}
		ToolTip, %joycnt% Joysticks found
		Run,%Keyboard_Mapper% "%player1%"%player2t%%player3t%%player4t%,,hide,kbmp
		if (Logging = 1)
			{
				fileappend,`n#####`n%Keyboard_Mapper% "%player1%"%player2t%%player3t%%player4t%`npid=%kbmp%`n#####`n,%home%\log.txt
			}
		Sleep,600
		Loop,5
			{
				Process,Exist,%mapln%
				if (errorlevel <> 0)
					{
						enfd= %errorlevel%
						break
					}
				Sleep,500
			}
		iniwrite,%joycnt%,%curpidf%,Mapper,connected
		iniwrite,%kbmp%,%curpidf%,Mapper,pid
		joyncnt:= joycnt
		if (Joycnt >= 2)
			{
				Loop,files,%pl1pth%\*.%mapper_extension%
					{
						if (A_LoopFileFullPath = Player1X)
							{
								joyncnt+= 1
								continue
							}
						joyncnt+= 1
						PlayerN= %gmnamex%_%joyncnt%.%mapper_extension%
						if (A_LoopFileName = PlayerN)
							{
								joypartX:= % joyGetName(joyncnt)
								iniwrite,%A_LoopFileFullPath%,%inif%,GENERAL,Player%joyncnt%
								Player%joycnt%= %A_loopFileFullPath%
							}
					}
				Loop,%joycnt%
					{
						if (A_Index = 1)
							{
								continue
							}
						PlayerZ= %pl1pth%\%gmname%_%A_Index%.%mapper_extension%
						NPlayer:= % Player%A_Index%
						if (!fileexist(PlayerZ)&& !fileexist(NPlayer))
							{
								FileCopy, %Player2_Template%, %PlayerZ%
								iniwrite,%A_LoopFileFullPath%,%inif%,GENERAL,Player%joyncnt%
							}
						ifnotexist,%mcntp%\%mcntrn%_%A_index%.%mapper_extension%
							{
								filecopy,%MediaCenter_Profile_Template%,%mcntp%\%mcntrn%_%A_Index%.%mapper_extension%
								iniwrite,%mcntp%\%mcntrn%_%A_Index%.%mapper_extension%,%inif%,GENERAL,MediaCenter_Profile%A_Index%
							}
					}
			}
	}
stringsplit,prestk,3_Pre,<
stringright,lnky,prestk2,4
runhow= 
Gui, Destroy
if (prestk2 <> "")
	{
		if (lnky = ".lnk")
			{
				Filegetshortcut,%prestk2%,,,argm,,,,lsrst
				if (lsrst = 7)
					{
						runhow= hide
					}			
				if (lsrst = 3)
					{
						runhow= Max
					}
			}
		if instr(prestk1,"W")
			{
		RunWait,%prestk2%,%A_ScriptDir%,%runhow%,precpid
				goto,begin
			}
		Run,%prestk2%,%A_ScriptDir%,%runhow%,precpid
		iniwrite,%precpid%,%curpidf%,3_Pre,pid
	}	
begin:
ToolTip,Loading %gmnamex%
if (nrx > 2)
	{
		Tooltip,reload exceeded marker`nBe sure you have the launched executable in the exe_list for this game.
		goto, givup
	}
Blockinput, Off	
ToolTip,
Run, %plfp%%linkoptions%%plarg%,%pldr%,max UseErrorLevel,dcls
nerlv= %errorlevel%
Tooltip,
Process, Exist, %bgmexe%
goto, bgl
if (instr(bgm,gmname)or instr(bgm,GMGDBCHK))
	{
		Run, %bgaming%,%BGMLOC%,,bgpid
		iniwrite,%bgpid%,%curpidf%,Borderless_Gaming_Program,pid
	}
	
bgl:	
Tooltip, :::getting ancilary exes:::
apchkn=
if (exe_list <> "")
	{
		appcheck:
		sleep, 1000
		Loop,parse,exe_list,|
			{
				apchkn+=1
				if (A_LoopField = "")
					{
						continue
					}
				process,exist,%A_LoopField%
				erahkpid= %errorlevel%
				if (erahkpid <> 0)
					{
						break
					}
				if (apchkn > 10)
					{
						Tooltip,
						goto,appcheck
					}
			}
		;;msgbox,,,%erahkpid% is closed`n%gmgdbchk% found`nnerlv=%nerlv%`ngii=%gii%`ndcls=%dcls%
		Tooltip,
		WinActivate
		WinGetActiveTitle,GMGDBCHK
		if ((GMGDBCHK <> gmname)&&(bgpon = 1))
			{
				acwchk= 1
				gosub,nonmres
				acwchk= 
			}
		Tooltip,
		BlockInput,Off
		iniwrite,%erahkpid%,%curpidf%,Current_Game,pid
		process,WaitClose, %erahkpid%
		goto, appclosed	
	}
Tooltip,
BlockInput,Off	
		;;msgbox,,,%erahkpid% is closed`n%gmgdbchk% found`nnerlv=%nerlv%`ngii=%gii%`ndcls=%dcls%
iniwrite,%dcls%,%curpidf%,Current_Game,pid
WinWait, ahk_pid %dcls%
WinActivate
WinGetActiveTitle,GMGDBCHK
if ((GMGDBCHK <> gmname)&&(bgpon = 1))
	{
		acwchk= 1
		gosub,nonmres
		acwchk= 
	}
Process,waitclose,%DCLS%

AppClosed:
if ((nerlv = 1234)or(gii = 1))
	{
		goto, givup
	}
ToolTip, Disabling Keyboard`n:::Please be patient:::
BlockInput, On
nrx+=1
goto, begin
return

Ctrl & f2::
process,close,%dcls%
ToolTip,Closing
process, close, %pfilef%
if (exe_list <> "")
	{
		Loop,parse,exe_list,|
			{
				process,close,%A_LoopField%
			}
		Tooltip,
	}
dcls= 
nrx=
return

^!+f9::
Run, NewOsk.exe
Return


Ctrl & f12::
givup:
Tooltip,...Quitting...
gii= 1
Quitout:
Blockinput,On
Tooltip,Keyboard / Mouse are disabled`n:::Please be patient:::
process,exist,%mapapp%
mperl= %errorlevel%
stringsplit,prestk,1_Post,<
stringright,lnky,prestk2,4
runhow= 
if (prestk2 <> "")
	{
		if (lnky = ".lnk")
			{
				Filegetshortcut,%prestk2%,,,argm,,,,lsrst
				if (lsrst = 7)
					{
						runhow= hide
					}			
				if (lsrst = 3)
					{
						runhow= Max
					}
			}
		if instr(prestk1,"W")
			{
				RunWait,%prestk2%,%A_ScriptDir%,%runhow%,postapid
				goto,postmapper
			}
		Run,%prestk2%,%A_ScriptDir%,%runhow%,postapid
	}
postmapper:	
if (Mapper > 0)
	{
		ToolTip,Please Be Patient`n:::Reloading Mediacenter/Desktop Profiles:::
		loop, 4 
			{
				PlayerVX=
				joypartX:= % joyGetName(A_Index)
				joypart%A_Index%:= joypartX
				if (joypartX = "failed")
					{
						break
					}
				joycount+= 1
				if (JoyCount >= joycnt)
					{
						continue
					}
				playerVX:= % player%JoyCount%	
				player%JoyCount%X:= playerVX
				player%JoyCount%n= "%playerVX%"
				playerVN= "%playerVX%"
				player%JoyCount%t:= A_Space . (playerVN)
				iniwrite,%PlayerVX%,%inif%,GENERAL,Player%A_index%
				if (JoyCount = 1)
					{
						MediaCenter_Profile= %Game_Profiles%\%MEDIACENTER_Profilen%.%Mapper_Extension%
						continue
					}
					else {
						MEDIACENTER_PROFILE_N= %GAME_PROFILES%\%MEDIACENTER_Profilen%_%JoyCount%.%Mapper_Extension%
						if (JMap = "antimicro")
							{
								mediacenter_profile_%JoyCount%n= "%MEDIACENTER_PROFILE_N%"
								mediacenter_profile_%JoyCount%t:=  A_Space . "" . MEDIACENTER_PROFILE_N . ""				
							}		
						if (JMap = "JoyToKey")
							{
								mediacenter_profile_%JoyCount%n= "%MEDIACENTER_PROFILE_N%"
								mediacenter_profile_%JoyCount%t:=  A_Space . "" . MEDIACENTER_PROFILE_N . "" . A_Space "" . GAME_PROFILES . "\" . GMNAMEX . "" 
							}
						if (JMap = "xpadder")
							{
								mediacenter_profile_%JoyCount%n= "%MEDIACENTER_PROFILE_N%"
								mediacenter_profile_%JoyCount%t:=  A_Space . "" . MEDIACENTER_PROFILE_N . ""				
							}
					}
			}
		if (joycount < 2)
			{
				Loop,4
					{
						if (A_Index = 1)
							{
								continue
							}
						mediacenter_profile_%A_Index%= 
						mediacenter_profile_%A_Index%t= 
					}
			}
		else {
			if (joycount > 1)
				{
					joyindex=
					splitpath,Player1,p1fn,pl1pth,,plgetat
					Loop, 4
						{
							joyindex+=1
							Loop,files,%pl1pth%\*.%mapper_extension%
								{
									PlayerVX= 
									if ((A_LoopFileFullPath = Player1) or (A_LoopFileFullPath = Player2) or (A_LoopFileFullPath = Player3) or (A_LoopFileFullPath = Player4) or instr(A_LoopFileName,"MediaCenter"))
										{
											continue
										}
									if (A_LoopFileName = plgetat . "_" . joyindex)
										{
											PlayerVX= %A_LoopFileFullPath%
											Player%joyindex%= %A_LoopFileFullPath%
											break
										}
									if (instr(A_LoopFileName,"Player" . joyindex)or instr(A_LoopFileName,"Player_" . joyindex)or instr(A_LoopFileName,"Player" . A_Space . joyindex)or instr(A_LoopFileName,"Player" . joyindex))
										{
											Player%joyindex%= %A_LoopFileFullPath%
											break
										}
									else {
											Player%joyindex%= %A_LoopFileFullPath%
											break
									}
								}
						}
					Loop,%joycount%	
						{
							plyrnx:= % Player%A_Index%
							P_LoopInd= %A_Index%
							if ((plyrnx = "")or !fileexist(plyrnx))
								{
									if (plyrnx = "")
										{
											plyrnx= %pl1pth%\%gmnamex%_%P_LoopInd%.%mapper_extension%
										}
									FileCopy,%Player2_Template%,%plyrnx%
								}
							Loop,Files,%pl1pth%\MediaCenter*.%mapper_extension%
								{
									mcmnm= 
									if ((A_LoopFileFullPath = MediaCenter_Profile)or(P_LoopInd = 1))
										{
											if (A_LoopFileFullPath = MediaCenter_Profile)
												{
													mcmnm= 	%A_LoopFileFullPath%							
												}
											continue
										}
									stringreplace,mctmpx,A_LoopFileName,%mapper_extension%,,All
									stringright,mctmpnn,mctmpx,1
									if ((P_LoopInd = mctmpnn)&&(P_LoopInd <> 1))
										{
											MediaCenter_Profile_%P_LoopInd%= %A_LoopFileFullPath%
											mcmnm= %MediaCenter_Profile%_%P_LoopInd%
											if (JMap = "antimicro")
												{
													mediacenter_profile_%P_LoopInd%n= "%mcmnm%"
													mediacenter_profile_%P_LoopInd%t:=  A_Space . "" . mcmnm . ""				
												}		
											if (JMap = "xpadder")
												{
													mediacenter_profile_%P_LoopInd%n= "%mcmnm%"
													mediacenter_profile_%P_LoopInd%t:=  A_Space . "" . mcmnm . ""				
												}		
											if (JMap = "joytokey")
												{
													if (A_index = 1)
														{
															mediacenter_profile_%P_LoopInd%n= "%mcmnm%"
															mediacenter_profile_%P_LoopInd%t:=  A_Space . "" . mcmnm . ""	. A_Space . "" . GAME_PROFILES . "\" . GMNAMEX . "" 
														}
													else {
														continue
														}	
												}
											break
										}
								}
							if ((mcmnm = "")or !fileexist(mcmnm))
								{
									if (mcmnm = "")
										{
											mcmnm= %pl1pth%\MediaCenter_%P_LoopInd%.%mapper_extension%
										}
									if (JMap = "antimicro")
										{
											mediacenter_profile_%P_LoopInd%n= "%mcmnm%"
											mediacenter_profile_%P_LoopInd%t:=  A_Space . "" . mcmnm . ""				
										}		
									if (JMap = "JoyToKey")
										{
											if (A_Index = 1)
												{
													mediacenter_profile_%P_LoopInd%n= "%mcmnm%"
													mediacenter_profile_%P_LoopInd%t:=  A_Space . "" . GAMEPROFILES . "\" . GMNAMEX . ""				
													}

												else {
													continue
													}	
										}			
									if (JMap = "xpadder")
										{
											mediacenter_profile_%P_LoopInd%n= "%mcmnm%"
											mediacenter_profile_%P_LoopInd%t:=  A_Space . "" . mcmnm . ""				
										}	
									if (Logging = 1)
										{
											FileAppend,%MediaCenter_Profile_Template%==%pl1pth%\MediaCenter_%P_LoopInd%.%mapper_extension%	,%home%\log.txt
										}
									FileCopy,%MediaCenter_Profile_Template%,%pl1pth%\MediaCenter_%P_LoopInd%.%mapper_extension%	
								}
						}
				}
		}	
		Run, %Keyboard_Mapper% "%MediaCenter_Profile%"%MediaCenter_Profile_2t%%MediaCenter_Profile_3t%%MediaCenter_Profile_4t%,,hide,kbmp
		Loop,5
			{
				Process,Exist,%mapln%
				if (errorlevel <> 0)
					{
						enfd= %errorlevel%
						break
					}
				Sleep,500
			}
	}
Tooltip,Reloading Profiles`n:::shutting down game:::

process,close, %erahkpid%
process,close, %dcls%
process, close, %pfilef%
if (exe_list <> "")
	{
		Loop,parse,exe_list,|
			{
				process,close,%A_LoopField%
			}
	}
if (Logging = 1)
	{
		fileappend,er=%erahkpid%`ndcls=%dcls%`npfile=%pfile%,%home%\log.txt
	}
Run, taskkill /f /im "%plnkn%*",,hide
stringsplit,prestk,2_Post,<
stringright,lnky,prestk2,4
runhow= 
if (prestk2 <> "")
	{
		if (lnky = ".lnk")
			{
				Filegetshortcut,%prestk2%,,,argm,,,,lsrst
				if (lsrst = 7)
					{
						runhow= hide
					}			
				if (lsrst = 3)
					{
						runhow= Max
					}
			}
		if instr(prestk1,"W")
			{
				RunWait,%prestk2%,%A_ScriptDir%,%runhow%,postbpid
				goto,postmonitor
			}
		Run,%prestk2%,%A_ScriptDir%,%runhow%,postbpid	
	}
postmonitor:
;regWrite, REG_SZ,HKCU\Control Panel\Desktop,WallPaper,%curwlp%
;RunWait, Rundll32.exe user32.dll`, UpdatePerUserSystemParameters
if (MonitorMode > 0)
	{
		if (instr(MULTIMONITOR_TOOL,"multimonitortool")&& fileexist(MM_Game_Config)&& fileexist(MM_MediaCenter_Config))
			{
				Run, %MultiMonitor_Tool% /SaveConfig "%MM_Game_Config%",%mmpath%,hide,dsplo
				Run, %MultiMonitor_Tool% /LoadConfig "%MM_MediaCenter_Config%",%mmpath%,hide,dsplo
			}
		else {
			Run, %Multimonitor_Tool%,%mmpath%,hide,dsplo
		}	
	}
Tooltip,shutting down game`n:::Writing Settings
iniwrite,%MONITORMODE%,%inif%,GENERAL,MonitorMode
iniwrite,%disprogw%,%inif%,GENERAL,disprogw
iniwrite,%MAPPER%,%inif%,GENERAL,Mapper
iniwrite,%Game_Profile%,%inif%,GENERAL,Game_Profile
iniwrite,%KeyBoard_Mapper%,%inif%,GENERAL,KeyBoard_Mapper
Loop, 4
	{
		if (A_Index = 1)
			{
				iniwrite,%MediaCenter_Profile%,%inif%,GENERAL,MediaCenter_Profile
				continue
			}
		mcpn:= % MediaCenter_Profile%A_Index%	
		if (mcpn <> "")
			{
				iniwrite,%mcpn%,%inif%,GENERAL,MediaCenter_Profile%A_Index%
			}
	}
iniwrite,%MM_MEDIACENTER_Config%,%inif%,GENERAL,MM_MEDIACENTER_Config
iniwrite,%MM_Game_Config%,%inif%,GENERAL,MM_Game_Config
iniwrite,%MultiMonitor_Tool%,%inif%,GENERAL,MultiMonitor_Tool
iniwrite,%Game_Directory%,%inif%,GENERAL,Game_Directory
Loop,4
	{
		plyrn:= % Player%A_index%
		if (plyrn <> "")
			{
				iniwrite,%plyrn%,%inif%,GENERAL,Player%A_Index%	
			}
	}
iniwrite,%Jmap%,%inif%,JOYSTICKS,Jmap
iniwrite,%Mapper_Extension%,%inif%,JOYSTICKS,Mapper_Extension
sleep, 1000
WinGet, WindowList, List
Loop, %WindowList%
	{
		WinRestore, % "ahk_id " . WindowList%A_Index%
	}
Process, exist, %bgmexe%
	{
		Process,close,bgpid
		Process,close,%bgmexe%
		Run,Taskkill /f /im %bgmexe%,,hide
	}
Process,close,dsplo
Loop,20
	{
		process,close,vp%A_index%
		process,close,hp%A_index%
	}
Send {LCtrl Down}&{LAlt Down}&K
Send {LCtrl Up}&{LAlt Up}
stringsplit,prestk,3_Post,<
stringright,lnky,prestk2,4
runhow= 
if (prestk2 <> "")
	{
		if (lnky = ".lnk")
			{
				Filegetshortcut,%prestk2%,,,argm,,,,lsrst
				if (lsrst = 7)
					{
						runhow= hide
					}			
				if (lsrst = 3)
					{
						runhow= Max
					}
			}
		if instr(prestk1,"W")
			{
				RunWait,%prestk2%,%A_ScriptDir%,%runhow%,postcpid
				ToolTip,
				goto,loggingout
			}
		Run,%prestk2%,%A_ScriptDir%,%runhow%,postcpid	
	}
loggingout:	
if (Logging = 1)
	{
		FileAppend,Run="%plfp%[%linkoptions%|%plarg%]in%pldr%"`nkeyboard=|%Keyboard_Mapper% "%player1%"%player2t%%player3t%%player4t%|`njoycount1="%joycnt%"`n%Keyboard_Mapper% "%MediaCenter_Profile%"%MediaCenter_Profile_2t%%MediaCenter_Profile_3t%%MediaCenter_Profile_4t%`njoycount2=%joucount%`n`n,%home%\log.txt
	}
ExitApp

nonmres:
FileRead,bgm,%Borderless_Gaming_Database%
if (instr(bgm,GMGDBCHK)&& fileexist(Borderless_Gaming_Program))or (instr(bgm,gmname)&& fileexist(Borderless_Gaming_Program))
	{
		splitpath,Borderless_Gaming_Program,bgmexe,BGMLOC
			{
				Process,exist,%bgmexe%
				if (errorlevel = 0)	
					{
						Run, %Borderless_Gaming_Program%,%BGMLOC%,hide,bgpid
					}
					else {
						bgpid= %errorlevel%
					}
				if (acwchk = 1)
					{
						return
					}
			}
	}
return

AltKey:
Tooltip,!! AltKey Detected !!`nKeyboad/Mouse Disabled`n::Please Be Patient::`n
SetupINIT:
nogmnx= WIN32|WIN64|Game|Win|My Documents|My Games|Windows Games|Shortcuts
nogmne= Launch|Launcher|bat|cmd|exe|Program Files|Program Files (x86)|Windows|Roaming|Local|AppData|Documents|Desktop|%A_Username%|\|/|:|
CreateSetup= 1
iniread,Game_Profiles,%home%\RJDB.ini,GENERAL,Game_Profiles
Game_Profiles= %Game_Profiles%\%gmnamex%
iniread,mapper_extension,%home%\RJDB.ini,JOYSTICKS,mapper_extension
iniread,Game_Directory,%home%\RJDB.ini,GENERAL,Game_Directory
ifnotexist,%GAME_PROFILES%\game.ini
	{
		filecopy,%RJDB_Config%,%GAME_PROFILES%\game.ini
	}
FileCreateDir,%Game_Profiles%
ToolTip, Creating Configurations
FileCreateDir,%Game_Profiles%
Game_Profile= %Game_Profiles%\Game.ini
This_Profile= %Game_Profiles%
player1= %This_Profile%\%gmnamex%.%mapper_extension%
FileCopy,%Player1_Template%,%player1%,
player2= %This_Profile%\%gmnamex%_2.%mapper_extension%
FileCopy,%Player2_Template%,%player2%,
Filecopy,%home%\Game.cfg,%This_Profile%\Game.cfg
Filecopy,%home%\Desktop.cfg,%This_Profile%\Desktop.cfg
Filecopy,%home%\Mediacenter.%mapper_extension%,%This_Profile%\Mediacenter.%mapper_extension%
FileCopy,%home%\RJDB.ini,%This_Profile%\Game.ini
iniwrite,%This_Profile%\Desktop.cfg,%Game_Profile%,GENERAL,MM_MEDIACENTER_Config
iniwrite,%This_Profile%\Game.cfg,%Game_Profile%,GENERAL,MM_Game_Config
iniwrite,%player1%,%Game_Profile%,GENERAL,Player1
iniwrite,%player2%,%Game_Profile%,GENERAL,Player2
iniwrite,%This_Profile%\MediaCenter.%mapper_extension%,%Game_Profile%,GENERAL,MediaCenter_Profile
FileCreateShortcut,%plink%,%This_Profile%\%gmnamex%.lnk,%scpath%, ,%gmnamex%,%plink%,,%iconnumber%
FileCreateShortcut,%binhome%\RJ_LinkRunner.exe, %Game_Directory%\%gmnamex%.lnk,%scpath%, `"%This_Profile%\%gmname%.lnk`",%gmname%,%plink%,,%iconnumber%
inif= %RJDB_Config%,%GAME_PROFILES%\game.ini
Return	

NameTuning:
StringReplace,gmnamex,tempn,%A_Space%Launcher,,All
StringReplace,gmnamex,gmnamex,_Launcher,,All
StringReplace,gmnamex,gmnamex,%A_Space%Shortcut,,All
StringReplace,gmnamex,gmnamex,-Launcher,,All
StringReplace,gmnamex,gmnamex,Launch%A_Space%,,All
StringReplace,gmnamex,gmnamex,Launch-,,All
StringReplace,gmnamex,gmnamex,Launch_,,All
StringReplace,gmnamex,gmnamex,WIN64,,All
StringReplace,gmnamex,gmnamex,WIN_64,,All
StringReplace,gmnamex,gmnamex,WIN_32,,All
StringReplace,gmnamex,gmnamex,WIN32,,All
StringReplace,gmnamex,gmnamex,%A_Space%x64,,All
StringReplace,gmnamex,gmnamex,x-64,,All
StringReplace,gmnamex,gmnamex,_x64,,All
StringReplace,gmnamex,gmnamex,Shortcut to%A_Space%,,All
Stringleft,chka,gmnamex,1
StringRight,chkb,gmnamex,1

Loop,4
	{
		if ((chka = "_") or (chka = "-")or (chka = ".") or (chka = "%A_Space%"))
			{
				stringtrimleft,gmnamex,gmnamex,1
				Stringleft,chka,gmnamex,1
			}			
	}
Loop,4
	{
		if ((chkb = "_")or (chkb = "-")or (chkb = ".")or (chkb = "%A_Space%"))
			{
				stringtrimRight,gmnamex,gmnamex,1
				StringRight,chkb,gmnamex,1
			}
	}
absgmx= |%gmnamex%|
absgme= |%gmname%|
if (instr(nogmnx,absgmx)or instr(nogmne,absgme))
	{
		if (lnkg = 1)
			{
				 if (lnkrg = 1)
					{
						if (lnkft = 1)
							{
								gmnamex= %tempn%
								gosub, nonmres
								goto,pgmonchk
							}
						splitpath,npfdir,,,,tempn
						lnkft= 1
						goto,NameTuning
					}
				splitpath,pfdir,,,,tempn
				lnkrg= 1
				splitpath,pfdir,,npfdir
				goto, NameTuning	
			}
		lnkg= 1
		tempn= %plnkn%
		goto, NameTuning
	}
return

CmdRet(sCmd, callBackFuncObj := "", encoding := "")
	{
	   static HANDLE_FLAG_INHERIT := 0x00000001, flags := HANDLE_FLAG_INHERIT
			, STARTF_USESTDHANDLES := 0x100, CREATE_NO_WINDOW := 0x08000000
			
	   (encoding = "" && encoding := "cp" . DllCall("GetOEMCP", "UInt"))
	   DllCall("CreatePipe", "PtrP", hPipeRead, "PtrP", hPipeWrite, "Ptr", 0, "UInt", 0)
	   DllCall("SetHandleInformation", "Ptr", hPipeWrite, "UInt", flags, "UInt", HANDLE_FLAG_INHERIT)
	   
	   VarSetCapacity(STARTUPINFO , siSize :=    A_PtrSize*4 + 4*8 + A_PtrSize*5, 0)
	   NumPut(siSize              , STARTUPINFO)
	   NumPut(STARTF_USESTDHANDLES, STARTUPINFO, A_PtrSize*4 + 4*7)
	   NumPut(hPipeWrite          , STARTUPINFO, A_PtrSize*4 + 4*8 + A_PtrSize*3)
	   NumPut(hPipeWrite          , STARTUPINFO, A_PtrSize*4 + 4*8 + A_PtrSize*4)
	   
	   VarSetCapacity(PROCESS_INFORMATION, A_PtrSize*2 + 4*2, 0)

	   if !DllCall("CreateProcess", "Ptr", 0, "Str", sCmd, "Ptr", 0, "Ptr", 0, "UInt", true, "UInt", CREATE_NO_WINDOW
								  , "Ptr", 0, "Ptr", 0, "Ptr", &STARTUPINFO, "Ptr", &PROCESS_INFORMATION)
	   {
		  DllCall("CloseHandle", "Ptr", hPipeRead)
		  DllCall("CloseHandle", "Ptr", hPipeWrite)
		  throw "CreateProcess is failed"
	   }
	   DllCall("CloseHandle", "Ptr", hPipeWrite)
	   VarSetCapacity(sTemp, 4096), nSize := 0
	   while DllCall("ReadFile", "Ptr", hPipeRead, "Ptr", &sTemp, "UInt", 4096, "UIntP", nSize, "UInt", 0) {
		  sOutput .= stdOut := StrGet(&sTemp, nSize, encoding)
		  ( callBackFuncObj && callBackFuncObj.Call(stdOut) )
	   }
	   DllCall("CloseHandle", "Ptr", NumGet(PROCESS_INFORMATION))
	   DllCall("CloseHandle", "Ptr", NumGet(PROCESS_INFORMATION, A_PtrSize))
	   DllCall("CloseHandle", "Ptr", hPipeRead)
	   Return sOutput
	}
joyGetName(ID) {
	VarSetCapacity(caps, 728, 0)
	if DllCall("winmm\joyGetDevCapsW", "uint", ID-1, "ptr", &caps, "uint", 728) != 0
		return "failed"
	return StrGet(&caps+4, "UTF-16")
}	
