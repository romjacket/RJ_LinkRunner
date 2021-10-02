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
filextns= exe|lnk
GUIVARS= PostWait|PewWait|SCONLY|EXEONLY|BOTHSRCH|ButtonClear|ButtonCreate|MyListView|CREFLD|GMCONF|GMJOY|GMLNK|UPDTSC|OVERWR|POPULATE|RESET|EnableLogging|RJDB_Config|RJDB_Location|GAME_Profiles|GAME_Directory|SOURCE_DirButton|SOURCE_DirectoryT|REMSRC|Keyboard_Mapper|Player1_Template|Player2_Template|MediaCenter_Profile|MultiMonitor_Tool|MM_Game_Config|MM_MediaCenter_Config|Borderless_Gaming_Program|Borderless_Gaming_Database|PREAPP|PREDD|DELPREAPP|POSTAPP|PostDD|DELPOSTAPP
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
Gui, Add, ListView, r44 x310 y35 h560 w340 vMyListView gMyListView Checked hidden, Name|Type|Directory/Location|Size (KB)
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
Gui Add, GroupBox, x16 y505 w283 h94,
Gui, Font, Bold
Gui, Add, Button, x241 y24 w45 h25 vPOPULATE gPOPULATE,GO>
Gui, Font, Normal
Gui, Add, Radio, x30 y32 vSCONLY gSCONLY, Lnk Only
Gui, Add, Radio, x95 y32 vEXEONLY gEXEONLY, Exe Only
Gui, Add, Radio, x175 y32 vBOTHSRCH gBOTHSRCH checked, Exe+Lnk
Gui, Font, Bold
Gui, Add, Button, x12 y578 h18 vRESET gRESET,R
Gui, Font, Normal
Gui, Add, Checkbox, x24 y8 h14 vEnableLogging gEnableLogging %loget%, Log

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
GUi, Add, Checkbox, x80 y152 vGMCONF gGMCONF %cfgget% %cfgenbl%,Cfg
GUi, Add, Checkbox, x136 y152 vGMJOY gGMJOY %Joyget% %joyenbl%,Joy
GUi, Add, Checkbox, x184 y152 vGMLNK gGMLNK %lnkget% %lnkenbl%,Lnk
Gui, Add, Radio, x95 y132 vUPDTSC gUPDTSC, Overwrite
Gui, Add, Radio, x168 y132 vOVERWR gOVERWR checked, Update

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
Gui, Add, Checkbox, x270 y519 w12 h12 vPreWait gPreWait %prestatus%,
Gui, Add, Text, x270 y535 h12,wait
Gui, Add, Button, x285 y520 w14 h14 vDELPREAPP gDELPREAPP ,X

Gui, Font, Bold
Gui, Add, Button, x20 y550 w36 h21 vPOSTAPP gPOSTAPP,PST
Gui, Font, Normal
Gui, Add, DropDownList, x64 y552 w204 vPostDD gPostDD Right,%postlist%
Gui, Add, Text, x64 y574 h12 w230 vPOSTDDT,<Post-Launch Programs>
Gui, Add, Checkbox, x270 y549 w12 h12 vPostWait gPostWait %poststatus%,X
Gui, Add, Text, x270 y565 h12,
Gui, Add, Button, x285 y552 w14 h14 vDELPOSTAPP gDELPOSTAPP ,X


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


Gui, Add, StatusBar, x0 y546 w314 h28 vRJStatus, Status Bar
Gui Show, w314 h625, RJ_LinkRunner
Return


esc::
GuiEscape:
GuiClose:
ExitApp

; End of the GUI section

RJDB_Config:gui,submit,nohideFileSelectFile,RJDB_ConfigT,3,%flflt%,Select Fileif ((RJDB_ConfigT <> "")&& !instr(RJDB_ConfigT,"<")){RJDB_Config= %RJDB_ConfigT%iniwrite,%RJDB_Config%,%RJDB_Config%,GENERAL,RJDB_Configstringreplace,RJDB_ConfigT,RJDB_ConfigT,%A_Space%,`%,Allguicontrol,,RJDB_ConfigT,%RJDB_Config%}else {stringreplace,RJDB_ConfigT,RJDB_ConfigT,%A_Space%,`%,Allguicontrol,,RJDB_ConfigT,<RJDB_Config
}return

RJDB_Location:gui,submit,nohideFileSelectFolder,RJDB_LocationT,%fldflt%,3,Select Folderif ((RJDB_LocationT <> "")&& !instr(RJDB_LocationT,"<")){RJDB_Location= %RJDB_LocationT%iniwrite,%RJDB_Location%,%RJDB_Config%,GENERAL,RJDB_Locationstringreplace,RJDB_LocationT,RJDB_LocationT,%A_Space%,`%,Allguicontrol,,RJDB_LocationT,%RJDB_Location%}else {stringreplace,RJDB_LocationT,RJDB_LocationT,%A_Space%,`%,Allguicontrol,,RJDB_LocationT,<RJDB_Location
}return

GAME_Profiles:gui,submit,nohideFileSelectFolder,GAME_ProfilesT,%fldflt%,3,Select Folderif ((GAME_ProfilesT <> "")&& !instr(GAME_ProfilesT,"<")){GAME_Profiles= %GAME_ProfilesT%iniwrite,%GAME_Profiles%,%RJDB_Config%,GENERAL,GAME_Profilesstringreplace,GAME_ProfilesT,GAME_ProfilesT,%A_Space%,`%,Allguicontrol,,GAME_ProfilesT,%GAME_Profiles%}else {stringreplace,GAME_ProfilesT,GAME_ProfilesT,%A_Space%,`%,Allguicontrol,,GAME_ProfilesT,<GAME_Profiles
}return

GAME_Directory:gui,submit,nohideFileSelectFolder,GAME_DirectoryT,%fldflt%,3,Select Folderif ((GAME_DirectoryT <> "")&& !instr(GAME_DirectoryT,"<")){GAME_Directory= %GAME_DirectoryT%iniwrite,%GAME_Directory%,%RJDB_Config%,GENERAL,GAME_Directorystringreplace,GAME_DirectoryT,GAME_DirectoryT,%A_Space%,`%,Allguicontrol,,GAME_DirectoryT,%GAME_Directory%}else {stringreplace,GAME_DirectoryT,GAME_DirectoryT,%A_Space%,`%,Allguicontrol,,GAME_DirectoryT,<GAME_Directory
}return

Source_DirButton:gui,submit,nohideFileSelectFolder,Source_DirectoryT,%fldflt%,3,Select Folderif ((Source_DirectoryT <> "")&& !instr(Source_DirectoryT,"<"))	{		Source_DirectoryX= %Source_DirectoryT%
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
				srcdira.= pkrs . "|"
			}SOURCE_DIRECTORY= %scrdira%
iniwrite,%srcdira%,%RJDB_Config%,GENERAL,Source_Directorystringreplace,CURDP,Source_DirectoryX,%A_Space%,`%,Allguicontrol,,Source_DirectoryT,|%srcdira%
guicontrol,,CURDP,%CURDP%}return

Keyboard_Mapper:gui,submit,nohideFileSelectFile,Keyboard_MapperT,3,Antimicro,Select File,*.exeif ((Keyboard_MapperT <> "")&& !instr(Keyboard_MapperT,"<")){Keyboard_Mappern= %Keyboard_MapperT%}else {
stringreplace,Keyboard_MapperT,Keyboard_MapperT,%A_Space%,`%,Allguicontrol,,Keyboard_MapperT,<Keyboard_Mapper}
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
stringreplace,Keyboard_MapperT,Keyboard_MapperT,%A_Space%,`%,Allguicontrol,,Keyboard_MapperT,%Keyboard_Mapper%
iniwrite,%A_ScriptDir%\Antimicro_!.cmd,%RJDB_Config%,GENERAL,Keyboard_Mapperreturn

Player1_Template:gui,submit,nohideFileSelectFile,Player1_TemplateT,3,,Select Fileif ((Player1_TemplateT <> "")&& !instr(Player1_TemplateT,"<")){Player1_Template= %Player1_TemplateT%iniwrite,%Player1_Template%,%RJDB_Config%,GENERAL,Player1_Templatestringreplace,Player1_TemplateT,Player1_TemplateT,%A_Space%,`%,Allguicontrol,,Player1_TemplateT,%Player1_TemplateT%}else {
stringreplace,Player1_TemplateT,Player1_TemplateT,%A_Space%,`%,Allguicontrol,,Player1_TemplateT,<Player1_Template}return

Player2_Template:gui,submit,nohideFileSelectFile,Player2_TemplateT,3,,Select Fileif ((Player2_TemplateT <> "")&& !instr(Player2_TemplateT,"<")){Player2_Template= %Player2_TemplateT%iniwrite,%Player2_Template%,%RJDB_Config%,GENERAL,Player2_Templatestringreplace,Player2_TemplateT,Player2_TemplateT,%A_Space%,`%,Allguicontrol,,Player2_TemplateT,%Player2_TemplateT%}else {
stringreplace,Player2_TemplateT,Player2_TemplateT,%A_Space%,`%,Allguicontrol,,Player2_TemplateT,<Player2_Template}return

MediaCenter_Profile:gui,submit,nohideFileSelectFile,MediaCenter_ProfileT,3,,Select Fileif ((MediaCenter_ProfileT <> "")&& !instr(MediaCenter_ProfileT,"<")){MediaCenter_Profile= %MediaCenter_ProfileT%iniwrite,%MediaCenter_Profile%,%RJDB_Config%,GENERAL,MediaCenter_Profile
iniwrite,%MediaCenter_Profile%,%RJDB_Config%,GENERAL,MediaCenter2_Profilestringreplace,MediaCenter_ProfileT,MediaCenter_ProfileT,%A_Space%,`%,Allguicontrol,,MediaCenter_ProfileT,%MediaCenter_ProfileT%}else {
stringreplace,MediaCenter_ProfileT,MediaCenter_ProfileT,%A_Space%,`%,Allguicontrol,,MediaCenter_ProfileT,<MediaCenter_Profile}return

MultiMonitor_Tool:gui,submit,nohideFileSelectFile,MultiMonitor_ToolT,3,,Select File,multimonitor*.exeif ((MultiMonitor_ToolT <> "")&& !instr(MultiMonitor_ToolT,"<")){MultiMonitor_Tool= %MultiMonitor_ToolT%iniwrite,%MultiMonitor_Tool%,%RJDB_Config%,GENERAL,MultiMonitor_Toolstringreplace,MultiMonitor_ToolT,MultiMonitor_ToolT,%A_Space%,`%,Allguicontrol,,MultiMonitor_ToolT,%MultiMonitor_ToolT%}else {
stringreplace,MultiMonitor_ToolT,MultiMonitor_ToolT,%A_Space%,`%,Allguicontrol,,MultiMonitor_ToolT,<MultiMonitor_Tool}
if ((MM_Game_Config = "")or(MM_Mediacenter_Config = ""))
    {
        msgbox,4,Setup,Setup the Multimonitor Tool now?
        ifmsgbox,yes
            {
                gosub, MMSETUP
            }
    }return

MM_GAME_Config:gui,submit,nohideFileSelectFile,MM_GAME_ConfigT,3,,Select File,*.cfgif ((MM_GAME_ConfigT <> "")&& !instr(MM_GAME_ConfigT,"<")){MM_GAME_Config= %MM_GAME_ConfigT%iniwrite,%MM_GAME_Config%,%RJDB_Config%,GENERAL,MM_GAME_Configiniwrite,2,%RJDB_Config%,GENERAL,MonitorMode
stringreplace,MM_GAME_ConfigT,MM_GAME_ConfigT,%A_Space%,`%,Allguicontrol,,MM_GAME_ConfigT,%MM_GAME_ConfigT%}else {
stringreplace,MM_GAME_Config,MM_GAME_Config,%A_Space%,`%,Allguicontrol,,MM_GAME_Config,<MM_GAME_Config}return

MM_MediaCenter_Config:gui,submit,nohideFileSelectFile,MM_MediaCenter_ConfigT,3,,Select File,*.cfgif ((MM_MediaCenter_ConfigT <> "")&& !instr(MM_MediaCenter_ConfigT,"<")){MM_MediaCenter_Config= %MM_MediaCenter_ConfigT%iniwrite,%MM_MediaCenter_Config%,%RJDB_Config%,GENERAL,MM_MediaCenter_Config
iniwrite,2,%RJDB_Config%,GENERAL,MonitorModestringreplace,MM_MediaCenter_ConfigT,MM_MediaCenter_ConfigT,%A_Space%,`%,Allguicontrol,,MM_MediaCenter_ConfigT,%MM_MediaCenter_ConfigT%}else {
stringreplace,MM_MediaCenter_Config,MM_MediaCenter_Config,%A_Space%,`%,Allguicontrol,,MM_MediaCenter_Config,<MM_MediaCenter_Config}return

Borderless_Gaming_Program:gui,submit,nohideFileSelectFile,Borderless_Gaming_ProgramT,3,Borderless Gaming,Select File,*.exeif ((Borderless_Gaming_ProgramT <> "")&& !instr(Borderless_Gaming_ProgramT,"<")){Borderless_Gaming_Program= %Borderless_Gaming_ProgramT%iniwrite,%Borderless_Gaming_Program%,%RJDB_Config%,GENERAL,Borderless_Gaming_Programstringreplace,Borderless_Gaming_ProgramT,Borderless_Gaming_ProgramT,%A_Space%,`%,Allguicontrol,,Borderless_Gaming_ProgramT,%Borderless_Gaming_ProgramT%}else {
stringreplace,Borderless_Gaming_ProgramT,Borderless_Gaming_ProgramT,%A_Space%,`%,Allguicontrol,,Borderless_Gaming_ProgramT,<Borderless_Gaming_Program}return

Borderless_Gaming_Database:gui,submit,nohideFileSelectFile,Borderless_Gaming_DatabaseT,3,%A_Appdata%\Andrew Sampson\Borderless Gaming,Select File,config.binif ((Borderless_Gaming_DatabaseT <> "")&& !instr(Borderless_Gaming_DatabaseT,"<")){Borderless_Gaming_Database= %Borderless_Gaming_DatabaseT%iniwrite,%Borderless_Gaming_Database%,%RJDB_Config%,GENERAL,Borderless_Gaming_Databasestringreplace,Borderless_Gaming_DatabaseT,Borderless_Gaming_DatabaseT,%A_Space%,`%,Allguicontrol,,Borderless_Gaming_DatabaseT,%Borderless_Gaming_DatabaseT%}else {
stringreplace,Borderless_Gaming_Database,Borderless_Gaming_Database,%A_Space%,`%,Allguicontrol,,Borderless_Gaming_Database,<Borderless_Gaming_Database}return

PREAPP:PreList= 
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
	}FileSelectFile,PREAPPT,3,%flflt%,Select Fileif (PREAPPT <> ""){PREAPP= %PREAPPT%
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
}return

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

SOURCE_DirectoryDD:
gui,submit,nohide
guicontrolget,CURDP,,SOURCE_DIRECTORYT
guicontrol,,CURDP,%CURDP%
return

DELPREAPP:gui,submit,nohide
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

DELPOSTAPP:gui,submit,nohide
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
filextns= exe|lnk
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
        stringreplace,mctmp,mctmp,[NEWOSK],%SCRIPTRV%,,All
        FileAppend,%mctmp%,Player1.gamecontroller.amgp
    }
ifnotexist,Player2.gamecontroller.amgp
    {
        fileread,mctmp,allgames.set
        stringreplace,SCRIPTRV,A_ScriptDir,\,/,All
        stringreplace,mctmp,mctmp,[NEWOSK],%SCRIPTRV%,,All
        FileAppend,%mctmp%,Player2.gamecontroller.amgp
    }    
ifnotexist,MediaCenter.gamecontroller.amgp
    {
        fileread,mctmp,Desktop.set
        stringreplace,SCRIPTRV,A_ScriptDir,\,/,All
        stringreplace,mctmp,mctmp,[NEWOSK],%SCRIPTRV%,,All
        FileAppend,%mctmp%,MediaCenter.gamecontroller.amgp
    }  
ifnotexist,MediaCenter2.gamecontroller.amgp
    {
        fileread,mctmp,Desktop.set
        stringreplace,SCRIPTRV,A_ScriptDir,\,/,All
        stringreplace,mctmp,mctmp,[NEWOSK],%SCRIPTRV%,,All
        FileAppend,%mctmp%,MediaCenter2.gamecontroller.amgp
    }
return

UPDTSC:
OVERWR= 
return
OVERWR:
OVERWR= 1
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
fileread,ad,exez.txt

fullist=
lvachk= +Check
Loop,parse,SOURCE_DIRECTORY,|
	{
		SRCLOOP= %A_LoopField%
		if (!fileexist(SRCLOOP)or(A_LoopField= ""))
			{
				continue
			}
			
		Loop,parse,filextns,|
			{
				fsext= %A_LoopField%
				sfi_size := A_PtrSize + 8 + (A_IsUnicode ? 680 : 340)
				VarSetCapacity(sfi, sfi_size)
				loop, Files, %SRCLOOP%\*.%fsext%,R
					{
						if (instr(A_LoopFileName,"setup")or instr(A_LoopFileName,"crashreporter")or instr(A_LoopFileName,"install")or instr(A_LoopFileName,"reshade")or instr(A_LoopFileName,"vcredist")or instr(A_LoopFileName,"vc_redist")or instr(A_LoopFileName,"unins")or instr(A_LoopFileName,"crashhandler")or instr(A_LoopFileName,"dotnet")or instr(A_LoopFileName,"directx")or instr(A_LoopFileName,"patch")or instr(A_LoopFileName,"crack"))
							{
								continue
							}
						FileExt= exe	
						FileName := A_LoopFileFullPath  ; Must save it to a writable variable for use below.
						filez:= A_LoopFileSizeKB	
						if (A_LoopFileExt = "lnk")
							{
								FileGetShortcut, %A_LoopFileFullPath%,FileSCName,OutDir,OutArgs,OutDescription,OutIcon,IconNumber,OutRunState
								FileGetSize,filez,%FileName%
								FileExt= lnk
							}
						SplitPath, FileName,FileNM,FilePath,  ; Get the file's extension.
						ifinstring,ad,%FileNM%|
							{
								continue
							}	
						LV_Add(lvachk,FileNM, FileExt, FilePath,  filez)	
						fullist.= A_LoopFileFullPath . "|"
					}
			}
	}
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
Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		if not RowNumber
			{
				break
			}
		LV_GetNext(RowNumber, Focused)
		LV_GetText(curtxt, RowNumber,1)
		LV_GetText(curtxtn, RowNumber,1)
		LV_GetText(curpth, RowNumber,3)
		stringreplace,fullisx,fullist,%curpth%\%curtxtn%|,,All
	}	
stringsplit,fullstn,fullist,|
gmnames:=
Loop,%fullstn0%
	{
		prn= % fullstn%A_Index%
		splitpath,prn,prnmx,OutDir,prnxtn,gmnamex
        OutRunState= 1
        OutTarget= %prn%
        OutDescription= %gmnamex%
		gmnamer= %gmnamex%
		splitpath,outdir,outdnam,outdmnd,outmpxtn,outdmnd
		IF (1 = 1)
			{
				Stringreplace,gfnamex,prn,G:\Games\,,All
				stringsplit,gmnxi,gfnamex,\
				gmnamex= %gmnxi1%
				gmnamer= %gmnxi1%|
				gmnameD= %gmnxi1%|
			}
			
				iter:= 
				if instr(gmnames,gmnamer)
					{
						Loop,%GAME_Profiles%\%GMNAMED%\%GMNAME%*.lnk
							{
								if (instr(outdnam,"exe64")or instr(outdnam,"Win64")or instr(outdnam,"x64")or instr(GMNAMEX,"Win64")or instr(GMNAMEX,"x64"))
									{
										gmnamex= %gmnamex% x64									
									}
								if (instr(outdnam,"exe32")or instr(outdnam,"Win32")or instr(outdnam,"x86")or instr(GMNAMEX,"Win32")or instr(GMNAMEX,"x86"))
									{
										gmnamex= %gmnamex% x32									
									}
									else {
										iter+=1
										ifinstring,gmnamex,%A_Space%[0
											{
												stringtrimRight,gmnamex,gmnamex,4
											}
										gmnamex= %gmnamex% [0%iter%]
									}
							}
						gmnames.= gmnamex . "|"
					}
						else {
							gmnames.= gmnamex . "|"		
							}	
		if (prnxtn = "lnk")
			{
				FileGetShortcut, %prn%,OutTarget,OutDir,OutArgs,OutDescription,OutIcon,IconNumber,OutRunState
				splitpath,prn,,,,linkname
				prvv= %prn%
				gmnamex= %linkname%	
			/*
				stringreplace,OutTarget,OutTarget,C:\,G:\,All
				stringreplace,OutDir,OutDir,C:\,G:\,All
				stringreplace,OutArgs,OutArgs,C:\,G:\,All
				stringreplace,OutDescription,OutDescription,C:\,G:\,All
				stringreplace,OutIcon,OutIcon,C:\,G:\,All
				stringreplace,IconNumber,IconNumber,C:\,G:\,All
				stringreplace,OutRunState,OutRunState,C:\,G:\,All
				*/
				if (OUTICON = "")
					{
						IconNumber:= (Index - 1)
					}
			}
			else {
					ExtID := FileExt  ; Special ID as a placeholder.
					IconNumber := 0  ; Flag it as not found so that these types can each have a unique icon.
				}
				/*
		if not IconNumber  ; There is not yet any icon for this extension, so load it.
			{
				; Get the high-quality small-icon associated with this file extension:
				if not DllCall("Shell32\SHGetFileInfo" . (A_IsUnicode ? "W":"A"), "Str", FileName
					, "UInt", 0, "Ptr", &sfi, "UInt", sfi_size, "UInt", 0x101)  ; 0x101 is SHGFI_ICON+SHGFI_SMALLICON
					IconNumber := 9999999  ; Set it out of bounds to display a blank icon.
				else ; Icon successfully loaded.
					{
						; Extract the hIcon member from the structure:
						hIcon := NumGet(sfi, 0)
						; Add the HICON directly to the small-icon and large-icon lists.
						; Below uses +1 to convert the returned index from zero-based to one-based:
						IconNumber := DllCall("ImageList_ReplaceIcon", "Ptr", ImageListID1, "Int", -1, "Ptr", hIcon) + 1
						DllCall("ImageList_ReplaceIcon", "Ptr", ImageListID2, "Int", -1, "Ptr", hIcon)
						; Now that it's been copied into the ImageLists, the original should be destroyed:
						DllCall("DestroyIcon", "Ptr", hIcon)
						; Cache the icon to save memory and improve loading performance:
						IconArray%ExtID% := IconNumber
					} 
			}
			*/

				StringReplace,gmnamex,gmnamex,%A_Space%Launcher,,All
				StringReplace,gmnamex,gmnamex,_Launcher,,All
				StringReplace,gmnamex,gmnamex,-Launcher,,All
				StringReplace,gmnamex,gmnamex,Launch%A_Space%,,All
				StringReplace,gmnamex,gmnamex,Launch-,,All
				StringReplace,gmnamex,gmnamex,Launch_,,All
				StringReplace,gmnamex,gmnamex,WIN64,,All
				StringReplace,gmnamex,gmnamex,WIN32,,All
				StringReplace,gmnamex,gmnamex,%A_Space%x64,,All
				StringReplace,gmnamex,gmnamex,x-64,,All
				StringReplace,gmnamex,gmnamex,_x64,,All
				Stringleft,chka,gmnamex,1
				StringRight,chkb,gmnamex,1
				gmnamed= %gmnamex%
				Loop,4
					{
						if ((chka = "_")or (chka = "-")or (chka = ".") or (chka = "%A_Space%"))
							{
								stringtrimleft,gmnamed,gmnamed,1
								stringtrimleft,gmnamex,gmnamex,1
								stringtrimleft,OutArgs,OutArgs,1
							}			
					}
				if (gmnamex = "")
					{
						gmnamex= %gmname%
						gmnamed= %gmnameX%
					}
				Loop,4
					{
						if ((chkb = "_")or (chkb = "-")or (chkb = ".") or (chkb = "%A_Space%"))
							{
								stringtrimright,gmnamed,gmnamed,1
								stringtrimright,gmnamex,gmnamex,1
								stringtrimright,OutArgs,OutArgs,1
							}
					}
				if (gmnamex = "")
					{
						gmnamex= %gmname%
						gmnamed= %gmnameX%
					}
				IF (OutArgs <> "")
						{
							OutArgs:= A_Space . OutArgs
						}
				;;UntOuch= C:\Users\romja\extranious\NoMon\%gmname%.lnk
				sidn= %Game_Profiles%\%gmnameD%\
				gamecfg= %A_ScriptDir%\profiles\%GMNAMED%\game.ini
				if (CREFLD = 1)
					{
						FileCreateDir, %Game_Profiles%\%gmnamed%
					}
				else {
					if ((CREFLD = 0)&& !fileExist(sidn))
						{
							continue
						}
				}	
				if (GMLNK = 1)
					{
						linktarget= %GAME_Directory%\%gmnamex%.lnk
						linkproxy= %prn%
						if ((OVERWRT = 1)&&(prnxtn = "lnk"))
							{
								FileDelete,%linktarget%
							}							
						if (prnxtn = "exe")
							{
								OutArgs= 
								prvv= %GAME_PROFILES%\%GMNAMED%\%gmnamex%.lnk
								linktarget= %GAME_Directory%\%gmnamex%.lnk
								linkproxy= %GAME_PROFILES%\%GMNAMED%\%gmnamex%.lnk
								if (OVERWRT = 1)
									{
										FileDelete,%linkproxy%									
									}
								if !fileexist(linkproxy)
									{
										;;msgbox,,,FileCreateShortcut|%prn%|%linkproxy%|%outdir%|%OutArgs%|%OutDescription%| %OutTarget%|| %IconNumber%| %OutRunState%
										FileCreateShortcut,%prn%,%linkproxy%,%outdir%,%OutArgs%,%gmnamex%, %OutTarget%,, %IconNumber%, %OutRunState%
									}
							}
						ifnotexist,%linktarget%
							{
								FileCreateShortcut, %RJDB_LOCATION%\RJ_LinkRunner.exe, %linktarget%, %OutDir%, `"%linkproxy%`"%OutArgs%, %gmnamex%, %OutTarget%,, %IconNumber%, %OutRunState%
							}
                        Filecopy,%GAME_Directory%\%gmnamex%.lnk,%GAME_PROFILES%\%GMNAMED%\%gmnamex%.lnk,%OVERWRT%	
                        Filecopy,%prvv%,%GAME_PROFILES%\%GMNAMED%\_%gmnamex%.lnk_,%OVERWRT%
                        if (GMCONF = 1)
                            {
                                Player1x= %GAME_PROFILES%\%GMNAMED%\%GMNAMEX%.%Mapper_Extension%
                                Player2x= %GAME_PROFILES%\%GMNAMED%\%GMNAMEX%_2.%Mapper_Extension%
                                if ((OVERWR = 1)or !fileexist(gamecfg))
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
                                                        if (OVERWR = 1)
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
						if ((errorlevel = 0)or fileexist(player12))
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
SB_SetText("Shortcuts Created")	
Loop,parse,GUIVARS,|
	{
		guicontrol,enable,%A_LoopField%
	}	
return
ButtonClear:
LV_Delete()  ; Clear the ListView, but keep icon cache intact for simplicity.
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

