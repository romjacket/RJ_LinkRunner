#NoEnv
#SingleInstance Force
SetBatchLines -1
localdir=%A_ScriptDir%
home= %A_ScriptDir%
splitpath,home,srcfn,srcpth
if ((srcfn = "src")or(srcfn = "bin")or(srcfn = "binaries"))
	{
		home= %srcpth%
	}	
binhome= %home%\bin
source= %home%\src
SetWorkingDir, %home%
rjrlupdfX= %1%
cacheloc= %home%\downloaded
inapp= 
if (rjrlupdfX <> "")
	{
		inapp= 1
		splitpath,rjrlupdfX,savefileX,home
		cacheloc= %home%\downloaded
		binhome= %home%\bin
		source= %home%\src
		SetWorkingDir, %home%
		goto, rjrlupdf
	}
FileDelete, %home%\version.txt
ARCORG= %source%\repos.set

IniRead,sourceHost,%ARCORG%,GLOBAL,SOURCEHOST
IniRead,UPDATEFILE,%ARCORG%,GLOBAL,UPDATEFILE
IniRead,RELEASE,%ARCORG%,GLOBAL,VERSION
getVer:
URLDownloadToFile, %sourceHost%,%home%\version.txt
ifnotexist, %home%\version.txt
	{
		MsgBox,4,Not Found,Update Versioning File not found.`nRetry?
		ifMsgBox, Yes
			{
				goto, getVer
			}
		return
	}
FileReadLine,DATECHK,version.txt,1
stringsplit,VERCHKC,DATECHK,=
if (VERCHKC1 <> RELEASE)
	{
		msgbox,4,Update, Update available`n%VERCHKC1%`nWould you like to update RJ_LinkRunner?
		IfMsgBox, yes
			{
				gosub, getupdate
				guicontrol,enable,UpdateSK
				return
			}
		ifmsgbox, no
			{
				exitapp
				return
			}
	}
return

getupdate:
upcnt=
loop, %cacheloc%\rj_linkrunner*.zip
	{
		upcnt+=1
	}
URLFILE= %UPDATEFILE%
save= %cacheloc%\RJ_LinkRunner%upcnt%.zip
DownloadFile(URLFILE, save, True, True)
ifexist,%save%
	{
		Process, close, Setup.exe
		Process, close, lrdeploy.exe
		Process, close, RJ_LinkRunner.exe
		Process, close, Build_Source.exe
		Runwait, %comspec% cmd /c "%binhome%\7za.exe x -y "%save%" -O"`%CD`%" ",,hide
		if (ERRORLEVEL <> 0)
			{
				MsgBox,3,Update Failed,Update not found.`n    Retry?
				ifMsgBox, Yes
					{
						goto, getupdate
					}
				exitapp
			}
		Run, RJ_LinkRunner.exe
		exitapp
	}
	else {
		MsgBox,3,Update Failed,Update not found.`nRetry?
		ifMsgBox, Yes
			{
				goto, getupdate
			}
		exitapp
	}
return

rjrlupdf:
TrayTip, Update, Extracting Update.`nRj_linkRunner will restart,999,48
Runwait, %binhome%\7za.exe x -y "%rjrlupdfX%" -O"%home%",,hide
if (ERRORLEVEL <> 0)
	{
		MsgBox,,ERROR,Update Failed,3
	}
if (inapp = 1)
	{
		Run, RJ_LinkRunner.exe
	}	
exitapp

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
          Progress, Off
          SetTimer, DownloadFileFunction_UpdateProgressBar, Off
      }
      return

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
			PercentDone= 0
		}
	progress, %PercentDone%
		return
	}
progress, off
exitapp
return