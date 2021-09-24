#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
ToolTip,building LinkRunner
FileDelete,NewOsk.exe
#SingleInstance Force
FileDelete,RJ_LinkRunner.exe
FileDelete,Setup.exe
iniread,URLFILEX,RJDB.ini,CONFIG,remotebinaries
DOWNLOADIT:
iniread,URLFILE,RJDB.ini,CONFIG,remotebinaries%nam%
if (URLFILE = "") or (URLFILE = "ERROR")
	{
		URLFILE= %URLFILEX%
		nam= 
	}
splitpath,A_ScriptFullPath,scriptfilename,HEREDIR
save= %HEREDIR%\Binaries.zip
DownloadFile(URLFILE,save,False,True)
;UrlDownloadToFile,%URLFILE%,%save%
ToolTip, 
Sleep, 500
ifexist,%save%
	{
		ToolTip, Extracting...
		Unz(save,HEREDIR)
		Tooltip,Extracted.
	}
Sleep, 500
ToolTip, 
ifnotexist,%save%
	{
		msgbox,258,,Failed To download,Binary support files did not download.`n`nContinue?
		ifmsgbox,Abort
		exitapp
		if (nam = "")
			{
				nam+=1
			}
			else {
			nam= 
			}
		goto, DOWNLOADIT
	}
splitpath,A_AhkPath,,AHKLOC
Loop,%AHKLOC%\*.exe,R
	{
		if (A_LoopFileName = "Ahk2Exe.exe")
			{
				AHKEXE= %A_LoopFileFullPath%
				splitpath,AHKEXE,AHKEXN,AHKEXEPATH
				break
			}
Loop,%AHKLOC%\*.bin,R
	{
		if (A_LoopFileName = "Unicode 64-bit.bin")
			{
				BINFILE= %A_LoopFileFullPath%
				break
			}
		}	
	}
RUnWait,"%AHKEXE%" /in "%HEREDIR%\RJ_LinkRunner.ahk" /icon "RJ_LinkRunner.ico" /bin "%BINFILE%" /out "%HEREDIR%\RJ_LinkRunner.exe",%HEREDIR%,hide
ToolTip,building Setup
RUnWait,"%AHKEXE%" /in "%HEREDIR%\Setup.ahk" /icon "RJ_Setup.ico" /bin "%BINFILE%" /out "%HEREDIR%\Setup.exe",%HEREDIR%,hide
ToolTip,Building NewOSK
RUnWait,"%AHKEXE%" /in "%HEREDIR%\NewOSK.ahk" /icon "NewOSK.ico" /bin "%BINFILE%" /out "%HEREDIR%\NewOSK.exe",%HEREDIR%,hide
ToolTip,complete
sleep,2000
exitapp
esc::
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
	 ToolTip,%Speed% at %PercentDone%`% : %CurrentSize% bytes completed
	 return
  }


Unz(sZip, sUnz)
	{
    psh  := ComObjCreate("Shell.Application")
    psh.Namespace( sUnz ).CopyHere( psh.Namespace( sZip ).items, 4|16 )
	}