#NoEnv  
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance Force
#Persistent
RJDB_Config= RJDB.ini
FileCreateDir,Launchers
FileCreateDir,profiles
FileCreateDir,Shortcuts
ifnotexist,Antimicro_!.cmd
    {
        gosub, INITAMIC
    }
gosub,RECREATEJOY
gosub, DDPOPS
repopbut= hidden
fileread,unlike,unlike.Set
fileread,unselect,unsel.set
fileread,absol,absol.set
if fileexist("continue.db")
	{
		repopbut= 
		fileread,SOURCEDLIST,continue.db
	}
fileread,exclfls,exclfnms.set
filextns= exe|lnk
reduced= |_Data|Assets|alt|shipping|Data|ThirdParty|engine|App|steam|steamworks|script|nocd|Tool|trainer|
priora= |Launcher64|Launcherx64|Launcherx8664|Launcher64bit|Launcher64|Launchx64|Launch64|Launchx8664|
priorb= |Launcher32|Launcherx86|Launcher32bit|Launcher32|Launchx86|Launch32|
prioraa= |win64|x64|64bit|64bits|64|x8664|bin64|bin64bit|windowsx64|windows64|binx64|exex64|exe64|binariesx64|binaries64|binariesx8664|
priorbb= |win32|32bit|32bits|x8632|x86|x8632bit|32|windows32|windows32|bin32|windowsx86|bin32bit|binx86|bin32|exex86|exe32|binariesx86|binaries32|binariesx86|
undir= |%A_WinDir%|%A_Programfiles%|%A_Programs%|%A_AppDataCommon%|%A_AppData%|%A_Desktop%|%A_DesktopCommon%|%A_StartMenu%|%A_StartMenuCommon%|%A_Startup%|%A_StartupCommon%|%A_Temp%|
GUIVARS= PostWait|PreWait|SCONLY|EXEONLY|BOTHSRCH|ButtonClear|ButtonCreate|MyListView|CREFLD|GMCONF|GMJOY|GMLNK|UPDTSC|OVERWRT|POPULATE|RESET|EnableLogging|RJDB_Config|RJDB_Location|GAME_Profiles|GAME_Directory|SOURCE_DirButton|SOURCE_DirectoryT|REMSRC|Keyboard_Mapper|Player1_Template|Player2_Template|MediaCenter_Profile|MultiMonitor_Tool|MM_Game_Config|MM_MediaCenter_Config|Borderless_Gaming_Program|Borderless_Gaming_Database|PREAPP|PREDD|DELPREAPP|POSTAPP|PostDD|DELPOSTAPP|REINDEX|KILLCHK|INCLALTS
STDVARS= KeyBoard_Mapper|MediaCenter_Profile|Player1_Template|Player2_Template|MultiMonitor_Tool|MM_MEDIACENTER_Config|MM_Game_Config|BorderLess_Gaming_Program|BorderLess_Gaming_Database|extapp|Game_Directory|Game_Profiles|RJDB_Location|Source_Directory|Mapper_Extension|1_Pre|2_Pre|3_Pre|1_Post|2_Post|3_Post|switchcmd|switchback
DDTA= <$This_prog$><Monitor><Mapper>
DDTB= <Monitor><$This_prog$><Mapper>
DDTC= <$This_prog$><Monitor><Mapper>
ifnotexist,RJDB.ini
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
	}
if (GMCONF = 1)
	{
		cfgget= checked
	}
if (GMJOY = 1)
	{	
		joyget= checked
	}
if (GMLNK = 1)
	{
		lnkget= checked
	}
ifinstring,1_Pre,"W<"
prestatus= checked
ifinstring,1_Post,"W<"
poststatus= checked
; Create the ListView and its columns via Gui Add:
Gui, Add, Button, x310 y8 vButtonClear gButtonClear hidden disabled, Clear List
Gui, Font, Bold
Gui, Add, Button, x560 y8 vButtonCreate gButtonCreate hidden disabled,CREATE
Gui, Font, Normal
Gui, Add, ListView, r44 x310 y35 h560 w340 vMyListView gMyListView hwndMyListView Checked hidden, Name|Type|Directory/Location|Size (KB)
LV_ModifyCol(3, "Integer")  ; For sorting, indicate that the Size column is an integer.

; Create an ImageList so that the ListView can display some icons:
ImageListID1 := IL_Create(10)
ImageListID2 := IL_Create(10, 10, true)  ; A list of large icons to go with the small ones.

; Attach the ImageLists to the ListView so that it can later display the icons:
LV_SetImageList(ImageListID1)
LV_SetImageList(ImageListID2)

; Create a popup menu to be used as the context menu:
Menu, MyContextMenu, Add, Open, ContextOpenFile
Menu, MyContextMenu, Add, Properties, ContextProperties
Menu, MyContextMenu, Add, Clear from ListView, ContextClearRows
Menu, MyContextMenu, Default, Open  ; Make "Open" a bold font to indicate that double-click does the same thing.	
Gui, Add, GroupBox, x16 y0 w280 h208 center, RJDB_Wizard

Gui Add, GroupBox, x16 y205 w283 h146,
Gui Add, GroupBox, x16 y345 w283 h103,
Gui Add, GroupBox, x16 y441 w283 h70,
Gui Add, GroupBox, x16 y505 w283 h104,
Gui, Add, Button, x241 y8 w45 h15 vREINDEX gREINDEX %repopbut%,re-index
Gui, Font, Bold
Gui, Add, Button, x241 y24 w45 h25 vPOPULATE gPOPULATE,GO>
Gui, Font, Normal
Gui, Add, Radio, x30 y32 vSCONLY gSCONLY, Lnk Only
Gui, Add, Radio, x95 y32 vEXEONLY gEXEONLY checked, Exe Only
Gui, Add, Radio, x175 y32 vBOTHSRCH gBOTHSRCH, Exe+Lnk
Gui, Font, Bold
Gui, Add, Button, x18 y578 h18 vRESET gRESET,R
Gui, Font, Normal
Gui, Add, Checkbox, x40 y14 h14 vKILLCHK gKILLCHK checked,Kill-List
Gui, Add, Checkbox, x108 y14 h14 vINCLALTS gINCLALTS checked,Include Alts

Gui, Font, Bold
Gui, Add, Button, x24 y56 w36 h21 vSOURCE_DirButton gSOURCE_DirButton,SRC
;;Gui, Add, Text,  x64 y192 w222 h14 vSOURCE_DirectoryT Disabled Right,"<%SOURCE_DirectoryT%"
Gui, Font, Normal
Gui, Add, DropDownList, x64 y56 w190 vSOURCE_DirectoryT gSOURCE_DirectoryDD,%SOURCE_Directory%
Gui, Add, Button, x271 y61 w15 h15 vREMSRC gREMSRC,X
Gui, Add, Text, x73 y80 h14 vCURDP Right,<Game Exe/Lnk Source Directories>

Gui, Font, Bold
Gui, Add, Button, x24 y104 w36 h21 vGAME_Directory gGAME_Directory,OUT
Gui, Add, Text, x64 y96 w222 h14 vGAME_DirectoryT Disabled Right,"<%GAME_DirectoryT%"
Gui, Font, Normal
Gui, Add, Text, x84 y110 h14,<Shortcut Output Directory>

GUi, Add, Checkbox, x36 y132 h14 vCREFLD gCREFLD %fldrget% %fldrenbl%, Folders
GUi, Add, Checkbox, x40 y152 h14 vGMCONF gGMCONF %cfgget% %cfgenbl%,Cfg
GUi, Add, Checkbox, x96 y152 h14 vGMJOY gGMJOY %Joyget% %joyenbl%,Joy
GUi, Add, Checkbox, x144 y152 vGMLNK gGMLNK %lnkget% %lnkenbl%,Lnk
Gui, Add, Radio, x95 y132 vOVERWRT gUPDTSC, Overwrite
Gui, Add, Radio, x168 y132 vUPDTSC gOVERWRT checked, Update

Gui, Font, Bold
Gui, Add, Button, x21 y176 w36 h21 vGAME_Profiles gGAME_Profiles,GPD
Gui, Add, Text, x64 y171 w222 h14 vGAME_ProfilesT Disabled Right,"<%GAME_ProfilesT%"
Gui, Font, Normal
Gui, Add, Text,  x64 y185 w222 h14,<Game Profiles Directory>
Gui, Font, Bold

Gui, Font, Bold
Gui, Add, Button, x20 y224 w36 h21 vKeyboard_Mapper gKeyboard_Mapper,KBM
Gui, Add, Text,  x64 y224 w222 h14 vKeyboard_MapperT Disabled Right,"<%Keyboard_MapperT%"
Gui, Font, Normal
Gui, Add, Text,  x64 y238 w222 h14,<Keyboard Mapper Program>

Gui, Font, Bold
Gui, Add, Button, x20 y256 w36 h21 vPlayer1_Template gPlayer1_Template,PL1
Gui, Add, Text,  x64 y256 w222 h14 vPlayer1_TemplateT Disabled Right,"<%Player1_TemplateT%"
Gui, Font, Normal
Gui, Add, Text,  x64 y270 w222 h14,.....Template Profile for Player 1>
Gui, Font, Bold

Gui, Add, Button, x20 y288 w36 h21 vPlayer2_Template gPlayer2_Template,PL2
Gui, Add, Text,  x64 y288 w222 h14 vPlayer2_TemplateT Disabled Right,"<%Player2_TemplateT%"
Gui, Font, Normal
Gui, Add, Text,  x64 y302 w222 h14,.....Template Profile for Player 2>

Gui, Font, Bold
Gui, Add, Button, x20 y320 w36 h21 vMediaCenter_Profile gMediaCenter_Profile,MCP
Gui, Add, Text,  x64 y320 w222 h14 vMediaCenter_ProfileT Disabled Right,"<%MediaCenter_ProfileT%"
Gui, Font, Normal
Gui, Add, Text,  x64 y334 w222 h14,.....Template Profile for MediaCenter/Desktop>

Gui, Font, Bold
Gui, Add, Button, x20 y352 w36 h21 vMultiMonitor_Tool gMultiMonitor_Tool,MMT
Gui, Add, Text,  x64 y354 w222 h14 vMultiMonitor_ToolT Disabled Right,"<%MultiMonitor_ToolT%"
Gui, Font, Normal
Gui, Add, Text,  x64 y368 w222 h14,<Multimonitor Program>

Gui, Font, Bold
Gui, Add, Button, x20 y384 w36 h21 vMM_Game_Config gMM_Game_Config,GMC
Gui, Add, Text,  x64 y384 w222 h14 vMM_Game_ConfigT Disabled Right,"<%MM_Game_ConfigT%"
Gui, Font, Normal
Gui, Add, Text,  x64 y398 w222 h14,.....Gaming Configuration File>

Gui, Font, Bold
Gui, Add, Button, x20 y416 w36 h21 vMM_MediaCenter_Config gMM_MediaCenter_Config,DMC
Gui, Add, Text,  x64 y416 w222 h14 vMM_MediaCenter_ConfigT Disabled Right,"<%MM_MediaCenter_ConfigT%"
Gui, Font, Normal
Gui, Add, Text,  x64 y430 w234 h14,.....MediaCenter/Desktop Configuration File>

Gui, Font, Bold
Gui, Add, Button, x20 y448 w36 h21 vBorderless_Gaming_Program gBorderless_Gaming_Program,BGP
Gui, Add, Text,  x64 y448 w222 h14 vBorderless_Gaming_ProgramT Disabled Right,"<%Borderless_Gaming_ProgramT%"
Gui, Font, Normal
Gui, Add, Text,  x64 y462 w222 h14,<Borderless Gaming Program>

Gui, Font, Bold
Gui, Add, Button, x20 y480 w36 h21 vBorderless_Gaming_Database gBorderless_Gaming_Database,BGD
Gui, Add, Text, x64 y480 w222 h14 vBorderless_Gaming_DatabaseT Disabled Right,"<%Borderless_Gaming_DatabaseT%"
Gui, Font, Normal
Gui, Add, Text, x64 y494 w222 h14,.....Borderless Gaming Database>

Gui, Font, Bold
Gui, Add, Button, x20 y512 w36 h21 vPREAPP gPREAPP ,PRE
Gui, Font, Normal
Gui, Add, DropDownList, x64 y512 w204 vPREDD gPREDD Right,%prelist%
Gui, Add, Text, x64 y534 h12 w230 vPREDDT,<Pre-Launch Programs>
Gui, Add, Checkbox, x270 y513 w12 h12 vPreWait gPreWait %prestatus%,
Gui, Add, Text, x270 y535 h12,wait
Gui, Add, Button, x285 y520 w14 h14 vDELPREAPP gDELPREAPP ,X

Gui, Font, Bold
Gui, Add, Button, x20 y550 w36 h21 vPOSTAPP gPOSTAPP,PST
Gui, Font, Normal
Gui, Add, DropDownList, x64 y552 w204 vPostDD gPostDD Right,%postlist%
Gui, Add, Text, x64 y574 h12 w230 vPOSTDDT,<Post-Launch Programs>
Gui, Add, Checkbox, x270 y553 w12 h12 vPostWait gPostWait %poststatus%
Gui, Add, Text, x270 y565 h12,
Gui, Add, Button, x285 y557 w14 h14 vDELPOSTAPP gDELPOSTAPP ,X


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
Gui, Add, Checkbox, x260 y588 h14 vEnableLogging gEnableLogging %loget%, Log

Gui, Add, StatusBar, x0 y546 w314 h28 vRJStatus, Status Bar
Gui Show, w314 h625, RJ_Setup
Return


esc::
GuiEscape:
GuiClose:
ExitApp

; End of the GUI section

RJDB_Config:
gui,submit,nohide
FileSelectFile,RJDB_ConfigT,3,%flflt%,Select File
if ((RJDB_ConfigT <> "")&& !instr(RJDB_ConfigT,"<"))
{
RJDB_Config= %RJDB_ConfigT%
iniwrite,%RJDB_Config%,%RJDB_Config%,GENERAL,RJDB_Config
stringreplace,RJDB_ConfigT,RJDB_ConfigT,%A_Space%,`%,All
guicontrol,,RJDB_ConfigT,%RJDB_Config%
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
guicontrol,,RJDB_LocationT,%RJDB_Location%
}
else {
stringreplace,RJDB_LocationT,RJDB_LocationT,%A_Space%,`%,All
guicontrol,,RJDB_LocationT,<RJDB_Location
}
return

GAME_Profiles:
gui,submit,nohide
FileSelectFolder,GAME_ProfilesT,%fldflt%,3,Select Folder
if ((GAME_ProfilesT <> "")&& !instr(GAME_ProfilesT,"<"))
{
GAME_Profiles= %GAME_ProfilesT%
iniwrite,%GAME_Profiles%,%RJDB_Config%,GENERAL,GAME_Profiles
stringreplace,GAME_ProfilesT,GAME_ProfilesT,%A_Space%,`%,All
guicontrol,,GAME_ProfilesT,%GAME_Profiles%
}
else {
stringreplace,GAME_ProfilesT,GAME_ProfilesT,%A_Space%,`%,All
guicontrol,,GAME_ProfilesT,<GAME_Profiles
}
return

GAME_Directory:
gui,submit,nohide
FileSelectFolder,GAME_DirectoryT,%fldflt%,3,Select Folder
if ((GAME_DirectoryT <> "")&& !instr(GAME_DirectoryT,"<"))
{
GAME_Directory= %GAME_DirectoryT%
iniwrite,%GAME_Directory%,%RJDB_Config%,GENERAL,GAME_Directory
stringreplace,GAME_DirectoryT,GAME_DirectoryT,%A_Space%,`%,All
guicontrol,,GAME_DirectoryT,%GAME_Directory%
}
else {
stringreplace,GAME_DirectoryT,GAME_DirectoryT,%A_Space%,`%,All
guicontrol,,GAME_DirectoryT,<GAME_Directory
}
return

Source_DirButton:
gui,submit,nohide
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
SOURCE_DIRECTORY= %scrdira%
iniwrite,%srcdira%,%RJDB_Config%,GENERAL,Source_Directory
stringreplace,CURDP,Source_DirectoryX,%A_Space%,`%,All
guicontrol,,Source_DirectoryT,|%srcdira%
guicontrol,,CURDP,%CURDP%
}
return

Keyboard_Mapper:
gui,submit,nohide
FileSelectFile,Keyboard_MapperT,3,Antimicro,Select File,*.exe
if ((Keyboard_MapperT <> "")&& !instr(Keyboard_MapperT,"<"))
{
Keyboard_Mappern= %Keyboard_MapperT%
}
else {
stringreplace,Keyboard_MapperT,Keyboard_MapperT,%A_Space%,`%,All
guicontrol,,Keyboard_MapperT,<Keyboard_Mapper
}
Mapper= 
if instr(Keyboard_Mappern,"Antimicro")
	{
		Mapper= 1
		iniwrite,1,%RJDB_Config%,GENERAL,Mapper
		iniwrite,antimicro,%RJDB_Config%,JOYSTICKS,Jmap
		iniwrite,gamecontroller.amgp,%RJDB_Config%,JOYSTICKS,Mapper_Extension
        fileread,amcjp,allgames.set,
        oskloc= %A_ScriptDir%\newosk.exe
        stringreplace,oskloc,oskloc,\,/,All
        stringreplace,amcjp,amcjp,[NEWOSK],%oskloc%,All
        fileread,amcb,Amicro.set
		FileDelete,Antimicro_!.cmd
        stringreplace,amcb,amcb,[AMICRO],%Keyboard_Mappern%,All
        FileAppend,%amcb%,%A_ScriptDir%\Antimicro_!.cmd
		antimicro_executable=%keyboard_mappern%
        Keyboard_Mapper=%A_ScriptDir%\Antimicro_!.cmd
        iniwrite,%Keyboard_Mapper%,%RJDB_Config%,GENERAL,Keyboard_Mapper
        iniwrite,%Keyboard_Mappern%,%RJDB_Config%,GENERAL,Antimicro_executable
    }
		else {
			iniwrite,%Keyboard_Mapper%,%RJDB_Config%,GENERAL,Keyboard_Mapper
		}	
stringreplace,Keyboard_MapperT,Keyboard_MapperT,%A_Space%,`%,All
guicontrol,,Keyboard_MapperT,%Keyboard_Mapper%
iniwrite,%A_ScriptDir%\Antimicro_!.cmd,%RJDB_Config%,GENERAL,Keyboard_Mapper
return

Player1_Template:
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

Player2_Template:
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

MediaCenter_Profile:
gui,submit,nohide
FileSelectFile,MediaCenter_ProfileT,3,,Select File
if ((MediaCenter_ProfileT <> "")&& !instr(MediaCenter_ProfileT,"<"))
{
MediaCenter_Profile= %MediaCenter_ProfileT%
iniwrite,%MediaCenter_Profile%,%RJDB_Config%,GENERAL,MediaCenter_Profile
iniwrite,%MediaCenter_Profile%,%RJDB_Config%,GENERAL,MediaCenter2_Profile
stringreplace,MediaCenter_ProfileT,MediaCenter_ProfileT,%A_Space%,`%,All
guicontrol,,MediaCenter_ProfileT,%MediaCenter_ProfileT%
}
else {
stringreplace,MediaCenter_ProfileT,MediaCenter_ProfileT,%A_Space%,`%,All
guicontrol,,MediaCenter_ProfileT,<MediaCenter_Profile
}
return

MultiMonitor_Tool:
gui,submit,nohide
FileSelectFile,MultiMonitor_ToolT,3,,Select File,multimonitor*.exe
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
        msgbox,4,Setup,Setup the Multimonitor Tool now?
        ifmsgbox,yes
            {
                gosub, MMSETUP
            }
    }
return

MM_GAME_Config:
gui,submit,nohide
FileSelectFile,MM_GAME_ConfigT,3,,Select File,*.cfg
if ((MM_GAME_ConfigT <> "")&& !instr(MM_GAME_ConfigT,"<"))
{
MM_GAME_Config= %MM_GAME_ConfigT%
iniwrite,%MM_GAME_Config%,%RJDB_Config%,GENERAL,MM_GAME_Config
iniwrite,2,%RJDB_Config%,GENERAL,MonitorMode
stringreplace,MM_GAME_ConfigT,MM_GAME_ConfigT,%A_Space%,`%,All
guicontrol,,MM_GAME_ConfigT,%MM_GAME_ConfigT%
}
else {
stringreplace,MM_GAME_Config,MM_GAME_Config,%A_Space%,`%,All
guicontrol,,MM_GAME_Config,<MM_GAME_Config
}
return

MM_MediaCenter_Config:
gui,submit,nohide
FileSelectFile,MM_MediaCenter_ConfigT,3,,Select File,*.cfg
if ((MM_MediaCenter_ConfigT <> "")&& !instr(MM_MediaCenter_ConfigT,"<"))
{
MM_MediaCenter_Config= %MM_MediaCenter_ConfigT%
iniwrite,%MM_MediaCenter_Config%,%RJDB_Config%,GENERAL,MM_MediaCenter_Config
iniwrite,2,%RJDB_Config%,GENERAL,MonitorMode
stringreplace,MM_MediaCenter_ConfigT,MM_MediaCenter_ConfigT,%A_Space%,`%,All
guicontrol,,MM_MediaCenter_ConfigT,%MM_MediaCenter_ConfigT%
}
else {
stringreplace,MM_MediaCenter_Config,MM_MediaCenter_Config,%A_Space%,`%,All
guicontrol,,MM_MediaCenter_Config,<MM_MediaCenter_Config
}
return

Borderless_Gaming_Program:
gui,submit,nohide
FileSelectFile,Borderless_Gaming_ProgramT,3,Borderless Gaming,Select File,*.exe
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

Borderless_Gaming_Database:
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
guicontrol,,Borderless_Gaming_Database,<Borderless_Gaming_Database
}
return

PREAPP:
PreList= 
gui,submit,nohide
guicontrolget,fbd,,PREDD
guicontrolget,PreWait,,PreWait
stringsplit,dkz,fbd,<
orderPRE= %dkz1%
prewl=
if (prewait = 1)
	{
		prewl= W
	}
iniread,inn,%RJDB_CONFIG%,CONFIG,%orderPRE%_Pre
if (inn = "ERROR") 
	{
		inn= 
	}
FileSelectFile,PREAPPT,3,%flflt%,Select File
if (PREAPPT <> "")
{
PREAPP= %PREAPPT%
iniwrite,%dkf1%%prewl%<%PREAPP%,%RJDB_Config%,CONFIG,%dkf1%_Pre
iniread,cftst,%RJDB_Config%,CONFIG
Loop,3
    {
		iniread,cftsv,%RJDB_Config%,CONFIG,%A_Index%_Pre
        stringsplit,cftst,cftsv,<
		if instr(cftst1,"W")
			{
				dkc= %A_Index%W<
			}
        if (A_Index = OrderPre)
			{
				Prelist.= cftst2 . "||"
			}
		Prelist:= cftst2 . "|"
		iniwrite,%dkc%%cftst2%,%RJDB_Config%,CONFIG,%A_Index%_Pre
     }
guicontrol,,PreDD,|%PreList%
}
return

POSTAPP:
PostList= 
gui,submit,nohide
guicontrolget,fbd,,POSTDD
guicontrolget,PostWait,,PostWait
stringsplit,dkz,fbd,<
orderPOST= %dkz1%
postwl=
if (postwait = 1)
	{
		postwl= W
	}
iniread,inn,%RJDB_CONFIG%,CONFIG,%orderPOST%_Post
if (inn = "ERROR") 
	{
		inn= 
	}
FileSelectFile,POSTAPPT,3,%flflt%,Select File
if (POSTAPPT <> "")
{
POSTAPP= %POSTAPPT%
iniwrite,%dkf1%%postwl%<%POSTAPP%,%RJDB_Config%,CONFIG,%dkf1%_Post
iniread,cftst,%RJDB_Config%,CONFIG
Loop,3
    {
		iniread,cftsv,%RJDB_Config%,CONFIG,%A_Index%_Post
        stringsplit,cftst,cftsv,<
		if instr(cftst1,"W")
			{
				dkc= %A_Index%W<
			}
        if (A_Index = OrderPost)
			{
				Postlist.= cftst2 . "||"
			}
		Postlist:= cftst2 . "|"
		iniwrite,%dkc%%cftst2%,%RJDB_Config%,CONFIG,%A_Index%_Post		
     } 
guicontrol,,PostDD,|%PostList%
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
			;stringreplace,Srclistd,Srclist,||,|,All
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

DELPREAPP:
gui,submit,nohide
guicontrolget,DELPreDD,,PreDD
stringsplit,dxb,DELPreDD,<
stringleft,dxn,dxb1,1
iniWrite,%dxn%<,%RJDB_Config%,CONFIG,%dxn%_Pre
PreList= 
Loop,3
	{
		if (A_Index = dxn)
			{
				PreList.= dxn . "<" . "||"
			}
		else {
			iniread,daa,%RJDB_Config%,CONFIG,%A_Index%_Pre
			stringsplit,dxx,daa,<
			stringleft,dxg,dxx1,1
			PreList.= dxx1 . "<" . %dxx% .  "|"
		}	
		
	}
guicontrol,,PreDD,|%PreList%    
return

DELPOSTAPP:
gui,submit,nohide
guicontrolget,DELPostDD,,PostDD
stringsplit,dxb,DELPostDD,<
stringleft,dxn,dxb1,1
iniWrite,%dxn%<,%RJDB_Config%,CONFIG,%dxn%_Post
PostList= 
Loop,3
	{
		if (A_Index = dxn)
			{
				PostList.= dxn . "<" . "||"
			}
		else {
			iniread,daa,%RJDB_Config%,CONFIG,%A_Index%_Post
			stringsplit,dxx,daa,<
			stringleft,dxg,dxx1,1
			PostList.= dxx1 . "<" . %dxx% .  "|"
		}	
		
	}
guicontrol,,PostDD,|%PostList%    
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

POSTWAIT:
postwt= 
gui,submit,nohide
guicontrolget,postwait,,postwait
if (postwait = 1)
	{
		postwt= W
	}
guicontrolget,postdd,,PoSTDD
stringsplit,lls,postdd,<
stringleft,aae,lls1,1
iniwrite,%aae%%postwt%<%lls2%,%RJDB_CONFIG%,CONFIG,%aae%_PoST
return


PREWAIT:
PREwt= 
gui,submit,nohide
guicontrolget,PREwait,,PREwait
if (PREwait = 1)
	{
		PRprewt= W
	}
guicontrolget,dd,,PREDD
stringsplit,lls,predd,<
stringleft,aae,lls1,1
iniwrite,%aae%%postwt%<%lls2%,%RJDB_CONFIG%,CONFIG,%aae%_PoST
return

avnix:
newavinx:= % gfmn%iinx%
ifnotinstring,gmnames,%newavinx%|
	{
		gmnames.= newavinx . "|"
	}
return

PREDD:
gui,submit,nohide
guicontrolget,predd,,PreDD
stringleft,nos,predd,1
guicontrol,,Prewait,0
if (nos = 1)
	{
		guicontrol,,PREDDT,%DDTA%<game.exe>
	}
if (nos = 2)
	{
		guicontrol,,PREDDT,%DDTB%<game.exe>
	}
if (nos = 3)
	{
		guicontrol,,PREDDT,%DDTC%<game.exe>
	}

if instr(postdd,"W<")
	{
		guicontrol,,Prewait,1
	}
return

POSTDD:
gui,submit,nohide
guicontrolget,postdd,,postDD
stringLeft,nos,postdd,1
guicontrol,,postwait,0
if (nos = 1)
	{
		guicontrol,,POSTDDT,<game.exe>%DDTC%
	}
if (nos = 2)
	{
		guicontrol,,POSTDDT,<game.exe>%DDTB%
	}
if (nos = 3)
	{
		guicontrol,,POSTDDT,<game.exe>%DDTA%
	}

if instr(postdd,"W<")
	{
		guicontrol,,Postwait,1
	}
return

INITALL:
FileRead,RJTMP,RJDB.set
Loop,parse,STDVARS,|
    {
        %A_LoopField%=
    }
stringreplace,RJTMP,RJTMP,[LOCV],%A_ScriptDir%,All
FileDelete,RJDB.ini
FileAppend,%RJTMP%,RJDB.ini
return

RESET:
Msgbox,260,Reset RJ_LinkRunner,Reset RJ_LinkRunner?,5
ifMsgbox,Yes
    {
        gosub,INITALL
        resetting= 1
        filedelete,Antimicro_!.cmd
        filedelete,MediaCenter.gamecontroller.amgp
        filedelete,MediaCenter2.gamecontroller.amgp
        filedelete,Player1.gamecontroller.amgp
        filedelete,Player2.gamecontroller.amgp
        gosub,RECREATEJOY
        goto,popgui
		LV_Delete()
		guicontrol,,SOURCE,%SOURCE_Directory%
		guicontrol,,PreDD,|1<||2<|3<
		guicontrol,,PostDD,|1<||2<|3<
    }
return    

EnableLogging:
gui,submit,nohide
guicontrolget,EnableLogging,,EnableLogging
iniwrite,%EnableLogging%,%RJDB_Config%,GENERAL,Logging
return



INITAMIC:
fileread,amictmp,amicro.set
FileDelete,Antimicro_!.cmd
stringreplace,amictmp,amictmp,[AMICRO],%A_ScriptDir%\Antimicro\Antimicro.exe,
fileappend,%amictmp%,Antimicro_!.cmd
Antimicro_Executable= %A_ScriptDir%\Antimicro\Antimicro.exe
return

popgui:
FileRead,rjdb,RJDB.ini
Prelist=
PostStatus=
postlist= 
PostStatus=
PREDDT=
POSTDDT=
Loop,parse,rjdb,`r`n
    {
        if (A_LoopField = "")
            {
                continue
            }
        stringleft,dn,A_LoopField,1
        if (dn = "[")
            {
                stringreplace,SECTION,A_LoopField,[
                stringreplace,SECTION,SECTION,]
                continue
            }
        stringsplit,prx,A_LoopField,=
        val= %prx1%
        stringreplace,prtv,A_LoopField,%val%=,
        if (prtv = "")
            {
                prtv= %val%
            }
        %val%:= prtv
        stringreplace,prtvd,prtv,%A_Space%,`%,All
        %val%T:= prtvd
        if (val = "")
            {
                val= %val%T
            }
		if instr(val,"_Pre")
			{
				stringleft,vpnm,val,1
				if (vpnm = 1)
					{
						PREDDT.= prtv . "||"
						Prelist.= prtv . "||"
						continue
					}
				PREDDT.= prtvd . "|"
				Prelist.= prtvd . "|"
			}
		if instr(val,"_Post")
			{
				stringleft,vpnm,val,1
				if (vpnm = 1)
					{
						POSTDDT.= prtv . "||"
						Postlist.= prtv . "||"
						continue
					}
				POSTDDT.= prtvd . "|"
				Postlist.= prtvd . "|"
			}
        if (resetting = 1)
            {
                guicontrol,,%val%T,%prtvd%
                guicontrol,,PREDDT,<Pre-Launch Programs>
                guicontrol,,POSTDDT,<$This_Prog$><Mapper><Monitor>
				guicontrol,hide,ButtonCreate
				guicontrol,disable,ButtonCreate
				guicontrol,disable,ButtonClear
				guicontrol,hide,ButtonClear
				guicontrol,hide,MyListView
				guicontrol,disable,MyListView
				GuiControl, Move, MyListView, w0
				Gui, Show, Autosize
            }
    }
Iniread,Source_Directory,%RJDB_Config%,GENERAL,Source_Directory
guicontrol,,Sourcd_DirectoryT,|%Source_Directory%
resetting= 
return

RECREATEJOY:
ifnotexist,Player1.gamecontroller.amgp
    {
        fileread,mctmp,allgames.set
        stringreplace,SCRIPTRV,A_ScriptDir,\,/,All
        stringreplace,mctmp,mctmp,[NEWOSK],%SCRIPTRV%,All
        FileAppend,%mctmp%,Player1.gamecontroller.amgp
    }
ifnotexist,Player2.gamecontroller.amgp
    {
        fileread,mctmp,allgames.set
        stringreplace,SCRIPTRV,A_ScriptDir,\,/,All
        stringreplace,mctmp,mctmp,[NEWOSK],%SCRIPTRV%,All
        FileAppend,%mctmp%,Player2.gamecontroller.amgp
    }    
ifnotexist,MediaCenter.gamecontroller.amgp
    {
        fileread,mctmp,Desktop.set
        stringreplace,SCRIPTRV,A_ScriptDir,\,/,All
        stringreplace,mctmp,mctmp,[NEWOSK],%SCRIPTRV%,All
        FileAppend,%mctmp%,MediaCenter.gamecontroller.amgp
    }  
ifnotexist,MediaCenter2.gamecontroller.amgp
    {
        fileread,mctmp,Desktop.set
        stringreplace,SCRIPTRV,A_ScriptDir,\,/,All
        stringreplace,mctmp,mctmp,[NEWOSK],%SCRIPTRV%,All
        FileAppend,%mctmp%,MediaCenter2.gamecontroller.amgp
    }
return

UPDTSC:
OVERWRT= 
return
OVERWRT:
OVERWRT= 1
return

MMSETUP:
Msgbox,,Default Desktop Config,Configure your monitor/s as you would have them for your`nMediaCenter or Desktop`nthen click "OK"
ifmsgbox,OK
    {
        FileMove,Mediacenter.cfg,MediaCenter.cfg.bak
        RunWait, %comspec% /c "" "%multimonitor_tool%" /SaveConfig "%A_ScriptDir%\Mediacenter.cfg",%A_ScriptDir%,hide
        ifexist,Mediacenter.cfg
            {
                Msgbox,,Success,The current monitor configuration will be used for your Mediacenter or desktop
                iniwrite,%A_ScriptDir%\Mediacenter.cfg,%RJDB_Config%,GENERAL,MM_MEDIACENTER_Config
                iniwrite,/LoadConfig "%A_ScriptDir%\Mediacenter.cfg",%RJDB_Config%,CONFIG,switchback
            }
           else {
            Msgbox,,Failure,The current monitor configuration could not be saved
           } 
    }
Msgbox,,Default Game Config,Configure your monitor/s as you would have them for your`nGames or Emulators`nthen click "OK"
ifmsgbox,OK
    {
        FileMove,Gaming.cfg,Gaming.cfg.bak
        RunWait, %comspec% /c "" "%multimonitor_tool%" /SaveConfig "%A_ScriptDir%\Gaming.cfg",%A_ScriptDir%,hide
        ifexist,Gaming.cfg
            {
                Msgbox,,Success,The current monitor configuration will be used for your Games or Emulators
                iniwrite,%A_ScriptDir%\Gaming.cfg,%RJDB_Config%,GENERAL,MM_Game_Config
                iniwrite,/LoadConfig "%A_ScriptDir%\Gaming.cfg",%RJDB_Config%,CONFIG,switchcmd
            }
    }
   else {
    Msgbox,,Failure,The current monitor configuration could not be saved
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

GMLNK:
gui,submit,nohide
iniwrite,%GMLNK%,%RJDB_CONFIG%,CONFIG,GMLNK
return

REINDEX:
SOURCEDLIST= 
fullist= 
filedelete,continue.db
guicontrol,hide,REINDEX
POPULATE:
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
				
				LV_Add(lvachk,rni1, rni2, rni3,  rni4)
				fullist.= rni3 . "\" . rni1 . "|"
			}
		goto,REPOP	
	}	
SOURCEDLIST= 
FileDelete,simpth.db
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
						FileExt= exe	
						FileName := A_LoopFileFullPath  ; Must save it to a writable variable for use below.
						filez:= A_LoopFileSizeKB	
						splitpath,FileName,FileNM,FilePath,,filtn
						splitpath,FilePath,filpn,filpdir,,filpjn
						stringreplace,simpath,FileName,%SCRLOOP%\,,
						Loop,parse,absol,`r`n
							{
								if (A_LoopField = "")
									{
										continue
									}
								if instr(FileNM,A_LoopField)
									{
										excl= 1
										break
									}
							}
						if (excl = 1)
							{
								continue
							}
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
								if (instr(FileName,A_LoopField)&& !instr(filpn,A_LoopField))
									{
										lvachk=
										simpnk.= FileName . "`n"
										fileappend,%simpath%,simpth.db
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
										fileappend,%FileName%`n,simpth.db
										goto,Chkcon
									}
							}
						if (lvachk <> "")
							{
								fullist.= A_LoopFileFullPath . "|"						
							}	
						Chkcon:
						LV_Add(lvachk,FileNM, FileExt, FilePath,  filez)
						SOURCEDLIST.= FileNM . "|" . FileExt . "|" . FilePath . "|" . filez . "`n"
					}
			}
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
								LV_Add(lvachk,fenf, fenxtn, fendir, 0)
								SOURCEDLIST.= fenf . "|" . fenxtn . "|" fendir . "|" . 0 . "`n"
								fullist.= fenx . "|"
								break
							}					
					}
			}
	}
fileappend,%SOURCEDLIST%,continue.db
REPOP:
Guicontrol,Show,MyListView	
Guicontrol,Show,ButtonCreate
Guicontrol,Show,ButtonClear

GuiControl, +Redraw, MyListView  ; Re-enable redrawing (it was disabled above).
LV_ModifyCol(1, 140) ; Make the Size column at little wider to reveal its header.
LV_ModifyCol(2, 40) ; Make the Size column at little wider to reveal its header.
LV_ModifyCol(3, 130) ; Make the Size column at little wider to reveal its header.
LV_ModifyCol(4, 60) ; Make the Size column at little wider to reveal its header.
listView_autoSize:
GUI, +LastFound ; activate GUI window
totalWidth := 0 ; initialize ListView width variable
	; get columns' widths       
Loop % LV_GetCount("Column")
	{
		SendMessage, 4125, A_Index - 1, 0, SysListView321 ; 4125 is LVM_GETCOLUMNWIDTH.
		totalWidth := totalWidth + ErrorLevel
	}
; resize ListView control and GUI
GuiControl, Move, MyListView, w340
GUI, Show, AutoSize
Loop,parse,GUIVARS,|
	{
		guicontrol,enable,%A_LoopField%
	}
Gui, +Resize	
SB_SetText("Completed Aquisition")	
Return	

GuiSize:  ; Expand or shrink the ListView in response to the user's resizing of the window.
if (A_EventInfo = 1)  ; The window has been minimized. No action needed.
    return
; Otherwise, the window has been resized or maximized. Resize the ListView to match.
GuiControl, Move, MyListView, % "W" . (A_GuiWidth - 20) . " H" . (A_GuiHeight - 40)
return

ButtonCreate:
SB_SetText("Creating Custom ShortCuts")
Loop,parse,GUIVARS,|
	{
		guicontrol,disable,%A_LoopField%
	}

guicontrolget,CREFLD,,CREFLD
guicontrolget,GMJOY,,GMJOY
guicontrolget,GMCONF,,GMCONF
guicontrolget,OVERWRT,,OVERWRT
guicontrolget,GMLNK,,GMLNK
guicontrolget,INCLALTS,,INCLALTS
guicontrolget,KILLCHK,,KILLCHK
complist:= LVGetCheckedItems("SysListView321", "RJ_Setup")
if (fullist = complist)
	{
		SB_SetText("default items selected")
	}
else {
SB_SetText("changes made")
fullist= %complist%
}	
stringsplit,fullstn,fullist,|
gmnames= |
gmnameds= |
gmnamed=
fullstx= %fullstn%
Loop,%fullstn0%
	{
		prn= % fullstn%A_Index%
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
								;;msgbox,,,found_root`n%prn%`n%outdir%`n%gmnamex%
								outdir= %A_temp%\thin
								filecreatedir,%outdir%		
								break
							}	
					}
				invar= %gmnamex%
				gosub, CleanVar
				gmnamet= |%invarx%|
				gmnamedx= |%gmnamet%|	
				if instr(exclfls,gmnamedx)
					{
						gmnamex= %gmnamex%!
					}
				gmname= %gmnamex%
				cursrc=
				tlevel= %outdir%
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
						cursrp=|	
						stringreplace,undirs,undir,|%cursrc%|,,
					}
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
				chkpl= %cursrc%\%topdir%
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
				
				
				exlthis= |%gmnamex%|
				if instr(exclfls,gmnamedx)
					{
						gmnamex= %gmnamed%
					}
				if (topdirec = gmnamed)
					{
						mattop= %gmnamedv%
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
						tmppath= %curpth%
						splitpath,tmppath,gmnamek,curpthk
						curpthn= |%curpth%|
						curpthd= %curpth%\
						if (instr(undirs,curpthn)&& !instr(undirs,curpthd))
							{
								goto, topout
							}
						stringtrimright,gfnamek,gfnamex,%gmat%
						if (gfnamek = "")
							{
								goto, topout
							}
						gfnamex= %gfnamek%	
						curpth= %curpthk%	
						topreduc= 1
						tlevel= %curpth%
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
				priority:= 0
				fileappend,%topdirec%##%gfnamex%###,log.txt
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
				Loop,parse,unlike,|
					{
						if (A_LoopField = "")
							{
								continue
							}
						if instr(gmnamex,A_LoopField)
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
				tot:=
				tot+=-20
				poscnt:= 0
				if instr(exlist,posb)
					{
						rn= 1
						fp= 	
						nm= 
						Loop,%expa0%
							{	
								fp= 
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
						if (priority > tot)
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
								gmnamex= %gmname%_[0%poscnt%]
								/*
								Loop,files,%GAME_PROFILES%\%GMNAMED%\*_More,D
									{
										kprt= _More
										if instr(A_LoopFileName,kprt)
											{
												stringsplit,Subnumd,A_LoopFileName,_
												subnumbr:= Subnumd1	
												newNumbr:= poscntx
												if (subnumbr > poscntx)
													{
														newNumbr:= submumbr + 1													
													}
												splitpath,A_LoopFileFullPath,substfld
												substfldrc= %gmnamex%
												subfldrep= %subnumbr%_More\
												substfldrc= %subfldrep%%gmname%_[0%newNumbr%]
												break	
											}
									}
								if ((renum = 1)&&(inclalts = 1))
									{
										gincrem= %substfld%\%gmname%_[0%subnumbr%]
										filecopy, %GAME_PROFILES%\%GMNAMED%\%gincrem%game.ini,%GAME_PROFILES%\%GMNAMED%\%substfldrc%.ini,%OVERWRT%
										filecopy, %GAME_PROFILES%\%GMNAMED%\game.ini,%GAME_PROFILES%\%GMNAMED%\%subfldrc%.ini,%OVERWRT%
										filecopy, %GAME_PROFILES%\%GMNAMED%\%gmnamed%.lnk,%GAME_PROFILES%\%GMNAMED%\%substfldrc%.lnk,%OVERWRT%
									}
									else {
											if (renum = "")or(subnumbr = 1)
												{
												newNumbr:= poscntx
											}
									}
								AddMore= %GAME_PROFILES%\%GMNAMED%\%newNumbr%_More
								FileMoveDir,%GAME_PROFILES%\%GMNAMED%\%subfldrep%,%AddMore%,R
								msgbox,,,%errorlevel%`n%subfldrep%`n%addmore%
								FileSetAttrib, +H,%AddMore%
								*/
							}
						else {
							subfldrep= 
							;gmnamex= %gmname%_[0%poscntx%]
							gmnamex= %gmnamed%
						}	
					}
				stringtrimright,subfldrepn,subfldrep,1
				fileappend,%subfldrep%%gmnamed%|%gmnamex%(%renum%):!%priority%!`n,log.txt
				GMon= %subfldrep%%gmnamex%_Game.cfg
				DMon= %subfldrep%%gmnamex%_Desktop.cfg
				gamecfgn= %subfldrep%%gmnamex%.ini	
				if ((renum = 1)or(rn = ""))
					{
						FileCreateDir,%GAME_PROFILES%\%GMNAMED%\alternates
						subfldrep= 	
						GMon= Game.cfg
						DMon= Desktop.cfg
						gamecfgn= Game.ini
						gmnamex= %gmnamed%
						FileMove,%GAME_PROFILES%\%GMNAMED%\%gmnamed%.lnk,%GAME_PROFILES%\%GMNAMED%\alternates\%gmnamed%_[0%poscntx%].lnk,1
						FileMove,%GAME_PROFILES%\%GMNAMED%\Game.ini,%GAME_PROFILES%\%GMNAMED%\alternates\%gmnamed%_[0%poscntx%].ini,1
						FileMove,%GAME_PROFILES%\%GMNAMED%\*.amgp,%GAME_PROFILES%\%GMNAMED%\alternates,1
						FileMove,%GAME_PROFILES%\%GMNAMED%\*.cfg,%GAME_PROFILES%\%GMNAMED%\alternates,1
					}
				sidn= %Game_Profiles%\%gmnameD%\%subfldrep%
				gamecfg= %Game_Profiles%\%GMNAMED%\%subfldrep%%gamecfgn%
				if (CREFLD = 1)
					{
						FileCreateDir, %Game_Profiles%\%gmnamed%
						if (subfldrep <> "")
							{
								FileCreateDir, %Game_Profiles%\%gmnamed%\%subfldrepn%
								FileSetAttrib, +H, %GAME_Profiles%\%GMNAMED%\%Subfldrepn%
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
						prvv= %GAME_PROFILES%\%GMNAMED%\%subfldrep%%gmnamex%.lnk
						linktarget= %GAME_Directory%\%gmnamex%.lnk
						linkproxy= %GAME_PROFILES%\%GMNAMED%\%subfldrep%%gmnamex%.lnk
						if ((OVERWRT = 1)&&(prnxtn = "lnk"))
							{
								if (!fileexist(linkproxy) or (renum = 1))
									{
										FileCreateShortcut,%prn%,%linkproxy%,%outdir%,%OutArgs%,%refname%, %OutTarget%,, %IconNumber%, %OutRunState%
										Filecopy,%prvv%,%GAME_PROFILES%\%GMNAMED%\%subfldrep%%gmnamed%._lnk_,%OVERWRT%
									}
								if (!fileexist(linktarget)or(renum = 1))
									{
										FileDelete,%linktarget%
										FileCreateShortcut, %RJDB_LOCATION%\RJ_LinkRunner.exe, %linktarget%, %OutDir%, `"%linkproxy%`"%OutArgs%, %refname%, %OutTarget%,, %IconNumber%, %OutRunState%
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
										FileCreateShortcut, %RJDB_LOCATION%\RJ_LinkRunner.exe, %linktarget%, %OutDir%, `"%linkproxy%`"%OutArgs%, %refname%, %OutTarget%,, %IconNumber%, %OutRunState%
									}
								if (!fileexist(linktarget)&&(renum = "")&&(SETALTSALL = 1))	
										{
											FileCreateShortcut, %RJDB_LOCATION%\RJ_LinkRunner.exe, %linktarget%, %OutDir%, `"%linkproxy%`"%OutArgs%, %refname%, %OutTarget%,, %IconNumber%, %OutRunState%
										}
							}
                        if (GMCONF = 1)
                            {
								Player1x= %GAME_PROFILES%\%GMNAMED%\%subfldrep%%GMNAMEX%.%Mapper_Extension%
                                Player2x= %GAME_PROFILES%\%GMNAMED%\%subfldrep%%GMNAMEX%_2.%Mapper_Extension%
                                if ((OVERWRT = 1)or !fileexist(gamecfg))
                                    {
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
                                                        continue
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
								DeskMon= %GAME_PROFILES%\%GMNAMED%\%subfldrep%%DMon%
                                if ((OVERWRT = 1)or !fileexist(DeskMon)&& fileexist(MM_MediaCenter_Config))
                                    {
										filecopy, %MM_MediaCenter_Config%,%DeskMon%,%OVERWRT%
										iniwrite,%DeskMon%,%gamecfg%,GENERAL,MM_MediaCenter_Config
									}
                                GameMon= %GAME_PROFILES%\%GMNAMED%\%subfldrep%%GMon%
                                if ((OVERWRT = 1)or !fileexist(GameMon)&& fileexist(MM_Game_Config))
                                    {
										filecopy, %MM_GAME_Config%,%GameMon%,%OVERWRT%
										iniwrite,%GameMon%,%gamecfg%,GENERAL,MM_Game_Config
									}
								killist:
								if (KILLCHK = 1)
									{
										klist= 
										Loop,files,%OutDir%\*.exe,R
											{
												splitpath,A_LoopFileFullPath,tmpfn,tmpfd,,tmpfo
												if (instr(absol,tmpfo)or (A_LoopFileName = prnmx))
													{
														continue
													}
												klist.= A_LoopFileName . "|"
											}
										if (klist <> "")
											{
											    klist.= prnmx
												iniread,nklist,%gamecfg%,CONFIG,exe_list
												if ((nklist = "")or(nklist = "ERROR")or(OVRWR = 1))
													{
														iniwrite,%klist%,%gamecfg%,CONFIG,exe_list
													}
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
			}
	}
SB_SetText("Shortcuts Created")	
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

ButtonClear:
LV_Delete()  ; Clear the ListView, but keep icon cache intact for simplicity.
SOURCEDLIST= 
fileDelete,continue.db
return

MyListView:
if (A_GuiEvent = "DoubleClick")  ; There are many other possible values the script can check.
{
   /*
   LV_GetText(FileName, A_EventInfo, 1) ; Get the text of the first field.
    LV_GetText(FileDir, A_EventInfo, 2)  ; Get the text of the second field.
    Run %FileDir%\%FileName%,, UseErrorLevel
    if ErrorLevel
        MsgBox Could not open "%FileDir%\%FileName%".
		*/
}
return

GuiContextMenu:  ; Launched in response to a right-click or press of the Apps key.
if (A_GuiControl != "MyListView")  ; Display the menu only for clicks inside the ListView.
    return
; Show the menu at the provided coordinates, A_GuiX and A_GuiY. These should be used
; because they provide correct coordinates even if the user pressed the Apps key:
Menu, MyContextMenu, Show, %A_GuiX%, %A_GuiY%
return

ContextOpenFile:  ; The user selected "Open" in the context menu.
ContextProperties:  ; The user selected "Properties" in the context menu.
; For simplicitly, operate upon only the focused row rather than all selected rows:
FocusedRowNumber := LV_GetNext(0, "F")  ; Find the focused row.
if not FocusedRowNumber  ; No row is focused.
    return
LV_GetText(FileName, FocusedRowNumber, 1) ; Get the text of the first field.
LV_GetText(FileDir, FocusedRowNumber, 2)  ; Get the text of the second field.
if InStr(A_ThisMenuItem, "Open")  ; User selected "Open" from the context menu.
	{	
		;;Run %FileDir%\%FileName%,, UseErrorLevel
	}
	
	else {
		;; Run Properties "%FileDir%\%FileName%",, UseErrorLevel
	}  ; User selected "Properties" from the context menu.
if ErrorLevel
    {
		;; MsgBox Could not perform requested action on "%FileDir%\%FileName%".
	}
return

ContextClearRows:  ; The user selected "Clear" in the context menu.
RowNumber := 0  ; This causes the first iteration to start the search at the top.
Loop
{
    ; Since deleting a row reduces the RowNumber of all other rows beneath it,
    ; subtract 1 so that the search includes the same row number that was previously
    ; found (in case adjacent rows are selected):
    RowNumber := LV_GetNext(RowNumber - 1)
    if not RowNumber  ; The above returned zero, so there are no more selected rows.
        break
    LV_Delete(RowNumber)  ; Clear the row from the ListView.
}
return

LVGetCheckedItems(cN,wN) {
    ControlGet, LVItems, List,, % cN, % wN
    Pos:=!Pos,Item:=Object()
    While Pos
        Pos:=RegExMatch(LVItems,"`am)(^.*?$)",_,Pos+StrLen(_)),mCnt:=A_Index-1,Item[mCnt]:=_1
    Loop % mCnt {
        SendMessage, 0x102c, A_Index-1, 0x2000, % cN, % wN
        ChekItems:=(ErrorLevel ? Item[A_Index-1] "`n" : "")
		stringsplit,dbb,ChekItems,%A_Tab%
		ChkItems.= dbb3 . "\" . dbb1 . "|"
    }
    Return ChkItems
}