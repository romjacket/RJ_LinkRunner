## Use Case

Filthy pirates who don't use steam/gog/epic/origin/etc... should be able to 
manage their libraries too.

## Installation
This Version:0.99.25.031

This Build: 2022-01-28 8:45 AM

Run the installer or extract the binary to a location of your choice, **or** download and build and run the source files and executables.
```sh
rj_linkrunner
+-- bin
¦   +-- aria2c.exe
¦   +-- 7za.exe
¦   +-- lrDeploy.exe
¦   +-- NewOSK.exe
¦   +-- RJ_LinkRunner.exe
¦   +-- Setup.exe
¦   +-- Source_Builder.exe
¦   +-- Update.exe
¦
+-- site
¦   +-- index.html
¦   +-- install.png
¦   +-- example.png
¦   +-- runas.png
¦   +-- key.png
¦   +-- keymapper.png
¦   +-- tip.png
¦   +-- update.png
¦   +-- ReadMe.md
¦
+-- src
¦   +-- absol.set
¦   +-- allgames.set
¦   +-- amicro.set
¦   +-- build.ahk
¦   +-- Buildtools.set
¦   +-- Desktop.set
¦   +-- exclfnms.set
¦   +-- exez.set
¦   +-- Installer.ico
¦   +-- Joystick.ico
¦   +-- lrDeploy.ahk
¦   +-- lrDeploy.set
¦   +-- newosk.ahk
¦   +-- NewOSK.ico
¦   +-- rabsol.set
¦   +-- readme.set
¦   +-- repos.set
¦   +-- RJDB.set
¦   +-- RJ_LinkRunner.ahk
¦   +-- RJ_LinkRunner.ico
¦   +-- RJ_Setup.ico
¦   +-- Setup.ahk
¦   +-- Source_Builder.ico
¦   +-- unlike.set
¦   +-- unsel.set
¦   +-- Update.ahk
¦   +-- xallgames.set
¦   +-- xDesktop.set
¦   +-- xpadr.set
¦
+-- README.md
```

## Setup

Setup (bin\Setup.exe) is fairly simple and the tool will index your drives for common game folders used by many delivery providers.

Use the "SRC" button to add a folder/s where games have been installed. EG: C:\Games, or C:\Program Files

Use the "OUT" button to set the location for the shortcuts.

The "GPD" button will set the location where profile folders for each game will be kept.

Right-Click on the buttons in the setup tool to download supported executables.

## Launching Games

It is not necessary, but best if RJ_LinkRunner.exe, antimicro.exe and xpadder.exe are assigned to run as the administrator.

![AsAdmin](https://romjacket.github.io/RJ_LinkRunner/runas.png)

During gameplay you may create additional joystick profiles and any found within the game's jacket will be saved and reloaded for player 2/3/4, prioritizing the default profile-name eg: "Game Jacket".gamecontroller.amgp, and other "player#" monikers.)

I've tested this on a variety of preconfigurations with a few hundred games and found that 99% of them are identified & launched properly without any adjustment whatsoever.
