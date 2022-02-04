#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance Force
#Persistent

RELEASE= 2022-02-03 8:51 PM
VERSION= 0.99.25.035
home= %A_ScriptDir%
Splitpath,A_ScriptDir,tstidir,tstipth
if ((tstidir = "src")or(tstidir = "bin")or(tstidir = "binaries"))
	{
		home= %tstipth%
	}
source= %home%\src
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
CFGDIR= %SCPATH%
RJDB_Config= %home%\RJDB.ini
if (scextn = "lnk")
	{
		FileGetShortcut,%plink%,inscname,inscpth,chkargl
		if instr(inscname,"linkrunner")
			{
				splitpath,chkargl,chkargxe,chkargpth
				CFGDIR= %CHKARGPTH%
				RJDB_Config= %CFGDIR%\RJDB.ini
			}

	}
	else {
		CFGDIR= %home%
		RJDB_Config= %CFGDIR%\RJDB.ini
	}
binhome= %home%\bin
if ((plink = "") or !fileExist(plink) or (scextn = ""))
	{
		filedelete,%home%\log.txt
	}
ifnotexist,%home%\xpadder_!.cmd
	{
		gosub, INITXPD
	}
ifnotexist,%home%\Antimicro_!.cmd
    {
        gosub, INITAMIC
    }
gosub, DDPOPS
repopbut= hidden
fileread,unlike,%source%\unlike.set
fileread,unselect,%source%\unsel.set
fileread,absol,%source%\absol.set
fileread,rabsol,%source%\rabsol.set
if fileexist(home . "\" . "continue.db")
	{
		repopbut=
		fileread,SOURCEDLIST,%home%\continue.db
	}
fileread,exclfls,%source%\exclfnms.set
filextns= exe|lnk
remotebins= _BorderlessGaming_|_Antimicro_|_JoyToKey_|_Xpadder_|_MultiMonitorTool_|_SetSoundDevice_|_SoundVolumeView_
MENU_X:= A_GuiX*(A_ScreenDPI/96)
MENU_Y:= A_GuiY*(A_ScreenDPI/96)
reduced= |_Data|Assets|alt|shipping|Data|ThirdParty|engine|App|steam|steamworks|script|nocd|Tool|trainer|
priora= |Launcher64|Launcherx64|Launcherx8664|Launcher64bit|Launcher64|Launchx64|Launch64|Launchx8664|
priorb= |Launcher32|Launcherx86|Launcher32bit|Launcher32|Launchx86|Launch32|
prioraa= |win64|x64|64bit|64bits|64|x8664|bin64|bin64bit|windowsx64|windows64|binx64|exex64|exe64|binariesx64|binaries64|binariesx8664|
priorbb= |win32|32bit|32bits|x8632|x86|x8632bit|32|windows32|windows32|bin32|windowsx86|bin32bit|binx86|bin32|exex86|exe32|binariesx86|binaries32|binariesx86|
ProgramFilesX86 := A_ProgramFiles . (A_PtrSize=8 ? " (x86)" : "")
progdirs= %A_ProgramFiles%|%ProgramW6432%|%ProgramFilesX86%|%A_MyDocuments%|
remProgdirs= Program Files|Program Files (x86)|ProgramData|C:\users\%A_username%
steamhome= Steam\SteamApps\common
dralbet= c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|
GogQuery= GOG|G.O.G|GOG Games
GenQuery= Games|juegos|spellen|Spiele|Jeux|Giochi
AllQuery:= GogQuery . | . "Origin" . "|" . "Epic Games" . steamhome
undira= |%A_WinDir%|%A_Programfiles%|%A_Programs%|%A_AppDataCommon%|%A_AppData%|%A_Desktop%|%A_DesktopCommon%|%A_StartMenu%|%A_StartMenuCommon%|%A_Startup%|%A_StartupCommon%|%A_Temp%|
undirs= %undira%
GUIVARS= ASADMIN|PostWait|PreWait|Localize|SCONLY|EXEONLY|BOTHSRCH|ADDGAME|ButtonClear|ButtonCreate|MyListView|CREFLD|GMCONF|GMJOY|GMLNK|UPDTSC|OVERWRT|POPULATE|RESET|EnableLogging|RJDB_Config|RJDB_Location|GAME_ProfB|GAME_DirB|SOURCE_DirB|SOURCE_DirectoryT|REMSRC|Keyboard_MapB|Player1_TempB|Player2_TempB|MediaCenter_ProfB|MultiMonitor_Tool|MM_ToolB|MM_Game_CfgB|MM_MediaCenter_CfgB|BGM_ProgB|BGP_DataB|PREAPP|PREDD|DELPREAPP|POSTAPP|PostDD|DELPOSTAPP|REINDEX|KILLCHK|INCLALTS|SELALLBUT|SELNONEBUT|KBM_RC|MMT_RC|JAL_ProgB|JBE_ProgB|JBE_RC|JAL_RC|PRE_RC|POST_RC
STDVARS= SOURCE_DirectoryT|SOURCE_Directory|KeyBoard_Mapper|MediaCenter_Profile|Player1_Template|Player2_Template|MultiMonitor_Tool|MM_MEDIACENTER_Config|MM_Game_Config|BorderLess_Gaming_Program|BorderLess_Gaming_Database|extapp|Game_Directory|Game_Profiles|RJDB_Location|Source_Directory|Mapper_Extension|1_Pre|2_Pre|3_Pre|1_Post|2_Post|3_Post|switchcmd|switchback
DDTA= <$This_prog$><Monitor><Mapper>
DDTB= <Monitor><$This_prog$><Mapper>
DDTC= <$This_prog$><Monitor><Mapper>
ifnotexist,%home%\RJDB.ini
gosub,INITALL
gosub, popgui
if (Logging = 1)
	{
		loget= checked
	}
cfgenbl= disabled
joyenbl= disabled
lnkenbl= disabled
if (CREFLD = 1)
	{
		fldrget= checked
		cfgenbl=
		joyenbl=
		lnkenbl=
		admnenabl= 
	}
ovrwrchk=
updtchk= checked
if (CREMODE = 0)
	{
		ovrwrchk= checked
		updtchk=
	}
if (GMCONF = 1)
	{
		cfgget= checked
	}
if (GMJOY = 1)
	{
		joyget= checked
	}
if (ASADMIN = 1)
	{
		admnget= checked
	}	
if (GMLNK = 1)
	{
		lnkget= checked
	}
if instr(1_PreT,"W<")
	{
		prestatus= checked
	}
if instr(1_PostT,"W<")
	{
		poststatus= checked
	}
if instr(JustAfterLaunch,"W<")
	{
		jalstatus= checked
	}
	
if instr(JustBeforeExit,"W<")
	{
		jbestatus= checked
	}
taskbarv= checked
if (Hide_Taskbar = 0)
	{
		taskbarv= 	
	}
Loop,files,%binhome%\*.exe,F
  {
	  if (A_LoopFileName = "soundVolumeView.exe")
		{
		  Menu,AddProgs,Add,soundVoumeView,SVV_Prog
		}
	  if (A_LoopFileName = "setsounddevice.exe")
		{
		  Menu,AddProgs,Add,setSoundDevice,SSD_Prog
		}
  }	
Menu,RCLButton,Add,Reset ,ResetButs
Menu,AddProgs,Add,Download,DownloadAddons
Menu,UCLButton,Add,Download,DownloadButs
Menu,UCLButton,Add,Disable ,DisableButs
Menu,DCLButton,Add,Delete ,DeleteButs
Menu,UPDButton,Add,Update,UpdateRJLR

Gui, Add, Button, x310 y8 vButtonClear gButtonClear hidden disabled, Clear List
Gui, Add, Text, x377 y8 h12, Check
Gui, Add, Button, x420 y8 vSELALLBUT gSELALLBUT hidden, All
Gui, Add, Button, x445 y8 vSELNONEBUT gSELNONEBUT hidden, None
Gui, Add, Button, x490 y10 h20 vADDGAME gADDGAME disabled, ADD
Gui, Add, Edit, x530 y12 w50 disabled,
Gui, Add, Button, x565 y12 w14 h14 disabled,X
Gui, Font, Bold
Gui, Add, Button, x590 y8 vButtonCreate gButtonCreate hidden disabled,CREATE
Gui, Font, Normal
Gui, Add, ListView, r44 x310 y35 h560 w340 -Readonly vMyListView gMyListView hwndHLV1 AltSubmit Checked hidden,Name|Type|Directory/Location|Size (KB)|Name Override|KBM|P1|P2|McP|MMT|GM|DM|JAL|JBE|Pre|Pst

LV_ModifyCol(3, "Integer") 
ImageListID1 := IL_Create(10)
ImageListID2 := IL_Create(10, 10, true) 

LV_SetImageList(ImageListID1)
LV_SetImageList(ImageListID2)

Menu, MyContextMenu, Add, Open in Explorer, ContextOpenFile
Menu, MyContextMenu, Add, Toggle KBM, ContextProperties
Menu, MyContextMenu, Add, Assign Player1 Template, ContextProperties
Menu, MyContextMenu, Add, Assign Player2 Template, ContextProperties
Menu, MyContextMenu, Add, Toggle MMT, ContextProperties
Menu, MyContextMenu, Add, Assign Game-Monitor Config, ContextProperties
Menu, MyContextMenu, Add, Assign Desktop-Monitor Config, ContextProperties
Menu, MyContextMenu, Add, Toggle BGM, ContextProperties
Menu, MyContextMenu, Add, Toggle PRE, ContextProperties
Menu, MyContextMenu, Add, Toggle PST, ContextProperties
Menu, MyContextMenu, Add,,
Menu, MyContextMenu, Add, Clear from ListView, ContextClearRows

Gui, Add, GroupBox, x16 y0 w280 h97 center,
Gui, Add, GroupBox, x16 y91 w280 h120 center,

Gui Add, GroupBox, x16 y205 w283 h146,
Gui Add, GroupBox, x16 y345 w283 h103,
Gui Add, GroupBox, x16 y441 w283 h70,
Gui Add, GroupBox, x16 y505 w283 h104,
Gui, Add, Button, x241 y8 w45 h15 vREINDEX gREINDEX %repopbut%,re-index
Gui, Font, Bold
Gui, Add, Button, x241 y24 w45 h25 vPOPULATE gPOPULATE,GO>
Gui, Font, Normal
Gui, Add, Radio, x30 y32 vSCONLY gSCONLY hidden, Lnk Only
Gui, Add, Radio, x95 y32 vEXEONLY gEXEONLY checked, Exe`,Cmd`,Bat
Gui, Add, Radio, x175 y32 vBOTHSRCH gBOTHSRCH hidden, Exe+Lnk
Gui, Font, Bold
Gui, Add, Button, x18 y588 h16 w16 vRESET gRESET,R
Gui, Font, Normal
Gui, Add, Checkbox, x23 y14 w54 h14 vKILLCHK gKILLCHK checked,Kill-List
Gui, Add, Checkbox, x100 y14 h14 vINCLALTS gINCLALTS hidden,Alts
Gui, Add, Checkbox, x87 y14 w89 h14 vHide_Taskbar gHide_Taskbar %taskbarv%,Hide Taskbar
Gui, Add, Checkbox, x180 y14 w61 h14 vLocalize gLocalize,Localize

Gui, Font, Bold
Gui, Add, Button, x24 y56 w36 h21 vSOURCE_DirB gSOURCE_DirB,SRC

Gui, Font, Normal
Gui, Add, DropDownList, x64 y56 w190 vSOURCE_DirectoryT gSOURCE_DirectoryDD,%SOURCE_Directory%
Gui, Add, Button, x271 y61 w15 h15 vREMSRC gREMSRC,X
Gui, Add, Text, x73 y80 h14 vCURDP Right,<Game Exe/Lnk Source Directories>

Gui, Font, Bold
Gui, Add, Button, x24 y108 w36 h21 vGame_DirB gGame_DirB,OUT
Gui, Add, Text, x64 y100 w222 h14 vGAME_DirectoryT Disabled Right,"<%GAME_DirectoryT%"
Gui, Font, Normal
Gui, Add, Text, x84 y114 h14,<Shortcut Output Directory>

GUi, Add, Checkbox, x36 y137 h14 vCREFLD gCREFLD %fldrget% %fldrenbl%, Folders
GUi, Add, Checkbox, x40 y157 h14 vGMCONF gGMCONF %cfgget% %cfgenbl%,Cfg
GUi, Add, Checkbox, x96 y157 h14 vGMJOY gGMJOY %Joyget% %joyenbl%,Joy
GUi, Add, Checkbox, x188 y157 h14 vASADMIN gASADMIN %admnget% %admnenabl%,As_Admin
GUi, Add, Checkbox, x144 y157 vGMLNK gGMLNK %lnkget% %lnkenbl%,Lnk
Gui, Add, Radio, x115 y137 vOVERWRT gUPDTSC %ovrwrchk%, Overwrite
Gui, Add, Radio, x188 y137 vUPDTSC gOVERWRT %updtchk%, Update

Gui, Font, Bold
Gui, Add, Button, x21 y180 w36 h21 vGame_ProfB gGame_ProfB,GPD
Gui, Add, Text, x64 y175 w222 h14 vGAME_ProfilesT Disabled Right,"<%GAME_ProfilesT%"
Gui, Font, Normal
Gui, Add, Text,  x64 y189 w222 h14,<Game Profiles Directory>
Gui, Font, Bold

Gui, Font, Bold
Gui, Add, Button, x17 y224 w36 h21 vKeyboard_MapB gKeyboard_MapB,KBM
Gui Add, Button, x52 y224 w10 h21 vKBM_RC gKBM_RC, v
Gui, Add, Text,  x64 y224 w222 h14 vKeyboard_MapperT Disabled Right,"<%Keyboard_MapperT%"
Gui, Font, Normal
Gui, Add, Text,  x64 y238 w222 h14,<Keyboard Mapper Program>

Gui, Font, Bold
Gui, Add, Button, x21 y256 w35 h19 vPlayer1_TempB gPlayer1_TempB,PL1
Gui, Add, Text,  x64 y256 w222 h14 vPlayer1_TemplateT Disabled Right,"<%Player1_TemplateT%"
Gui, Font, Normal
Gui, Add, Text,  x64 y270 w222 h14,.....Template Profile for Player 1>
Gui, Font, Bold

Gui, Add, Button, x21 y288 w36 h19 vPlayer2_TempB gPlayer2_TempB,PL2
Gui, Add, Text,  x64 y288 w222 h14 vPlayer2_TemplateT Disabled Right,"<%Player2_TemplateT%"
Gui, Font, Normal
Gui, Add, Text,  x64 y302 w222 h14,.....Template Profile for Player 2>

Gui, Font, Bold
Gui, Add, Button, x21 y320 w36 h19 vMediaCenter_ProfB gMediaCenter_ProfB,MCP
Gui, Add, Text,  x64 y320 w222 h14 vMediaCenter_ProfileT Disabled Right,"<%MediaCenter_ProfileT%"
Gui, Font, Normal
Gui, Add, Text,  x64 y334 w222 h14,.....Template Profile for MediaCenter/Desktop>

Gui, Font, Bold
Gui, Add, Button, x17 y352 w36 h21 vMM_ToolB gMM_ToolB,MMT
Gui Add, Button, x53 y352 w10 h21 vMMT_RC gMMT_RC, v
Gui, Add, Text,  x64 y354 w222 h14 vMultiMonitor_ToolT Disabled Right,"<%MultiMonitor_ToolT%"
Gui, Font, Normal
Gui, Add, Text,  x64 y368 w222 h14,<Multimonitor Program>

Gui, Font, Bold
Gui, Add, Button, x21 y384 w35 h19 vMM_Game_CfgB gMM_Game_CfgB,GMC
Gui, Add, Text,  x64 y384 w222 h14 vMM_Game_ConfigT Disabled Right,"<%MM_Game_ConfigT%"
Gui, Font, Normal
Gui, Add, Text,  x64 y398 w222 h14,.....Gaming Configuration File>

Gui, Font, Bold
Gui, Add, Button, x21 y416 w35 h19 vMM_MediaCenter_CfgB gMM_MediaCenter_CfgB,DMC
Gui, Add, Text,  x64 y416 w222 h14 vMM_MediaCenter_ConfigT Disabled Right,"<%MM_MediaCenter_ConfigT%"
Gui, Font, Normal
Gui, Add, Text,  x64 y430 w234 h14,.....MediaCenter/Desktop Configuration File>

Gui, Font, Bold
Gui, Add, Button, x17 y448 w36 h21 vJAL_ProgB gJAL_ProgB,JAL
Gui Add, Button, x53 y448 w10 h21 vJAL_RC gJAL_RC, v
Gui, Add, Text,  x64 y448 w198 h14 vRunAfterLaunchT Disabled Right,"<%JustAfterLaunchT%"
Gui, Font, Normal
Gui, Add, Checkbox, x270 y448 w12 h12 vJALWait gJALWait %jbestatus%
Gui, Add, Text,  x64 y462 w198 h14,<Run After Launch>


Gui, Font, Bold
Gui, Add, Button, x17 y480 w35 h19 vJBE_ProgB gJBE_ProgB,JBE
Gui Add, Button, x53 y480 w10 h21 vJBE_RC gJBE_RC, v
Gui, Add, Text, x64 y480 w198 h14 vJustBeforeExitT Disabled Right,"<%JustBeforeExitT%"
Gui, Font, Normal
Gui, Add, Checkbox, x270 y480 w12 h12 vJBEWait gJBEWait %jbestatus%
Gui, Add, Text, x64 y494 w198 h14,<Run Before Exit>

Gui, Font, Bold
Gui, Add, Button, x17 y512 w36 h21 vPREAPP gPREAPP ,PRE
Gui Add, Button, x52 y512 w10 h21 vPRE_RC gPRE_RC, v
Gui, Font, Normal
Gui, Add, Text, x60 y514 h12 vPRETNUM,1
Gui, Add, DropDownList, x70 y512 w198 vPREDD gPREDD Right,%prelist%
Gui, Add, Text, x64 y534 h12 w230 vPREDDT,<$This_Prog$><Monitor><Mapper><game.exe>
Gui, Add, Checkbox, x270 y513 w12 h12 vPreWait gPreWait %prestatus%,
Gui, Add, Text, x270 y535 h12,wait
Gui, Add, Button, x283 y520 w14 h14 vDELPREAPP gDELPREAPP ,X

Gui, Font, Bold
Gui, Add, Button, x17 y550 w36 h21 vPOSTAPP gPOSTAPP,PST
Gui Add, Button, x52 y550 w10 h21 vPOST_RC gPOST_RC, v
Gui, Font, Normal
Gui, Add, Text, x60 y552 h12 vPOSTDNUM,1
Gui, Add, DropDownList, x70 y552 w198 vPostDD gPostDD Right,%postlist%
Gui, Add, Text, x64 y574 h12 w230 vPOSTDDT,<game.exe><$This_Prog$><Mapper><Monitor>
Gui, Add, Checkbox, x270 y553 w12 h12 vPostWait gPostWait %poststatus%
Gui, Add, Text, x270 y565 h12,
Gui, Add, Button, x283 y557 w14 h14 vDELPOSTAPP gDELPOSTAPP ,X


Gui, Font, Bold
Gui, Add, Button, x20 y64 w36 h21 vRJDB_Config gRJDB_Config hidden disabled,CFG
Gui, Add, Text,  x64 y64 w222 h14 vRJDB_ConfigT hidden disabled Right,"<%RJDB_ConfigT%"
Gui, Font, Normal
Gui, Add, Text,  x64 y78 w222 h14 hidden disabled,<CONFIG FILE>

Gui, Font, Bold
Gui, Add, Button, x20 y96 w36 h21 vRJDB_Location gRJDB_Location hidden disabled,DIR
Gui, Add, Text,  x64 y96 w222 h14 vRJDB_LocationT  hidden disabled Right,"<%RJDB_LocationT%"
Gui, Font, Normal
Gui, Add, Text,  x64 y110 w222 h14  hidden disabled,<Application Directory>
Gui, Add, Button, x235 y588 h14 w14 vOPNLOG gOPNLOG,O
Gui, Add, Checkbox, x255 y588 h14 vEnableLogging gEnableLogging %loget%, Log

OnMessage(0x200, "WM_MOUSEMOVE")
Gui, Add, StatusBar, x0 y546 w314 h28 vRJStatus, Status Bar
Gui Show, w314 h627, RJ_Setup

SB_SetText("")
ButtonClear_TT :="clears the current queued it"ems
Hide_TaskBar_TT :="Hides the windows taskbar while active"
SELALLBUT_TT :="Selects all items in the current queue"
SELNONEBUT_TT :="clears the selection of all items in the current queue"
ADDGAME_TT :="Add a game with the file browser.`nrj_linkrunner will try to guess the appropriate name"
ButtonCreate_TT :="creates profiles for selected items in the current queued"
MyListView_TT :="The current queue"
REINDEX_TT :="clears the queue and searches for games"
POPULATE_TT :="Searches for games or loads the last queue"
RESET_TT :="resets the rj_linkrunner application to default settings"
KILLCHK_TT :="ancilary and executable-subprocess are terminated upon exiting the game"
INCLALTS_TT :="Alternate versions of a game will be created as alternates in a subfolder of the profile."
Localize_TT :="Sets the profile folder to`n the game's installation folder`n*     (not recommended)     *`n"
SOURCE_DirB_TT :="Add a directory containing the root of game-installation/s."
SOURCE_DirectoryT_TT :="the current source directory"
REMSRC_TT :="remove the currently selected source directory"
CURDP_TT :=""
Game_DirB_TT :="The location where shortcuts will be created"
GAME_DirectoryT_TT :="the current shortcut directory"
CREFLD_TT :="Creates the profile folder"
GMCONF_TT :="Creates the configuration files"
GMJOY_TT :="creates the joystick profiles"
ASADMIN_TT :="sets shortcuts and programs to run as the aministrator."
GMLNK_TT :="creates the shortcuts"
OVERWRT_TT :="overwrite and recreate settings"
UPDTSC_TT :="creates new profile/configurations and updates profiles with any blank/unset values"
Game_ProfB_TT :="Sets the directory where profiles will be created"
GAME_ProfilesT_TT :="the profiles directory"
Keyboard_MapB_TT :="Assigns the keymapper`n(antimicro/xpadder/joytokey)"
KBM_RC_TT :="disable or download and assign a supported keymapper`n(antimicro/xpadder/joytokey)"
Keyboard_MapperT_TT :="the current keyboard mapper`n(supported mappers are auto-scripted '~_!.cmd')"
Player1_TempB_TT :="sets the keymapper's configuration-template file for Player 1"
Player1_TemplateT_TT :="the keymapper's configuration-template  for Player 1"
Player2_TempB_TT :="sets the keymapper's configuration-template file for Player 2"
Player2_TemplateT_TT :="the keymapper's configuration-template file for Player 2"
MediaCenter_ProfileT_TT :="the keymapper's configuration-template file for the Mediacenter/Frontend"
MM_ToolB_TT :="Assigns the multimonitor executable"
MMT_RC_TT :="disable or download and assign the multimonitor program"
MultiMonitor_ToolT_TT :="the multimonitor program"
MM_Game_CfgB_TT :="Select the multimonitor configuration template file used for games"
MM_Game_ConfigT_TT :="the multimonitor game-configuration template file"
MM_MediaCenter_CfgB_TT :="Select the multimonitor configuration template file used for the MediaCenter/Frontend"
MM_MediaCenter_ConfigT_TT :="the MediaCenter/Frontend configuration template file"
JAL_ProgB_TT :="Assign a program to run after the game is launched`n*    (good for trainers or executable-aware programs.)"
JAL_RC_TT :="disable or download and assign a program after launch"
RunAfterLaunchT_TT :="a program after launch"
JBE_RC_TT :="disable or download and assign an executable  prior to termination "
JBE_ProgB_TT :="Assign a program to run prior to executable termination"
JustBeforeExitT_TT :="program to run prior to executable termination"
PREAPP_TT :="Assign a program to run before the game is launched"
PRE_RC_TT :="disable or download and Assign a program to run before the game is launched"
PRETNUM_TT :=""
JARWAIT_TT :="waits for the program to exit"
JBEWAIT_TT :="waits for the program to exit"
PREDD_TT :="the currently selected pre-program`n*  ( ><ThisProg>< )"
PREDDT_TT :=""
PreWait_TT :="Waits for the currently selected pre-program to exit"
DELPREAPP_TT :="removes the currently selected pre-program"
POSTAPP_TT :="Assign a program to run after the game has exited"
POST_RC_TT :="disable or download and Assign a program to run after the game has exited"
PostDD_TT :="the currently selected post-program`n*  ( ><ThisProg>< )"
POSTDDT_TT :=""
PostWait_TT :="Waits for the currently selected post-program to exit"
DELPOSTAPP_TT :="removes the currently selected post-program"
RJDB_Config_TT :=""
RJDB_ConfigT_TT :=""
RJDB_Location_TT :=""
RJDB_LocationT_TT :=""
OPNLOG_TT :="opens the log file for this program"
EnableLogging_TT :="enables logging for this program and the rj_linkrunner.exe"
RJStatus_TT :="feedback display for the program"
Return


!esc::
GuiEscape:
GuiClose:
ExitApp


RJDB_Config:
gui,submit,nohide
FileSelectFile,RJDB_ConfigT,3,%flflt%,Select File
if ((RJDB_ConfigT <> "")&& !instr(RJDB_ConfigT,"<"))
	{
		RJDB_Config= %RJDB_ConfigT%
		iniwrite,%RJDB_Config%,%RJDB_Config%,GENERAL,RJDB_Config
		stringreplace,RJDB_ConfigT,RJDB_ConfigT,%A_Space%,`%,All
		guicontrol,,RJDB_ConfigT,%RJDB_ConfigT%
	}
	else {
		stringreplace,RJDB_ConfigT,RJDB_ConfigT,%A_Space%,`%,All
		guicontrol,,RJDB_ConfigT,<RJDB_Config
	}
return

RJDB_Location:
gui,submit,nohide
FileSelectFolder,RJDB_LocationT,%fldflt%,3,Select Folder
if ((RJDB_LocationT <> "")&& !instr(RJDB_LocationT,"<"))
	{
		RJDB_Location= %RJDB_LocationT%
		iniwrite,%RJDB_Location%,%RJDB_Config%,GENERAL,RJDB_Location
		stringreplace,RJDB_LocationT,RJDB_LocationT,%A_Space%,`%,All
		guicontrol,,RJDB_LocationT,%RJDB_LocationT%
	}
	else {
		stringreplace,RJDB_LocationT,RJDB_LocationT,%A_Space%,`%,All
		guicontrol,,RJDB_LocationT,<RJDB_Location
	}
return



Game_ProfB:
gui,submit,nohide
FileSelectFolder,GAME_ProfilesT,%fldflt%,3,Select Folder
if ((GAME_ProfilesT <> "")&& !instr(GAME_ProfilesT,"<"))
	{
		if (instr(Game_ProfilesT,"profile")or instr(Game_ProfilesT,"Jacket"))or (instr(Game_ProfilesT,"RJ")&& instr(Game_ProfilesT,"data"))
			{
				Game_Profiles= %Game_Profiles%
			}
		else {
			stringright,gdtst,Game_ProfilesT,2
			stringLeft,rdtst,Game_ProfilesT,2
			if (gdtst = ":\")
				{
					Game_ProfilesT= %rdtst%
				}
			Game_Profiles= %GAME_ProfilesT%\RJ_Profiles
			Game_ProfilesT= %Game_Profiles%
		}

		GAME_Profiles= %GAME_ProfilesT%
		iniwrite,%GAME_Profiles%,%RJDB_Config%,GENERAL,GAME_Profiles
		stringreplace,GAME_ProfilesT,GAME_ProfilesT,%A_Space%,`%,All
		guicontrol,,GAME_ProfilesT,%GAME_ProfilesT%
	}
	else {
		stringreplace,GAME_ProfilesT,GAME_ProfilesT,%A_Space%,`%,All
		guicontrol,,GAME_ProfilesT,<GAME_Profiles
	}
return

Game_DirB:
gui,submit,nohide
FileSelectFolder,GAME_DirectoryT,%fldflt%,3,Select Folder
if ((GAME_DirectoryT <> "")&& !instr(GAME_DirectoryT,"<"))
	{
		if (instr(Game_DirectoryT,"launchers")or instr(Game_DirectoryT,"shortcuts")or instr(Game_DirectoryT,"links")or instr(Game_DirectoryT,"lnk") or instr(Game_DirectoryT,"runner"))
			{
				GAME_Directory= %GAME_DirectoryT%
			}
		else {
			stringright,gdtst,Game_DirectoryT,2
			stringLeft,rdtst,Game_DirectoryT,2
			if (gdtst = ":\")
				{
					Game_DirectoryT= %rdtst%
				}
			Game_Directory= %Game_DirectoryT%\RJ_Launchers
			Game_DirectoryT= %Game_Directory%
		}

		iniwrite,%GAME_Directory%,%RJDB_Config%,GENERAL,GAME_Directory
		stringreplace,GAME_DirectoryT,GAME_DirectoryT,%A_Space%,`%,All
		guicontrol,,GAME_DirectoryT,%GAME_DirectoryT%
	}
	else {
		stringreplace,GAME_DirectoryT,GAME_DirectoryT,%A_Space%,`%,All
		guicontrol,,GAME_DirectoryT,<GAME_Directory
	}
return

SELALLBUT:
gui,submit,nohide
Gui, ListView, MyListView
LV_Modify(0, "+Check")
return

SELNONEBUT:
gui,submit,nohide
Gui, ListView, MyListView
LV_Modify(0, "-Check")
return


SOURCE_DirB:
gui,submit,nohide
SFSLCTD:
FileSelectFolder,Source_DirectoryT,%fldflt%,3,Select Folder
if ((Source_DirectoryT <> "")&& !instr(Source_DirectoryT,"<"))
	{
		Source_DirectoryX= %Source_DirectoryT%
		IniRead,SRCDIRS,%RJDB_CONFIG%,GENERAL,Source_Directory
		rnum=
		srcdira:= SOURCE_DIRECTORYT . "||"
		Loop,parse,SRCDIRS,|
			{
				if (A_LoopField = "")
					{
						continue
				   }
				pkrs= %A_LoopField%
				if (pkrs = SOURCE_DIRECTORYT)
					{
						continue
					}
				ifinstring,A_LoopField,%SRCDIRS%
					{
						SB_SetText("The selected directory is a subdirectory of an existing source dir")
						CONTINUE
					}
				srcdira.= pkrs . "|"
			}
		SOURCEDLIST=
		SOURCE_DIRECTORY= %srcdira%
		iniwrite,%srcdira%,%RJDB_Config%,GENERAL,Source_Directory
		stringreplace,CURDP,Source_DirectoryX,%A_Space%,`%,All
		guicontrol,,Source_DirectoryT,|%srcdira%
		guicontrol,,CURDP,%CURDP%
	}
return

Keyboard_MapBDownload:
Return
Keyboard_MapBDisable:
Keyboard_Mapper=
Keyboard_MapperT=
Player1_Template=
Player1_TemplateT=
Player2_Template=
Player2_TemplateT=
MediaCenter_Profile=
MediaCenter_ProfileT=
iniwrite,%A_Space%,%RJDB_CONFIG%,GENERAL,Keyboard_Mapper
iniwrite,%A_Space%,%RJDB_CONFIG%,GENERAL,Player1_Template
iniwrite,%A_Space%,%RJDB_CONFIG%,GENERAL,Player2_Template
iniwrite,%A_Space%,%RJDB_CONFIG%,GENERAL,MediaCenter_Profile_Template
GuiControl,,Player1_TemplateT,
GuiControl,,Player2_TemplateT,
GuiControl,,MediaCenter_ProfileT,
GuiControl,,Keyboard_MapperT,
return

Keyboard_MapB:
gui,submit,nohide
kbmdefloc= %home%
xpadtmp=
Antimtmp=
jtktmp=
if fileexist(Programfilesx86 . "\" . "joytokey" . "\" . "joytokey.exe")
	{
		kbmdefloc= %programfilesx86%\joytokey
		jtktmp= %kbmdefloc%\joytokey.exe
	}
if fileexist(Programfilesx86 . "\" . "JoyToKey" . "\" . "JoyToKey.exe")
	{
		kbmdefloc= %programfilesx86%\JoyToKey
		jtktmp= %kbmdefloc%\JoyToKey.exe
	}
if fileexist(Programfilesx86 . "\" . "Antimicro" . "\" . "Antimicro.exe")
	{
		kbmdefloc= %programfilesx86%\Antimicro
		Antimtmp= %kbmdefloc%\antimicro.exe
	}
if fileexist(binhome . "\" . "Xpadder" . "\" . "Xpadder.exe")
	{
		kbmdefloc= %binhome%\Xpadder
		Xpadtmp= %kbmdefloc%\Xpadder.exe
	}
if fileexist(binhome . "\" . "JoyToKey" . "\" . "JoyToKey.exe")
	{
		kbmdefloc= %binhome%\JoyToKey
		jtktmp= %kbmdefloc%\JoyToKey.exe
	}
if fileexist(binhome . "\" . "Antimicro" . "\" . "Antimicro.exe")
	{
		kbmdefloc= %binhome%\Antimicro
		Antimtmp= %kbmdefloc%\antimicro.exe
	}
if (dchk = "")
	{
		FileSelectFile,Keyboard_MapperT,35,%kbmdefloc%,Select File,xpadder.exe; antimicro.exe; JoyToKey.exe
		;
	}
if ((Keyboard_MapperT <> "")&& !instr(Keyboard_MapperT,"<"))
	{
		Keyboard_Mappern= %Keyboard_MapperT%
	}
	else {
		stringreplace,Keyboard_MapperT,Keyboard_MapperT,%A_Space%,`%,All
		guicontrol,,Keyboard_MapperT,<Keyboard_Mapper
	}
Mapper=
if ((antimicro_executable = Antimtmp)&& !fileexist(antimicro_executable))
	{
		antimicro_executable= %Antimtmp%
	}
if ((joytokey_executable = jtktmp)&& !fileexist(joytk_executable))
	{
		joytokey_executable= %jtktmp%
	}
if ((xpadder_executable = xpadtmp)&& !fileexist(xpadder_executable))
	{
		xpadder_executable= %Xpadtmp%
	}
amicrotmp= %antimicro_executable%
jtktmp= %Joytokey_executable%
Xpadtmp= %Xpadder_executable%
if instr(Keyboard_Mappern,"JoyToKey")
	{
		gosub, RECREATEJOYTK
		Mapper= 1
		iniwrite,JoyToKey,%RJDB_Config%,JOYSTICKS,Jmap
		mapper_extension= cfg
		tooltip,JoyToKey
		FileDelete,%home%\joytokey_!.cmd
        fileread,jtkcb,%source%\joytk.set
		splitpath,joytokey,jtkprg,jtkprgd
		joytokeyini= %jtkprgd%\joytokey.ini
		ifexist,%jtkprgd%\JoyToKey.ini
			{
				joytokeyini= %jtkprgd%\JoyToKey.ini
				}
		ifexist,%A_MyDocuments%\JoyToKey\JoyToKey.ini
			{
				joytokeyini= %A_MyDocuments%\JoyToKey\JoyToKey.ini
				}
        stringreplace,jtkcb,jtkcb,[JOYTKINI],%joytokeyini%,All
        stringreplace,jtkcb,jtkcb,[JOYTK],%Keyboard_Mappern%,All
        FileAppend,%jtkcb%,%home%\joytokey_!.cmd
		keyboard_Mapper= %home%\joytokey_!.cmd
		keyboard_Mappern= %home%\joytokey_!.cmd
		JMAP= JoyToKey
		joytokey_executable=%Keyboard_MapperT%
		if (ASADMIN = 1)
			{
				RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers, %Xpadder_executable%, ~ RUNASADMIN
			}
	}
if instr(Keyboard_Mappern,"Xpadder")
	{
		gosub, RECREATEXPAD
		Mapper= 1
		iniwrite,Xpadder,%RJDB_Config%,JOYSTICKS,Jmap
		mapper_extension= xpadderprofile
		tooltip,xpadder
		FileDelete,%home%\xpadder_!.cmd
        fileread,xpdcb,%source%\xpadr.set
        stringreplace,xpdcb,xpdcb,[XPADR],%Keyboard_Mappern%,All
        FileAppend,%xpdcb%,%home%\xpadder_!.cmd
		keyboard_Mapper= %home%\xpadder_!.cmd
		keyboard_Mappern= %home%\xpadder_!.cmd
		JMAP= Xpadder
		xpadder_executable=%xpadtmp%
		if (ASADMIN = 1)
			{
				RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers, %Xpadder_executable%, ~ RUNASADMIN
			}
	}
if instr(Keyboard_Mappern,"Antimicro")
	{
		gosub, RECREATEAMICRO
		Mapper= 1
		tooltip,antimicro
		mapper_extension= gamecontroller.amgp
		FileDelete,%home%\Antimicro_!.cmd
        fileread,amcb,%source%\Amicro.set
        fileread,amcjp,%source%\allgames.set,
        oskloc= %binhome%\NewOSK.exe
        stringreplace,oskloc,oskloc,\,/,All
        stringreplace,amcjp,amcjp,[NEWOSK],%oskloc%,All
        stringreplace,amcb,amcb,[AMICRO],%Keyboard_Mappern%,All
        FileAppend,%amcb%,%home%\Antimicro_!.cmd
		keyboard_Mapper= %home%\Antimicro_!.cmd
		keyboard_Mappern= %home%\Antimicro_!.cmd
		antimicro_executable=%keyboard_Mapper%
		JMAP= antimicro
		if (ASADMIN = 1)
			{
				RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers, %antimicro_executable%, ~ RUNASADMIN
			}
	}
Player1_Template= %home%\Player1.%mapper_extension%
Player2_Template= %home%\Player1.%mapper_extension%
Mediacenter_Profile_Template= %home%\Mediacenter.%mapper_extension%
iniwrite,%JMAP%,%RJDB_Config%,JOYSTICKS,Jmap
stringreplace,keyboard_mapperT,keyboard_mapper,%A_Space%,`%,All
stringreplace,Player1_TemplateT,Player1_Template,%A_Space%,`%,All
stringreplace,Player2_TemplateT,Player2_Template,%A_Space%,`%,All
stringreplace,MediaCenter_ProfileT,MediaCenter_Profile_Template,%A_Space%,`%,All
stringreplace,keyboard_mapperT,keyboard_mapper,%A_Space%,`%,All
iniwrite,%mapper_extension%,%RJDB_Config%,JOYSTICKS,Mapper_Extension
iniwrite,%mapper%,%RJDB_Config%,GENERAL,Mapper
iniwrite,%Keyboard_Mapper%,%RJDB_Config%,GENERAL,Keyboard_Mapper
stringreplace,Keyboard_MapperT,Keyboard_MapperT,%A_Space%,`%,All
stringreplace,Player1_TemplateT,Player1_TemplateT,%A_Space%,`%,All
stringreplace,MediaCenter_ProfileT,MediaCenter_ProfileT,%A_Space%,`%,All
iniwrite,%home%\Player1.%mapper_extension%,%RJDB_CONFIG%,GENERAL,Player1_Template
iniwrite,%home%\Player2.%mapper_extension%,%RJDB_CONFIG%,GENERAL,Player2_Template
iniwrite,%home%\Mediacenter.%mapper_extension%,%RJDB_CONFIG%,GENERAL,MediaCenter_Profile_Template
iniwrite,%xpadtmp%,%RJDB_Config%,GENERAL,Xpadder_executable
iniwrite,%Antimtmp%,%RJDB_Config%,GENERAL,Antimicro_executable
iniwrite,%jtktmp%,%RJDB_Config%,GENERAL,joytokey_executable
stringreplace,Keyboard_MapperT,Keyboard_MapperT,%A_Space%,`%,All
guicontrol,,Keyboard_MapperT,%Keyboard_MapperT%
guicontrol,,Player1_TemplateT,%Player2_TemplateT%
guicontrol,,Player2_TemplateT,%Player2_TemplateT%
guicontrol,,MediaCenter_ProfileT,%MediaCenter_ProfileT%
guicontrol,,Keyboard_MapperT,%Keyboard_Mapper%
tooltip,
return

Player1_TempB:
gui,submit,nohide
FileSelectFile,Player1_TemplateT,3,,Select File
if ((Player1_TemplateT <> "")&& !instr(Player1_TemplateT,"<"))
	{
		Player1_Template= %Player1_TemplateT%
		iniwrite,%Player1_Template%,%RJDB_Config%,GENERAL,Player1_Template
		stringreplace,Player1_TemplateT,Player1_TemplateT,%A_Space%,`%,All
		guicontrol,,Player1_TemplateT,%Player1_TemplateT%
	}
	else {
		stringreplace,Player1_TemplateT,Player1_TemplateT,%A_Space%,`%,All
		guicontrol,,Player1_TemplateT,<Player1_Template
	}
return

Player2_TempB:
gui,submit,nohide
FileSelectFile,Player2_TemplateT,3,,Select File
if ((Player2_TemplateT <> "")&& !instr(Player2_TemplateT,"<"))
	{
		Player2_Template= %Player2_TemplateT%
		iniwrite,%Player2_Template%,%RJDB_Config%,GENERAL,Player2_Template
		stringreplace,Player2_TemplateT,Player2_TemplateT,%A_Space%,`%,All
		guicontrol,,Player2_TemplateT,%Player2_TemplateT%
	}
	else {
		stringreplace,Player2_TemplateT,Player2_TemplateT,%A_Space%,`%,All
		guicontrol,,Player2_TemplateT,<Player2_Template
	}
return

MediaCenter_ProfB:
gui,submit,nohide
FileSelectFile,MediaCenter_ProfileT,3,,Select File
if ((MediaCenter_ProfileT <> "")&& !instr(MediaCenter_ProfileT,"<"))
	{
		MediaCenter_Profile_Template= %MediaCenter_ProfileT%
		iniwrite,%MediaCenter_Profile_Template%,%RJDB_Config%,GENERAL,MediaCenter_Profile_Template
		stringreplace,MediaCenter_ProfileT,MediaCenter_ProfileT,%A_Space%,`%,All
		guicontrol,,MediaCenter_ProfileT,%MediaCenter_ProfileT%
	}
	else {
		stringreplace,MediaCenter_ProfileT,MediaCenter_ProfileT,%A_Space%,`%,All
		guicontrol,,MediaCenter_ProfileT,<MediaCenter_Profile_Template
	}
return

MM_ToolBDownload:
return

SVV_Prog:
ADMNV=
if (ASADMIN = 1)
  {
		ADMNV:= "/RunAsAdmin" . A_Space
	  }
if (butrclick = "POSTAPP")
	{
		MsgBox,4096,MediaCenter Speakers,Select Your MediaCenter's Speakers After Clicking "OK"
		Loop,parse,GUIVARS,|
			{
				guicontrol,disable,%A_LoopField%
			}
			
		fileappend,echo off`npushd "%binhome%"`n"%binhome%\soundvolumeView.exe" %ADMNV%/setDefault "%sndvice%" all`nexit /b,%home%\MediaCenterAudio.cmd
		gosub,DeviceReturn
		POSTAPPF= %home%\MediaCenterAudio.cmd
		gosub, POSTAPP
	}
if (butrclick = "PREAPP")
	{
		MsgBox,4096,Game Speakers,Select Your Game Speakers After Clicking "OK"
		Loop,parse,GUIVARS,|
			{
				guicontrol,disable,%A_LoopField%
			}
		gosub,DeviceReturn
		fileappend,echo off`npushd "%binhome%"`n"%binhome%\soundvolumeView.exe" %ADMNV%/setDefault "%sndvice%" all`nexit /b,%home%\GameAudio.cmd
		PREAPPF= %home%\GameAudio.cmd
		gosub, PREAPP
	}
Loop,parse,GUIVARS,|
	{
		guicontrol,enable,%A_LoopField%
	}	
mmtrc=
return

DeviceReturn:
alir= devlist.cmd
filedelete,cr.txt
filedelete,%alir%
fileappend,echo off`n,%alir%
fileappend,for /f "tokens=1`,2`,3 delims=`," `%`%a in ('"%binhome%\SoundVolumeView.exe" /scomma') do if "`%`%~b" == "Device" for /f `%`%x in ("`%`%~c") do if "`%`%~x" == "Render" echo.`%`%~a `>`>cr.txt`nexit /b,devlist.cmd
runwait,%alir%,,hide
fileread,inff,cr.txt
filedelete,%alir%
filedelete,cr.txt
vein= 
Loop,parse,inff,`n`r
	{
		if (A_LoopField = "")
			{
				continue
			}
		vein+=1
		ak%vein%= %A_loopField%
		Menu,addonx,Add,%A_loopField%,VeinHC
	}
Menu, addonx, Show, %A_GuiX%, %A_GuiY%	
return
VeinHC:
sndvice= %A_ThisMenuItem%
return

SSD_Prog:
Run, %binhome%\ssd.exe,%binhome%,,
return

OtherDownloads:
curemote= _soundVolumeView_
gosub, BINGETS
gosub, DOWNLOADIT
flflt= %binhome%
if (butrclick = "PREAPP")
	{
		gosub, SVV_Prog
	}
if (butrclick = "POSTAPP")
	{
		gosub, SVV_Prog
	}

Menu,AddProgs,Delete

Loop,files,%binhome%\*.exe,F
  {
	  if (A_LoopFileName = "soundVolumeView.exe")
		Menu,AddProgs,Add,soundVoumeView,SVV_Prog
	  if (A_LoopFileName = "setsounddevice.exe")
		Menu,AddProgs,Add,setSoundDevice,SSD_Prog
	  }	
Menu,AddProgs,Add,Download,DownloadAddons
return

AltDownloads:
curemote= _SetSoundDevice_
gosub, BINGETS
gosub, DOWNLOADIT
flflt= %binhome%
if (butrclick = "PREAPP")
	{
		gosub, PREAPP
	}
if (butrclick = "POSTAPP")
	{
		gosub, POSTAPP
	}
gosub, SSD_Prog

Menu,AddProgs,Delete

Loop,files,%binhome%\*.exe,F
  {
	  if (A_LoopFileName = "soundVolumeView.exe")
		Menu,AddProgs,Add,soundVoumeView,SVV_Prog
	  if (A_LoopFileName = "setsounddevice.exe")
		Menu,AddProgs,Add,setSoundDevice,SSD_Prog
  }
Menu,AddProgs,Add,Download,DownloadAddons	  
SB_SetText("")
prerc=
bgmrc=
mmtrc=
postrc=
kbmrc=
return

DownloadAddons:
Menu,addonp,Add
Menu,addonp,DeleteAll
if (butrclick = "PREAPP")
	{
		Menu,addonp, Add,soundVolumeView,OtherDownloads
	}
if (butrclick = "POSTAPP")
	{
		Menu,addonp, Add,soundVolumeView,OtherDownloads
	}
Menu,addonp,show
prerc=
bgmrc=
mmtrc=
postrc=
kbmrc=
return

MM_ToolBDisable:
MultiMonitor_Tool=
MultiMonitor_ToolT=
MM_GAME_Config=
MM_GAME_ConfigT=
MM_MEDIACENTER_Config=
MM_MEDIACENTER_ConfigT=
iniwrite,%A_SPace%,%RJDB_CONFIG%,GENERAL,MultiMonitor_Tool
iniwrite,%A_SPace%,%RJDB_CONFIG%,GENERAL,MM_GAME_Config
iniwrite,%A_SPace%,%RJDB_CONFIG%,GENERAL,MM_Mediacenter_Config
Guicontrol,,MultiMonitor_ToolT,
Guicontrol,,MM_Game_ConfigT,
Guicontrol,,MM_MediaCenter_ConfigT,
return

MM_ToolB:
gui,submit,nohide
if (dchk = "")
	{
		FileSelectFile,MultiMonitor_ToolT,3,,Select File,multimonitor*.exe
	}
if ((MultiMonitor_ToolT <> "")&& !instr(MultiMonitor_ToolT,"<"))
	{
		MultiMonitor_Tool= %MultiMonitor_ToolT%
		iniwrite,%MultiMonitor_Tool%,%RJDB_Config%,GENERAL,MultiMonitor_Tool
		stringreplace,MultiMonitor_ToolT,MultiMonitor_ToolT,%A_Space%,`%,All
		guicontrol,,MultiMonitor_ToolT,%MultiMonitor_ToolT%
	}
	else {
		stringreplace,MultiMonitor_ToolT,MultiMonitor_ToolT,%A_Space%,`%,All
		guicontrol,,MultiMonitor_ToolT,<MultiMonitor_Tool
	}
if ((MM_Game_Config = "")or(MM_Mediacenter_Config = ""))
    {
        msgbox,4100,Setup,Setup the Multimonitor Tool now?
        ifmsgbox,yes
            {
                gosub, MMSETUPD
                gosub, MMSETUPG
            }
    }

return

MM_Game_CfgB:
gui,submit,nohide
guicontrolget,gmcfg,,MM_Game_ConfigT
if (!fileexist(CFGDIR . "\" . "GameMonitors.mon")or !fileexist(gmcfg))
	{
		 msgbox,4100,Setup,Setup the Multimonitor Tool now?
        ifmsgbox,yes
            {
                gosub, MMSETUPG
				setupmm= 1
            }
	}
if ((setupmm = "")or !fileexist(CFGDIR . "\" . "GameMonitors.mon"))
	{
		FileSelectFile,MM_GAME_ConfigT,35,,Select File,*.cfg; *.mon
		if ((MM_GAME_ConfigT <> "")&& !instr(MM_GAME_ConfigT,"<"))
			{
				MM_GAME_Config= %MM_GAME_ConfigT%
				FileCopy,%MM_GAME_Config%,%home%\GameMonitors.mon
				iniwrite,%MM_GAME_Config%,%RJDB_Config%,GENERAL,MM_GAME_Config
				iniwrite,2,%RJDB_Config%,GENERAL,MonitorMode
				stringreplace,MM_GAME_ConfigT,MM_GAME_ConfigT,%A_Space%,`%,All
				guicontrol,,MM_GAME_ConfigT,%MM_GAME_ConfigT%
			}
			else {
				stringreplace,MM_GAME_Config,MM_GAME_Config,%A_Space%,`%,All
				guicontrol,,MM_GAME_ConfigT,<MM_GAME_Config
			}
	}
setupmm=
return

MM_MediaCenter_CfgB:
gui,submit,nohide
guicontrolget,dtcfg,,MM_MediaCenter_ConfigT
if (!fileexist(CFGDIR . "\" . "DesktopMonitors.mon")or !fileexist(dtcfg))
	{
		 msgbox,4100,Setup,Setup the Multimonitor Tool now?
        ifmsgbox,yes
            {
                gosub, MMSETUPD
				setupmm= 1
            }
	}
if ((setupmm = "")or !fileexist(CFGDIR . "\" . "DesktopMonitors.mon"))
	{
		FileSelectFile,MM_MediaCenter_ConfigT,35,,Select File,*.cfg;*.mon
		if ((MM_MediaCenter_ConfigT <> "")&& !instr(MM_MediaCenter_ConfigT,"<"))
			{
				MM_MediaCenter_Config= %MM_MediaCenter_ConfigT%
				FileCopy,%MM_MediaCenter_Config%,%home%\DesktopMonitors.mon
				iniwrite,%MM_MediaCenter_Config%,%RJDB_Config%,GENERAL,MM_MediaCenter_Config
				iniwrite,2,%RJDB_Config%,GENERAL,MonitorMode
				stringreplace,MM_MediaCenter_ConfigT,MM_MediaCenter_ConfigT,%A_Space%,`%,All
				guicontrol,,MM_MediaCenter_ConfigT,%MM_MediaCenter_ConfigT%
			}
			else {
				stringreplace,MM_MediaCenter_Config,MM_MediaCenter_Config,%A_Space%,`%,All
				guicontrol,,MM_MediaCenter_ConfigT,<MM_MediaCenter_Config
			}
	}
setupmm=
return

BGM_ProgBDownload:
BGM_ProgBDisable:
Borderless_gaming_Program=
Borderless_gaming_ProgramT=
Borderless_gaming_Database=
Borderless_gaming_DatabaseT=
iniwrite,%A_Space%,%RJDB_CONFIG%,GENERAL,Borderless_Gaming_Program
iniwrite,%A_Space%,%RJDB_CONFIG%,GENERAL,Borderless_Gaming_Database
Guicontrol,,Borderless_Gaming_ProgramT,
Guicontrol,,Borderless_Gaming_DatabaseT,
return

BGM_ProgB:
gui,submit,nohide

if (dchk = "")
	{
		FileSelectFile,Borderless_Gaming_ProgramT,3,Borderless Gaming,Select File,*.exe
	}
if ((Borderless_Gaming_ProgramT <> "")&& !instr(Borderless_Gaming_ProgramT,"<"))
	{
		Borderless_Gaming_Program= %Borderless_Gaming_ProgramT%
		iniwrite,%Borderless_Gaming_Program%,%RJDB_Config%,GENERAL,Borderless_Gaming_Program
		stringreplace,Borderless_Gaming_ProgramT,Borderless_Gaming_ProgramT,%A_Space%,`%,All
		guicontrol,,Borderless_Gaming_ProgramT,%Borderless_Gaming_ProgramT%
	}
	else {
		stringreplace,Borderless_Gaming_ProgramT,Borderless_Gaming_ProgramT,%A_Space%,`%,All
		guicontrol,,Borderless_Gaming_ProgramT,<Borderless_Gaming_Program
	}
return

JBE_ProgB:
gui,submit,nohide
guicontrolget,JBEWait,,JBEWait
if (dchk = "")
	{
		FileSelectFile,JustBeforeExitT,3,Before Termination,Select File,*.*
	}
if ((JustBeforeExitT <> "")&& !instr(JustBeforeExitT,"<"))
	{
		predl=<
		if (instr(JustBeforeExitT,".cmd")or instr(JustAfterLaunch,".bat") or instr(JustAfterLaunch,".ps1")or instr(JustAfterLaunch,".psd"))
			{
				predl=0W<
				JBEWait= 1
			}
		JustBeforeExit= %predl%%JustBeforeExitT%
		iniwrite,%JustBeforeExit%,%RJDB_Config%,GENERAL,JustBeforeExit
		stringreplace,JustBeforeExitT,JustBeforeExitT,%A_Space%,`%,All
		guicontrol,,JustBeforeExitT,%JustBeforeExitT%
	}
	else {
		stringreplace,JustBeforeExitT,JustBeforeExitT,%A_Space%,`%,All
		guicontrol,,JustBeforeExitT,<JustBeforeExit
	}
guicontrol,,JBEWAIT,%JBEWAIT%
return

JBE_ProgBDisable:
JustBeforeExit=
JustBeforeExitT=
iniwrite,%A_Space%,%RJDB_CONFIG%,GENERAL,JustBeforeExit
guicontrol,,JustBeforeExitT,
JBEWAIT=0
guicontrol,,JBEWAIT,%JBEWAIT%
return

JAL_ProgBDisable:
RunAfterLaunch=
RunAfterLaunchT=
iniwrite,%A_Space%,%RJDB_CONFIG%,GENERAL,RunAfterLaunch
guicontrol,,RunAfterLaunchT,
JALWAIT=0
guicontrol,,JALWAIT,%JALWAIT%
return

JAL_ProgB:
gui,submit,nohide
if (dchk = "")
	{
		FileSelectFile,JustAfterLaunchT,3,After Launch,Select File,*.*
	}
if ((JustAfterLaunchT <> "")&& !instr(JustAfterLaunchT,"<"))
	{
		predl=<
		if (instr(JustAfterLaunch,".cmd")or instr(JustAfterLaunch,".bat") or instr(JustAfterLaunch,".ps1")or instr(JustAfterLaunch,".psd"))
			{
				predl=0<
			}
		JustAfterLaunch= %predl%%JustAfterLaunchT%
		iniwrite,%JustAfterLaunch%,%RJDB_Config%,GENERAL,JustAfterLaunch
		stringreplace,JustAfterLaunchT,JustAfterLaunchT,%A_Space%,`%,All
		guicontrol,,JustAfterLaunchT,%JustAfterLaunchT%
	}
	else {
		stringreplace,JustAfterLaunchT,JustAfterLaunchT,%A_Space%,`%,All
		guicontrol,,JustAfterLaunchT,<JustAfterLaunch
	}
return

BGP_DataB:
gui,submit,nohide
FileSelectFile,Borderless_Gaming_DatabaseT,3,%A_Appdata%\Andrew Sampson\Borderless Gaming,Select File,config.bin
if ((Borderless_Gaming_DatabaseT <> "")&& !instr(Borderless_Gaming_DatabaseT,"<"))
	{
		Borderless_Gaming_Database= %Borderless_Gaming_DatabaseT%
		iniwrite,%Borderless_Gaming_Database%,%RJDB_Config%,GENERAL,Borderless_Gaming_Database
		stringreplace,Borderless_Gaming_DatabaseT,Borderless_Gaming_DatabaseT,%A_Space%,`%,All
		guicontrol,,Borderless_Gaming_DatabaseT,%Borderless_Gaming_DatabaseT%
	}
	else {
		stringreplace,Borderless_Gaming_Database,Borderless_Gaming_Database,%A_Space%,`%,All
		guicontrol,,Borderless_Gaming_DatabaseT,<Borderless_Gaming_Database
	}
return

PostAPP:
gui,submit,nohide
guicontrolget,fbd,,PostDD
guicontrolget,fbdnum,,PosTdNUM
guicontrolget,PostWait,,PostWait
Postwl=
if (Postwait = 1)
	{
		Postwl= W
	}
iniread,inn,%RJDB_CONFIG%,CONFIG,%fbdnum%_Post
if (inn = A_SPace)
	{
		inn:= A_Space
	}
if (POSTAPPF <> "")
  {
	  POSTAPPT= %POSTAPPF%
	  POSTAPPF= 
	  goto, POSTAPPDEF
	  }
FileSelectFile,PostAPPT,35,%flflt%,Select File
POSTAPPDEF:
if (PostAPPT <> "")
	{
		PostAPP= %PostAPPT%
		PostList= |
		Loop,3
			{
				iniread,cftsv,%RJDB_Config%,CONFIG,%A_Index%_Post
				stringsplit,cftst,cftsv,<
				if (A_Index = fbdnum)
					{
						iniwrite,%fbdnum%%Postwl%<%PostAPP%,%RJDB_Config%,CONFIG,%fbdnum%_Post
						Postlist.= fbdnum . Postwl . "<" . PostAPP . "|"
						if (A_Index = 1)
							{
								PostList.= "|"
							}
						continue
					}
				Postlist.= cftsv . "|"
				if (A_Index = 1)
					{
						PostList.= "|"
					}
			 }
		guicontrol,,PostDD,%PostList%
		guicontrol,,POSTDNUM,1
	}
return

PREAPP:
gui,submit,nohide
guicontrolget,fbd,,PREDD
guicontrolget,fbdnum,,PRETNUM
guicontrolget,PreWait,,PreWait
prewl=
if (prewait = 1)
	{
		prewl= W
	}
iniread,inn,%RJDB_CONFIG%,CONFIG,%fbdnum%_Pre
if (inn = A_SPace)
	{
		inn:= A_Space
	}
if (PREAPPF <> "")
  {
	  PREAPPT= %PREAPPF%
	  PREAPPF= 
	  goto, PREAPPDEF
	  }
FileSelectFile,PREAPPT,35,%flflt%,Select File
PREAPPDEF:
if (PREAPPT <> "")
	{
		PREAPP= %PREAPPT%
		PreList= |
		Loop,3
			{
				iniread,cftsv,%RJDB_Config%,CONFIG,%A_Index%_Pre
				stringsplit,cftst,cftsv,<
				if (A_Index = fbdnum)
					{
						iniwrite,%fbdnum%%prewl%<%PREAPP%,%RJDB_Config%,CONFIG,%fbdnum%_Pre
						PreList.= fbdnum . prewl . "<" . PREAPP . "|"
						if (A_Index = 1)
							{
								PreList.= "|"
							}
						continue
					}
				PreList.= cftsv . "|"
				if (A_Index = 1)
					{
						PreList.= "|"
					}
			 }
		guicontrol,,PreDD,%PreList%
		guicontrol,,PRETNUM,1
	}
return

REMSRC:
gui,submit,nohide
guicontrolget,SRCDIRDD,,SOURCE_DIRECTORYT
iniread,cftst,%RJDB_Config%,GENERAL,Source_Directory
knum=
Loop,parse,cftst,|
    {
		IF (a_lOOPfIELD = "")
			{
				CONTINUE
			}
		if (A_LoopField = SRCDIRDD)
			{
				 continue
			}
		knum+=1
		CURDP= %A_LoopField%
		if (knum = 1)
			{
				Srclist.= CURDP . "||"
				continue
			}
		Srclist.= dkv . "|"
    }
SOURCE_DIRECTORY= %SrcList%
iniwrite,%Srclist%,%RJDB_Config%,GENERAL,SOURCE_Directory
guicontrol,,SOURCE_DirectoryT,|%Srclist%
guicontrol,,CURDP,%CURDP%
return

KILLCHK:
gui,submit,nohide
guicontrolget,KILLCHK,,KILLCHK
return

INCLALTS:
gui,submit,nohide
guicontrolget,INCLALTS,,INCLALTS
return

SOURCE_DirectoryDD:
gui,submit,nohide
guicontrolget,CURDP,,SOURCE_DIRECTORYT
guicontrol,,CURDP,%CURDP%
return

DELpostAPP:
gui,submit,nohide
guicontrolget,DELpostDD,,postDD
stringsplit,dxb,DELpostDD,<
stringreplace,dxn,dxb1,W,,
iniWrite,%dxn%<,%RJDB_Config%,CONFIG,%dxn%_post
postList= |
postWaitn=
Loop,3
	{
		if (A_Index = dxn)
			{
				postList.= dxn . "<" "|"
				if (A_Index = 1)
					{
						postlist.= "|"
					}
				continue
			}
		iniread,daa,%RJDB_Config%,CONFIG,%A_Index%_post
		postList.= daa . "|"
		if (A_Index = 1)
			{
				stringsplit,dant,daa,<
				if instr(dant1,"W")
					{
						postWaitn= 1
					}
				postList.= "|"
			}
	}
guicontrol,,postDD,%postList%
guicontrol,,postWAIT,%postwaitn%
guicontrol,,postDNUM,1
return

DELPREAPP:
gui,submit,nohide
guicontrolget,DELPreDD,,PreDD
stringsplit,dxb,DELPreDD,<
stringreplace,dxn,dxb1,W,,
iniWrite,%dxn%<,%RJDB_Config%,CONFIG,%dxn%_Pre
PreList= |
PreWaitn=
Loop,3
	{
		if (A_Index = dxn)
			{
				PreList.= dxn . "<" "|"
				if (A_Index = 1)
					{
						Prelist.= "|"
					}
				continue
			}
		iniread,daa,%RJDB_Config%,CONFIG,%A_Index%_Pre
		PreList.= daa . "|"
		if (A_Index = 1)
			{
				stringsplit,dant,daa,<
				if instr(dant1,"W")
					{
						PreWaitn= 1
					}
				PreList.= "|"
			}
	}
guicontrol,,PreDD,%PreList%
guicontrol,,PreWAIT,%prewaitn%
guicontrol,,PRETNUM,1
return


EXEONLY:
filextns= exe
return

SCONLY:
filextns= lnk
return

BOTHSRCH:
filextns= exe|lnk|_lnk_
return

PREWAIT:
PREwl=
gui,submit,nohide
guicontrolget,fbdnum,,PRETNUM
guicontrolget,PREwait,,PREwait
if (PREwait = 1)
	{
		prewl= W
	}
guicontrolget,dd,,PREDD
stringsplit,ddn,dd,<
stringreplace,ddn1,ddn1,W,,
if ((ddn2 = A_Space) or (ddn2 = ""))
	{
		ddn2:=
		prewl=
	}
PreList= |
Loop,3
	{
		iniread,cftsv,%RJDB_Config%,CONFIG,%A_Index%_Pre
		stringsplit,cftst,cftsv,<
		if (A_Index = fbdnum)
			{
				iniwrite,%fbdnum%%prewl%<%cftst2%,%RJDB_Config%,CONFIG,%fbdnum%_Pre
				PreList.= fbdnum . prewl . "<" . cftst2 . "||"
				continue
			}
		PreList.= cftsv . "|"
	 }
guicontrol,,PREDD,%PreList%
return

JALWait:
gui,submit,nohide
guicontrolget,JALWAIT,,JALWAIT
JALtmp2=
stringsplit,JALtmp,JustAfterLaunch,<
JustAfterLaunch= %JALtmp2%
jalop= %JALtmp1%
stringreplace,jalop,jalop,W,,
if (JALtmp2 = "")
	{
		jalop=
		JustAfterLaunch= %JALtmp1%
	}
if ((JustAfterLaunch = "")or(JustAfterLaunch = "ERROR")or !fileexist(JustAfterLaunch))
	{
		if (JALWait = 1)
			{
				JALWait= 0
				guicontrol,,JALWAIT,%JALWAIT%
			}
		SB_SetText("A program must be assigned")
		return
	}
if (JALWAIT = 1)
	{
		JustAfterLaunch=%jalop%W<%JustAfterLaunch%
	}
else {
		JustAfterLaunch=%jalop%<%JustAfterLaunch%
	}
iniwrite,%JustAfterLaunch%,%RJDB_Config%,GENERAL,JustAfterLaunch
return

JBEWait:
gui,submit,nohide
guicontrolget,JBEWAIT,,JBEWAIT
jbetmp2=
stringsplit,jbetmp,JustBeforeExit,<
JustBeforeExit= %jbetmp2%
jbeop= %jbetmp1%
stringreplace,jbeop,jbeop,W,,
if (jbetmp2 = "")
	{
		jbeop= 
		JustBeforeExit= %jbetmp1%
	}
if ((JustBeforeExit = "")or(JustbeforeExit = "ERROR")or !fileexist(JustBeforeExit))
	{
		if (JBEWait = 1)
			{
				JBEWait= 0
				guicontrol,,JBEWAIT,%JBEWAIT%
			}
		SB_SetText("A program must be assigned")
		return
	}
if (JBEWAIT = 1)
	{
		JustBeforeExit=%jbeop%W<%JustBeforeExit%
	}
else {
		JustBeforeExit=%jbeop%<%JustBeforeExit%
	}
iniwrite,%JustBeforeExit%,%RJDB_Config%,GENERAL,JustBeforeExit
return

postWAIT:
postwl=
gui,submit,nohide
guicontrolget,fbdnum,,postDNUM
guicontrolget,postwait,,postwait
if (postwait = 1)
	{
		postwl= W
	}
guicontrolget,dd,,postDD
stringsplit,ddn,dd,<
stringreplace,ddn1,ddn1,W,,
if ((ddn2 = A_Space) or (ddn2 = ""))
	{
		ddn2:=
		postwl=
	}
postList= |
Loop,3
	{
		iniread,cftsv,%RJDB_Config%,CONFIG,%A_Index%_post
		stringsplit,cftst,cftsv,<
		if (A_Index = fbdnum)
			{
				iniwrite,%fbdnum%%postwl%<%cftst2%,%RJDB_Config%,CONFIG,%fbdnum%_post
				postList.= fbdnum . postwl . "<" . cftst2 . "||"
				continue
			}
		postList.= cftsv . "|"
	 }
guicontrol,,postDD,%postList%
return

avnix:
newavinx:= % gfmn%iinx%
ifnotinstring,gmnames,%newavinx%|
	{
		gmnames.= newavinx . "|"
	}
return

postDD:
gui,submit,nohide
guicontrolget,postdd,,postDD
stringsplit,povr,postdd,<
if instr(povr1,1)
	{
		guicontrol,,postDDT,<game.exe><$This_Prog$><Mapper><Monitor>
	}
if instr(povr1,2)
	{
		guicontrol,,postDDT,<game.exe><Mapper><$This_Prog$><Monitor>
	}
if instr(povr1,3)
	{
		guicontrol,,postDDT,<game.exe><Mapper><Monitor><$This_Prog$>
	}
if instr(povr1,"W")
	{
		guicontrol,,postwait,1
	}
	else {
		guicontrol,,postwait,0
		}
stringreplace,postDNUM,povr1,W,,
guicontrol,,postDNUM,%postDNUM%
return

PREDD:
gui,submit,nohide
guicontrolget,predd,,PreDD
stringsplit,povr,predd,<
if instr(povr1,3)
	{
		guicontrol,,PREDDT,<$This_Prog$><Monitor><Mapper><game.exe>
	}
if instr(povr1,2)
	{
		guicontrol,,PREDDT,<Monitor><$This_Prog$><Mapper><game.exe>
	}
if instr(povr1,1)
	{
		guicontrol,,PREDDT,<Monitor><Mapper><$This_Prog$><game.exe>
	}
if instr(povr1,"W")
	{
		guicontrol,,Prewait,1
	}
	else {
		guicontrol,,Prewait,0
		}
stringreplace,PRETNUM,povr1,W,,
guicontrol,,PRETNUM,%PRETNUM%
return

INITALL:
FileRead,RJTMP,%source%\RJDB.set
Loop,parse,STDVARS,|
    {
        %A_LoopField%=
    }
initz= 1
stringreplace,RJTMP,RJTMP,[LOCV],%home%,All
FileDelete,%home%\RJDB.ini
FileAppend,%RJTMP%,%home%\RJDB.ini
return

RESET:
Msgbox,260,Reset RJ_LinkRunner,Reset RJ_LinkRunner?,5
ifMsgbox,Yes
    {
        gosub,INITALL
        resetting= 1
        filedelete,%home%\Antimicro_!.cmd
        filedelete,%home%\xpadder_!.cmd
        filedelete,%home%\joytokey_!.cmd
        filedelete,%home%\MediaCenter.xpadderprofile
        filedelete,%home%\MediaCenter2.xpadderprofile
        filedelete,%home%\Player1.xpadderprofile
        filedelete,%home%\Player2.xpadderprofile
		filedelete,%home%\MediaCenter.gamecontroller.amgp
        filedelete,%home%\MediaCenter2.gamecontroller.amgp
        filedelete,%home%\Player1.gamecontroller.amgp
        filedelete,%home%\Player2.gamecontroller.amgp
		filedelete,%home%\MediaCenter.cfg
        filedelete,%home%\MediaCenter2.cfg
        filedelete,%home%\Player1.cfg
        filedelete,%home%\Player2.cfg
        goto,popgui
		LV_Delete()
		guicontrol,,SOURCE_DIRECTORYT,%SOURCE_Directory%
		guicontrol,,PreDD,|1<||2<|3<
		guicontrol,,PostDD,|1<||2<|3<
    }
return

EnableLogging:
gui,submit,nohide
guicontrolget,EnableLogging,,EnableLogging
iniwrite,%EnableLogging%,%RJDB_Config%,GENERAL,Logging
return

OPNLOG:
gui,submit,NoHide
if fileexist("%home%\log.txt")
	{
		Run,Notepad %home%\log.txt,
	}
else {
	SB_SetText("no log exists")
}
return

INITXPD:
fileread,xpadtmp,%source%\xpadr.set
FileDelete,%home%\xpadder_!.cmd
if fileexist(home . "\" . "\" . "bin" . "\" . "xpadder" . "\" . "Xpadder.exe")
	{
		stringreplace,xpadtmp,xpadtmp,[XPADR],%binhome%\xpadder\Xpadder.exe,
		fileappend,%xpadtmp%,%home%\xpadder_!.cmd
		Xpadder_Executable= %binhome%\xpadder\Xpadder.exe
	}
return

INITJTK:
fileread,jtktmp,%source%\joytk.set
FileDelete,%home%\joytokey_!.cmd
if fileexist(home . "\" . "\" . "bin" . "\" . "joytokey" . "\" . "joytokey.exe")
	{
		stringreplace,jtktmp,jtktmp,[JOYTK],%binhome%\joytokey\joytokey.exe,
		stringreplace,jtktmp,jtktmp,[JOYTKINI],%binhome%\joytokey\joytokey.ini,
		fileappend,%jtktmp%,%home%\joytokey_!.cmd
		joytokey_Executable= %binhome%\joytokey\joytokey.exe
	}
return

INITAMIC:
fileread,amictmp,%source%\amicro.set
FileDelete,%home%\Antimicro_!.cmd
if fileexist(binhome . "\" . "Antimicro" . "\" . "antimicro.exe")
	{
		stringreplace,amictmp,amictmp,[AMICRO],%binhome%\Antimicro\Antimicro.exe,
		fileappend,%amictmp%,%home%\Antimicro_!.cmd
		Antimicro_Executable= %binhome%\Antimicro\Antimicro.exe
	}
return



INITQUERY:
CONCAT_ROOT=
GENERIC_ROOT=
Loop,parse,dralbet,|
	{
		srchdrl= %A_LoopField%:
		Loop,parse,GenQuery,|
			{
				GNCHK= %srchdrl%\%A_LoopField%
				if fileexist(GNCHK)
					{
						Loop,files,%GNCHK%,D
							{
								Loop,parse,AllQuery,|
									{
										ALLCHK= %A_LoopFileFullPath%\%A_LoopField%
									}
								if (fileexist(ALLCHK)&& !instr(CONCAT_ROOT,ALLCHK))
									{
										CONCAT_ROOT.= ALLCHK . "|"
										GENERIC_ROOT.= ALLCHK . "|"
									}
							}
						if !instr(CONCAT_ROOT,GNCHK)
							{
								CONCAT_ROOT.= GNCHK . "|"
								GENERIC_ROOT.= GNCHK . "|"
							}
					}
			}
	}

STEAM_ROOT=
Loop,parse,progdirs
	{
		srclocd= %A_LoopField%
		Loop,Files,%srclocd%,D
			{
				if instr(A_LoopFileName,"Steam")
					{
						Loop,files,%A_LoopFileFullPath%,D
							{
								if instr(A_LoopFileName,"apps")
									{
										Loop,files,%A_LoopFileFullPath%,D
											{
												if (A_LoopFilename = "common")
													{
														CONCAT_ROOT.= A_LoopFileFullPath . "|"
														STEAM_ROOT.= A_LoopFileFullPath . "|"
														break
													}
											}
									}
							}
					}
			}
	}
Loop,parse,dralbet,|
	{
		srclocd= %A_LoopField%:
		if instr(A_LoopFileName,"Steam")
					{
						Loop,files,%A_LoopFileFullPath%,D
							{
								if instr(A_LoopFileName,"apps")
									{
										Loop,files,%A_LoopFileFullPath%,D
											{
												if ((A_LoopFilename = "common")&& !instr(STEAM_ROOT,A_LoopField))
													{
														CONCAT_ROOT.= A_LoopFileFullPath . "|"
														STEAM_ROOT.= A_LoopFileFullPath . "|"
														break
													}
											}
									}
							}
					}
	}


GOGROOT=

Loop,parse,progdirs
	{
		srclocd= %A_LoopField%
		Loop,Files,%srclocd%,D
			{
				gogchkd= %A_LoopFileFullPath%
				Loop,parse,gogquery,|
					{
						gogchkh= %gogchkd%\%A_LoopField%
						if (fileexist(gogchkh)&& !instr(CONCAT_ROOT,gogchkh))
							{
								CONCAT_ROOT.= gogchkh . "|"
								GOG_ROOT.= gogchkh . "|"
								break
							}
					}
			}
	}
Loop,parse,dralbet,|
	{
		srchdrl= %A_LoopField%:
		Loop,parse,remProgdirs,|
			{
				Loop,files,%srchdrl%\%A_LoopField%,D
					{
						gogchkd= %A_LoopFileFullPath%
						Loop,parse,gogquery,|
							{
								gogchkh= %gogchkd%\%A_LoopField%
								if (fileexist(gogchkh)&& !instr(CONCAT_ROOT,gogchkh))
									{
										CONCAT_ROOT.= gogchkh . "|"
										GOG_ROOT.= gogchkh . "|"
										break
									}
							}
					}

			}
	}

ORIGINROOT=

Loop,parse,progdirs
	{
		srclocd= %A_LoopField%
		Loop,Files,%srclocd%,D
			{
				Loop,files,%A_LoopFileFullPath%,D
					{
						if (instr(A_LoopFileName,"Origin")&& !instr(CONCAT_ROOT,A_LoopFileName))
							{
								CONCAT_ROOT.= ORIGINchkh . "|"
								ORIGIN_ROOT.= ORIGINchkh . "|"
							}
					}
			}
	}
Loop,parse,dralbet,|
	{
		srchdrl= %A_LoopField%:
		Loop,parse,remProgdirs,|
			{
				Loop,files,%srchdrl%\%A_LoopField%,D
					{
						ORIGINchkd= %A_LoopFileFullPath%
						if instr(A_LoopFileName,"Origin")
							{
								Anorigin= %A_LoopFileFullPath%\Origin.exe
								if (fileexist(Anorigin)&& !instr(CONCAT_ROOT,A_LoopFileFullPath))
									{
										CONCAT_ROOT.= ORIGINchkh . "|"
										ORIGIN_ROOT.= ORIGINchkh . "|"
									}
							}
					}

			}
	}
if (CONCAT_ROOT <> "")
	{
		pl=
		SOURCE_Directory= %CONCAT_ROOT%
		Loop,parse,CONCAT_ROOT,|
			{
				if (A_LoopField = "")
					{
						continue
					}
				pl+=1
				if (pl = 1)
					{
						sourc_t:= A_LoopField . "||"
						continue
					}
				sourc_t.= A_LoopField . "|"

			}
		stringtrimRight,sourc_t,sourc_t,1
		stringtrimRight,Source_directory,Source_directory,1
		iniwrite,%Source_directory%,%RJDB_Config%,GENERAL,SOURCE_DIRECTORY
		SOURCE_DIRECTORY= %sourc_t%
	}
return

popgui:
FileRead,rjdb,%RJDB_Config%
Prelist=
PostStatus=
postlist=
PostStatus=
PREDDT=
POSTDDT=
iniread,RJDBSECTS,%RJDB_Config%
Loop,parse,RJDBSECTS,`r`n
	{
		if (A_LoopField = "")
			{
				continue
			}
		iniread,sectp,%home%\RJDB.ini,%A_LoopField%
		Loop,parse,sectp,`r`n
			{
				if (A_LoopField = "")
					{
						continue
					}
				stringsplit,kval,A_LoopField,=
				val= %kval1%
				stringreplace,trval,A_LoopField,%kval1%=
				if (trval = "")
					{
						trval= %kval1%
					}
				%val%:= trval
				stringreplace,trvald,trval,%A_Space%,`%,All
				%kval1%T:= trvald
				if instr(kval1,"_post")
					{
						postlist.= trval . "|"
						if (kval1 = "1_post")
							{
								postlist.= "|"
							}
					}

				if instr(kval1,"_Pre")
					{
						Prelist.= trval . "|"
						if (kval1 = "1_Pre")
							{
								Prelist.= "|"
							}
					}
				if (resetting = 1)
					{
						guicontrol,,%kval1%T,%trval%
					}
			}
	}
if (resetting = 1)
	{
		guicontrol,,PREDDT,<$This_Prog$><Monitor><Mapper><game.exe>
		guicontrol,,POSTDDT,<game.exe><$This_Prog$><Mapper><Monitor>
		guicontrol,hide,ButtonCreate
		guicontrol,disable,ButtonCreate
		guicontrol,disable,ButtonClear
		guicontrol,hide,ButtonClear
		guicontrol,hide,MyListView
		guicontrol,disable,MyListView
		GuiControl, Move, MyListView, w0
	}

Srcdeflt= %home%\Shortcuts
Iniread,Source_Directory,%RJDB_Config%,GENERAL,Source_Directory
if ((Source_Directory = "")or (resetting = 1) or (initz = 1))
	{
		gosub, INITQUERY
	}
initz=
guicontrol,,Source_DirectoryT,%Source_Directory%
resetting=
return

RECREATEXPAD:
newoskfile= %binhome%\NewOSK.exe
ifnotexist,%home%\Player1.xpadderprofile
	{
		filecopy,%source%\xallgames.set,%home%\Player1.xpadderprofile
	}
ifnotexist,%home%\Player2.xpadderprofile
	{
		filecopy,%source%\xallgames.set,%home%\Player2.xpadderprofile
	}
ifnotexist,%home%\Mediacenter.xpadderprofile
	{
		filecopy,%source%\xDesktop.set,%home%\MediaCenter.xpadderprofile
	}
ifnotexist,%home%\Mediacenter2.xpadderprofile
	{
		filecopy,%source%\xDesktop.set,%home%\MediaCenter2.xpadderprofile
	}
return

RECREATEJOYTK:
newoskfile= %binhome%\NewOSK.exe
stringreplace,SCRIPTRV,newoskfile,\,/,All
ifnotexist,%home%\Player1.cfg
    {
		filecopy,%source%\Jallgames.set,%home%\Player1.cfg
        fileread,mctmp,%source%\jallgames.set
        stringreplace,mctmp,mctmp,[NEWOSK],%SCRIPTRV%,All
        FileAppend,%mctmp%,%home%\Player1.cfg
    }
ifnotexist,%home%\Player2.cfg
    {
		filecopy,%source%\Jallgames.set,%home%\Player2.cfg
        fileread,mctmp,%source%\jallgames.set
        stringreplace,mctmp,mctmp,[NEWOSK],%SCRIPTRV%,All
        FileAppend,%mctmp%,%home%\Player2.cfg
    }
ifnotexist,%home%\MediaCenter.cfg
    {
		filecopy,%source%\JDesktop.set,%home%\MediaCenter.cfg
		filecopy,%source%\JDesktop.set,%home%\MediaCenter2.cfg
        fileread,mctmp,%source%\jDesktop.set
        stringreplace,mctmp,mctmp,[NEWOSK],%SCRIPTRV%,All
        FileAppend,%mctmp%,%home%\MediaCenter.cfg
    }
return

RECREATEAMICRO:
newoskfile= %binhome%\NewOSK.exe
stringreplace,SCRIPTRV,newoskfile,\,/,All
ifnotexist,%home%\Player1.gamecontroller.amgp
	{
        fileread,mctmp,%source%\allgames.set
        stringreplace,mctmp,mctmp,[NEWOSK],%SCRIPTRV%,All
        FileAppend,%mctmp%,%home%\Player1.gamecontroller.amgp
    }
ifnotexist,%home%\Player2.gamecontroller.amgp
    {
        fileread,mctmp,%source%\allgames.set
        stringreplace,mctmp,mctmp,[NEWOSK],%SCRIPTRV%,All
        FileAppend,%mctmp%,%home%\Player2.gamecontroller.amgp
    }
ifnotexist,%home%\MediaCenter.gamecontroller.amgp
    {
        fileread,mctmp,%source%\Desktop.set
        stringreplace,mctmp,mctmp,[NEWOSK],%SCRIPTRV%,All
        FileAppend,%mctmp%,%home%\MediaCenter.gamecontroller.amgp
    }
return
UPDTSC:
OVERWRT=
return
OVERWRT:
OVERWRT= 1
return
MMSETUPD:
Msgbox,,Default Desktop Config,Configure your monitor/s as you would have them for your`nMediaCenter or Desktop`nthen click "OK"
ifmsgbox,OK
    {
        FileMove,%home%\DesktopMonitors.mon,%home%\DesktopMonitors.mon.bak
        RunWait, %multimonitor_tool% /SaveConfig "%CFGDIR%\DesktopMonitors.mon",%home%,hide
        ifexist,%CFGDIR%\DesktopMonitors.mon
            {
                Msgbox,,Success,The current monitor configuration will be used for your Mediacenter or desktop
                iniwrite,%CFGDIR%\DesktopMonitors.mon,%RJDB_Config%,GENERAL,MM_MEDIACENTER_Config
				stringreplace,MM_Mediacenter_ConfigT,MM_Mediacenter_ConfigT,%A_Space%,#,All
				guicontrol,,MM_Mediacenter_ConfigT,%MM_Mediacenter_ConfigT%
            }
           else {
            Msgbox,,Failure,The current monitor configuration could not be saved
			return
           }
SB_SetText("Monitor config saved")
    }
return
MMSETUPG:
Msgbox,,Default Game Config,Configure your monitor/s as you would have them for your`nGames or Emulators`nthen click "OK"
ifmsgbox,OK
    {
        FileMove,%home%\GameMonitors.mon,%home%\GameMonitors.mon.bak
        RunWait, %multimonitor_tool% /SaveConfig "%CFGDIR%\GameMonitors.mon",%home%,hide
        ifexist,%CFGDIR%\GameMonitors.mon
            {
                Msgbox,,Success,The current monitor configuration will be used for your Game/s or Emulator/s
                iniwrite,%CFGDIR%\GameMonitors.mon,%RJDB_Config%,GENERAL,MM_Game_Config
				stringreplace,MM_Game_ConfigT,MM_Game_ConfigT,%A_Space%,#,All
				guicontrol,,MM_Game_ConfigT,%MM_Game_ConfigT%
			}
		   else {
			Msgbox,,Failure,The current monitor configuration could not be saved
    }
}
return

DDPOPS:
iniread,cftst,%RJDB_Config%,CONFIG
knum=
snum=
Loop,parse,cftst,`n`r
    {
        stringsplit,dkd,A_LoopField,=
        ifinstring,dkd1,_Post
            {
                stringreplace,dkv,A_LoopField,%dkd1%=,,
                if (dkv = "")
                    {
                        continue
                    }
                knum+=1
                %knum%_Post= dkv
                if (knum = 1)
                    {
                        PostList.= "|" . dkv . "||"
                        continue
                    }
                PostList.= dkv . "|"
            }
         ifinstring,dkd1,_Pre
            {
                stringreplace,dkv,A_LoopField,%dkd1%=,,
                if (dkv = "")
                    {
                        continue
                    }
                snum+=1
                %snum%_Pre= dkv
                if (snum = 1)
                    {
                        PreList.= dkv . "||"
                        continue
                    }
                PreList.= dkv . "|"
            }
    }
guicontrol,,PostDD,%PostList%
guicontrol,,PreDD,%PreList%
Return

ADDGAME:
gui,submit,NoHide
FileSelectFile,Gametoadd,35,,Select a Game,*.exe;*.lnk
fullist.= GametoAdd . "|"
FileGetSize,filez,GameToAdd
splitpath,GameToAdd,filenm,filepath,fileext
SOURCEDLIST.= FileNM . "|" . FileExt . "|" . FilePath . "|" . filez . "|" . A_Space . "|" . 9999 . "|" . 9999 . "`n"
Gui,ListView,MyListView
LV_Add(lvachk,FileNM, FileExt, FilePath, filez,A_Space,"y","<","<","<","y","<","<","<","<","y","y")
LV_ModifyCol()
return

CREFLD:
gui,submit,nohide
guicontrol,enable,GMJOY
guicontrol,enable,GMLNK
guicontrol,enable,GMCONF
if (CREFLD = 0)
	{
		guicontrol,disable,GMJOY
		guicontrol,,GMJOY,0
		guicontrol,disable,GMLNK
		guicontrol,,GMLNK,0
		guicontrol,disable,GMCONF
		guicontrol,,GMCONF,0
		iniwrite,%CREFLD%,%RJDB_CONFIG%,CONFIG,GMJOY
		iniwrite,%CREFLD%,%RJDB_CONFIG%,CONFIG,GMLNK
		iniwrite,%CREFLD%,%RJDB_CONFIG%,CONFIG,GMCONF
	}
iniwrite,%CREFLD%,%RJDB_CONFIG%,CONFIG,CREFLD
return

GMCONF:
gui,submit,nohide
iniwrite,%GMCONF%,%RJDB_CONFIG%,CONFIG,GMCONF
return

GMJOY:
gui,submit,nohide
iniwrite,%GMJOY%,%RJDB_CONFIG%,CONFIG,GMJOY
return


ASADMIN:
gui,submit,nohide
iniwrite,%ASADMIN%,%RJDB_CONFIG%,CONFIG,ASADMIN
return

GMLNK:
gui,submit,nohide
iniwrite,%GMLNK%,%RJDB_CONFIG%,CONFIG,GMLNK
return

;;##########################################################################
;;############################### POPULATION ###############################;;
;;##########################################################################

REINDEX:
SOURCEDLIST=
fullist=
simpnk=
omitd=
filedelete,%home%\simpth.db
filedelete,%home%\continue.db
guicontrol,hide,REINDEX
POPULATE:
Gui,Listview,MyListView
LV_Delete()
if (!Fileexist(GAME_Directory)or !FileExist(Game_Profiles))
    {
        SB_SetText("Please Select Valid Directories")
    }
SB_SetText("Getting Lnk/Exe List")
Loop,parse,GUIVARS,|
	{
		guicontrol,disable,%A_LoopField%
	}
str := ""
guicontrolget,EXEONLY,,EXEONLY
if (exeonly = 1)
	{
		gosub, EXEONLY
	}
guicontrolget,SCONLY,,SCONLY
if (SCONLY = 1)
	{
		gosub, SCONLY
	}
guicontrolget,BOTHSRCH,,BOTHSRCH
if (BOTHSRCH = 1)
	{
		gosub, BOTHSRCH
	}
lvachk= +Check
fullist=
if (SOURCEDLIST <> "")
	{
		Loop,parse,SOURCEDLIST,`n
			{
				stringsplit,rni,A_LoopField,|

				LV_Add(lvachk,rni1, rni2, rni3,  rni4, A_Space,"y", "<", "<","<","y","<","<","<","<","y","y")
				fullist.= rni3 . "\" . rni1 . "|"
			}
		goto,REPOP
	}
SOURCEDLIST=
FileDelete,%home%\simpth.db
Loop,parse,SOURCE_DIRECTORY,|
	{
		SRCLOOP= %A_LoopField%
		if (!fileexist(SRCLOOP)or(A_LoopField= ""))
			{
				continue
			}

		Loop,parse,filextns,|
			{
				if (A_LoopField = "")
					{
						continue
					}
				fsext= %A_LoopField%
				sfi_size := A_PtrSize + 8 + (A_IsUnicode ? 680 : 340)
				VarSetCapacity(sfi, sfi_size)
				Loop,files,%SRCLOOP%,D
					{
						allfld.= A_LoopFileFullPath . "|"
					}
				loop, Files, %SRCLOOP%\*.%fsext%,R
					{
						excl=
						lvachk= +Check
						FileName := A_LoopFileFullPath
						filez:= A_LoopFileSizeKB
						splitpath,FileName,FileNM,FilePath,FileExt,filtn
						splitpath,FilePath,filpn,filpdir,,filpjn
						stringreplace,simpath,FilePath,%SCRLOOP%\,,
						stringreplace,trukpath,filpdir,%SCRLOOP%\,,
						splitpath,simpath,simpn,simpdir
						splitpath,trukpath,truknm,farpth
						splitpath,farpth,farnm,

						simploc= %simpath%\%FileNM%
						if (FilePath <> SCRLOOP)
							{
								simploc= %filpn%\%FileNM%
								if ((truknm <> filpn)&&(truknm <> ""))
									{
										simploc= %truknm%\%filpn%\%FileNM%
									}
								if ((farpth <> "")&&(farnm <> truknm))
									{
										simploc= %farnm%\%truknm%\%filpn%\%FileNM%
									}
							}
						Loop,parse,absol,`r`n
							{
								if (A_LoopField = "")
									{
										continue
									}
								if instr(simploc,A_LoopField)
									{
										omitd.= filenm . "|" . "|" . simploc . "`n"
										excl= 1
										break
									}
							}
						if (excl = 1)
							{
								continue
							}
						Loop,parse,rabsol,`r`n
							{
								if (A_LoopField = "")
									{
										continue
									}
								if ((FileNM = A_LoopField) or (filtn = A_LoopField))
									{
										omitd.= filenm . "|" . simploc . "`n"
										excl= 1
										break
									}	
								if instr(simploc,A_LoopField)
									{
										lvachk=
										simpnk.= FileName . "`n"
										fileappend,%simpath%,%home%\simpth.db
										goto,Chkcon
									}
							}
						if (excl = 1)
							{
								continue
							}
						PostDirChk:
						if ((A_LoopFileExt = "lnk")or(A_LoopFileExt = "_lnk_"))
							{
								FileGetShortcut, %FileName%,FileSCName,OutDir,OutArgs,OutDescription,OutIcon,IconNumber,OutRunState
								FileGetSize,filez,%FileName%
								FileExt= lnk
							}
						Loop,parse,unselect,`r`n
							{
								if (A_LoopField = "")
									{
										continue
									}
								if (instr(simploc,A_LoopField)&& !instr(filpn,A_LoopField))
									{
										lvachk=
										simpnk.= FileName . "`n"
										fileappend,%simpath%,%home%\simpth.db
										goto,Chkcon
									}
							}
						Loop,parse,unlike,`r`n
							{
								if (A_LoopField = "")
									{
										continue
									}
								unlika= _%a_LoopField%
								unlikb= %A_LoopField%_
								stringreplace,filtfp,FileNM,.,_,All
								stringreplace,filtfp,filtf,-,_,All
								stringreplace,filtfp,filtp,%A_Space%,_,All
								if (instr(filtfp,unlika)or instr(filtfp,unlikb)&& !instr(filpn,A_LoopField))
									{
										lvachk=
										simpnk.= FileName . "`n"
										fileappend,%FileName%`n,%home%\simpth.db
										goto,Chkcon
									}
							}
						if (lvachk <> "")
							{
								fullist.= A_LoopFileFullPath . "|"
							}
						Chkcon:
						LV_Add(lvachk,FileNM, FileExt, FilePath,  filez, A_Space,"y","<","<","<","y","<","<","<","<","y","y")
						SOURCEDLIST.= FileNM . "|" . FileExt . "|" . FilePath . "|" . filez . "|" . A_Space . "|" . "y" . "|" . "<" . "|" . "<" . "|" . "<" . "|" . "y" . "|" . "<" . "|" . "<" . "|" . "<" . "|" . "<" . "|" . "y" . "|" . "y" . "`n"
					}
			}
	}
if (enablelogging = 1)
	{
		fileappend,[OMITTED]`n%omitd%`n`n[RE-INCLUDED]`n,log.txt
	}
Loop,parse,simpnk,`r`n
	{
		if (A_LoopField = "")
			{
				continue
			}
		fenx= %A_LoopField%
		splitpath,fenx,fenf,fendir,fenxtn,fenol
		Loop,Source_Directory,|
			{
				if (A_LoopField = "")
					{
						continue
					}
				srcdtmp= %A_LoopField%\
				stringreplace,fen,fendir,%srcdtmp%\,,UseErrorLevel
				if (errorlevel <> 0)
					{
						stringreplace,fltsmp,fullist,%scrdtmp%\,,UseErrorLevel
						fenum2=
						stringsplit,fenum,fen,\
						rplt= %fenum1%
						if (fenum2 <> "")
							{
								rplt= %fenum1%\%fenum2%
							}
						stringreplace,jtst,fltsmp,%rplt%,,UseErrorLevel
						if (errorlevel = 0)
							{
								if (enablelogging = 1)
									{
								fileappend,%fenx%|`n,log.txt
									}
								LV_Add(lvachk,fenf, fenxtn, fendir, 0, A_Space,"y","<","<","<","y","<","<","<","<","y","y")
								SOURCEDLIST.= fenf . "|" . fenxtn . "|" fendir . "|" . 0 . "|" . A_Space . "|" . "y" . "|" . "<" . "|" . "<" . "|" . "<" . "|" . "y" . "|" . "<" . "|" . "<" . "|" . "<" . "|" . "<" . "|" . "y" . "|" . "y" . "`n"
								fullist.= fenx . "|"
								break
							}
					}
			}
	}
fileappend,%SOURCEDLIST%,%home%\continue.db
REPOP:
Guicontrol,Show,MyListView
Guicontrol,Show,ButtonCreate
Guicontrol,Show,ButtonClear
Guicontrol,Show,SELALLBUT
Guicontrol,Show,SELNONEBUT


GuiControl, +Redraw, MyListView 
LV_ModifyCol(1, 140) 
LV_ModifyCol(2, 40) 
LV_ModifyCol(3, 130) 
LV_ModifyCol(4, 60) 
LV_ModifyCol(5, 100) 
listView_autoSize:
GUI, +LastFound 
totalWidth := 0 
Loop % LV_GetCount("Column")
	{
		SendMessage, 4125, A_Index - 1, 0, SysListView321
		totalWidth := totalWidth + ErrorLevel
	}
GuiControl, Move, MyListView, w500

GUI, Show, AutoSize
Loop,parse,GUIVARS,|
	{
		guicontrol,enable,%A_LoopField%
	}

ICELV1 := New LV_InCellEdit(HLV1)
ICELV1.SetColumns(5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15)
ICELV1.OnMessage()
Gui, +Resize
SB_SetText("Completed Aquisition")
Return
KillToolTip:
   ToolTip
Return

GuiSize:
if (A_EventInfo = 1)
    return
GuiControl, Move, MyListView, % "W" . (A_GuiWidth - 320) . "H" . (A_GuiHeight - 65)
return

SANITIZER:
stringreplace,insan,insan,:,-,All
SANITIZE:
stringreplace,insan,insan,/,-,All
stringreplace,insan,insan,?,-,All
stringreplace,insan,insan,`,,-,All
stringreplace,insan,insan,>,-,All
stringreplace,insan,insan,",,All
;"
stringreplace,insan,insan,=,-,All
stringreplace,insan,insan,|,-,All
stringreplace,outsan,insan,%A_Tab%,-,All
if instr(outsan,"<")
	{
		outsan= <
	}
return
;;#########################################################################################  
;;###############################  SHORTCUT CREATION  #####################################:;
;;#########################################################################################  
ButtonCreate:
SB_SetText("Creating Custom ShortCuts")
Loop,parse,GUIVARS,|
	{
		guicontrol,disable,%A_LoopField%
	}
fileread,cmdtpp,%home%\src\cmdtemplate.set
guicontrolget,CREFLD,,CREFLD
guicontrolget,ASADMIN,,ASADMIN
guicontrolget,GMJOY,,GMJOY
guicontrolget,GMCONF,,GMCONF
guicontrolget,OVERWRT,,OVERWRT
guicontrolget,GMLNK,,GMLNK
guicontrolget,Localize,,Localize
guicontrolget,INCLALTS,,INCLALTS
guicontrolget,KILLCHK,,KILLCHK
guicontrolget,Hide_Taskbar,,Hide_Taskbar
guicontrolget,EnableLogging,,EnableLogging
complist:= LVGetCheckedItems("SysListView321","RJ_Setup")
fullist= %complist%

stringsplit,fullstn,fullist,|
gmnames= |
gmnameds= |
gmnamed=
exlist=
fullstx= %fullstn%
if !fileexist(GAME_Directory)
	{
		filecreatedir,%Game_Directory%
	}
if !fileexist(GAME_Profiles)
	{
		filecreatedir,%GAME_Profiles%
	}
Loop,%fullstn0%
	{
		nameOverride=
		przn= % fullstn%A_Index%
		if ((przn = "")or(przn = "?/>>>>>>>>>>>"))
			{
				continue
			}
		if instr(przn,"?")
			{
				stringsplit,prvn,przn,?>
				prn= %prvn1%
				nameOverride= %prvn2%
				INSAN= %NAMEOVERRIDE%
				gosUB,SANITIZER
				nameOverride= %outsan%
			}
		else {
			stringsplit,prvn,przn,>/
			prn= %prvn1%
		}
		kbmovr= %prvn2%
		mmovr= %prvn6%
		bgmovr= %prvn9%
		preovr= %prvn10%
		pstovr= %prvn11%
		if (prvn7 <> "<")
			{
				pl1ovr= %prvn3%
			}
		if (prvn8 <> "<")
			{
				pl2ovr= %prvn4%
			}
		if (prvn9 <> "<")
			{
				mcpovr= %prvn5%
			}
		if (prvn11 <> "<")
			{
				mgovr= %prvn7%
			}
		if (prvn12 <> "<")
			{
				dgovr= %prvn8%
			}
		if (prvn13 <> "<")
			{
				jlovr= %prvn9%
			}
		if (prvn14 <> "<")
			{
				jbovr= %prvn10%
			}
		splitpath,prn,tmpn,tmpth,tmpxtn,gmnamex
		refname= %gmnamex%
		if ((tmpxtn = "exe")or(tmpxtn = "bat")or(tmpxtn = "cmd")or(tmpxtn = "apk"))
			{
				fnd64=
				fnd32=
				getaplist=
				splitpath,prn,prnmx,OutDir,prnxtn,gmnamex
				OutRunState= 1
				OutTarget= %prn%
				OutDescription= %gmnamex%
				gmnamer.= gmnamex . "|"
				splitpath,outdir,gmnamed,curpth,outmpxtn
				Loop,parse,undirs,|
					{
						if (a_Loopfield = "")
							{
								continue
							}
						if (outdir = A_Loopfield)
							{
								outdir= %A_temp%\thin
								filecreatedir,%outdir%
								break
							}
					}
				invar= %gmnamex%
				gosub, CleanVar
				gmnamet= |%invarx%|
				gmnamedx= |%gmnamet%|
				if (instr(exclfls,gmnamedx)or instr(exclfls,gmnamex))
					{
						gmnamex= %gmnamex%!
					}
				gmname= %gmnamex%
				cursrc=
				Loop,parse,Source_directory,|
					{
						if (A_LoopField = "")
							{
								continue
							}
						if instr(prn,A_LoopField)
							{
								cursrc= %A_LoopField%
								break
							}
					}
				PARENTSOURCE=
				IF (cursrc = "")
					{
						PARENTSOURCE= 1
						cursrc= %outdir%
					}
				tlevel= %outdir%
				cursrp=|
				stringreplace,undirs,undira,|%cursrc%|,,
				Stringreplace,gfnamex,outdir,%cursrc%\,,All

				realpth= \%gfnamex%\
				invar= %realpth%
				gosub,CleanVar
				realpth= %invarx%
				stringsplit,tdirn,gfnamex,\

				topdirec= %tdirn1%

				invar= %topdirec%
				gosub, CleanVar
				topdir= %invarx%
				gmnamedv= %topdir%
				stringlen,topln,topdir
				chkpl= %cursrc%\%topdirec%
				pthchk=
				Loop,%fullstx0%
					{
						glt:= % fullstn%A_Index%
						if instr(glt,chkpl)
							{
								pthchk.= glt . "|"
							}
					}
				stringreplace,pthchk,pthchk,%cursrc%,\,All
				exlist.= "?" . cursrc . "?" . "|"
				ExtID := FileExt
				IconNumber:= 0
				redpth= %outdir%
				exlthis= |%gmnamex%|
				if instr(exclfls,gmnamedx)
					{
						gmnamex= %gmnamex%!
					}
				if (topdirec = gmnamed)
					{
						mattop= %gmnamedv%
						invar= %gmnamed%
						gosub, CleanVar
						gmnamecm= %invarx%
						goto, TOPFIN
					}
				topreduc=
				gmnameo= %gmnamed%
				TOPREDUC:
				stringlen,gmat,gmnamed
				gmat+=1
				invar= %gmnamed%
				gosub,CleanVar
				gmnamedv= %invarx%
				mattop= %gmnamedv%
				gmnamedvx= |%gmnamedv%|
				stringlen,mattlen,gmnamedv
				if (instr(gmnamedv,gmnamed)&&(gmnamed <> gmnamedv)&&(mattlen > 5))
					{
						gmnamed= %gmnameo%
					}
				if instr(exclfls,gmnamedvx)
					{
						tmppath= %redpth%
						splitpath,tmppath,gmnamek,curpthk
						curpthn= |%curpth%|
						curpthd= %curpth%\
						if (instr(undirs,curpthn)&& !instr(undirs,curpthd))
							{
								tlevel= %redpth%
								goto, topout
							}
						stringtrimright,gfnamek,gfnamex,%gmat%
						if (gfnamek = "")
							{
								tlevel= %redpth%
								goto, topout
							}
						gfnamex= %gfnamek%
						redpth= %curpthk%
						stringlen,gmat,gmnamek
						gmat+=1
						topreduc= 1
						tlevel= %redpth%
						invar= %gmnamek%
						gosub, CleanVar
						topdir= %invarx%
						if (!instr(topdir,gmnamed)or(mattlen < 5))
							{
								gmnamed= %gmnamek%
							}
						goto, topreduc
					}
				TOPOUT:
				invar= %gmnamed%
				gosub, CleanVar
				gmnamecm= %invarx%
				TOPFIN:
				invar= %gmnamex%
				gosub, CleanVar
				gmnamfcm= %invarx%
				if (PARENTSOURCE = 1)
					{
						cursrc= %redpth%
					}
				stringlen,orilen,gmnamfcm
				if (instr(topdir,mattop) && (mattlen > 5))
					{
						gmnamed= %topdirec%
						gmnamedx= |%topdirec%|
					}
				if (instr(topdir,gmnamfcm) && (orilen > 5) && !instr(topdir,gmnamecm))
					{
						gmnamed= %topdirec%
						gmnamedx= |%topdirec%|
					}
				if (nameOverride <> "")
					{
						gmnamed= %nameOverride%
					}
				priority:= 0
				if (topdirec = gmnamed)
					{
						;goto, SUBDCHK
					}
				if instr(gmnamecm,gmnamfcm)
					{
						priority:= 4
					}
				if (gmnamfcm = gmnamecm)
					{
						priority:= 5
					}
				if (instr(gmnamex,"launch")or instr(gmnamex,"start"))
					{
						priority:= 6
					}
				SUBDCHK:
				if instr(priorb,gmnamedx)
					{
						priority:= 7
					}
				if instr(priora,gmnamedx)
					{
						priority:= 10
					}
				Loop,parse,gfnamex,\
					{
						kinn= %A_LoopField%
						invar= %kinn%
						gosub, CleanVar
						gmtnm= %invarx%
						kivx= |%gmtnm%|
						if instr(priorbb,kivx)
							{
								priority+=1
							}
						if instr(prioraa,kivx)
							{
								priority+=3
								if instr(priorbb,kivx)
									{
										priority+=-1
									}
									else {
										Loop,parse,priorbb,|
											{
												if instr(gmnamex,A_LoopField)
													{
														priority+=-1
														break
													}
											}
									}
							}
						if (instr(unlike,kinn)or instr(reduced,kinn))
							{
								priority+=-1
							}
					}
				Loop,parse,reduced,|
					{
						if (A_LoopField = "")
							{
								continue
							}
						if (instr(gfnamex,A_LoopField)or instr(gmnamex,A_LoopField))
							{
								priority+=-1
								break
							}
					}
				Loop,parse,unlike,`r`n
					{
						if (A_LoopField = "")
							{
								continue
							}
						if (instr(refname,A_LoopField)or instr(gmnamex,A_LoopField))
							{
								priority+=-1
								break
							}
					}
				posa= %gmnamed%
				posb= |%gmnamed%|
				stringsplit,expa,exlist,|
				renum=
				rn=
				fp=
				tot:=-20
				poscnt:= 0
				if instr(exlist,posb)
					{
						rn= 1
						fp=
						nm=
						Loop,%expa0%
							{
								fp= 0
								fn:= A_Index + 1
								fu:= % expa%A_index%
								if (fu = "")
									{
										continue
									}
								if (fu = posa)
									{
										poscnt+=1
										fp:= % expa%fn%
										if (fp > tot)
											{
												tot:= fp
											}
									}
							}
						if (priority >= tot)
							{
								renum= 1
							}
					}
					else {
					gmnamex= %gmnamed%
					}
				exlist.= posa . "|" . priority . "|"
				subfldrep=
				if (rn = 1)
					{
						poscntx:= poscnt + 1
						if (poscnt > 0)
							{
								Loop,12
									{
										GMMO%A_Index%:=
									}
								stringsplit,GMMO,gmnamed,%A_Space%_-([{}
								if (GMMO3 = "")
									{
										stringleft,gmo,GMMO1,4
										stringleft,gmb,GMMO2,3
										stringupper,gmo,gmo,T
										stringupper,gmb,gmb,T
										gmname:= gmo . gmb
									}
								if (GMMO2 = "")
									{
										Stringleft,gmname,GMMO1,7
										stringupper,gmname,gmname,T
									}
								if ((GMMO1 = "the") or (GMMO1 = "A")&&(GMMO4 = ""))
									{
										stringleft,INNSG,GMMO1,1
										stringupper,INNSG,INNSG,T
										stringleft,INNSJ,GMMO2,1
										stringupper,INNSJ,INNSJ,T
										stringleft,gmop,GMMO3,3
										stringupper,gmop,gmop,T
										gmname= INNSG . INNSJ . GMOP
										if (gmop = "")
											{
												stringleft,INNSK,GMMO2,3
												stringupper,INNSK,INNSK,T
												gmname:= .INNSG . INNSK
											}
										if (INNSJ = "")
											{
												Stringleft,SICRME,INNSJ,5
												stringupper,SIRCME,SIRCME,T
												gmname= %SICRME%
											}
									}
								else {
										stringleft,abegin,GMMO1,3
										SIRCME= %abegin%
										stringleft,amidl,GMMO2,3
										SIRCAD= %amidl%
										stringleft,amend,GMMO3,2
										SIRCEND= %amend%
										stringupper,SIRCME,SIRCME,T
										stringupper,SIRCAD,SIRCAD,T
										stringupper,SIRCEND,SIRCEND,T
										gmname:= SIRCME . SIRCAD . SIRCEND
									}
 								subnumbr:= poscnt
								;subfldrep= %poscnt%_More\
								subfldrep= alternates\
								substfldrc= %poscnt%_More\%gmname%_[0%poscntx%]
								if (INCLALTS = "")
									{
										gmnamex= %gmname%_[0%poscnt%]
									}
							}
						else {
							subfldrep=
							if (INCLALTS = "")
								{
									gmnamex= %gmnamed%
								}
						}
					}
				stringtrimright,subfldrepn,subfldrep,1
				if (enablelogging = 1)
					{
						fileappend,%rn%==%subfldrep%%gmnamed%|%gmnamex%(%renum%):%tot%<!%priority%!`n,log.txt
					}
				sidn= %Game_Profiles%\%gmnameD%
				if (Localize = 1)
					{
						sidn= %OUTDIR%
					}
				splitpath,sidn,sidnf,sidnpth
				GMon= %subfldrep%%gmnamex%_GameMonitors.mon
				DMon= %subfldrep%%gmnamex%_DesktopMonitors.mon
				gamecfgn= %subfldrep%%gmnamex%.ini
				if ((renum = 1)or(rn = ""))
					{
						FileCreateDir,%sidn%\alternates
						subfldrep=
						GMon= GameMonitors.mon
						DMon= DesktopMonitors.mon
						gamecfgn= Game.ini
						gmnamex= %gmnamed%
						FileMove,%sidn%\%gmnamed%.lnk,%sidn%\alternates\%gmnamed%_[0%poscntx%].lnk,1
						FileMove,%sidn%\Game.ini,%sidn%\alternates\%gmnamed%_[0%poscntx%].ini,1
						FileMove,%sidn%\*.xpadderprofile,%sidn%\alternates,1
						FileMove,%sidn%\*.amgp,%sidn%\alternates,1
						FileMove,%sidn%\*.cfg,%sidn%\alternates,1
					}
				gamecfg= %sidn%\%subfldrep%%gamecfgn%
				if (CREFLD = 1)
					{
						FileCreateDir, %sidn%
						if (subfldrep <> "")
							{
								FileCreateDir, %sidn%\%subfldrepn%
								FileSetAttrib, +H, %sidn%\%Subfldrepn%
							}
					}
				else {
					if ((CREFLD = 0)&& !fileExist(sidn))
						{
							continue
						}
					}
				skip=
				if (GMLNK = 1)
					{
						prvv= %sidn%\%subfldrep%%gmnamex%.lnk
						linktar= %GAME_Directory%\%gmnamex%
						linktarget:= linktar . ".lnk"
						linktargez:= linktar . ".cmd"
						linkprox= %sidn%\%subfldrep%%gmnamex%
						linkproxy:= linkprox . ".lnk"
						linkproxz:= linkprox . ".cmd"
						if ((OVERWRT = 1)&&(prnxtn = "lnk"))
							{
								if (!fileexist(linkproxy) or (renum = 1))
									{
										FileCreateShortcut,%prn%,%linkproxy%,%outdir%,%OutArgs%,%refname%, %OutTarget%,, %IconNumber%, %OutRunState%
										Filecopy,%prvv%,%sidn%\%subfldrep%%gmnamed%._lnk_,%OVERWRT%
									}
								if (!fileexist(linktarget)or(renum = 1))
									{
										FileDelete,%linktarget%
										FileCreateShortcut, %RJDB_LOCATION%\bin\RJ_LinkRunner.exe, %linktarget%, %OutDir%, `"%linkproxy%`"%OutArgs%, %refname%, %OutTarget%,, %IconNumber%, %OutRunState%
									}
							}
						if (prnxtn = "exe")
							{
								OutArgs=
								if ((OVERWRT = 1)or(renum = 1))
								 	{
										FileDelete,%linkproxy%
									}
								FileCreateShortcut,%prn%,%linkproxy%,%outdir%,%OutArgs%,%refname%, %OutTarget%,, %IconNumber%, %OutRunState%
								if (renum = 1)
									{
										if fileexist(linktarget)
											{
												FileDelete,%linktarget%
											}
									}
								if ((rn = "")or(renum = 1))
									{
										FileCreateShortcut, %RJDB_LOCATION%\bin\RJ_LinkRunner.exe, %linktarget%, %OutDir%, `"%linkproxy%`"%OutArgs%, %refname%, %OutTarget%,, %IconNumber%, %OutRunState%
									}
								if (!fileexist(linktarget)&&(renum = "")&&(SETALTSALL = 1))
									{
										FileCreateShortcut, %RJDB_LOCATION%\bin\RJ_LinkRunner.exe, %linktarget%, %OutDir%, `"%linkproxy%`"%OutArgs%, %refname%, %OutTarget%,, %IconNumber%, %OutRunState%
									}
							}
						if (ASADMIN = 1)
							{
								RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers, %linkproxy%, ~ RUNASADMIN
							}
                        if (GMCONF = 1)
                            {
								Player1x= %sidn%\%subfldrep%%GMNAMEX%.%Mapper_Extension%
								if (pl1ovr <> "<")
									{
										Player1_Template= %pl1ovr%
										splitpath,pl1ovr,pl1flnm
									}
                                Player2x= %sidn%\%subfldrep%%GMNAMEX%_2.%Mapper_Extension%
								if (pl2ovr <> "<")
									{
										Player2_Template= %pl1ovr%
										splitpath,pl2ovr,pl2flnm
									}
								SplitPath,MediaCenter_Profile_Template,MediaCenter_ProfileName	
								MediaCenter_ProfileX= %sidn%\%subfldrep%%MediaCenter_ProfileName%	
                                cfgcopied=
								if ((OVERWRT = 1)or !fileexist(gamecfg))
                                    {
										cfgcopied= 1
										Filecopy,%RJDB_Config%,%gamecfg%,%OVERWRT%
                                        if ((errorlevel <> 0)or fileexist(gamecfg))
                                            {
                                                fileread,gmcf,%gamecfg%
                                                Loop,parse,gmcf,`n`r
                                                    {
                                                        stringleft,bb,A_LoopField,1
                                                        if (bb = "[")
                                                            {
                                                                stringreplace,sect,A_LoopField,[,,
                                                                stringreplace,section,sect,],,
                                                                continue
                                                            }
                                                        stringsplit,an,A_LoopField,=
                                                        stringreplace,vb,A_LoopField,%an1%=,,
                                                        if ((vb <> "")&&(vb <> "ERROR"))
                                                            {
                                                                %an1%= %vb%
                                                            }
                                                    }
                                            }
                                    }
                                fileread,amcf,%RJDB_CONFIG%
                                Loop,parse,amcf,`n`r
                                    {
                                        stringleft,bb,A_LoopField,1
                                        if (bb = "[")
                                            {
                                                stringreplace,sect,A_LoopField,[,,
                                                stringreplace,section,sect,],,
                                                continue
                                            }
                                        stringsplit,an,A_LoopField,=
                                        stringreplace,vb,A_LoopField,%an1%=,,
                                        if ((vb <> "")&&(vb <> "ERROR"))
                                            {
                                                krs:= % an1
                                                if ((an1 = "Source_Directory") or (an1 = "Game_Profiles")or(an1 = "Game_Directory"))
                                                    {
														Continue
                                                    }
												if (instr(vb,"GameAudio.cmd")or instr(vb,"MediaCenterAudio.cmd")or instr(vb,"_!.cmd"))
												  {
														eb2= 
														stringsplit,eb,vb,<
														if (eb2 <> "")
															{
																splitpath,eb2,vb
																eb1.= "<"
															}
															else {
																	splitpath,eb1,vb
																	eb1= 
															}
														%an1%= %vb%
														filecopy,%home%\%vb%,%sidn%,%OVERWRT%
                                                        if (OVERWRT = 1)
                                                            {
															  iniwrite,%eb1%%sidn%\%vb%,%gamecfg%,%section%,%an1%
															} 
														CONTINUE
												  }
                                                if ((krs = "")&&!instr(an1,"template"))
                                                    {
                                                        %an1%= %vb%
                                                        if (OVERWRT = 1)
                                                            {
                                                                iniwrite,%vb%,%gamecfg%,%section%,%an1%
                                                            }
                                                        else {
                                                            iniread,vtmb,%gamecfg%,%section%,%an1%
                                                            if ((vtmb = "ERROR")or(vtmb = ""))
                                                                {
                                                                    iniwrite,%vb%,%gamecfg%,%section%,%an1%
                                                                }
                                                        	}
                                                    }
                                            }
                                    }
								if ((OVERWRT = 1)or(cfgcopied = 1))
									{
										iniwrite, %sidn%,%gamecfg%,GENERAL,GAME_PROFILES
										iniwrite, %outdir%,%gamecfg%,GENERAL,Source_Directory
										iniwrite, %gamecfg%,%gamecfg%,GENERAL,RJDB_Config
									}
								DeskMon= %sidn%\%subfldrep%%DMon%
								if ((dgovr <> "<")&&(dgovr <> ""))
									{
										DeskMon= %dgovr%
									}
                                if ((OVERWRT = 1))or (!fileexist(DeskMon)&& fileexist(MM_MediaCenter_Config))
                                    {
										filecopy, %MM_MediaCenter_Config%,%DeskMon%,%OVERWRT%
										iniwrite,%DeskMon%,%gamecfg%,GENERAL,MM_MediaCenter_Config
									}
                                GameMon= %sidn%\%subfldrep%%GMon%
								if (mgovr <> "<")
									{
										GameMon= %mgovr%
									}
                                if ((OVERWRT = 1))or (!fileexist(GameMon)&& fileexist(MM_Game_Config))
                                    {
										filecopy, %MM_GAME_Config%,%GameMon%,%OVERWRT%
										iniwrite,%GameMon%,%gamecfg%,GENERAL,MM_Game_Config
									}
								GameProfs= %sidn%
								iniwrite,%GameMon%,%gamecfg%,GENERAL,MM_Game_Config
								killist:
								klist=%tmpn%|
								if (KILLCHK = 1)
									{
										Loop,files,%tlevel%\*.exe,R
											{
												splitpath,A_LoopFileFullPath,tmpfn,tmpfd,,tmpfo
												abson=
												Loop,parse,absol,`r`n
													{
														if (A_LoopField = "")
															{
																continue
															}
														if instr(tmpfo,A_LoopField)
															{
																abson= 1
																continue
															}
													}
												if (!instr(klist,A_LoopFileName)&&(abson = ""))
													{
														klist.= A_LoopFileName . "|"
													}
											}
										iniread,nklist,%gamecfg%,CONFIG,exe_list
										if ((nklist = "")or(nklist = "ERROR")or(OVERWRT = 1))
											{
												iniwrite,%klist%,%gamecfg%,CONFIG,exe_list
											}
									}
									
                            }
					}
				if (GMJOY = 1)
					{
						Filecopy,%Player1_Template%,%player1X%,%OVERWRT%
						if ((errorlevel = 0)or fileexist(player1X))
							{
								if (OVERWRT = 1)
									{
										iniwrite,%player1x%,%GAMECFG%,GENERAL,Player1
									}
								else {
										iniread,pkt,%GAMECFG%,GENERAL,Player1
										if ((pkt = "ERROR")or(pkt = ""))
											{
												iniwrite,%player1x%,%GAMECFG%,GENERAL,Player1
											}
									}
							}
						if (MAPPER <> "JoyToKey")
							{
								Filecopy,%Player2_Template%,%player2X%,%OVERWRT%
								if ((errorlevel = 0)or fileexist(player2x))
									{
										if (OVERWRT = 1)
											{
												iniwrite,%player2x%,%GAMECFG%,GENERAL,Player2
											}
										else {
												iniread,pkt2,%GAMECFG%,GENERAL,Player2
												if ((pkt2 = "ERROR")or(pkt2 = ""))
													{
														iniwrite,%player2x%,%GAMECFG%,GENERAL,Player2
													}
											}
							}
							}
						Filecopy,%MediaCenter_Profile_Template%,%MediaCenter_ProfileX%,%OVERWRT%
						if ((errorlevel = 0)or fileexist(MediaCenter_ProfileX))
							{
								if (OVERWRT = 1)
									{
										iniwrite,%MediaCenter_ProfileX%,%GAMECFG%,GENERAL,MediaCenter_Profile
									}
								else {
										iniread,mktA,%GAMECFG%,GENERAL,MediaCenter_Profile
										if ((mktA = "ERROR")or(mktA = ""))
											{
												iniwrite,%MediaCenter_ProfileX%,%GAMECFG%,GENERAL,MediaCenter_Profile
											}
									}
							}	
					}
				if (GMLNK = 1)
					{
						newcmd= %linkproxz%
						if ((OVERWRT = 1)or(renum = 1))
							{
								stringreplace,cmdtmp,cmdtpp,[MonitorMode],%MonitorMode%
								stringreplace,cmdtmp,cmdtmp,[multimonitor_tool],%multimonitor_tool%
								stringreplace,cmdtmp,cmdtmp,[Mapper],%mapper%
								stringreplace,cmdtmp,cmdtmp,[GAME_EXE],%prn%
								Loop,3
									{
										prea2= 
										npre:= % %A_Index%_Pre
										npst:= % %A_Index%_Post
										stringsplit,prea,npre,<
										%A_Index%_PreW=""
										if (prea2 <> "")
											{
												if instr(prea1,"W")
													{
														%A_Index%_PreW= /Wait ""
													}
												%A_Index%_Pre= %prea2%
											}
										prea2= 
										stringsplit,prea,npst,<
										%A_Index%_PostW=""
										if (prea2 <> "")
											{
												if instr(prea1,"W")
													{
														%A_Index%_PostW= /Wait ""
													}
												%A_Index%_Post= %prea2%
											}
										}
								prea2=
								stringsplit,prea,JustBeforeExit,<
								JBEW=""
								if (prea2 <> "")
									{
										if instr(prea1,"W")
											{
												JBEW= /Wait ""
											}
										JustBeforeExit= %prea2%
									}
								prea2=
								JALW=""
								stringsplit,prea,JustAfterLaunch,<
								if (prea2 <> "")
									{
										if instr(prea1,"W")
											{
												JALW= /Wait ""
											}
										JustAfterLaunch= %prea2%
									}
								stringreplace,cmdtmp,cmdtmp,[1_Pre],%1_Pre%
								stringreplace,cmdtmp,cmdtmp,[1_PreW],%1_PreW%
								stringreplace,cmdtmp,cmdtmp,[2_Pre],%2_Pre%
								stringreplace,cmdtmp,cmdtmp,[2_PreW],%2_PreW%
								stringreplace,cmdtmp,cmdtmp,[3_Pre],%3_Pre%
								stringreplace,cmdtmp,cmdtmp,[3_PreW],%3_PreW%
								stringreplace,cmdtmp,cmdtmp,[3_PostW],%3_PostW%
								stringreplace,cmdtmp,cmdtmp,[3_Post],%3_Post%
								stringreplace,cmdtmp,cmdtmp,[2_Post],%2_Post%
								stringreplace,cmdtmp,cmdtmp,[2_PostW],%2_PostW%
								stringreplace,cmdtmp,cmdtmp,[1_Post],%1_Post%
								stringreplace,cmdtmp,cmdtmp,[1_PostW],%1_PostW%
								stringreplace,cmdtmp,cmdtmp,[JustBeforeExit],%JustBeforeExit%
								stringreplace,cmdtmp,cmdtmp,[JBEW],%JBEW%
								stringreplace,cmdtmp,cmdtmp,[JustAfterLaunch],%JustAfterLaunch%
								stringreplace,cmdtmp,cmdtmp,[JALW],%JALW%
								stringreplace,cmdtmp,cmdtmp,[exelist],%klist%
								stringreplace,cmdtmp,cmdtmp,[MultMonitor_tool],%MultMonitor_tool%
								stringreplace,cmdtmp,cmdtmp,[keyboard_mapper],%keyboard_mapper%
								stringreplace,cmdtmp,cmdtmp,[MM_Game_config],%GameMon%
								stringreplace,cmdtmp,cmdtmp,[MM_MediaCenter_config],%DeskMon%
								stringreplace,cmdtmp,cmdtmp,[MediaCenter_profile],%MediaCenter_ProfileX%
								stringreplace,cmdtmp,cmdtmp,[Player1],%Player1x%
								stringreplace,cmdtmp,cmdtmp,[Player2],%Player2x%
								FileDelete,%linkproxz%
							}
						fileappend,%cmdtmp%,%newcmd%
						if (renum = 1)
							{
								if fileexist(linkproxz)
									{
										FileDelete,%linkproxz%
									}
							}
						if ((rn = "")or(renum = 1))
							{
								fileappend,%cmdtmp%,%linkproxz%
							}
						if (!fileexist(linkproxz)&&(renum = "")&&(SETALTSALL = 1))
							{
								fileappend,%cmdtmp%,%linkproxz%
							}
					}
			}
		if ((kbmovr = "n") or (kbmovr = "0"))
			{
				iniwrite,0,%GAMECFG%,GENERAL,Mapper
			}
		if ((mmovr = "n") or (mmovr ="0"))
			{
				iniwrite,0,%GAMECFG%,GENERAL,MonitorMode
			}
		if ((bgmovr = "n") or (bgmovr ="0"))
			{
				iniwrite,%A_Space%,%GAMECFG%,GENERAL,BorderLess_Gaming_Program
				iniwrite,%A_Space%,%GAMECFG%,GENERAL,BorderLess_Gaming_Database
			}
		if ((preovr = "n") or (preovr ="0"))
			{
				iniwrite,%A_Space%,%GAMECFG%,CONFIG,1_Pre
				iniwrite,%A_Space%,%GAMECFG%,CONFIG,2_Pre
				iniwrite,%A_Space%,%GAMECFG%,CONFIG,3_Pre
			}
		if ((pstovr = "n") or (pstovr ="0"))
			{
				iniwrite,%A_Space%,%GAMECFG%,CONFIG,1_Post
				iniwrite,%A_Space%,%GAMECFG%,CONFIG,2_Post
				iniwrite,%A_Space%,%GAMECFG%,CONFIG,3_Post
			}
		if (mcpovr <> "<")
			{
				iniwrite,%mcpovr%,%GAMECFG%,CONFIG,MediaCenter_Profile
			}
		
	}
SB_SetText("Shortcuts Created")
if (ASADMIN = 1)
	{
		RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers, %binhome%\RJ_LinkRunner.exe, ~ RUNASADMIN
	}
Loop,parse,GUIVARS,|
	{
		guicontrol,enable,%A_LoopField%
		stringreplace,exlisting,exlist,|,`n,All
	}
return

CleanVar:
stringreplace,invarx,invar,.,,All
stringreplace,invarx,invarx,`,,,All
stringreplace,invarx,invarx,_,,All
stringreplace,invarx,invarx,(,,All
stringreplace,invarx,invarx,),,All
stringreplace,invarx,invarx,{,,All
stringreplace,invarx,invarx,},,All
stringreplace,invarx,invarx,[,,All
stringreplace,invarx,invarx,],,All
stringreplace,invarx,invarx,-,,All
stringreplace,invarx,invarx,%A_Space%,,All
return
Localize:
gui,submit,NoHide
guicontrolget,localize,,localize
return

Hide_Taskbar:
gui,submit,nohide
iniwrite,%Hide_Taskbar%,%RJDB_CONFIG%,GENERAL,Hide_Taskbar
return
ResetButs:
gui,submit,nohide
goto,%butrclick%Reset
return
DisableButs:
goto,%butrclick%Disable
return
DeleteButs:
goto,%butrclick%Delete
return


UpdateRJLR:
curemote= originalBinary
gosub, BINGETS
UPDATING= 1
gosub, DOWNLOADIT
UPDATING=
ifexist,%save%
	{
		Process, close, RJ_LinkRunner.exe
		Process, close, Update.exe
		Process, close, Source_Builder.exe
		Process, close, NewOSK.exe
		Process, close, lrdeploy.exe
		FileCopy, %binhome%\Update.exe, %A_Temp%
		Run, "%A_Temp%\Update.exe" "%save%"
		Process, close, Setup.exe
		exitapp
	}
SB_SetText("Update file not found")
return
JAL_RC:
jalrc=1
butrclick=JAL_ProgB
Menu,UCLButton,Show,x53 y448
return
JBE_RC:
jberc=1
butrclick=JBE_ProgB
Menu,UCLButton,Show,x53 y448
return
BGM_RC:
bgmrc=1
butrclick=BGM_ProgB
Menu,UCLButton,Show,x53 y448
return
MMT_RC:
butrclick=MM_ToolB
mmtrc=1
Menu,UCLButton,Show,x53 y352
return
PRE_RC:
butrclick=PREAPP
prerc=1
Menu,AddProgs,Show,x52 y512
return
POST_RC:
butrclick=POSTAPP
postrc=1
Menu,AddProgs,Show,x52 y550
return
KBM_RC:
butrclick=Keyboard_MapB
kbmrc=1
Menu,UCLBUtton,Show, x52 y224
return

DownloadButs:
Menu,keymapd,Add
Menu,keymapd,DeleteAll
if ((butrclick = "Keyboard_MapB")or(kbmrc = 1))
	{
		Menu,keymapd,Add,Antimicro,keymapdownload
		Menu,keymapd, Add,Xpadder,keymapdownload
		Menu,keymapd, Add,JoyToKey,keymapdownload
	}
if ((butrclick = "MM_ToolB")or(mmtrc = 1))
	{
		Menu,keymapd,Add,MultiMonitorTool,MMdownload
	}
if ((butrclick = "BGM_ProgB")or(bgmrc = 1)or(jalrc = 1)or(butrclick = "JAL_ProgB")or(jberc = 1)or(butrclick = "JBE_ProgB"))
	{
		Menu,keymapd,Add,Borderless Gaming,BGMdownload
	}
Menu,keymapd,show
prerc=
jalrc=
jberc=
bgmrc=
mmtrc=
postrc=
kbmrc=
goto,%butrclick%Download
return

MMDownload:
curemote= _MultiMonitorTool_
gosub, BINGETS
gosub, DOWNLOADIT
MultiMonitor_ToolT= %binhome%\multimonitortool.exe
gosub, MM_ToolB
dchk=
SB_SetText("")
return

JAL_ProgBDownload:
JBE_ProgBDownload:
BGMdownload:
curemote= _BorderlessGaming_
gosub, BINGETS
gosub, DOWNLOADIT
Borderless_Gaming_Program= %binhome%\Borderless Gaming\borderless-gaming-portable.exe
gosub, %butrclick%
dchk=
SB_SetText("")
return

SSDDownload:


keymapdownload:
if (A_ThisMenuItem = "Antimicro")
	{
		curemote= _Antimicro_
		gosub, BINGETS
		gosub, DOWNLOADIT
		keyboard_mapperT= %binhome%\Antimicro\Antimicro.exe
	}
if (A_ThisMenuItem = "DS4Windows")
	{
		curemote= _DS4Windows_
		gosub, BINGETS
		gosub, DOWNLOADIT
		keyboard_mapperT= %binhome%\ds4windows\ds4windows.exe
	}
if (A_ThisMenuItem = "JoyToKey")
	{
		curemote= _JoyToKey_
		gosub, BINGETS
		gosub, DOWNLOADIT
		keyboard_mapperT= %binhome%\JoyToKey\JoyToKey.exe
	}
if (A_ThisMenuItem = "Xpadder")
	{
		curemote= _Xpadder_
		gosub, BINGETS
		gosub, DOWNLOADIT
		keyboard_mapperT= %binhome%\xpadder\xpadder.exe
	}
SB_SetText("")
gosub, Keyboard_MapB
dchk=
return

ButtonClear:
LV_Delete()
SOURCEDLIST=
fileDelete,%home%\continue.db
guicontrol,show,REINDEX
return

MyListView:
FocusedRowNumber := LV_GetNext(0, "F")
if not FocusedRowNumber 
LV_GetText(nmFDir, FocusedRowNumber, 3)
LV_GetText(nmovr, FocusedRowNumber, 5)
LV_GetText(kbmstat, FocusedRowNumber, 6)
LV_GetText(pl1stat, FocusedRowNumber, 7)
LV_GetText(pl2stat, FocusedRowNumber, 8)
LV_GetText(mcpstat, FocusedRowNumber, 9)
LV_GetText(mmtstat, FocusedRowNumber, 10)
LV_GetText(gmsstat, FocusedRowNumber, 11)
LV_GetText(dmsstat, FocusedRowNumber, 12)
LV_GetText(bgmtat, FocusedRowNumber, 13)
LV_GetText(prestat, FocusedRowNumber, 14)
LV_GetText(pststat, FocusedRowNumber, 15)
    return

If (A_GuiEvent == "F") {
   If (ICELV1["Changed"]) {
      Msg := ""
      For I, O In ICELV1.Changed
         Msg .= "Row " . O.Row . " - Column " . O.Col . " : " . O.Txt
      ToolTip, % "Changes in " . A_GuiControl . "`r`n`r`n" . Msg
      SetTimer, KillToolTip, 2000
      ICELV1.Remove("Changed")
   }
  if ((O.Col = 6)or(O.Col = 10)or(O.Col = 13)or(O.Col = 14)or(O.Col = 15))
	{
		if ((O.Col <> 0) or (O.Col <> 1) or (O.Col <> "y") or (O.Col <> "n") or (O.Col <> "off") or (O.Col <> "on"))
			{
				SB_SetText("Booleans Only: 0`,off`,n`,1`,on`,or y")
			}
	}
  if ((O.Col = 7)or(O.Col = 8)or(O.Col = 9)or(O.Col = 11)or(O.Col = 13)or(O.Col = 14)or(O.Col = 12))
	{
		;FileSelectFile,replathis,35,,Select File,*.*
		SB_SetText("input an unquoted path to the file")
	}
}
return

DOWNLOADIT:
extractloc= %binhome%%xtractpath%
extractlocf= "%extractloc%"
filecreateDir,%home%\downloaded
save= %home%\downloaded\%binarcf%
splitpath,save,savefile,savepath,savextn
savef= "%save%"
compltdwn:= % curemote
if (fileexist(save)&& (compltdwn = 1))
	{
		Msgbox,260,Redownload,Download the %binarcf% file again?`noriginal will be renamed ".bak",3
		ifmsgbox,yes
			{
				gosub,DOWNBIN
			}
		if (dwnrej = "")
			{
				goto, EXTRACTING
			}
		dwnrej=
	}
DOWNBIN:
SB_SetText("Downloading" "" binarcf "")

DWNCONFIRM:
dwnrej=
DownloadFile(URLFILE,save,False,True)
SB_SetText(" " binarcf " ""downloaded")
if (UPDATING = 1)
	{
		return
	}
EXTRACTING:
ToolTip,
Sleep, 500
if (fileexist(save)&& !fileexist(exetfnd))
	{
		ToolTip, Extracting...
		if !fileexist(extractloc . "\")
			{
				FileCreateDir,%extractloc%
			}
		if (!fileexist(binhome . "\" . "7za.exe")&&(savextn <> "7z"))
			{
				Extract2Folder(savef,extractlocf)
			}
			else {
			if fileexist(binhome . "\" . "7za.exe")
				{
					RunWait,%binhome%\7za.exe x -y "%home%\downloaded\%binarcf%" -O"%extractloc%",%binhome%,hide
				}
				else {
					Msgbox,258,,7za.exe not found,Binary file 7za.exe is missing from`n%binhome%`n`nContinue?
					ifmsgbox,Abort
						{
							exitapp
						}
					if Msgbox,Retry
						{
							curemote= originalBinary
							xtractpath=
							gosub, BINGETS
							goto, DOWNLOADIT
						}
				}
			}
		Tooltip,Extracted.
		dchk= 1
		if (rento <> "")
			{
				FileMoveDir,%extractloc%,%rento%,R
			}
	}
Sleep, 500
ToolTip,
ifnotexist,%save%
	{
		msgbox,258,Download Failed,%binarcf% did not download.`nYou may select the location of support files later`n`nContinue?
		ifmsgbox,Abort
			{
				if (curemote = "originalBinary")
					{
						exitapp
					}
			}
		if Msgbox,Retry
			{
				goto, DOWNLOADIT
			}
	}
SB_SetText("")
return

BINGETS:
Loop,6,
	{
		URLNX%A_Index%=
	}
renfrm=
rento=
iniread,URLFILESPLIT,%source%\repos.set,BINARIES,%curemote%
stringsplit,URLNX,URLFILESPLIT,|
URLFILE=%URLNX1%
Splitpath,URLFILE,binarcf
exetfndsp=%URLNX2%
xtractpath=%URLNX3%
stringsplit,rensp,urlnx4,?
renfrm= %rensp1%
rento= %rensp2%
if (URLFILE = "") or (URLFILE = "ERROR")
	{
		URLFILE= %URLFILEX%
	}
return

GuiContextMenu:
gui,submit,nohide
If A_GuiControlEvent RightClick
	{
	butrclick= %A_GuiControl%
	MENU_X:= A_GuiX*(A_ScreenDPI/96)
	MENU_Y:= A_GuiY*(A_ScreenDPI/96)
	if A_GuiControl = RESET
		{
			Menu, UPDButton, Show, %MENU_X% %MENU_Y%
			return
		}
	if A_GuiControl = MM_ToolB
		{
			Menu, UCLButton, Show, %MENU_X% %MENU_Y%
			return
		}
	if A_GuiControl = Keyboard_MapB
		{
			Menu, UCLButton, Show, %MENU_X% %MENU_Y%
			return
		}
	if A_GuiControl = POSTAPP
		{
			Menu,AddProgs,Show,%MENU_X% %MENU_Y%
			return
		}
	if A_GuiControl = PREAPP
		{
			Menu,AddProgs,Show,%MENU_X% %MENU_Y%
			return
		}
if A_GuiControl = BGM_ProgB
		{
			Menu, UCLButton, Show, %MENU_X% %MENU_Y%
			return
		}

if (A_GuiControl != "MyListView")
    return

Menu, MyContextMenu, Show, %A_GuiX%, %A_GuiY%
}
return

ContextOpenFile:  
ContextProperties: 
FocusedRowNumber := LV_GetNext(0, "F") 
if not FocusedRowNumber 
    return
LV_GetText(nmFName, FocusedRowNumber, 1) 
LV_GetText(nmFDir, FocusedRowNumber, 3)
LV_GetText(nmovr, FocusedRowNumber, 5)
LV_GetText(kbmstat, FocusedRowNumber, 6)
LV_GetText(pl1stat, FocusedRowNumber, 7)
LV_GetText(pl2stat, FocusedRowNumber, 8)
LV_GetText(mcpstat, FocusedRowNumber, 9)
LV_GetText(mmtstat, FocusedRowNumber, 10)
LV_GetText(gmsstat, FocusedRowNumber, 11)
LV_GetText(dmsstat, FocusedRowNumber, 12)
LV_GetText(jbetat, FocusedRowNumber, 13)
LV_GetText(jaltat, FocusedRowNumber, 14)
LV_GetText(prestat, FocusedRowNumber, 15)
LV_GetText(pststat, FocusedRowNumber, 16)
if InStr(A_ThisMenuItem, "Open in Explorer") 
	{
		Run, Explorer `"%nmfDir%`"
	}

	else {
	} 
if ErrorLevel
    {
		;; MsgBox Could not perform requested action on "%FileDir%\%FileName%".
	}
return

ContextClearRows:
RowNumber := 0 
Loop
	{

    RowNumber := LV_GetNext(RowNumber - 1)
    if not RowNumber 
        break
    LV_Delete(RowNumber)  
}
return

LVGetCheckedItems(cN,wN) {
	noen= \|
    ControlGet, LVItems, List,, % cN, % wN
    Pos:=!Pos,Item:=Object()
    While Pos
        Pos:=RegExMatch(LVItems,"`am)(^.*?$)",_,Pos+StrLen(_)),mCnt:=A_Index-1,Item[mCnt]:=_1
    Loop % mCnt {
        SendMessage, 0x102c, A_Index-1, 0x2000, % cN, % wN
        ChekItems:=(ErrorLevel ? Item[A_Index-1] "`n" : "")
		dbb5=
		stringsplit,dbb,ChekItems,%A_Tab%
		renafm:= "?" . dbb5 . ">"
		fprnt:= dbb3 . "\" . dbb1
		if (!instr(ChkItems,fprnt)&&(fprnt <> noen))
			{
				ChkItems.= dbb3 . "\" . dbb1 . renafm . dbb6 . ">" . dbb7 . ">" . dbb8 . ">" . dbb9 . ">" . dbb10 . ">" . dbb11 . ">" . dbb12 . ">" . dbb13 . ">" . dbb14 . ">" . dbb15 . "|"
			}
    }
	stringreplace,chkitems,chkitems,`n,,All
	stringreplace,chkitems,chkitems,?%A_Space%,,All
    Return ChkItems
}

DownloadFile(UrlToFile, _SaveFileAs, Overwrite := True, UseProgressBar := True) {
	FinalSize=

  If (!Overwrite && FileExist(_SaveFileAs))
	  {
		FileSelectFile, _SaveFileAs,S, %_SaveFileAs%
		if !_SaveFileAs
		  return
	  }

  If (UseProgressBar) {

		SaveFileAs := _SaveFileAs

		try WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		catch {
		}

		try WebRequest.Open("HEAD", UrlToFile)
		catch {
		}
		try WebRequest.Send()
		catch {
		}

		try FinalSize := WebRequest.GetResponseHeader("Content-Length")
		catch {
			FinalSize := 1
		}
		SetTimer, DownloadFileFunction_UpdateProgressBar, 100


  }
  UrlDownloadToFile, %UrlToFile%, %_SaveFileAs%
If (UseProgressBar) {
	ToolTip,
  }

      DownloadFileFunction_UpdateProgressBar:

      try CurrentSize := FileOpen(_SaveFileAs, "r").Length
	  catch {
			}

      try CurrentSizeTick := A_TickCount
    catch {
			}

      try Speed := Round((CurrentSize/1024-LastSize/1024)/((CurrentSizeTick-LastSizeTick)/1000)) . " Kb/s"
	  catch {
			}

      LastSizeTick := CurrentSizeTick
      try LastSize := FileOpen(_SaveFileAs, "r").Length
    catch {
			}

      try PercentDone := Round(CurrentSize/FinalSize*100)
    catch {
			}

	 if (PercentDone > 100)
		{
			ToolTip,
			PercentDone=
		}
	 SB_SetText(" " Speed " at " PercentDone "`% " CurrentSize " bytes completed")
	 return
  }


Extract2Folder(Zip, Dest="", jhFln="")
{
    SplitPath, Zip,, SourceFolder
    if ! SourceFolder
        Zip := A_ScriptDir . "\" . Zip

    if ! Dest {
        SplitPath, Zip,, DestFolder,, Dest
        Dest := DestFolder . "\" . Dest . "\"
    }
    if SubStr(Dest, 0, 1) <> "\"
        Dest .= "\"
    SplitPath, Dest,,,,,DestDrive
    if ! DestDrive
        Dest := A_ScriptDir . "\" . Dest

    fso := ComObjCreate("Scripting.FileSystemObject")
    If Not fso.FolderExists(Dest)
		{
			fso.CreateFolder(Dest)
		}

    AppObj := ComObjCreate("Shell.Application")
    FolderObj := AppObj.Namespace(Zip)
    if jhFln {
        FileObj := FolderObj.ParseName(jhFln)
        AppObj.Namespace(Dest).CopyHere(FileObj, 4|16)
    }
    else
    {
        FolderItemsObj := FolderObj.Items()
        AppObj.Namespace(Dest).CopyHere(FolderItemsObj, 4|16)
    }
}
CmdRet(sCmd, callBackFuncObj := "", encoding := ""){
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
WM_MOUSEMOVE() {
	
	static CurrControl, PrevControl, _TT
	CurrControl := A_GuiControl
	If (CurrControl <> PrevControl)
		{
			SetTimer, DisplayToolTip, -300
			PrevControl := CurrControl
		}
	return

	DisplayToolTip:
	try
			ToolTip % %CurrControl%_TT
	catch
			ToolTip
	SetTimer, RemoveToolTip, -6000
	return

	RemoveToolTip:
	ToolTip
	return
}
Class LV_InCellEdit {
    __New(HWND, HiddenCol1 := False, BlankSubItem := False, EditUserFunc := "") {
      If (This.Base.Base.__Class) 
         Return False
      If This.Attached[HWND] 
         Return False
      If !DllCall("IsWindow", "Ptr", HWND)
         Return False
      VarSetCapacity(Class, 512, 0)
      DllCall("GetClassName", "Ptr", HWND, "Str", Class, "Int", 256)
      If (Class <> "SysListView32") 
         Return False
      If (EditUserFunc <> "") && (Func(EditUserFunc).MaxParams < 6)
         Return False
      SendMessage, 0x1036, 0x010000, 0x010000, , % "ahk_id " . HWND
      This.HWND := HWND
      This.HEDIT := 0
      This.Item := -1
      This.SubItem := -1
      This.ItemText := ""
      This.RowCount := 0
      This.ColCount := 0
      This.Cancelled := False
      This.Next := False
      This.Skip0 := !!HiddenCol1
      This.Blank := !!BlankSubItem
      This.Critical := "Off"
      This.DW := 0
      This.EX := 0
      This.EY := 0
      This.EW := 0
      This.EH := 0
      This.LX := 0
      This.LY := 0
      This.LR := 0
      This.LW := 0
      This.SW := 0
      If (EditUserFunc <> "")
         This.EditUserFunc := Func(EditUserFunc)
      This.OnMessage()
      This.Attached[HWND] := True
   }
   __Delete() {
      This.Attached.Remove(This.HWND, "")
      WinSet, Redraw, , % "ahk_id " . This.HWND
   }
   EditCell(Row, Col := 0) {
      If !This.HWND
         Return False
      ControlGet, Rows, List, Count, , % "ahk_id " . This.HWND
      This.RowCount := Rows - 1
      ControlGet, ColCount, List, Count Col, , % "ahk_id " . This.HWND
      This.ColCount := ColCount - 1
      If (Col = 0) {
         If (This["Columns"])
            Col := This.Columns.MinIndex() + 1
         ELse If This.Skip0
            Col := 2
         Else
            Col := 1
      }
      If (Row < 1) || (Row > Rows) || (Col < 1) || (Col > ColCount)
         Return False
      If (Column = 1) && This.Skip0
         Col := 2
      If (This["Columns"])
         If !This.Columns[Col - 1]
            Return False
      VarSetCapacity(LPARAM, 1024, 0)
      NumPut(Row - 1, LPARAM, (A_PtrSize * 3) + 0, "Int")
      NumPut(Col - 1, LPARAM, (A_PtrSize * 3) + 4, "Int")
      This.NM_DBLCLICK(&LPARAM)
      Return True
   }
   SetColumns(ColNumbers*) {
      If !This.HWND
         Return False
      This.Remove("Columns")
      If (ColNumbers.MinIndex() = "")
         Return True
      ControlGet, ColCount, List, Count Col, , % "ahk_id " . This.HWND
      Indices := []
      For Each, Col In ColNumbers {
         If Col Is Not Integer
            Return False
         If (Col < 1) || (Col > ColCount)
            Return False
         Indices[Col - 1] := True
      }
      This["Columns"] := Indices
      Return True
   }
    OnMessage(Apply := True) {
      If !This.HWND
         Return False
      If (Apply) && !This.HasKey("NotifyFunc") {
         This.NotifyFunc := ObjBindMethod(This, "On_WM_NOTIFY")
         OnMessage(0x004E, This.NotifyFunc)
      }
      Else If !(Apply) && This.HasKey("NotifyFunc") {
         OnMessage(0x004E, This.NotifyFunc, 0)
         This.NotifyFunc := ""
         This.Remove("NotifyFunc")
      }
      WinSet, Redraw, , % "ahk_id " . This.HWND
      Return True
   }
   Static Attached := {}
   Static OSVersion := DllCall("GetVersion", "UChar")
 
   On_WM_COMMAND(W, L, M, H) {
      Critical, % This.Critical
      If (L = This.HEDIT) {
         N := (W >> 16)
         If (N = 0x0400) || (N = 0x0300) || (N = 0x0100) { 
            If (N = 0x0100)
               SendMessage, 0x00D3, 0x01, 0, , % "ahk_id " . L
            ControlGetText, EditText, , % "ahk_id " . L
            SendMessage, % (A_IsUnicode ? 0x1057 : 0x1011), 0, % &EditText, , % "ahk_id " . This.HWND
            EW := ErrorLevel + This.DW
            , EX := This.EX
            , EY := This.EY
            , EH := This.EH + (This.OSVersion < 6 ? 3 : 0) 
            If (EW < This.MinW)
               EW := This.MinW
            If (EX + EW) > This.LR
               EW := This.LR - EX
            DllCall("SetWindowPos", "Ptr", L, "Ptr", 0, "Int", EX, "Int", EY, "Int", EW, "Int", EH, "UInt", 0x04)
            If (N = 0x0400) 
               Return 0
         }
      }
   }
   On_WM_HOTKEY(W, L, M, H) {
      If (H = This.HWND) {
         If (W = 0x801B) {
            This.Cancelled := True
            PostMessage, 0x10B3, 0, 0, , % "ahk_id " . H
         }
         Else {
            This.Next := True
            SendMessage, 0x10B3, 0, 0, , % "ahk_id " . H
            This.Next := True
            This.NextSubItem(W)
         }
         Return False
      }
   }
   On_WM_NOTIFY(W, L) {
      Critical, % This.Critical
      If (H := NumGet(L + 0, 0, "UPtr") = This.HWND) {
         M := NumGet(L + (A_PtrSize * 2), 0, "Int")
         If (M = -175) || (M = -105)
            Return This.LVN_BEGINLABELEDIT(L)
         If (M = -176) || (M = -106)
            Return This.LVN_ENDLABELEDIT(L)
         If (M = -3)
            This.NM_DBLCLICK(L)
      }
   }
   LVN_BEGINLABELEDIT(L) {
      Static Indent := 4
      If (This.Item = -1) || (This.SubItem = -1)
         Return True
      H := This.HWND
      SendMessage, 0x1018, 0, 0, , % "ahk_id " . H 
      This.HEDIT := ErrorLevel
      , VarSetCapacity(ItemText, 2048, 0)
      , VarSetCapacity(LVITEM, 40 + (A_PtrSize * 5), 0)
      , NumPut(This.Item, LVITEM, 4, "Int")
      , NumPut(This.SubItem, LVITEM, 8, "Int")
      , NumPut(&ItemText, LVITEM, 16 + A_PtrSize, "Ptr")
      , NumPut(1024 + 1, LVITEM, 16 + (A_PtrSize * 2), "Int")
      SendMessage, % (A_IsUnicode ? 0x1073 : 0x102D), % This.Item, % &LVITEM, , % "ahk_id " . H ; LVM_GETITEMTEXT
      This.ItemText := StrGet(&ItemText, ErrorLevel)

      If (This.EditUserFunc)
         This.EditUserFunc.Call("BEGIN", This.HWND, This.HEDIT, This.Item + 1, This.Subitem + 1, This.ItemText)
      SendMessage, 0x000C, 0, % &ItemText, , % "ahk_id " . This.HEDIT
      If (This.SubItem > 0) && (This.Blank) {
         Empty := ""
         , NumPut(&Empty, LVITEM, 16 + A_PtrSize, "Ptr") 
         , NumPut(0,LVITEM, 16 + (A_PtrSize * 2), "Int")
         SendMessage, % (A_IsUnicode ? 0x1074 : 0x102E), % This.Item, % &LVITEM, , % "ahk_id " . H ; LVM_SETITEMTEXT
      }
      VarSetCapacity(RECT, 16, 0)
      , NumPut(This.SubItem, RECT, 4, "Int")
      SendMessage, 0x1038, This.Item, &RECT, , % "ahk_id " . H 
      This.EX := NumGet(RECT, 0, "Int") + Indent
      , This.EY := NumGet(RECT, 4, "Int")
      If (This.OSVersion < 6)
         This.EY -= 1
      If (This.SubItem = 0) {
         SendMessage, 0x101D, 0, 0, , % "ahk_id " . H
         This.EW := ErrorLevel
      }
      Else
         This.EW := NumGet(RECT, 8, "Int") - NumGet(RECT, 0, "Int")
      This.EH := NumGet(RECT, 12, "Int") - NumGet(RECT, 4, "Int")
      VarSetCapacity(LVCOL, 56, 0)
      , NumPut(1, LVCOL, "UInt")
      SendMessage, % (A_IsUnicode ? 0x105F : 0x1019), % This.SubItem, % &LVCOL, , % "ahk_id " . H
      If (NumGet(LVCOL, 4, "UInt") & 0x0002) {
         SendMessage, % (A_IsUnicode ? 0x1057 : 0x1011), 0, % &ItemText, , % "ahk_id " . This.HWND
         EW := ErrorLevel + This.DW
         If (EW < This.MinW)
            EW := This.MinW
         If (EW < This.EW)
            This.EX += ((This.EW - EW) // 2) - Indent
      }
      This.CommandFunc := ObjBindMethod(This, "On_WM_COMMAND")
      , OnMessage(0x0111, This.CommandFunc)
      If !(This.Next)
         This.RegisterHotkeys()
      This.Cancelled := False
      This.Next := False
      Return False
   }
   LVN_ENDLABELEDIT(L) {
      H := This.HWND
      OnMessage(0x0111, This.CommandFunc, 0)
      This.CommandFunc := ""
      If !(This.Next)
         This.RegisterHotkeys(False)
      ItemText := This.ItemText
      If !(This.Cancelled)
         ControlGetText, ItemText, , % "ahk_id " . This.HEDIT
      If (ItemText <> This.ItemText) {
         If !(This["Changed"])
            This.Changed := []
         This.Changed.Insert({Row: This.Item + 1, Col: This.SubItem + 1, Txt: ItemText})
      }
      If (ItemText <> This.ItemText) || ((This.SubItem > 0) && (This.Blank)) {
         VarSetCapacity(LVITEM, 40 + (A_PtrSize * 5), 0)
         , NumPut(This.Item, LVITEM, 4, "Int")
         , NumPut(This.SubItem, LVITEM, 8, "Int")
         , NumPut(&ItemText, LVITEM, 16 + A_PtrSize, "Ptr")
         SendMessage, % (A_IsUnicode ? 0x1074 : 0x102E), % This.Item, % &LVITEM, , % "ahk_id " . H
      }
      If !(This.Next)
         This.Item := This.SubItem := -1
      This.Cancelled := False
      This.Next := False
      If (This.EditUserFunc)
         This.EditUserFunc.Call("END", This.HWND, This.HEDIT, This.Item + 1, This.Subitem + 1, ItemText)
      Return False
   }
   NM_DBLCLICK(L) {
      H := This.HWND
      This.Item := This.SubItem := -1
      Item := NumGet(L + (A_PtrSize * 3), 0, "Int")
      SubItem := NumGet(L + (A_PtrSize * 3), 4, "Int")
      If (This["Columns"]) {
         If !This["Columns", SubItem]
            Return False
      }
      If (Item >= 0) && (SubItem >= 0) {
         This.Item := Item, This.SubItem := SubItem
         If !(This.Next) {
            ControlGet, V, List, Count, , % "ahk_id " . H
            This.RowCount := V - 1
            ControlGet, V, List, Count Col, , % "ahk_id " . H
            This.ColCount := V - 1
            , NumPut(VarSetCapacity(WINDOWINFO, 60, 0), WINDOWINFO)
            , DllCall("GetWindowInfo", "Ptr", H, "Ptr", &WINDOWINFO)
            , This.DX := NumGet(WINDOWINFO, 20, "Int") - NumGet(WINDOWINFO, 4, "Int")
            , This.DY := NumGet(WINDOWINFO, 24, "Int") - NumGet(WINDOWINFO, 8, "Int")
            , Styles := NumGet(WINDOWINFO, 36, "UInt")
            SendMessage, % (A_IsUnicode ? 0x1057 : 0x1011), 0, % "WWW", , % "ahk_id " . H ; LVM_GETSTRINGWIDTH
            This.MinW := ErrorLevel
            SendMessage, % (A_IsUnicode ? 0x1057 : 0x1011), 0, % "III", , % "ahk_id " . H ; LVM_GETSTRINGWIDTH
            This.DW := ErrorLevel
            , SBW := 0
            If (Styles & 0x200000)
               SysGet, SBW, 2
            ControlGetPos, LX, LY, LW, , , % "ahk_id " . H
            This.LX := LX
            , This.LY := LY
            , This.LR := LX + LW - (This.DX * 2) - SBW
            , This.LW := LW
            , This.SW := SBW
            , VarSetCapacity(RECT, 16, 0)
            , NumPut(SubItem, RECT, 4, "Int")
            SendMessage, 0x1038, %Item%, % &RECT, , % "ahk_id " . H
            X := NumGet(RECT, 0, "Int")
            If (SubItem = 0) {
               SendMessage, 0x101D, 0, 0, , % "ahk_id " . H
               W := ErrorLevel
            }
            Else
               W := NumGet(RECT, 8, "Int") - NumGet(RECT, 0, "Int")
            R := LW - (This.DX * 2) - SBW
            If (X < 0)
               SendMessage, 0x1014, % X, 0, , % "ahk_id " . H
            Else If ((X + W) > R)
               SendMessage, 0x1014, % (X + W - R + This.DX), 0, , % "ahk_id " . H
         }
         PostMessage, % (A_IsUnicode ? 0x1076 : 0x1017), %Item%, 0, , % "ahk_id " . H
      }
      Return False
   }

   NextSubItem(K) {
      H := This.HWND
      Item := This.Item
      SubItem := This.SubItem
      If (K = 0x8009)
         SubItem++
      Else If (K = 0x8409) {
         SubItem--
         If (SubItem = 0) && This.Skip0
            SubItem--
      }
      Else If (K = 0x8028)
         Item++
      Else If (K = 0x8026)
         Item--
      IF (K = 0x8409) || (K = 0x8009) {
         If (This["Columns"]) {
            If (SubItem < This.Columns.MinIndex())
               SubItem := This.Columns.MaxIndex(), Item--
            Else If (SubItem > This.Columns.MaxIndex())
               SubItem := This.Columns.MinIndex(), Item++
			   Else {
               While (This.Columns[SubItem] = "") {
                  If (K = 0x8009)
                     SubItem++
                  Else
                     SubItem--
               }
            }
         }
      }
      If (SubItem > This.ColCount)
         Item++, SubItem := This.Skip0 ? 1 : 0
      Else If (SubItem < 0)
         SubItem := This.ColCount, Item--
      If (Item > This.RowCount)
         Item := 0
      Else If (Item < 0)
         Item := This.RowCount
      If (Item <> This.Item)
         SendMessage, 0x1013, % Item, False, , % "ahk_id " . H 
      VarSetCapacity(RECT, 16, 0), NumPut(SubItem, RECT, 4, "Int")
      SendMessage, 0x1038, % Item, % &RECT, , % "ahk_id " . H
      X := NumGet(RECT, 0, "Int"), Y := NumGet(RECT, 4, "Int")
      If (SubItem = 0) {
         SendMessage, 0x101D, 0, 0, , % "ahk_id " . H
         W := ErrorLevel
      }
      Else
         W := NumGet(RECT, 8, "Int") - NumGet(RECT, 0, "Int")
      R := This.LW - (This.DX * 2) - This.SW, S := 0
      If (X < 0)
         S := X
      Else If ((X + W) > R)
         S := X + W - R + This.DX
      If (S)
         SendMessage, 0x1014, % S, 0, , % "ahk_id " . H 
      Point := (X - S + (This.DX * 2)) + ((Y + (This.DY * 2)) << 16)
      SendMessage, 0x0201, 0, % Point, , % "ahk_id " . H 
      SendMessage, 0x0202, 0, % Point, , % "ahk_id " . H 
      SendMessage, 0x0203, 0, % Point, , % "ahk_id " . H 
      SendMessage, 0x0202, 0, % Point, , % "ahk_id " . H 
   }
   RegisterHotkeys(Register = True) {
      H := This.HWND
      If (Register) {
         DllCall("RegisterHotKey", "Ptr", H, "Int", 0x801B, "UInt", 0, "UInt", 0x1B)
         , DllCall("RegisterHotKey", "Ptr", H, "Int", 0x8009, "UInt", 0, "UInt", 0x09)
         , DllCall("RegisterHotKey", "Ptr", H, "Int", 0x8409, "UInt", 4, "UInt", 0x09)
         , DllCall("RegisterHotKey", "Ptr", H, "Int", 0x8028, "UInt", 0, "UInt", 0x28)
         , DllCall("RegisterHotKey", "Ptr", H, "Int", 0x8026, "UInt", 0, "UInt", 0x26)
         , This.HotkeyFunc := ObjBindMethod(This, "On_WM_HOTKEY")
         , OnMessage(0x0312, This.HotkeyFunc)
      }
      Else {
         DllCall("UnregisterHotKey", "Ptr", H, "Int", 0x801B)
         , DllCall("UnregisterHotKey", "Ptr", H, "Int", 0x8009)
         , DllCall("UnregisterHotKey", "Ptr", H, "Int", 0x8409)
         , DllCall("UnregisterHotKey", "Ptr", H, "Int", 0x8028)
         , DllCall("UnregisterHotKey", "Ptr", H, "Int", 0x8026)
         , OnMessage(0x0312, This.HotkeyFunc, 0)
         , This.HotkeyFunc := ""
      }
   }
}
