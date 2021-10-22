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
	
if ((plink = "") or !fileExist(plink) or (scextn = ""))
	{
		Tooltip, No Item Detected
		Sleep, 3000
		exitapp
	}
if (GetKeyState("Alt")&&(scextn = "exe"))
	{
		CreateSetup= 1
		iniread,Game_Profiles,RJDB.ini,GENERAL,Game_Profiles
		iniread,mapper_extension,RJDB.ini,GENERAL,mapper_extension
		FileCreateDir,%Game_Profiles%\%gmname%
		if (errorlevel = 0)
			{
				Game_Profiles= %Game_Profiles%\%gmname%
				FileCopy,Player1.%mapper_extension%,%GameProfiles%
				FileCopy,Player2.%mapper_extension%,%GameProfiles%
				Filecopy,Game.cfg,%GameProfiles%
				Filecopy,Desk.cfg,%GameProfiles%
				Filecopy,Mediacenter.%mapper_extension%,%GameProfiles%
				FileCopy,RJDB.ini,%GameProfiles%\Game.ini
				iniwrite,%GameProfiles%\Desk.cfg,%GameProfiles%\Game.ini,GENERAL,MM_MEDIACENTER_Config
				iniwrite,%GameProfiles%\Game.cfg,%GameProfiles%\Game.ini,GENERAL,MM_Game_Config
				iniwrite,%GameProfiles%\Player1.%mapper_extension%,%GameProfiles%\Game.ini,GENERAL,Player1
				iniwrite,%GameProfiles%\Player2.%mapper_extension%,%GameProfiles%\Game.ini,GENERAL,Player2
				iniwrite,%GameProfiles%\MediaCenter.%mapper_extension%,%GameProfiles%\Game.ini,GENERAL,MediaCenter_Profile
			}
	}
;;LinkOptions= 
inif= RJDB.ini
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
	
Loop,4
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
splitpath,plfp,pfile,pfdir,plxtn,plnkn
tempn= %gmname%	

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

if ((gmnamex = "WIN32")or (gmnamex = "WIN64")or (gmnamex = "Game")or (gmnamex = "Win")or (gmname = "Launch")or (gmname = "Launcher")or (gmname = "bat")or (gmname = "cmd")or (gmname = "exe")or (gmname = "Program Files")or (gmname = "Program Files (x86)")or (gmname = "Windows")or (gmname = "Roaming")or (gmname = "Local")or (gmname = "AppData")or (gmname = "Documents")or (gmname = "Desktop")or (gmname = "%A_Username%")or (gmname = "\")or (gmname = "/")or (gmname = ":") or (gmnamex = "") or (gmnamex = "My Documents") or (gmnamex = "My Games") or (gmnamex = "Windows Games") or (gmnamex = "Shortcuts"))
	{
		if (lnkg = 1)
			{
				 if (lnkrg = 1)
					{
						if (lnkft = 1)
							{
								gmnamex= %tempn%
								goto, nonmres
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
gbrpr= %GAME_PROFILES%\%gmnamex%\game.ini
if ((Game_Profile = "")&& fileexist(gbrpr))
	{
		Game_Profile= %gbrpr%
	}
if (fileexist(gbrpr)&&(gbar <> 1))
	{
		gbar = 1
		inif= %gbrpr%
		Game_Profile= %gbrpr%
		goto, readini
	}
inif= %GAME_PROFILES%\%gmnamex%\game.ini
ifnotexist,%inif%
	{
		filecopy,%RJDB_Config%,%inif%
	}
ifnotexist,%Game_Profiles%\%gmnamex%\
	{
		FileCreateDir,%Game_Profiles%\%gmnamex%
	}
if player1= 
	{
		player1= %Game_Profiles%\%gmnamex%\%gmnamex%.%Mapper_Extension%
	}
ifnotexist,%player1%
	{
		Filecopy,%Player1_Template%,%player1%
		iniwrite,%player1%,%inif%,GENERAL,Player1
	}
if player2= 
	{
		player2= %Game_Profiles%\%gmnamex%\%gmnamex%_2.%Mapper_Extension%
		iniwrite,%player2%,%inif%,GENERAL,Player2
	}
ifnotexist,%player2%
	{
		Filecopy,%Player2_Template%,%player2%
	}
if (mediacenter_profile_2 = "")
	{
		splitpath,mediacenter_profile,,,,mcp2
		mediacenter_profile_2= %mcp2%2.%mapper_extension%
	}
ifnotexist, %mediacenter_profile_2%
	{
		Filecopy,%mediacenter_Template%,%mediacenter_profile_2%
	}
stringsplit,prestk,1_Pre,<
if (prestk2 <> "")
	{
		if instr(prestk1,"W")
			{
				RunWait,%prestk2%,,preapid
				goto,nonmres
			}
		Run,%prestk2%,,preapid	
	}
acwchk=
GMGDBCHK= %gmnamex%	
if !fileexist(Borderless_Gaming_Program)
	{
		bgpon= 1
		goto,pgmonchk
	}
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
process, close, %pfile%
pgmonchk:
if (MonitorMode > 0)
	{
		DeskMon= %GAME_PROFILES%\%GMNAMED%\Desktop.cfg
		if (!fileexist(DeskMon)&& fileexist(MM_MediaCenter_Config)&&(DeskMon <> MM_MediaCenter_Config))
			{
				filecopy,%MM_MediaCenter_Config%,%DeskMon%
				if (errorlevel <> 0)
					{
						MM_MediaCenter_Config= %DeskMon%
					}
			}
		else {
			if fileexist(DeskMon)
				{
					MM_MediaCenter_Config= %DeskMon%
				}
			}
		GameMon= %GAME_PROFILES%\%GMNAMED%\Game.cfg
		if (!fileexist(GameMon)&& fileexist(MM_Game_Config)&&(GameMon <> MM_Game_Config))
			{
				filecopy,%MM_Game_Config%,%GameMon%
				if (errorlevel <> 0)
					{
						MM_Game_Config= %GameMon%
					}
			}
		else {
			if fileexist(GameMon)
				{
					MM_Game_Config= %GameMon%
				}
			}
		if (instr(MULTIMONITOR_TOOL,"multimonitortool")&& fileexist(GameMon)&& fileexist(DeskMon))
			{
				switchcmd= /LoadConfig "%MM_Game_Config%"
				switchback= /LoadConfig "%MM_MEDIACENTER_Config%"
			}
		if (disprogw = 1)
			{
				RunWait,%MultiMonitor_Tool% %switchcmd%,%mmpath%,hide
			}
		else {
			Run,%MultiMonitor_Tool% %switchcmd%,%mmpath%,hide
		}
	}
sleep, 1200
Mapper_Extension:= % Mapper_Extension

WinGet, WindowList, List
Loop, %WindowList%
	{
		WinMinimize, % "ahk_id " . WindowList%A_Index%
	}
Send {LCtrl Down}&{LAlt Down}&B	
Send {LCtrl Up}&{LAlt Up}
stringsplit,prestk,2_Pre,<
if (prestk2 <> "")
	{
		if instr(prestk1,"W")
			{
				RunWait,%prestk2%,,prebpid
				goto,premapper
			}
		Run,%prestk2%,,prebpid	
	}
premapper:	
if (Mapper > 0)
	{
		joycnt=
		joycnt= %joycount%					
		player2n= "%player2%"
		gosub, AmicroTest
		if (JMap = "xpadder")
			{
				player2n=
				if (joycnt < 2)
					{
						player2t:= A_Space . player2n . "/M"
					}
			}
		if (JMap = "antimicro")
			{
				player2t:= A_Space . player2n
				unload:= "" . antimicro_executable . "" . A_Space . "--unload"
				Run, %unload%,%mapperp%,hide
				process,close,antimicro.exe
				sleep,600
				joycount=
				if (joycount < 2)
					{
						player2t=
					}
			}
		Run,%Keyboard_Mapper% "%player1%"%player2t%
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
	}
stringsplit,prestk,3_Pre,<
if (prestk2 <> "")
	{
		if instr(prestk1,"W")
			{
				RunWait,%prestk2%,,precpid
				goto,begin
			}
		Run,%prestk2%,,precpid
	}	
begin:
if (nrx > 2)
	{
		goto, givup
	}
Run, %plfp%%linkoptions%%plarg%,%pldr%,max UseErrorLevel,dcls
nerlv= %errorlevel%
Process, Exist, %bgmexe%
goto, bgl
if (instr(bgm,gmname)or instr(bgm,GMGDBCHK))
	{
		Run, %bgaming%,%BGMLOC%,,bgpid
	}
	
bgl:	
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
				if (apchkn < 10)
					{
						goto,appcheck
					}
			}
	}
if (exe_list <> "")
	{	
		WinActivate
		WinGetActiveTitle,GMGDBCHK
		if ((GMGDBCHK <> gmname)&&(bgpon = 1))
			{
				acwchk= 1
				gosub,nonmres
				acwchk= 
			}
		process,WaitClose,%erahkpid%
		goto, appclosed
	}
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
		msgbox,,,what
		goto, givup
	}
	
nrx+=1
goto, begin
return

Ctrl & f2::
process,close,%dcls%
process, close, %pfile%
if (exe_list <> "")
	{
		Loop,parse,exe_list,|
			{
				process,close,%A_LoopField%
			}
	}
dcls= 
nrx=
return

^!+f9::
Run, NewOsk.exe
Return


Ctrl & f12::
givup:
gii= 1
Quitout:
process,exist,%mapapp%
mperl= %errorlevel%
stringsplit,prestk,1_Post,<
if (prestk2 <> "")
	{
		if instr(prestk1,"W")
			{
				RunWait,%prestk2%,,postapid
				goto,postmapper
			}
		Run,%prestk2%,,postapid
	}
postmapper:	
if (Mapper > 0)
	{
		gosub, AmicroTest
		mediacenter_profile_2n= "%mediacenter_profile_2%"
		mediacenter_profile_2t:=  A_Space . "" . mediacenter_profile_2n . ""
		if (joycount =< 2)
			{
				mediacenter_profile_2t=
			}
		else {
			if ((joycount > joycnt)&&(joycnt < 3))
				{
					splitpath,Player1,p1fn,pl1pth,,plgetat
					Loop,files,%pl1pth%\*.%mapper_extension%
						{
							if (A_LoopFileFullPath = Player1)
								{
									continue
								}
							if (A_LoopFileName = plgetat . "_2")
								{
									Player2= %A_LoopFileFullPath%
									break
								}
							if (instr(A_LoopFileName,"Player2")or instr(A_LoopFileName,"Player_2")or instr(A_LoopFileName,"Player 2")or instr(A_LoopFileName,"Player2"))
								{
									Player2= %A_LoopFileFullPath%
								}
							else {
									Player2= %A_LoopFileFullPath%
							}	
						}
					iniwrite,%Player2%,%RJDB_Config%,GENERAL,Player2
				}
		}	
		Run, %Keyboard_Mapper% "%MediaCenter_Profile%"%MediaCenter_Profile_2t%,,hide,kbmp
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
process,close, %erahkpid%
process,close, %dcls%
process, close, %pfile%
if (exe_list <> "")
	{
		Loop,parse,exe_list,|
			{
				process,close,%A_LoopField%
			}
	}

Run, taskkill /f /im "%plnkn%*",,hide
stringsplit,prestk,2_Post,<
if (prestk2 <> "")
	{
		if instr(prestk1,"W")
			{
				RunWait,%prestk2%,,postbpid
				goto,postmonitor
			}
		Run,%prestk2%,,postbpid	
	}
postmonitor:
if (MonitorMode > 0)
	{
		if (instr(MULTIMONITOR_TOOL,"multimonitortool")&& fileexist(MM_Game_Config)&& fileexist(MM_MediaCenter_Config))
			{
				Run, %MultiMonitor_Tool% /SaveConfig "%MM_GameConfig%",%mmpath%,hide,dsplo
				Run, %MultiMonitor_Tool% %switchback%,%mmpath%,hide,dsplo
			}
		else {
			Run, %Multimonitor_Tool%,%mmpath%,hide,dsplo
		}	
	}
iniwrite,%MONITORMODE%,%inif%,GENERAL,MonitorMode
iniwrite,%disprogw%,%inif%,GENERAL,disprogw
iniwrite,%MAPPER%,%inif%,GENERAL,Mapper
iniwrite,%Game_Profile%,%inif%,GENERAL,Game_Profile
iniwrite,%KeyBoard_Mapper%,%inif%,GENERAL,KeyBoard_Mapper
iniwrite,%MediaCenter_Profile%,%inif%,GENERAL,MediaCenter_Profile
iniwrite,%MediaCenter_Profile_2%,%inif%,GENERAL,MediaCenter_Profile_2
iniwrite,%MM_MEDIACENTER_Config%,%inif%,GENERAL,MM_MEDIACENTER_Config
iniwrite,%MM_Game_Config%,%inif%,GENERAL,MM_Game_Config
iniwrite,%MultiMonitor_Tool%,%inif%,GENERAL,MultiMonitor_Tool
iniwrite,%Game_Directory%,%inif%,GENERAL,Game_Directory
iniwrite,%player1%,%inif%,GENERAL,Player1
iniwrite,%player2%,%inif%,GENERAL,Player2
iniwrite,%switchcmd%,%inif%,CONFIG,switchcmd
iniwrite,%switchBACK%,%inif%,CONFIG,switchback
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
if (prestk2 <> "")
	{
		if instr(prestk1,"W")
			{
				RunWait,%prestk2%,,postcpid
				goto,loggingout
			}
		Run,%prestk2%,,postcpid	
	}
loggingout:	
if (Logging = 1)
	{
		FileAppend,Run="%plfp%[%linkoptions%|%plarg%]in%pldr%"`nkeyboard=|%Keyboard_Mapper% "%player1%"%player2t%|`njoycount1="%joycnt%"`n%Keyboard_Mapper% "%MediaCenter_Profile%"%MediaCenter_Profile_2t%`njoycount2=%joucount%`n`n,%A_ScriptDir%\log.txt
	}
ExitApp

AmicroTest:
process,close,antimicro.exe
Run, %unload%,%mapperp%,hide
sleep, 600
retrycmdb:
process,close,antimicro.exe
testoutn+=1
splitpath,antimicro_executable,mapperx,mapperp
retrnj= "%Antimicro_executable%" -l
testout:= CmdRet(retrnj)
Sleep,600
Joycount= 
if ((testout = "")&&(testoutn < 3))
	{
		goto, retrycmdb
	}
Loop,parse,testout,`n`r
	{
		if (A_LoopField = "")
			{
				continue
			}
		ifinstring,A_LoopField,Game Controller: Yes
			{
				joycount+=1
			}
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
	
/*
if ((Mapper <> "")or(mperl <> 0))
	{
		testin:= CmdRet(retrnj)
			Loop,parse,testin,`n`r
			{
				if (A_LoopReadLine = "")
					{
						continue
					}
				ifinstring,A_LoopReadLine,Game Controller: Yes
					{
						joycnt+=1
					}
			}
		
		if ((joycnt > joycount)&&(joycnt > 1)or(joycount >1))
			{
				stringreplace,MEDIACENTER_PROFILEN,MEDIACENTER_PROFILE,.xpadderprofile,,All
				stringreplace,MEDIACENTER_PROFILEN,MEDIACENTER_PROFILEN,.gamecontroller.amgp,,All
				splitpath,MEDIACENTER_Profilen,mcnm,mcntp,mcnxtn,mcntrn
				MEDIACENTER_PROFILE_N= %GAME_PROFILES%\%GMNAMEX%\%MEDIACENTER_Profilen%_2.%Mapper_Extension% 
				MEDIACENTER_PROFILE_2T:= A_Space . "" . MediaCenter_Profile_N . ""
				if (player2 = "")
					{
						player2= %GAME_PROFILES%\%GMNAMEX%\%GMNAMEX%_2.%Mapper_Extension%
					}
				if (mediacenter_profile_2 = "")
					{
						filecopy,Desktop.set,%mediacenter_profile_N%
					}
				ifnotexist,%mediacenter_profile_2%
					{
						filecopy,Desktop.set,%mediacenter_profile_N%
					}	
				ifnotexist,%player2%
					{
						FILECOPY,%Player2_Template%,%Player2%
					}
			}
*/