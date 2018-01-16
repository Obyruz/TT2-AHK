#SingleInstance Force
SetWorkingDir, %A_ScriptDir%
CoordMode, Mouse, relative
CoordMode, Pixel, relative
DetectHiddenWindows, On
SetTitleMatchMode, 2
#WinActivateForce
SetControlDelay 1
SetWinDelay 0
SetKeyDelay -1
SetMouseDelay -1
SetBatchLines -1

GroupAdd, Nox, ahk_class Qt5QWindowIcon

Gui,2:+AlwaysOnTop
Gui,2:Add,Button,x10 y10 w200 h20 gStart, Tap'N'Prestige
Gui,2:Add,Button,x10 w200 h20 g2GuiClose, Close
Gui,2:Add,Text,, Press F11 to stop tapping.
Gui,2:Show,x1000 y200
return

2GuiClose:
	ExitApp
	
Find_Image:
	return

loopbreak = 0
startTime = 0
elapsedTime = 0

F11::
{
	global loopbreak
	loopbreak = 1
}

VerifyIfNoxIsOpen()
{
	if(WinExist("ahk_group Nox"))
	{
		return 1
	}
	else
	{
		MsgBox, Nox isn't open or it couldn't become the active screen.
		return 0
	}
}

MakeNoxActiveScreen()
{
	WinActivate, ahk_group Nox
	Sleep, 1000
}

GetNoxPositions()
{
	if(VerifyIfNoxIsOpen())
	{
		WinGetPos, topLeftX, topLeftY, width, height, ahk_group Nox
		Sleep, 500
		ControlClick,,,"ahk_group Nox",,, x232 y335
	}
}

LoadEssentials()
{
	global startTime
	GetNoxPositions()
	startTime = %A_TickCount%
}

LevelUpSwordMaster()
{
	ControlClick,,,"ahk_group Nox",,, x330 y510
}

TimeToPrestige()
{
	global elapsedTime
	global startTime
	
	elapsedTime := A_TickCount - startTime
	
	if(elapsedTime > 3000)
	{
		return 1
	}
	return 0
}

Prestige()
{
	SendInput, {Up}
	Sleep, 3000
	ImageSearch, prestigeX, prestigeY, 245, 565, 393, 658, *200 OpenPrestigeMenu.png

	if(%prestigeX% == 0 or %prestigeY% == 0)
	{
		Sleep, 1000
		Prestige()
	}

	ControlClick,,,"ahk_group Nox",,, x%prestigeX% y%prestigeY%
	Sleep, 1000
	ImageSearch, prestigeX, prestigeY, 139, 522, 261, 569, *200 Prestige.png
	ControlClick,,,"ahk_group Nox",,, x%prestigeX% y%prestigeY%
	Sleep, 1000
	ImageSearch, prestigeX, prestigeY, 210, 444, 331, 495, *200 ConfirmPrestige.png
	ControlClick,,,"ahk_group Nox",,, x%prestigeX% y%prestigeY%
	Sleep, 10000
	
	prestigeX = 0
	prestigeY = 0
	ReOpenSwordMasterMenu()
}

ReOpenSwordMasterMenu()
{
	global elapsedTime
	global startTime
	
	ControlClick,,,"ahk_group Nox",,, x32 y672
	Sleep, 500
	ControlSend,, {down},"ahk_group Nox"
	Sleep, 2000
	ControlSend,, {down},"ahk_group Nox"
	Sleep, 2000
	
	elapsedTime = 0
	startTime = %A_TickCount%
	
	LevelUpSwordMaster()
}

Tap()
{
	ControlSend,, {Space},"ahk_group Nox"
	Sleep, 500
}

Start()
{
	global loopbreak
	
	LoadEssentials()
	while(loopbreak < 1)
	{
		Tap()
		LevelUpSwordMaster()

		if(TimeToPrestige())
		{
			Prestige()
		}
	}
}


*ESC::ExitApp