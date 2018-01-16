﻿#SingleInstance Force
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
	
	if(loopbreak == 0)
		loopbreak = 1
	else
		loopbreak = 0
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

MakeNoxActiveWindow()
{
	WinActivate, ahk_group Nox
	Sleep, 1000
}

GetNoxPositions()
{
	if(VerifyIfNoxIsOpen())
	{
		MakeNoxActiveWindow()
		Sleep, 500
		WinGetPos, topLeftX, topLeftY, width, height, ahk_group Nox
		Sleep, 500
		Click, 232, 335
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
	ImageSearch, swordMenuMinimizedX, swordMenuMinimizedY, 5, 664, 60, 689, SwordMenuMinimized.png
	while(!ErrorLevel)
	{
		ReOpenSwordMasterMenu()
		Send, {down}
		Sleep, 2000
	}

	Click, 330, 510
}

TimeToPrestige()
{
	global elapsedTime
	global startTime
	
	elapsedTime := A_TickCount - startTime
	
	if(elapsedTime > 1200000)
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

	Click, %prestigeX%, %prestigeY%
	Sleep, 1000
	ImageSearch, prestigeX, prestigeY, 139, 522, 261, 569, *200 Prestige.png
	Click, %prestigeX%, %prestigeY%
	Sleep, 1000
	ImageSearch, prestigeX, prestigeY, 210, 444, 331, 495, *200 ConfirmPrestige.png
	Click, %prestigeX%, %prestigeY%
	Sleep, 10000
	
	prestigeX = 0
	prestigeY = 0
	ReOpenSwordMasterMenu()
}

ReOpenSwordMasterMenu()
{
	global elapsedTime
	global startTime
	
	Click, 32, 672
	Sleep, 500
	Send, {down}
	Sleep, 2000
	
	elapsedTime = 0
	startTime = %A_TickCount%
	
	LevelUpSwordMaster()
}

Tap()
{
	Send, {Space}
	Sleep, 500
}

Start()
{
	global loopbreak
	
	LoadEssentials()
	while(true)
	{
		if(loopbreak < 1 and WinActive("ahk_group Nox"))
		{
			Tap()
			LevelUpSwordMaster()

			if(TimeToPrestige())
			{
				Prestige()
			}
		}
		else if(not WinActive("ahk_group Nox"))
		{
			MakeNoxActiveWindow()
		}
		else
		{
			Sleep, 500
		}
	}
}


*ESC::ExitApp