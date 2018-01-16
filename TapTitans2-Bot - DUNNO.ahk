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
		MakeNoxActiveScreen()
		Sleep, 1000
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
	Click, 330, 510
}

TimeToPrestige()
{
	global elapsedTime
	global startTime
	
	elapsedTime := A_TickCount - startTime
	
	if(elapsedTime > 10000)
	{
		return 1
	}
	return 0
}

Prestige()
{
	menuPrestigeX = 0
	menuPrestigeY = 0
	prestigeX = 0
	prestigeY = 0
	confirmPrestigeX = 0
	confirmPrestigeY = 0

	while(%menuPrestigeX% == 0 and %menuPrestigeY% == 0)
	{
		SendInput, {Up}
		Sleep, 2000
		ImageSearch, menuPrestigeX, menuPrestigeY, 245, 565, 393, 658, *200 OpenPrestigeMenu.png
	}
	
	while(%prestigeX% == 0 and %prestigeY% == 0)
	{
		Click, %menuPrestigeX%, %menuPrestigeY%
		Sleep, 500
		ImageSearch, prestigeX, prestigeY, 139, 522, 261, 569, *200 Prestige.png
	}
	
	while(%confirmPrestigeX% == 0 and %confirmPrestigeY% == 0)
	{
		Click, %prestigeX%, %prestigeY%
		Sleep, 500
		ImageSearch, confirmPrestigeX, confirmPrestigeY, 210, 444, 331, 495, *200 ConfirmPrestige.png
	}
	
	menuPrestigeX = 0
	menuPrestigeY = 0
	prestigeX = 0
	prestigeY = 0
	confirmPrestigeX = 0
	confirmPrestigeY = 0
	
	ImageSearch, confirmPrestigeX, confirmPrestigeY, 210, 444, 331, 495, *200 ConfirmPrestige.png
	while(%confirmPrestigeX% != 0 and %confirmPrestigeY% != 0 )
	{
		Click, %confirmPrestigeX%, %confirmPrestigeY%
		Sleep, 500
		ImageSearch, confirmPrestigeX, confirmPrestigeY, 210, 444, 331, 495, *200 ConfirmPrestige.png
	}
	
	ReOpenSwordMasterMenu()
}

ReOpenSwordMasterMenu()
{
	global elapsedTime
	global startTime
	
	Sleep, 7000
	
	petX = 0
	petY = 0
	
	ImageSearch, petX, petY, 3, 464, 40, 498, *200 Pet.png
	while(%petX% != 0 and %petY% != 0)
	{
		petX = 0
		petY = 0
		Sleep, 500
		ImageSearch, petX, petY, 3, 464, 40, 498, *200 Pet.png
	}
	
	Click, %menuSwordMasterX%, %menuSwordMasterY%
	Sleep, 500
	
	ImageSearch, SwordMasterX, SwordMasterY, 2, 473, 59, 534, *200 SwordMaster.png
	while(%SwordMasterX% == "" and %SwordMasterY% == "")
	{
		Send, {down}
		Sleep, 500
		ImageSearch, SwordMasterX, SwordMasterY, 2, 473, 59, 534, *200 SwordMaster.png
	}

	elapsedTime = 0
	startTime = %A_TickCount%
	
	LevelUpSwordMaster()
}

Tap()
{
	SendInput, {Space}
	Sleep, 500
}

Start()
{
	global loopbreak
	
	LoadEssentials()
	while(loopbreak < 1 and WinActive("ahk_group Nox"))
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