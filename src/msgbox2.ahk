; ================================================================================================
;	MsgBox2 Library
;	Author: TheArkive
;
;	https://www.autohotkey.com/boards/viewtopic.php?t=72254
;	https://github.com/marius-sucan/other-small-AHK-scripts/blob/master/msgbox2.ahk (robodesign)
;
;	Replaces the MsgBox command and InputBox commands.  MsgBox2() can be used inline as a function
;	returning a value selected by the user.  The script thread using Msgbox2() will be halted
;	until the user gives input, as expected from the Msgbox/InputBox commands.  You can also add a
;	CheckBox, EditBox, DropDownList, ComboBox, or ListBox (or any combo of these) to get more
;	input from the user.  Also, the user can right click on the msg and copy it if desired.
;
;	MsgBox2() lets you change MANY aspects about how the dialog is displayed, such as font and
;	font size.  See the options list below for all the ways you can customize it.
;
;	The automatic sizing of MsgBox2() is based on the following criteria:
;
;		1) Width of message text is automatically sized up to 350 px limit.
;		2) Width of 350 is automatically overridden if CheckBox, ListBox, etc. control text is
;          wider.
;			> Use "`r`n" to line break a CheckBox or display message if desired.
;		3) Width limit can be changed with MaxWidth: option.
;		4) Width can be set to a static value with SetWidth: option.
;			> The only way the dialog will extend beyond the horizontal limits of the screen is
;			  if the user sets it that way, with options or long CheckBox / DropDownList text.
;		5) Height is automatically adjusted based on dialog contents.
;		6) Height is limited to 95% of screen height, or by MaxHeight: option.
;
;	Lastly, by default, Msgbox2() uses a text control to display the desired message.  This can
;	be changed to a read-only Edit control if displaying long scrolling text.
;
;	With a large list of options, it's easy to specify one global string to standardize the dialog
;	style you want, such as font, font size, etc., and just add on specific options when called.
;	Or you can modify the default options in the class (near the top, check comments) to set the
;	defaults you want to use.
;
; ================================================================================================
; User interaction and accessibility
; ================================================================================================
;	User can use arrow keys and {Tab} button to navigate the Msgbox2() GUI. Pressing ESC, ALT+F4,
;	CTRL+F4 or CTRL+Q returns "" as the "button pressed".
;	Pressing Enter will trigger the default button.
;
; ================================================================================================
; Usage / Return Value 
; ================================================================================================
;	Call Msgbox2 as follows:
;
;		mb2Var := New Msgbox2(Message,Title,Options,Styles,WinId)
;	OR
;		mb2Var := MsgBox2_New(Message,Title,Options,Styles,WinId)
;
;	Once called, the script/thread will be delayed by an InputHook (only used for this delay).
;	When the user interacts with the dialog, or closes it, then the following propertiesd are
;	populated:
;
;		mb2Var.button           text of the button clicked
;		mb2Var.edit				text of Edit box
;		mb2Var.list             row number selected in ListBox
;		mb2Var.listText         text of row number selected in Listbox
;		mb2Var.dropList         row number selected in DropDownList
;		mb2Var.dropListText     text of row number selected in DropDownList
;		mb2Var.combo            row number selected in ComboBox
;		mb2Var.comboText        text of row number selected in ComboBox
;		mb2Var.check            value of Checkbox (1 or 0 / true or false)
;		mb2Var.ClassNN          ClassNN of the button clicked
;
;		NOTE: If user presses a hotkey to close the dialog (ESC, ALT+F4, CTRL+F4) or uses the close
;		button in the top-right, .button and .ClassNN are blank.
;
;	To save memory, free the reference when done:
;
;		mb2Var := ""
;
; ================================================================================================
; Defaults
; ================================================================================================
;	The defaults, if options are not specified, are as follows:
;
;		Font               = Segoe UI
;		Font size          = 9
;		Dialog width       = 350 px (or the width of sMsg)
;		Button width       = widest button
;		Buttons shown      = OK
;		Default button     = 1st created button
;		button alignment   = right
;		Sys close button   = dialog has a close button, top-right
;		no icons, no CheckBox, no DropDownList, no Edit box, no ListBox, no ComboBox
;
; ================================================================================================
; Options
; ================================================================================================
; Specify zero or more of the options below - comma (,) separated.
;
;	fontFace:font_name_str
;		Sets font face/name.
;		Ex:  fontFace:Times New Roman
;
;	fontSize:#
;		Specify a font size.
;		Ex:  fontSize:20
;		> Sets font size to 20 for all controls.
;
;	txtColor:color_str
;		Specify color of msg text.  Same format as common AHK control style.
;		Ex:  txtColor:Red  OR  txtColor:FF0000  OR  txtColor:0xFF0000
;		> Sets the text message color to Red.  A blank value after the colon in "txtColor:" uses
;		the default system txt color.
;
;	bgColor:####
;		Specify color of dialog background.  Same format as Gui, Color command.  A blank value
;		after the colon in "bgColor:" uses the default system background color.
;		Ex:  bgColor:Blue  OR  bgColor:0000FF  OR  bgColor:0x0000FF
;		> Sets the background to Blue.
;
;	check:checkbox_caption:value
;		Specify a checkbox and caption text.  By default, the checkbox will be unchecked.  To change
;		this, specify 1 for the value.
;		EX:  check:Don't show again.:1
;		> Adds a checkbox to the dialog with the caption "Don't show again." and will be checked.
;
;	dropList:item|item|item:value
;		Creates a DropDownList with specified options.  Specify "value" as the row number to be
;		pre-selected in the DropDownList.
;
;	edit:edit_string
;		Adds an edit control to the dialog and fills it with optional specified text.
;		Ex:  edit:old file name.txt
;		> Adds an edit control and fills it with "old file name.txt"
;
;	list:item|item|item:value:rowsHeight
;		Creates a ListBox with specified options.  Specify "value" as the row number to be
;		pre-selected in the ListBox.  Specify "rowsHeight" to limit the height of the Listbox.
;		Specifying "value" or "rowsHeight" is optional.
;
;	selectable
;		Specify this to use a read-only edit control, instead of the default text control.  Note
;		that using this mode limits the text displayed to only about 65,535 characters. Also,
;		the system vScroll width is not automatically added to the message width, which helps text
;		to NOT prematurely wrap when using an edit control.
;
;	rightMenuCopy
;		Specify this option to allow right click context menu.
;
;	btnTextW
;		If specified, the buttons specified in btnList will be as wide as their display text + button
;		margins (defaults:  btnMarX := 20).  Default button width is the width of the string
;		"Try Again" at the specified font + button margins
;
;   btnList:Num_or_list
;		Use a number the same as the Msgbox command to load those buttons, or specify your own list
;		of buttons as a pipe delimited string.  Use &BtnText to allow using ALT as a shortcut.  See
;		GUI, Add, Button help for more info.
;		Ex:  btnList:1
;		> Displays (OK / Cancel) buttons.  Number 0-6.  See Msgbox command help for more info.
;		Ex:  btnList:OK|&Cancel[d]
;		> Specifies OK and Cancel buttons, and sets the "Cancel" button as the default.  Also, in
;		this example, ALT+C would trigger the Cancel button becuse of using "&".
;
;	help:help_btn_text
;		Specify a help button with custom text.  Help button width is set by the help_btn_text
;		specified.  A help button is treated the same as all other buttons in regards to the
;		return value.  The clicked "button text" will be returned.
;		Ex:  help:
;		> This will use a "?" as the help button text.  Returns "?" if clicked.
;		Ex:  help:Help
;		> This will specify a help button with the text "Help".  Returns "Help" if clicked.
;
;	btnAlign:left   OR   btnAlign:right
;		If this option is NOT specified, buttons are centered. Otherwise user can specify to align
;		the buttons to the right or left of the dialog.
;
;	btnMarX:###
;		Sets horzintal margin value for buttons.  This is both left and right margins added together.
;		Default is 20 px.  Buttons using fixed-width text may benefit from a smaller X margin than
;		the default.
;		Ex:  btnMarX:25
;		> Sets horizontal button margin total to 25, thus adding 25 to button text width, so this
;		affects the button width.
;
;	btnMarY:###
;		Sets vertical margin value for buttons.  This is both top and bottom margins added together.
;		Default is 15 px.
;		Ex:  btnMarY:10
;		> Sets vertical button margin total to 10, thus adding 10 to button text height, so this
;		affects the button height..
;
;	btnDimsW:###
;		Sets fixed button width. If left blank, the default fixed value (70) is used.
;		If set to 0, then width depends on font and text ().
;		
;	btnDimsH:###
;		Sets fixed button height. If left blank, the default fixed value (11) is used.
;		If set to 0, then height depends on font and text.
;
;	MaxWidth:###
;		Defines max pixel width for the dialog.  Default = 350 px wide or the width of sMsg if sMsg
;		is smaller.
;		Ex:  MaxWidth:300
;		> Sets text max width to 300 pixels.  If sMsg is less than 300 px wide, then the width of
;		sMsg will be used instead.
;
;	MaxHeight:###
;		Defines max pixel height for the sMsg control.  Default height is the height of sMsg.
;		Generally the screen height is used to try and limit the dialog height, but adding controls,
;		like edit, makes this a bit more sketchy.  If displaying a large sMsg, or a long scrolling
;		sMsg, it is usually best to specify the MaxHeight.
;		Ex:  MaxHeight:500
;		> Sets the MaxHeight to 500 pixels, or if sMsg is smaller, the height of sMsg.
;
;	SetWidth:###
;		Specifies a width to force the dialog to use. The width of sMsg has no effect if this
;		option is specified. Overrides Max and Min width.
;		Ex:  SetWidth:400
;		> Sets the dialog width to 400 px.
;
;	ForcedWinWidth:###
;		Defines width for the whole dialogue window.
;		Best NOT USED with variable text.
;
;	ForcedWinHeight:###
;		Defines height for the whole dialogue window.
;		Best NOT USED with variable text.
;
;	icon:icon_str
;		Specifies using an icon.  There are a few different ways to use this option:
;		Ex:  icon:error   OR   icon:warning   OR   icon:info   OR   icon:question
;		> Specify one of the 4 common icons featured in the Msgbox command.
;		Ex:  icon:file.jpg  OR  icon:file.dll/2
;		> Specify a picture file, or a file and icon index.  Use forward slash (/) as separator.
;		EX:  HICON:[handle]  OR  HBITMAP:[handle]
;		> See LoadPicture() for more info on HICON and HBITMAP handles.
;
;	iconTitle:icontitle_str
;		Specifies using a specific icon for the title bar. Same rules as above.
;
;	group:group_str
;		Put the message box window in the specified ahk group.
;		EX:  group:Group_MessageBox
;
;	parent:Hwnd
;		Specify parent window of msgbox.  Doing so will prevent a taskbar button and keep the
;		dialog on top of the specified parent.  Normally you will pass "Hwnd" as a var.
;		Ex:  options := "parent:" . HwndVar
;		>   In this example, the parent window is specified by the window handle value stored in
;		HwndVar.  This makes that window the parent, and also prevents a taskbar icon from showing.
;		This example is more specific to show how to properly use it in a script.
;
;	modal:Hwnd
;		Same effect as parent:Hwnd but also disables the parent window so that the user must click
;		a button or press ESC to continue.  If "modal:xxx" is specified then don't specify "parent:xxx".
;		Ex:  options := "modal:" . HwndVar
;
; ================================================================================================
; Styles
; ================================================================================================
; Specify additional options for the GUI.
;
;	Ex:  styles := "+MinimizeBox +SysMenu +AlwaysOnTop"
;
; ================================================================================================
; WinId
; ================================================================================================
; ByRef parameter. Put a blank variable in there to get back the message window handle.
;
;	Ex:  win := ""
;
; ================================================================================================


MsgBox2_New(p1:="",p2:="",p3:="",p4:="",byRef p5 := -1)
{
	return New Msgbox2(p1,p2,p3,p4,p5)
}


class msgbox2
{


__New(sMsg:="", sTitle:="", sOptions:="", sStyles:="",byRef WinId := -1)
{
	if (sMsg != "")
	{
		this.txt := sMsg
	}
	else
	{
		this.txt := "No Message"
	}

	if (sTitle != "")
	{
		this.title := sTitle
	}
	else
	{
		this.title := "No Title"
	}

	if (sOptions != "")
	{
		sOptions .= ","
	}
	this.options := sOptions

	if (sStyles != "")
	{
		sStyles := Trim(RegExReplace(sStyles, "i)(\-DPIScale|\+DPIScale|\-MaximizeBox|\+MaximizeBox|\+Border|\-SysMenu|\-MinimizeBox)", ""),"`r`n`t ")
	}
	this.styles := sStyles

	this.mButtonPress := ObjBindMethod(this,"ButtonPress")
	this.mTimerCheckParent := ObjBindMethod(this,"CheckParent")

	this.mSysCommand := ObjBindMethod(this,"SysCommand")
	mSysCommand := this.mSysCommand
	OnMessage(0x112,mSysCommand)

	this.criticalValue := A_IsCritical
	iconScale := A_ScreenDPI / 96
	Critical off

	; ================================================
	; == default user options - set as desired =======
	; ================================================
	this.fontFace := "Segoe UI"
	this.fontSize := 9

	this.btnDimsW := 70			; default button width
	this.btnDimsH := 11			; default button height

	this.btnMarXr := 3			; button X margin multiplier / [text width] + ([avg char width] * btnMarXr)
	this.btnMarYr := 1			; button Y margin multiplier / [text width] + ([avg char height] * btnMarYr)

	this.txtColor := "Default"
	this.bgColor := "Default"
	this.maxW := 350
	this.minW := 300
	this.maxH := 0

	iconHt := 32 * iconScale
	this.icon := this.PickIcon()
	this.iconTitle := this.PickIcon()

	this.btnTextW := false		; false = by default all buttons will be as wide as widest button
	this.selectable := false	; false = by default the message will be a text control, not an edit control
	this.rightMenuCopy := false
	this.btnAlign := "right"

	sPadR := 1.25				; sPadR is ratio to sPad ... sPad = fontSize * sParR / used for element spacing
	dlgMargin := 2				; dlgMargin is multiplier of sPad / this.dlgMargin = sPad * dlgMargin

	; ================================================
	; ==== default control settings ==================
	; ================================================
	this.checkMsg := ""
	this.checkMsgVal := 0
	this.dropListMsg := ""
	this.dropListMsgVal := 1
	this.editMsg := ""
	this.editBox := false
	this.comboMsg := ""
	this.comboMsgVal := 1
	this.listMsg := ""
	this.listVal := 1
	this.listRows := 0			; displayed rows will be automatic up to 10
	this.helpText := ""

	; ================================================
	; ==== suggested to NOT modify these defaults ====
	; ================================================
	this.btnDims := this.GetTextDims("Try Again",this.fontFace,this.fontSize)	; default button dims / no padding
	this.btnList := 0
	this.btnCount := 0
	this.btnDefault := 1
	this.bMWd := 0
	this.bMWc := 0
	this.helpDims := {}
	this.curMon := {}
	this.adjHeight := 0
	this.adjWidth := 0
	this.totalWidth := 0
	this.totalHeight := 0
	this.ctlWidth := 0
	this.ForcedWinWidth := 0
	this.ForcedWinHeight := 0
	this.modal := false
	this.hParent := 0
	this.parentX := ""
	this.parentY := ""
	this.parentW := ""
	this.parentH := ""
	this.groupName := ""

	; ================================================
	; ==== load function parameters ==================
	; ================================================

	DetectHiddenWindows, On

	errMsg := "Invalid Option`r`n`r`nopt:0 >  OK`r`nopt:1 >  OK / Cancel`r`nopt:2 >  Abort / Retry / Ignore`r`n"
	. "opt:3 >  Yes / No / Cancel`r`nopt:4 >  Yes / No`r`nopt:5 >  Retry / Cancel`r`nopt:6 >  Cancel / Try Again / Continue"

	optArr := StrSplit(this.options,",")
	Loop % optArr.Length()
	{

		curOptArr := StrSplit(optArr[A_Index],":")
		curOpt := curOptArr.HasKey(1) ? Trim(curOptArr[1]) : ""
		curVal2 := curOptArr.HasKey(2) ? Trim(curOptArr[2]) : ""
		curVal3 := curOptArr.HasKey(3) ? Trim(curOptArr[3]) : ""
		curVal4 := curOptArr.HasKey(4) ? Trim(curOptArr[4]) : ""
		curValFull := ""
		for i, el in curOptArr
		{
			if (i > 2)
			{
				curValFull .= ":" . el
			}
			else if (i > 1)
			{
				curValFull .= el
			}
		}

		If !curOpt
			Continue

		Else If (curOpt = "setWidth")
		{
			this.minW := curValFull ? curValFull : this.minW
			this.maxW := curValFull ? curValFull : this.maxW
		}
		If (curOpt = "MaxWidth")
		{
			this.maxW := curValFull ? curValFull : this.maxW
		}
		Else if (curOpt = "MaxHeight")
		{
			this.maxH := curValFull ? curValFull : this.maxH
		}

		Else if (curOpt = "ForcedWinWidth")
		{
			this.ForcedWinWidth := curValFull ? curValFull : this.ForcedWinWidth
		}
		Else if (curOpt = "ForcedWinHeight")
		{
			this.ForcedWinHeight := curValFull ? curValFull : this.ForcedWinHeight
		}

		Else if (curOpt = "btnDimsW")
		{
			this.btnDimsW := curValFull
		}
		Else if (curOpt = "btnDimsH")
		{
			this.btnDimsH := curValFull
		}

		Else If (curOpt = "modal")
		{
			this.hParent := WinExist("ahk_id " . curValFull)
			this.modal := true
		}
		Else If (curOpt = "parent")
		{
			this.hParent := WinExist("ahk_id " . curValFull)
		}

		Else if (curOpt = "group")
		{
			this.groupName := curValFull ? curValFull : this.groupName
		}
		Else If (curOpt = "icon")
		{
			this.icon := this.PickIcon(curValFull)
		}
		Else If (curOpt = "iconTitle")
		{
			this.iconTitle := this.PickIcon(curValFull)
		}

		Else If (curOpt = "btnList")
		{
			this.btnList := curValFull
		}
		Else If (curOpt = "edit")
		{
			this.editMsg := curValFull
			this.editBox := true
		}
		Else If (curOpt = "combo")
		{
			this.comboMsg := curVal2
			this.comboMsgVal := curVal3 ? curVal3 : this.comboMsgVal
		}
		Else If (curOpt = "dropList")
		{
			this.dropListMsg := curVal2
			this.dropListMsgVal := curVal3 ? curVal3 : this.dropListMsgVal
		}
		Else If (curOpt = "list")
		{
			this.listMsg := curVal2
			this.listMsgVal := curVal3 ? curVal3 : this.listMsgVal
			this.listRows := curVal4 ? curVal4 : this.listRows
		}
		Else If (curOpt = "check")
		{
			this.checkMsg := curVal2
			this.checkMsgVal := curVal3 ? curVal3 : this.checkMsgVal
		}
		Else If (curOpt = "help")
		{
			this.helpText := curValFull ? curValFull : "?"
		}

		Else If (curOpt = "btnAlign")
			this.btnAlign := (curValFull = "left" or curValFull = "right") ? curValFull : ""
		Else If (curOpt = "rightMenuCopy")
			this.rightMenuCopy := true
		Else If (curOpt = "selectable")
			this.selectable := true
		Else If (curOpt = "btnTextW")
			this.btnTextW := true
		Else If (curOpt = "ClassNN")
			this.btnClassNN := true

		Else If (curOpt = "fontFace")
			this.fontFace := curValFull ? curValFull : this.fontFace
		Else if (curOpt = "fontSize")
			this.fontSize := curValFull ? curValFull : this.fontSize
		Else If (curOpt = "txtColor")
			this.txtColor := curValFull ? curValFull : this.txtColor
		Else If (curOpt = "bgColor")
			this.bgColor := curValFull ? curValFull : this.bgColor

		Else If (curOpt = "btnMarXr")
			this.btnMarXr := curValFull ? curValFull : this.btnMarXr
		Else If (curOpt = "btnMarYr")
			this.btnMarYr := curValFull ? curValFull : this.btnMarYr
		Else If (curOpt = "sPadR")
			sPadR := curValFull ? curValFull : sPadR
		Else if (curOpt = "dlgMargin")
			dlgMargin := curValFull ? curValFull : dlgMargin

	}

	If (this.rightMenuCopy)
	{
		this.mRightClick := ObjBindMethod(this,"RightClickCopy")
		this.mContextMenu := ObjBindMethod(this,"ContextMenuCopy")
		mRightClick := this.mRightClick
		OnMessage(0x204,mRightClick)
	}

	parentX := parentY := parentW := parentH := 0
	If (this.hParent)
	{
		WinGetPos parentX, parentY, parentW, parentH, % "ahk_id " . this.hParent
		this.parentX := parentX
		this.parentY := parentY
		this.parentW := parentW
		this.parentH := parentH
	}
	this.curMon := this.GetMonitorData(parentX,parentY)					; props: left, right, top, bottom, x, y, Cx, Cy, w, h

	DetectHiddenWindows, Off

	testDims := this.GetTextDims("Testing 1 2 3",this.fontFace,this.fontSize)

	this.btnMarX := testDims.avgW * this.btnMarXr
	this.btnMarY := testDims.avgH * this.btnMarYr

	this.icon.h := iconHt
	this.icon.w := iconHt
	sPad := this.fontSize * sPadR
	this.sPad := sPad					; element spacing controlled ; w1.25 / h0.75
	this.dlgMargin := sPad * dlgMargin	; dialog margin

	btnList := this.btnList												; button list processing
	btnListTry := this.btnList + 0
	If (btnListTry = btnList And btnList >= 0 And btnList <= 6)			; btn config using pre-defined option
	{
		b := btnList
		btnList := (b=0) ? "OK" : ""
		btnList := (b=1) ? "OK|Cancel" : (b=4) ? "Yes|No" : (b=5) ? "Retry|Cancel" : btnList
		btnList := (b=2) ? "Abort|Retry|Ignore" : (b=3) ? "Yes|No|Cancel" : (b=6) ? "Cancel|Try Again|Continue" : btnList
		this.btnList := btnList
	}
	Else If (btnListTry = btnList And (btnList < 0 Or btnList > 6))		; invalid option specified
	{
		MsgBox errMsg
		this.__Delete()
		return
	}

	if (this.btnDimsW)
	{
		this.btnDims.w := this.btnDimsW
	}
	if (this.btnDimsH)
	{
		this.btnDims.h := this.btnDimsH
	}

	bW := this.btnDims.w
	bH := this.btnDims.h
	bMW := 0
	btnListW := []
	Loop Parse, btnList, | 		; initial parsing of btnList
	{
		If (A_LoopField = "")
			Continue
		
		btnText := RegExReplace(A_LoopField,"\[[\w]+\]$","")
		btnProp := RegExReplace(A_LoopField,"^[^\[]+|\[|\]","")
		this.btnDefault := (btnProp = "d") ? A_Index : this.btnDefault
		btnDims := this.GetTextDims(btnText,this.fontFace,this.fontSize)
		
		this.btnDims := (btnDims.w > this.btnDims.w) ? btnDims : this.btnDims
		bMW += btnDims.w + this.btnMarX
		btnListW.InsertAt(A_Index,btnDims.w)
		
		btnCount := A_Index
		btnDims := ""
	}
	this.btnCount := btnCount
	this.btnListW := btnListW	; list of custom button widths / no padding

	this.bMWd := btnCount * (this.btnDims.w + this.btnMarX)		; bMW default (all btns same width)
	this.bMWc := bMW											; bMW custom (btnTextW)

	If (this.helpText) {
		this.helpDims := this.GetTextDims(this.helpText,this.fontFace,this.fontSize)
		this.bMWd += this.helpDims.w + this.btnMarX
		this.bMWc += this.helpDims.w + this.btnMarX
	}

	this.MakeGui(1,WinId)
}


__Delete()		; release input hook, destroy GUI, etc...
{
	this.gui := ""
	this.IH := ""
	this := ""
}


MakeGui(ver, byRef Win := -1)
{
	icon := this.icon
	txt := this.txt
	edit := {}, dropList := {}, check := {}, msg := {}, combo := {}, list := {}
	edit.hwnd := 0, dropList.hwnd := 0, check.hwnd := 0, msg.hwnd := 0, combo.hwnd := 0, list.hwnd := 0
	SysGet vScrollW, 2
	SysGet hCaption, 4
	SysGet winFrame, 8
	sPad := this.sPad
	ctlWidth := this.ctlWidth
	totalWidth := this.totalWidth
	totalHeight := this.totalHeight
	dMar := this.dlgMargin

	If (!ctlWidth)
	{
		msg := this.GetTextDims(this.txt,this.fontFace,this.fontSize,this.maxW)
		ctlWidth := msg.w
	}
	Else
	{
		msg := this.GetTextDims(this.txt,this.fontFace,this.fontSize,ctlWidth)
	}

	Gui, New, % "+HwndGuiHwnd -DPIScale +Border -SysMenu -MaximizeBox -MinimizeBox", % this.title
	Gui, Margin, % dMar, % dMar
	this.hwnd := GuiHwnd
	Gui, Color, % this.bgColor
	Gui, Font, % "s" this.fontSize, % this.fontFace

	If (icon.file)
	{
		iconOptions := "+HwndIconHwnd xm ym h" icon.h " w-1" (icon.num ? " Icon" icon.num : "")
		Gui, Add, Picture, % iconOptions, % icon.file
		icon.hwnd := IconHwnd
		GuiControlGet, i, Pos, % IconHwnd
		icon.h := iH, icon.w := iW, icon.x := iX, icon.y := iY, this.icon := icon
	}

	adjHeight := this.adjHeight, adjWidth := this.adjWidth
	mX := (icon.file) ? "xm+" (icon.w + sPad) : "xm"
	mY := (icon.file And msg.h < icon.h) ? " ym+" ((icon.h/2) - (msg.h/2)) : " ym"
	mH := (!this.selectable) ? (msg.h - adjHeight) : (msg.h - adjHeight) + 8
	mW := (!this.selectable) ? msg.w - (adjWidth + dMar*2) : msg.w - (adjWidth + dMar*2) + (msg.avgW * 4)
	ctlWidth := (ctlWidth > mW) ? ctlWidth : mW

	selOps := "+HwndMsgHwnd " . mX . mY . " h" . mH . " w" . ctlWidth . " +Background" . this.bgColor . " c" . this.txtColor . (this.selectable ? " ReadOnly" : "")
	If (this.selectable)
	{
		Gui, Add, Edit, %selOps%
		GuiControl, , %MsgHwnd%, %txt%
	}
	Else
	{
		Gui, Add, Text, %selOps%, %txt%
	}
	GuiControlGet, m, Pos, % MsgHwnd
	msg.x := mX, msg.y := mY, msg.h := mH, msg.w := mW, msg.hwnd := MsgHwnd
	newY := (msg.h > icon.h) ? (dMar + msg.h + sPad) : (dMar + icon.h + sPad)

	if (this.listMsg)
	{
		listMsg := this.listMsg
		listArr := StrSplit(this.listMsg,"|")
		Loop Parse, listMsg, |
		{
			listDims := this.GetTextDims(A_LoopField,this.fontFace,this.fontSize,0)
			ctlWidth := (listDims.w + (vScrollw * 1.5) > ctlWidth) ? listDims.w + (vScrollW * 1.5) : ctlWidth
		}
		listRows := (listArr.Length() > 10 And !this.listRows) ? 10 : this.listRows, listArr := ""
		Gui, Add, Listbox, % "+HwndListHwnd AltSubmit xp y" newY " w" ctlWidth " Choose" this.listMsgVal " r" listRows, % this.listMsg
		GuiControlGet, L, Pos, % ListHwnd
		list.x := LX, list.y := LY, list.w := LW, list.h := LH, list.hwnd := ListHwnd
		newY += list.h + sPad
	}

	if (this.editBox)
	{
		editDims := this.GetTextDims(this.editMsg,this.fontFace,this.fontSize,0)
		ctlWidth := (editDims.w + vScrollW > ctlWidth) ? editDims.w + vScrollW : ctlWidth
		
		Gui, Add, Edit, +HwndEditHwnd xp y%newY% w%ctlWidth% r1, % this.editMsg
		GuiControlGet, e, Pos, % EditHwnd
		edit.x := eX, edit.y := eY, edit.w := eW, edit.h := eH, edit.hwnd := EditHwnd
		newY += edit.h + sPad
	}

	If (this.dropListMsg)
	{
		dropListMsg := this.dropListMsg
		Loop Parse, dropListMsg, |
		{
			dropListDims := this.GetTextDims(A_LoopField,this.fontFace,this.fontSize,0)
			ctlWidth := (dropListDims.w + (vScrollw * 1.5) > ctlWidth) ? dropListDims.w + (vScrollW * 1.5) : ctlWidth
		}
		
		Gui, Add, DropDownList, % "+HwndDropListHwnd AltSubmit xp y" newY " w" ctlWidth " Choose" this.dropListMsgVal, % this.dropListMsg
		GuiControlGet, L, Pos, % DropListHwnd
		dropList.x := LX, dropList.y := LY, dropList.w := LW, dropList.h := LH, dropList.hwnd := DropListHwnd
		newY += dropList.h + sPad
	}

	if (this.comboMsg)
	{
		comboMsg := this.comboMsg
		Loop Parse, comboMsg, |
		{
			comboDims := this.GetTextDims(A_LoopField,this.fontFace,this.fontSize,0)
			ctlWidth := (comboDims.w + (vScrollw * 1.5) > ctlWidth) ? comboDims.w + (vScrollW * 1.5) : ctlWidth
		}
		
		Gui, Add, ComboBox, % "+HwndComboHwnd AltSubmit xp y" newY " w" ctlWidth " Choose" this.comboMsgVal, % this.comboMsg
		GuiControlGet, co, Pos, % ComboHwnd
		combo.x := coX, combo.y := coY, combo.w := coW, combo.h := coH, combo.hwnd := ComboHwnd
		newY += combo.h + sPad
	}

	If (this.checkMsg)
	{
		Gui, Add, Checkbox, % "+HwndCheckHwnd xp y" newY, % this.checkMsg
		
		GuiControl, , %CheckHwnd%, % this.checkMsgVal
		GuiControlGet, c, Pos, % CheckHwnd
		check.x := cX, check.y := cY, check.w := cW, check.h := cH, check.hwnd := CheckHwnd
		
		ctlWidth := (check.w > ctlWidth) ? check.w : ctlWidth
		newY += check.h + sPad
	}

	this.ctrls := {}
	this.ctrls.msg := msg, this.ctrls.edit := edit, this.ctrls.dropList := dropList
	this.ctrls.check := check, this.ctrls.combo := combo, this.ctrls.list := list

	bMW := (this.btnTextW) ? this.bMWc : this.bMWd

	If (this.btnAlign = "center")
		btnX := (totalWidth) ? (totalWidth/2) - (bMW/2) : 0
	Else If (this.btnAlign = "right")
		btnX := (totalWidth) ? totalWidth - bMW - dMar : 0
	Else if (this.btnAlign = "left")
		btnX := (totalWidth) ? dMar : 0

	btnList := this.btnList
	btnDefault := this.btnDefault
	btnListW := this.btnListW
	btnDims := this.btnDims
	bMX := this.btnMarX
	bMY := this.btnMarY

	newY += 12				; add some margin on top of buttons

	mButtonPress := this.mButtonPress
	Loop Parse, btnList, |	; list specified buttons
	{
		If (A_LoopField)	; make sure button exists, helpful on zero-length string
		{
			btnText := RegExReplace(A_LoopField,"\[[\w]+\]$","")			
			xy := (A_Index = 1) ? "x" (!btnX ? "m" : btnX) " y" newY : "x+9"
			bWS := this.btnTextW ? " w" (btnListW[A_Index] + bMX) : " w" (btnDims.w + bMX)
			def := (A_Index = btnDefault) ? " +Default" : ""
			curOpts := "+HwndBtnHwnd" A_Index " " xy bWS " h" (btnDims.h + bMY) def
			
			Gui, Add, Button, % curOpts, % btnText
			
			hwndVar := BtnHwnd%A_Index%
			GuiControlGet, b, Pos, %hwndVar%
			GuiControl, +g, %hwndVar%, % mButtonPress
		}
	}

	this.ctlWidth := ctlWidth
	helpDims := this.helpDims, helpText := this.helpText
	If (helpText)
	{
		curOpts := "+HwndHelpHwnd x+0 w" (helpDims.w + bMX) " h" (helpDims.h + bMY)
		Gui, Add, Button, % curOpts, % helpText
		GuiControl, +g, %HelpHwnd%, % mButtonPress
	}

	If (ver = 1)
	{
		hwnd := this.hwnd
		curOpts := "h" (bY + bH + sPad) " Hide"
		Gui, %hwnd%:Show, % curOpts

		DetectHiddenWindows, On
		client := this.WinGetClient(hwnd)
		DetectHiddenWindows, Off

		tempMaxW := this.curMon.w * 0.95, tempMaxH := this.curMon.h * 0.95
		this.maxH := (!this.maxH) ? tempMaxH : (this.maxH > tempMaxH) ? tempMaxH : this.maxH
		this.maxW := (!this.maxW) ? tempMaxW : (this.maxW > tempMaxW) ? tempMaxW : this.maxW
		minW := this.minW, maxW := this.maxW, maxH := this.maxH

		totalWidth := (client.w > maxW) ? maxW : (client.w < minW) ? minW : client.w
		totalWidth := (bMW > totalWidth) ? bMW + dMar : totalWidth
		ctlWidthAdj := (icon.file) ? (dMar*2 + sPad) + (icon.w) : (dMar*2)
		totalWidth := (ctlWidth + ctlWidthAdj > totalWidth) ? ctlWidth + ctlWidthAdj : totalWidth
		totalHeight := (client.h > maxH And maxH) ? maxH : client.h
		ctlWidthAdj := (icon.file) ? sPad + icon.w : 0
		ctlWidth := (bMW - ctlWidthAdj > ctlWidth) ? bMW - ctlWidthAdj : ctlWidth
		If (ctlWidth > tempMaxW Or (ctlWidth + ctlWidthAdj + sPad*2) > tempMaxW)
		{
			ctlWidth := tempMaxW - ctlWidthAdj
			totalWidth := tempMaxW
		}
		adjWidth := (client.w - totalWidth < 0)  ? 0 : client.w - totalWidth
		adjHeight := (client.h - totalHeight < 0) ? 0 : client.h - totalHeight

		this.totalWidth := totalWidth
		this.totalHeight := totalHeight
		this.adjWidth := adjWidth
		this.adjHeight := adjHeight
		this.ctlWidth := ctlWidth

		Gui, % hwnd . ":Destroy"
		this.MakeGui(++ver,Win)
	}
	Else
	{
		hwnd := this.hwnd
		hParent := this.hParent
		groupName := this.groupName

		DetectHiddenWindows, On

		if (Win != -1)
		{
			Win := hwnd
		}
		if (groupName)
		{
			GroupAdd, % groupName, % "ahk_id " . hwnd
		}

		If (hParent)
		{
			WinShow, % "ahk_id " . hParent
			WinActivate, % "ahk_id " . hParent
			Gui, % "+Owner" . hParent
			If (this.modal)
			{
				WinSet, Disable,, % "ahk_id " . hParent
			}
		}

		h := this.totalHeight + 3
		w := this.totalWidth - 18 + (this.btnCount * 10)
		if (this.ForcedWinWidth)
		{
			w := this.ForcedWinWidth
		}
		if (this.ForcedWinHeight)
		{
			h := this.ForcedWinHeight
		}

		Gui, % hwnd . ":Show", % "x0 y0 w" . w . " h" . h . " Hide"

		if (this.iconTitle.file && this.iconTitle.num)								; set titlebar icon
		{
			TTLHICON := DllCall("Shell32\ExtractAssociatedIconA", UInt, 0, AStr, this.iconTitle.file, UShortP, this.iconTitle.num)
			SendMessage, 0x80, 0, TTLHICON , , % "ahk_id " . hwnd
			SendMessage, 0x80, 1, TTLHICON , , % "ahk_id " . hwnd
		}
		else if (this.iconTitle.file)
		{
			TTLHICON := DllCall("LoadImage", Uint, 0, Str, this.iconTitle.file, Uint, 1, int, 0, int, 0, uint, 0x10)
			SendMessage, 0x80, 0, TTLHICON , , % "ahk_id " . hwnd
			SendMessage, 0x80, 1, TTLHICON , , % "ahk_id " . hwnd
		}

		if (this.styles)
		{
			Gui, % hwnd . ":" . this.styles
		}

		curMon := this.curMon	; props: left, right, top, bottom, x, y, Cx, Cy, w, h
		WinGetPos, x, y, w, h, % "ahk_id " . hwnd
		Gui, % hwnd . ":Show", % "x" . curMon.Cx - (w/2) . " y" . y := curMon.Cy - (h/2)

		HSYSMENU := DllCall("GetSystemMenu", "Ptr", hwnd, "UInt", 0, "UPtr")		; remove some items from sysmenu (title bar menu)
		DllCall("DeleteMenu", "Ptr", HSYSMENU, "UInt", 0xF030, "UInt", 0)			; Remove MAXIMIZE
		DllCall("DeleteMenu", "Ptr", HSYSMENU, "UInt", 0xF000, "UInt", 0)			; Remove SIZE
		if ( !InStr(this.styles, "+MinimizeBox") )
		{
			DllCall("DeleteMenu", "Ptr", HSYSMENU, "UInt", 0xF020, "UInt", 0)		; Remove MINIMIZE
			DllCall("DeleteMenu", "Ptr", HSYSMENU, "UInt", 0xF120, "UInt", 0)		; Remove RESTORE
		}

		btnDefault := this.btnDefault
		btnDefault := (this.checkMsg) ? btnDefault += 1 : btnDefault
		GuiControl, % hwnd . ":Focus", "Button" . btnDefault

		DetectHiddenWindows, Off

		If (hParent)
		{
			timer := this.mTimerCheckParent
			SetTimer, % timer, 100
		}

		this.mIHKeyDown := ObjBindMethod(this,"IHKeyDown")
		mIHKeyDown := this.mIHKeyDown
		this.mIHKeyUp   := ObjBindMethod(this,"IHKeyUp")
		mIHKeyUp := this.mIHKeyUp
		
		IH := InputHook("V")	; "V" for not blocking input
		this.IH := IH
		this.IH.KeyOpt("{BackSpace}{Escape}{Enter}{Space}{NumpadEnter}{F4}{q}","N")
		this.IH.OnKeyDown := mIHKeyDown
		this.IH.OnKeyUp := mIHKeyUp
		this.IH.Start(), this.IH.Wait()
	}
}


PickIcon(iconFile:="")
{
	iconObj := {}
	iconObj.file := ""
	iconObj.num := ""
	if (iconFile)
	{
		f := "imageres.dll/"
		t := iconFile
		r := (t = "error") ? "e" : (t = "question") ? "q" : (t = "warning") ? "w" : (t = "info") ? "i" : ""
		iconFile := (r="e") ? f "94" : (r="q") ? f "95" : (r="w") ? f "80" : (r="i") ? f "77" : iconFile
		iArr := StrSplit(iconFile,"/")
		iconObj.file := iArr.HasKey(1) ? iArr[1] : ""
		iconObj.num := iArr.HasKey(2) ? iArr[2] : ""
		iArr := ""
	}
	return iconObj
}


SysCommand(wParam, lParam, msg, hwnd)
{
	If (hwnd = this.hwnd)
	{
		if (wParam = 0xF060)			; on window close
		{
			this.procResult()
		}
		else if (wParam = 0xF093)		; on title bar icon leftclick
		{
			return false
		}
	}
}


ButtonPress(CtrlHwnd, GuiEvent, EventInfo)
{
	GuiControlGet, ctlClassNN, Focus
	GuiControlGet, ctlText, , % CtrlHwnd
	bR := Array(ctlText,ctlClassNN)
	this.procResult(bR)
}


RightClickCopy(wParam, lParam, msg, hwnd)
{
	If (hwnd = this.hwnd)
	{
		x := lParam & 0xff
		y := (lParam >> (A_PtrSize * 2)) & 0xff
		
		mContextMenu := this.mContextMenu
		
		Menu, MsgBox2Menu, Add, Copy Message, % mContextMenu
		Menu, MsgBox2Menu, Show
	}
}


ContextMenuCopy(ItemName, ItemPos, MenuName)
{
	clipboard := Trim(this.txt,"`r`n`t ")
}


CheckParent()
{
	timer := ""
	DetectHiddenWindows, On
	if ( !WinExist("ahk_id " . this.hParent) )
	{
		timer := this.mTimerCheckParent
	}
	DetectHiddenWindows, Off
	if ( this.hwnd && !WinExist("ahk_id " . this.hwnd) )
	{
		timer := this.mTimerCheckParent
	}
	if (timer)
	{
		SetTimer, % timer, off
		this.procResult()
	}
}


IHKeyDown(iHook, VK, SC)
{
	; nothing here
}


IHKeyUp(iHook, VK, SC)
{
	curKey := Format("{:X}",VK)
	If (WinActive("ahk_id " . this.hwnd))
	{
		If (curKey = 73 And (GetKeyState("Alt") Or GetKeyState("Ctrl")))	; ALT/CTRL+F4
			this.procResult()
		Else If (curKey = 51 And GetKeyState("Ctrl"))						; CTRL+Q
			this.procResult()
		Else If (VK = 27)													; ESC
			this.procResult()
	}
}


procResult(bR:="")
{
	hParent := this.hParent
	modal := this.modal

	if ( hParent && WinExist("ahk_id " . hParent) )
	{
		if (modal)
		{
			WinSet, Enable, , % "ahk_id " . hParent		; re-enable hParent if modal was used
		}
		WinActivate, % "ahk_id " . hParent				; ALT+F4 seems to send hParent to background
	}

	timer := this.mTimerCheckParent
	SetTimer, % timer, off

	If (!this.hwnd)
	{
		return
	}

	bR := !bR ? ["",""] : bR
	this.edit := ""
	this.dropList := 0
	this.check := 0
	this.combo := 0

	If (this.ctrls.edit.hwnd)
	{
		GuiControlGet, editValue,, % this.ctrls.edit.hwnd
		this.edit := editValue
	}
	If (this.ctrls.dropList.hwnd)
	{
		GuiControlGet, dropListValue,, % this.ctrls.dropList.hwnd
		this.dropList := dropListValue
		a := StrSplit(this.dropListMsg,"|"), dropListText := a[dropListValue], a := ""
		this.dropListText := dropListText
	}
	If (this.ctrls.combo.hwnd)
	{
		GuiControlGet, comboValue,, % this.ctrls.combo.hwnd
		this.combo := comboValue
		a := StrSplit(this.comboMsg,"|"), comboText := a[comboValue], a := ""
		If (comboValue + 0 = comboValue)
			this.comboText := comboText
		Else
			this.comboText := comboValue
	}
	If (this.ctrls.check.hwnd)
	{
		GuiControlGet, checkValue,, % this.ctrls.check.hwnd
		this.check := checkValue
	}
	If (this.ctrls.list.hwnd)
	{
		GuiControlGet, listValue,, % this.ctrls.list.hwnd
		this.list := listValue
		a := StrSplit(this.listMsg,"|"), listText := a[listValue], a := ""
		If (listValue + 0 = listValue)
			this.listText := listText
		Else
			this.listText := listValue
	}

	this.button := bR[1]
	this.ClassNN := bR[2]

	this.IH.Stop()

	Gui, % this.hwnd . ":Destroy"
	this.hwnd := 0

	crit := this.criticalValue
	Critical, %crit%
}


WinGetClient(hwnd)
{
	; ======================================================================
	; posted by uname on 26 March 2016 @ 10:55 AM
	; URL: https://autohotkey.com/board/topic/91733-command-to-get-gui-client-areas-sizes/#entry578584
	; ======================================================================
	if (WinExist("ahk_id " . hwnd))
	{
		VarSetCapacity(rect, 16, 0)
		DllCall("GetClientRect", "Ptr", hwnd, "Ptr", &rect)
		width := NumGet(rect, 8, "Int")
		height := NumGet(rect, 12, "Int")
		client := {}, client.w := width, client.h := height
		return client
	}
}


GetMonitorData(x:="", y:="")
{
	; ===========================================================================
	; created by TheArkive
	; Usage: Specify X/Y coords to get info on which monitor that point is on,
	;        and the bounds of that monitor.  If no X/Y is specified then the
	;        current mouse X/Y coords are used.
	; ===========================================================================
	curMon := {}

	saveCoordModeMouse := A_CoordModeMouse
	CoordMode Mouse, Screen
	If (x = "" || x < 0 || y = "" || y < 0 )
		MouseGetPos x, y

	SysGet, monCount, MonitorCount
	Loop % monCount
	{
		SysGet, m, Monitor, %A_Index%
		
		If (mLeft = "" And mTop = "" And mRight = "" And mBottom = "")
			Continue
		
		If (x >= (mLeft) And x <= (mRight-1) And y >= mTop And y <= (mBottom-1))
		{
			curMon.left := mLeft
			curMon.right := mRight
			curMon.top := mTop
			curMon.bottom := mBottom
			curMon.active := A_Index
			curMon.x := x
			curMon.y := y
			curMon.Cx := ((mRight - mLeft) / 2) + mLeft
			curMon.Cy := ((mBottom - mTop) / 2) + mTop
			curMon.w := mRight - mLeft, curMon.h := mBottom - mTop
			Break
		}
	}

	CoordMode Mouse, %saveCoordModeMouse%
	return curMon
}


GetTextDims(r_Text,sFaceName,nHeight,maxWidth:=0)
{
	; ======================================================================
	; modified from Fnt_Library v3 posted by jballi
	; https://www.autohotkey.com/boards/viewtopic.php?f=6&t=4379
	; original function(s) = Fnt_CalculateSize() / Fnt_GetAverageCharWidth()
	; ======================================================================
	Static Dummy57788508, DEFAULT_GUI_FONT:=17, HWND_DESKTOP:=0, MAXINT:=0x7FFFFFFF, OBJ_FONT:=6, SIZE

	cbd := ""
	hDC := DllCall("GetDC", "Ptr", HWND_DESKTOP) ; "UInt" or "Ptr" ?
	devCaps := DllCall("GetDeviceCaps", "Uint", hDC, "int", 90)
	nHeight := -DllCall("MulDiv", "int", nHeight, "int", devCaps, "int", 72)

	bBold := False, bItalic := False, bUnderline := False, bStrikeOut := False, nCharSet := 0

	hFont := DllCall("CreateFont", "int", nHeight, "int", 0 ; get specified font handle
				   , "int", 0, "int", 0, "int", 400 + 300 * bBold
				   , "Uint", bItalic, "Uint", bUnderline, "Uint"
				   , bStrikeOut, "Uint", nCharSet, "Uint", 0, "Uint"
				   , 0, "Uint", 0, "Uint", 0, "str", sFaceName)

	hFont := !hFont ? DllCall("GetStockObject","Int",DEFAULT_GUI_FONT) : hFont ; load default font if invalid

	VarSetCapacity(SIZE,8,0) ;-- Initialize

	l_LeftMargin:=0, l_RightMargin:=0, l_TabLength:=0, r_Width:=0, r_Height:=0
	l_Width := (!maxWidth) ? MAXINT : maxWidth
	l_DTFormat := 0x400|0x10 ; DT_CALCRECT (0x400) / DT_WORDBREAK (0x10)

	VarSetCapacity(DRAWTEXTPARAMS,20,0) ;-- Create and populate DRAWTEXTPARAMS structure
	NumPut(20,           DRAWTEXTPARAMS,0,"UInt")       ;-- cbSize
	NumPut(l_TabLength,  DRAWTEXTPARAMS,4,"Int")        ;-- iTabLength
	NumPut(l_LeftMargin, DRAWTEXTPARAMS,8,"Int")        ;-- iLeftMargin
	NumPut(l_RightMargin,DRAWTEXTPARAMS,12,"Int")       ;-- iRightMargin

	VarSetCapacity(RECT,16,0) ;-- Create and populate the RECT structure
	NumPut(l_Width,RECT,8,"Int")                        ;-- right

	old_hFont:=DllCall("SelectObject","Ptr",hDC,"Ptr",hFont)

	testW := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz" ; taken from Fnt_GetAverageCharWidth()
	RC := DllCall("GetTextExtentPoint32","Ptr",hDC,"Str",testW,"Int",StrLen(testW),"Ptr",&SIZE)
	RC := RC ? NumGet(SIZE,0,"Int") : 0
	avgCharWidth := Floor((RC/26+1)/2)
	avgCharHeight := NumGet(SIZE,4,"Int")

	VarSetCapacity(l_Text,VarSetCapacity(r_Text)+16,0), l_Text:=r_Text ;-- Create a buffer + 16 bytes

	DllCall("DrawTextEx"
		,"Ptr",hDC                                      ;-- hdc [in]
		,"Str",l_Text                                   ;-- lpchText [in, out]
		,"Int",-1                                       ;-- cchText [in]
		,"Ptr",&RECT                                    ;-- lprc [in, out]
		,"UInt",l_DTFormat                              ;-- dwDTFormat [in]
		,"Ptr",&DRAWTEXTPARAMS)                         ;-- lpDTParams [in]

	DllCall("SelectObject","Ptr",hDC,"Ptr",old_hFont), DllCall("ReleaseDC","Ptr",HWND_DESKTOP,"Ptr",hDC) ; avoid memory leak

	NumPut(r_Width:=NumGet(RECT,8,"Int"),SIZE,0,"Int")
	NumPut(r_Height:=NumGet(RECT,12,"Int"),SIZE,4,"Int")

	retVal := {}
	retVal.h := r_Height
	retVal.w := r_Width
	retVal.cbd := cbd
	retVal.avgW := avgCharWidth
	retVal.avgH := avgCharHeight
	retVal.addr := &SIZE

	return retVal
}


}
#NoEnv
SendMode Input
#SingleInstance, Ignore

winId := ""
messOptions := "icon:" . "shell32.dll/150" . ",iconTitle:" . "shell32.dll/40" . ",SetWidth:400,group:mygroup,modal:" . winexist("A")
messStyles := "+SysMenu"

if (MsgBox2_New(,,messOptions,messStyles,winId).button = "ok")
{
	msgbox clicked1!
}

sleep 500

winId := ""
messOptions := "icon:" . "imageres.dll/150" . ",iconTitle:" . "wmploc.dll/20" . ",SetWidth:250,group:mygroup"
messStyles := "+MinimizeBox +AlwaysOnTop"

if (MsgBox2_New(,,messOptions,messStyles,winId).button = "ok")
{
	msgbox clicked2!
}


ExitApp

Return


#If ( WinActive("ahk_id " . winId) )
w::
msgbox hi winid
return
#If


#IfWinActive, ahk_group mygroup
g::
msgbox hi groupz
return
#If