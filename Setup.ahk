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
STDVARS= KeyBoard_Mapper|MediaCenter_Profile|Player1_Template|Player2_Template|MultiMonitor_Tool|MM_MEDIACENTER_Config|MM_Game_Config|BorderLess_Gaming_Program|BorderLess_Gaming_Database|extapp|Game_Directory|Game_Profiles|RJDB_Location|Source_Directory|Mapper_Extension|1_Pre|2_Pre|3_Pre|1_Post|2_Post|3_Post|switchcmd|switchback
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
Gui, Add, GroupBox, x16 y8 w284 h567 center, RJDB_Wizard
Gui, Add, Button, x262 y30 w25 h25 gPOPULATE,GO
GUi, Add, Checkbox, x70 y20 h14 vCREFLD gCREFLD %fldrget% %fldrenbl%, Folders
GUi, Add, Checkbox, x70 y38 vGMCONF gGMCONF %cfgget% %cfgenbl%,Cfg
GUi, Add, Checkbox, x110 y38 vGMJOY gGMJOY %Joyget% %joyenbl%,Joy
GUi, Add, Checkbox, x148 y38 vGMLNK gGMLNK %lnkget% %lnkenbl%,Lnk
Gui, Add, Radio, x190 y24 vUPDTSC gUPDTSC, Overwrite
Gui, Add, Radio, x190 y40 vOVERWR gOVERWR checked, Update
Gui, Add, Button, x282 y575 w15 h15 gRESET,R
Gui, Add, Checkbox, x24 y30 h14 vEnableLogging gEnableLogging %loget%, Log
Gui, Add, Button, x24 y64 w25 h24 vRJDB_Config gRJDB_Config,...
Gui, Add, Text,  x64 y64 w222 h14 vRJDB_ConfigT Right,"<%RJDB_ConfigT%"
Gui, Add, Button, x24 y96 w25 h24 vRJDB_Location gRJDB_Location,...
Gui, Add, Text,  x64 y96 w222 h14 vRJDB_LocationT Right,"<%RJDB_LocationT%"

Gui, Add, Button, x24 y128 w25 h24 vGAME_Profiles gGAME_Profiles,...
Gui, Add, Text,  x64 y128 w222 h14 vGAME_ProfilesT Right,"<%GAME_ProfilesT%"

Gui, Add, Button, x24 y160 w25 h24 vGAME_Directory gGAME_Directory,...
Gui, Add, Text,  x64 y160 w222 h14 vGAME_DirectoryT Right,"<%GAME_DirectoryT%"

Gui, Add, Button, x24 y192 w25 h24 vSOURCE_Directory gSOURCE_Directory,...
Gui, Add, Text,  x64 y192 w222 h14 vSOURCE_DirectoryT Right,"<%SOURCE_DirectoryT%"

Gui, Add, Button, x24 y224 w25 h24 vKeyboard_Mapper gKeyboard_Mapper,...
Gui, Add, Text,  x64 y224 w222 h14 vKeyboard_MapperT Right,"<%Keyboard_MapperT%"

Gui, Add, Button, x24 y256 w25 h24 vPlayer1_Template gPlayer1_Template,...
Gui, Add, Text,  x64 y256 w222 h14 vPlayer1_TemplateT Right,"<%Player1_TemplateT%"

Gui, Add, Button, x24 y288 w25 h24 vPlayer2_Template gPlayer2_Template,...
Gui, Add, Text,  x64 y288 w222 h14 vPlayer2_TemplateT Right,"<%Player2_TemplateT%"

Gui, Add, Button, x24 y320 w25 h24 vMediaCenter_Profile gMediaCenter_Profile,...
Gui, Add, Text,  x64 y320 w222 h14 vMediaCenter_ProfileT Right,"<%MediaCenter_ProfileT%"

Gui, Add, Button, x24 y352 w25 h24 vMultiMonitor_Tool gMultiMonitor_Tool,...
Gui, Add, Text,  x64 y352 w222 h14 vMultiMonitor_ToolT Right,"<%MultiMonitor_ToolT%"

Gui, Add, Button, x24 y384 w25 h24 vMM_Game_Config gMM_Game_Config,...
Gui, Add, Text,  x64 y384 w222 h14 vMM_Game_ConfigT Right,"<%MM_Game_ConfigT%"

Gui, Add, Button, x24 y416 w25 h24 vMM_MediaCenter_Config gMM_MediaCenter_Config,...
Gui, Add, Text,  x64 y416 w222 h14 vMM_MediaCenter_ConfigT Right,"<%MM_MediaCenter_ConfigT%"

Gui, Add, Button, x24 y448 w25 h24 vBorderless_Gaming_Program gBorderless_Gaming_Program,...
Gui, Add, Text,  x64 y448 w222 h14 vBorderless_Gaming_ProgramT Right,"<%Borderless_Gaming_ProgramT%"

Gui, Add, Button, x24 y480 w25 h24 vBorderless_Gaming_Database gBorderless_Gaming_Database,...
Gui, Add, Text, x64 y480 w222 h14 vBorderless_Gaming_DatabaseT Right,"<%Borderless_Gaming_DatabaseT%"

Gui, Add, Button, x24 y512 w25 h24 vPREAPP gPREAPP ,...
Gui, Add, DropDownList, x64 y515 w204 vPREDD gPREDD Right,%prelist%
Gui, Add, Button, x270 y512 w14 h14 vDELPREAPP gDELPREAPP ,X

Gui, Add, Button, x24 y544 w25 h24 vPOSTAPP gPOSTAPP ,...
Gui, Add, DropDownList, x64 y547 w204 vPostDD gPostDD Right,%postlist%
Gui, Add, Button, x270 y544 w14 h14 vDELPOSTAPP gDELPOSTAPP ,X

Gui, Add, StatusBar, x0 y546 w314 h28, Status Bar
Gui Show, w314 h610, Window
Return


esc::
GuiEscape:
GuiClose:
ExitApp

; End of the GUI section

RJDB_Config:gui,submit,nohideFileSelectFile,RJDB_ConfigT,3,%flflt%,Select Fileif ((RJDB_ConfigT <> "")&& !instr(RJDB_ConfigT,"<")){RJDB_Config= %RJDB_ConfigT%iniwrite,%RJDB_Config%,%RJDB_Config%,GENERAL,RJDB_Configstringreplace,RJDB_ConfigT,RJDB_ConfigT,%A_Space%,`%,Allguicontrol,,RJDB_ConfigT,%RJDB_Config%}else {stringreplace,RJDB_ConfigT,RJDB_ConfigT,%A_Space%,`%,Allguicontrol,,RJDB_ConfigT,<RJDB_Config
}return

RJDB_Location:gui,submit,nohideFileSelectFolder,RJDB_LocationT,%fldflt%,7,Select Folderif ((RJDB_LocationT <> "")&& !instr(RJDB_LocationT,"<")){RJDB_Location= %RJDB_LocationT%iniwrite,%RJDB_Location%,%RJDB_Config%,GENERAL,RJDB_Locationstringreplace,RJDB_LocationT,RJDB_LocationT,%A_Space%,`%,Allguicontrol,,RJDB_LocationT,%RJDB_Location%}else {stringreplace,RJDB_LocationT,RJDB_LocationT,%A_Space%,`%,Allguicontrol,,RJDB_LocationT,<RJDB_Location
}return

GAME_Profiles:gui,submit,nohideFileSelectFolder,GAME_ProfilesT,%fldflt%,7,Select Folderif ((GAME_ProfilesT <> "")&& !instr(GAME_ProfilesT,"<")){GAME_Profiles= %GAME_ProfilesT%iniwrite,%GAME_Profiles%,%RJDB_Config%,GENERAL,GAME_Profilesstringreplace,GAME_ProfilesT,GAME_ProfilesT,%A_Space%,`%,Allguicontrol,,GAME_ProfilesT,%GAME_Profiles%}else {stringreplace,GAME_ProfilesT,GAME_ProfilesT,%A_Space%,`%,Allguicontrol,,GAME_ProfilesT,<GAME_Profiles
}return

GAME_Directory:gui,submit,nohideFileSelectFolder,GAME_DirectoryT,%fldflt%,7,Select Folderif ((GAME_DirectoryT <> "")&& !instr(GAME_DirectoryT,"<")){GAME_Directory= %GAME_DirectoryT%iniwrite,%GAME_Directory%,%RJDB_Config%,GENERAL,GAME_Directorystringreplace,GAME_DirectoryT,GAME_DirectoryT,%A_Space%,`%,Allguicontrol,,GAME_DirectoryT,%GAME_Directory%}else {stringreplace,GAME_DirectoryT,GAME_DirectoryT,%A_Space%,`%,Allguicontrol,,GAME_DirectoryT,<GAME_Directory
}return

Source_Directory:gui,submit,nohideFileSelectFolder,Source_DirectoryT,%fldflt%,7,Select Folderif ((Source_DirectoryT <> "")&& !instr(Source_DirectoryT,"<")){Source_Directory= %Source_DirectoryT%iniwrite,%Source_Directory%,%RJDB_Config%,GENERAL,Source_Directorystringreplace,Source_DirectoryT,Source_DirectoryT,%A_Space%,`%,Allguicontrol,,Source_DirectoryT,%Source_Directory%}else {stringreplace,Source_DirectoryT,Source_DirectoryT,%A_Space%,`%,Allguicontrol,,Source_DirectoryT,<Source_Directory
}return

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
gui,submit,nohideFileSelectFile,PREAPPT,3,%flflt%,Select Fileif ((PREAPPT <> "")&& !instr(PREAPPT,"<")){PREAPP= %PREAPPT%
iniread,cftst,%RJDB_Config%,CONFIG
knum= 
Loop,parse,cftst,`n`r
    {
        stringsplit,dkd,A_LoopField,=
        ifinstring,dkd1,_Pre
            {
                stringreplace,dkv,A_LoopField,%dkd1%=,,
                if (dkv = "")
                    {
                        continue
                    }
                knum+=1
                %knum%_Pre= dkv
                if (knum = 1)
                    {
                        PreList.= "|" . dkv . "||"
                        continue
                    }
                PreList.= dkv . "|"
            }
    }
knum+=1
%knum%_Pre= %PREAPP%
PreList.= PREAPP . "|"iniwrite,%PREAPP%,%RJDB_Config%,CONFIG,%knum%_Preguicontrol,,PREDD,%PreList%}else {}return

POSTAPP:gui,submit,nohideFileSelectFile,POSTAPPT,3,%flflt%,Select Fileif ((POSTAPPT <> "")&& !instr(POSTAPPT,"<")){POSTAPP= %POSTAPPT%iniread,cftst,%RJDB_Config%,CONFIG
knum=
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
    }
knum+=1
%knum%_Post= %PostAPP% 
PostList.= POSTAPP . "|"
iniwrite,%PostAPP%,%RJDB_Config%,CONFIG,%knum%_Post
guicontrol,,PostDD,%PostList%}else {}return

DELPREAPP:gui,submit,nohide
guicontrolget,DELPreDD,,PreDD
iniread,cftst,%RJDB_Config%,CONFIG
knum=
Loop,parse,cftst,`n`r
    {
        stringsplit,dkd,A_LoopField,=
        ifinstring,dkd1,_Pre
            {
                stringreplace,dkv,A_LoopField,%dkd1%=,,
                if (dkv = "")
                    {
                        continue
                    }
                %knum%_Pre= dkv
                if (dkv = DELPreDD)
                    {
                         continue
                    }
                knum+=1
                if (knum = 1)
                    {
                        PreList.= "|" . dkv . "||"
                        continue
                    }
                   iniwrite,%dkv%,%RJDB_Config%,CONFIG,%knum%_Pre
                PreList.= dkv . "|"
            }
    }
guicontrol,,PreDD,%PreList%    
return

DELPOSTAPP:gui,submit,nohideguicontrolget,DELPOSTDD,,POSTDD
iniread,cftst,%RJDB_Config%,CONFIG
knum=
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
                %knum%_Post= dkv
                if (dkv = DELPOSTDD)
                    {
                         continue
                    }
                knum+=1
                if (knum = 1)
                    {
                        PostList.= "|" . dkv . "||"
                        continue
                    }
                   iniwrite,%dkv%,%RJDB_Config%,CONFIG,%knum%_Post
                PostList.= dkv . "|"
            }
    }
guicontrol,,PostDD,%PostList%    
return

PREDD:
gui,submit,nohide
return

POSTDD:
gui,submit,nohide
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
    }
return    

EnableLogging:
gui,submit,nohide
guicontrolget,EnableLogging,,EnableLogging
iniwrite,%EnableLogging%,%RJDB_Config%,GENERAL,Logging
return


POPULATE:
if (!Fileexist(GAME_Directory)or !FileExist(Profiles_Directory)or !FileExist(Game_Profiles)or !FileExist(Source_Directory))
    {
        ToolTip,Please Select Valid Directories
    }
str := "" 
ToolTip,Converting Links
loop, %SOURCE_DIRECTORY%\*.lnk 
	{
		; gets the details of the shortcut 
		; FileGetShortcut, %A_LoopFileFullPath%,OutTarget,OutDir,OutArgs,OutDescription,OutIcon,OutIconNum,OutRunState
		FileGetShortcut, %A_LoopFileFullPath%,OutTarget,OutDir,OutArgs,OutDescription,OutIcon,OutIconNum,OutRunState
		splitpath,A_LoopFileFullPath,,,,linkname
		stringreplace,OutTarget,OutTarget,C:\,G:\,All
		stringreplace,OutDir,OutDir,C:\,G:\,All
		stringreplace,OutArgs,OutArgs,C:\,G:\,All
		stringreplace,OutDescription,OutDescription,C:\,G:\,All
		stringreplace,OutIcon,OutIcon,C:\,G:\,All
		stringreplace,OutIconNum,OutIconNum,C:\,G:\,All
		stringreplace,OutRunState,OutRunState,C:\,G:\,All
		if (OUTICON = "")
			{
				OutIconNum:= (Index - 1)
			}
		gmnamex= %linkname%	
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
		Loop,4
			{
				if ((chka = "_")or (chka = "-")or (chka = ".") or (chka = "%A_Space%"))
					{
						stringtrimleft,gmnamex,gmnamex,1
						stringtrimleft,OutArgs,OutArgs,1
					}			
			}
		if (gmnamex = "")
			{
				gmnamex= %gmname%
			}
		Loop,4
			{
				if ((chkb = "_")or (chkb = "-")or (chkb = ".") or (chkb = "%A_Space%"))
					{
						stringtrimright,gmnamex,gmnamex,1
						stringtrimright,OutArgs,OutArgs,1
					}
			}
		if (gmnamex = "")
			{
				gmnamex= %gmname%
			}
		IF (OutArgs <> "")
				{
					OutArgs:= A_Space . OutArgs
				}
		UntOuch= C:\Users\romja\extranious\NoMon\%gmname%.lnk
		sidn= %Game_Profiles%\%gmnamex%\
		gamecfg= %A_ScriptDir%\profiles\%GMNAMEX%\game.ini
		if (CREFLD = 1)
			{
				FileCreateDir, %Game_Profiles%\%gmnamex%
			}
		else {
			if ((CREFLD = 0)&& !fileExist(sidn))
				{
					continue
				}
		}	
		if (GMLNK = 1)
			{
				if (OVERWRT = 1)
					{
						FileCreateShortcut, %RJDB_LOCATION%\RJ_LinkRunner.exe, %GAME_Directory%\%gmnamex%.lnk, %OutDir%, `"%SOURCE_DIRECTORY%\%A_LoopFileName%`"%OutArgs%, %OutDescription%, %OutTarget%,, %OutIconNum%, %OutRunState%
					}
				else {
						ifnotexist,%GAME_Directory%\%gmnamex%.lnk
							{
								FileCreateShortcut, %RJDB_LOCATION%\RJ_LinkRunner.exe, %GAME_Directory%\%gmnamex%.lnk, %OutDir%, `"%SOURCE_DIRECTORY%\%A_LoopFileName%`"%OutArgs%, %OutDescription%, %OutTarget%,, %OutIconNum%, %OutRunState%
							}
						}
						if (GMCONF = 1)
							{
								Player1x= %GAME_PROFILES%\%GMNAMEX%\%GMNAMEX%.%Mapper_Extension%
								Player2x= %GAME_PROFILES%\%GMNAMEX%\%GMNAMEX%_2.%Mapper_Extension%
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
		if (GMLNK = 1)
			{
				Filecopy,%GAME_Directory%\%gmnamex%.lnk,%GAME_PROFILES%\%GMNAMEX%\%gmnamex%.lnk,%OVERWRT%	
				Filecopy,%A_LoopFileFullPath%,%GAME_PROFILES%\%GMNAMEX%\_%gmnamex%.lnk_,%OVERWRT%	
			}
	}
tooltip,complete
sleep, 1000
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
        if (resetting = 1)
            {
                guicontrol,,%val%T,"<%prtvd%"
            }
    }
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
                        PreList.= "|" . dkv . "||"
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