## Installation
This Version:0.99.00.099
This Build: 2021-10-27 12:46 PM
Extract the binary to a location of your choice, **or** download and build and run the source files and executables.
```sh
rj_linkrunner
+-- bin
¦   +-- 7za.exe
¦   +-- MultiMonitorTool.chm
¦   +-- NewOSK.exe
¦   +-- RJ_LinkRunner.exe
¦   +-- Setup.exe
¦   +-- Source_Builder.exe
¦
+-- src
¦   +-- absol.set
¦   +-- allgames.set
¦   +-- amicro.set
¦   +-- build.ahk
¦   +-- Desktop.set
¦   +-- exclfnms.set
¦   +-- exez.set
¦   +-- Joystick.ico
¦   +-- log.txt
¦   +-- newosk.ahk
¦   +-- NewOSK.ico
¦   +-- repos.set
¦   +-- RJDB.set
¦   +-- RJ_LinkRunner.ahk
¦   +-- RJ_LinkRunner.ico
¦   +-- RJ_Setup.ico
¦   +-- Setup.ahk
¦   +-- Source_Builder.ico
¦   +-- unlike.set
¦   +-- unsel.set
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

If you have a multimonitor setup or wish to change the display of the monitor you will play games on, use the "GMC" button to create a profile for games, and the "DMC" button to create a profile for your mediacenter/desktop.

![example](http://romjacket.github.io/RJ_LinkRunner/example.png)

#### The presets are setup to do a few things:

Common Keyboard Mappings are setup for the XBOX-One/360 layout and have a template for games and your mediacenter/desktop.

You can use antimicro or xpadder prior to creating shortcuts to modify or create your own presets and these can be changed and updated for any games selected in the list.

To use the mouse and other common keys, hold the back button and:
```sh
The Right analog stick controls the mouse.
The R-Stick Button is Left-click.
The R-Trigger Button is Right-click.
The L-Trigger Button is Middle-Mouse-Button-Click.
The A-Button is the enter-key.
The X-Button is the Shift-key.
The B-Button is the Alt-key.
The Y Button is the Ctrl-key.
The L-Shoulder(bumper) button is the Backspace-key.
The R-Shoulder(bumper) button is the Space-Key.
The D-Pad corresponds to arrow keys.
Holding the Left-Analog stick upwards for a few seconds will activate the Win-Key.
The game-quit button combination is Back+Hold + Menu-Button(ctrl + f12)
the game-reset button combination is Back+Hold + L-Stick-Button) (ctrl + f2)

The on-screen-keyboard is Back+Hold + guide (xbox) button. (alt+ctrl+f9)
```
The profile for player 1 and player 2 have the ability to reset and end games as well as control the desktop.
The Mediacenter/Desktop profile is similar with differences being:

```sh
The mouse & keyboard controls are active without holding the back-button.
The start-button is the Esc-key.
The Left-Analog stick held upwards is the page-up-key.
The Left-Analog stick held down is the page-down-key.
The Left-Analog stick held left is the delete-key.
The Left-Analog stick held right is the Tab-key.
```
## Launching Games

It is best if you set the RJ_LinkRunner.exe, antimicro.exe and xpadder.exe to run as the administrator.

During gameplay you may add additional joysticks and save a profile for them. Any additional joystick profiles found within the game's jacket will be saved and reloaded for player 2, prioritizing the default profile-name (Game Jacket_2.gamecontroller.amgp, and other "player 2" monikers.)

The multimonitor tool will save the current monitor/s resolution/s of the current running game upon exit of the launcher.

I've tested this on a variety of preconfigurations with a few hundred games and found that 99% of them are identified & launched properly without any adjustment whatsoever.
