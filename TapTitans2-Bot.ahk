#SingleInstance Force
SetWorkingDir, %A_ScriptDir%
CoordMode, Mouse, relative
CoordMode, Pixel, relative
DetectHiddenWindows, On
SetTitleMatchMode, 2
#WinActivateForce
SetControlDelay -1
SetWinDelay 0
SetKeyDelay -1
SetMouseDelay -1
SetBatchLines -1

GroupAdd, Nox, ahk_class Qt5QWindowIcon

Gui,2:+AlwaysOnTop
Gui,2:Add,Button,x10 y10 w200 h20 gStart, Tap'N'Prestige
;Gui,2:Add,Button,x10 y30 w200 h20 gTest, CtlTest
Gui,2:Add,Edit, x10 y50 w200 h20 Number
Gui,2:Add,UpDown, vResetTime Range1-300, 90
Gui,2:Add,Button,x10 y70 w200 h20 g2GuiSave, Save
Gui,2:Add,Button,x10 w200 h20 g2GuiClose, Close
Gui,2:Add,Text,, Press F11 to stop tapping.
Gui,2:Show,x1000 y200
return

2GuiClose:
	ExitApp
	
2GuiSave:
	Gui,2:Submit, Nohide

Find_Image:
	return

loopbreak = 0
startTime = 0
elapsedTime = 0

/*
F11::
{
	global loopbreak
	
	if(loopbreak == 0)
	{
		loopbreak = 1
	}
	else
	{
		loopbreak = 0
	}
}
*/
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
		ControlClick, x235 y439, ahk_group Nox, , Left, 1, NA
	}
}

LoadEssentials()
{
	global startTime
	GetNoxPositions()
	startTime = %A_TickCount%
}

LevelUpHeroes()
{
	global startTime
	global elapsedTime
	elapsedTime := A_TickCount - startTime
	
	Sleep, 200
	
	if(Mod(elapsedTime, 600000) < 7500)
	{
		ImageSearch, heroMenuMinimizedX, heroMenuMinimizedY, 81, 782, 162, 830, *100 HeroesMenu.png
		while(!ErrorLevel)
		{
			Sleep, 100
			ControlClick, x121 y812, ahk_group Nox, , Left, 1, NA
			Sleep, 1000
			ImageSearch, heroMenuMinimizedX, heroMenuMinimizedY, 81, 782, 162, 830, *50 HeroesMenu.png
		}
		
		Tap()
	/*	
		new hero color: 0xF9AB08 
		grayed out hero: 0x969696 
		same as above, just the darker part: 0x494949
	*/
		
		ImageSearch, endOfMenuX, endOfMenuY, 175, 785, 481, 816, EndOfMenu.png
		while(ErrorLevel)
		{
			ControlClick, x404 y607, ahk_group Nox, , Left, 1, NA
			Sleep, 400
			if(!WinActive("ahk_group Nox"))
			{
				MakeNoxActiveWindow()
			}
			Send, {T}
			ImageSearch, endOfMenuX, endOfMenuY, 175, 785, 481, 816, EndOfMenu.png
		}
		
		Sleep, 200
		ControlClick, x403 y672, ahk_group Nox, , Left, 1, NA
		Sleep, 200
		ControlClick, x400 y753, ahk_group Nox, , Left, 1, NA
		Sleep, 200
		
		ImageSearch, buyMaxX, buyMaxY, 331, 519, 479, 567, *100 BUYMax.png
		while(ErrorLevel)
		{
			if(!WinActive("ahk_group Nox"))
			{
				MakeNoxActiveWindow()
			}
			Send, {down}
			Sleep, 1000
			ImageSearch, buyMaxX, buyMaxY, 331, 519, 479, 567, *100 BUYMax.png
		}
	}
}

ReOpenHeroMenu()
{
	ControlClick, x120 y814, ahk_group Nox, , Left, 1, NA
	Sleep, 500
	
	LevelUpHeroes()
}

LevelUpSwordMaster()
{
	ImageSearch, swordMenuMinimizedX, swordMenuMinimizedY, 0, 793, 77, 830, *100 SwordMenuMinimized.png
	while(!ErrorLevel)
	{
		ControlClick, x40 y814, ahk_group Nox, , Left, 1, NA
		Sleep, 500
		ImageSearch, swordMenuMinimizedX, swordMenuMinimizedY, 0, 793, 77, 830, *100 SwordMenuMinimized.png
	}
	
	ImageSearch, buyMaxX, buyMaxY, 331, 519, 479, 567, *100 BUYMax.png
	while(ErrorLevel)
	{
		if(!WinActive("ahk_group Nox"))
		{
			MakeNoxActiveWindow()
		}
		Send, {down}
		Sleep, 1000
		ImageSearch, buyMaxX, buyMaxY, 331, 519, 479, 567, *100 BUYMax.png
	}
	
	ControlClick, x409 y612, ahk_group Nox, , Left, 1, NA
}

TimeToPrestige()
{
	global elapsedTime
	global startTime
	global ResetTime
	
	elapsedTime := A_TickCount - startTime

	;if(elapsedTime > (%ResetTime% * 60000))
	if(elapsedTime > 5000000)
	{
		return 1
	}
	return 0
}

Prestige()
{
	LevelUpSwordMaster()
	Sleep, 500
	if(!WinActive("ahk_group Nox"))
	{
		MakeNoxActiveWindow()
	}
	SendInput, {Up}
	Sleep, 3000
	ImageSearch, prestigeX, prestigeY, 329, 703, 478, 786, *200 OpenPrestigeMenu.png

	while(ErrorLevel)
	{
		if(!WinActive("ahk_group Nox"))
		{
			MakeNoxActiveWindow()
		}
		SendInput, {Up}
		Sleep, 3000
		ImageSearch, prestigeX, prestigeY, 329, 703, 478, 786, *200 OpenPrestigeMenu.png
	}

	ControlClick, x%prestigeX% y%prestigeY%, ahk_group Nox, , Left, 1, NA
	Sleep, 1000
	ImageSearch, prestigeX, prestigeY, 168, 631, 315, 690, *200 Prestige.png
	ControlClick, x%prestigeX% y%prestigeY%, ahk_group Nox, , Left, 1, NA
	Sleep, 1000
	ImageSearch, prestigeX, prestigeY, 257, 538, 405, 597, *200 ConfirmPrestige.png
	ControlClick, x%prestigeX% y%prestigeY%, ahk_group Nox, , Left, 1, NA
	Sleep, 10000
	
	ImageSearch, prestigeX, prestigeY, 168, 631, 315, 690, *200 Prestige.png
	while(!ErrorLevel)
	{
		ImageSearch, prestigeX, prestigeY, 168, 631, 315, 690, *200 Prestige.png
		ControlClick, x%prestigeX% y%prestigeY%, ahk_group Nox, , Left, 1, NA
		Sleep, 1000
		ImageSearch, prestigeX, prestigeY, 257, 538, 405, 597, *200 ConfirmPrestige.png
		ControlClick, x%prestigeX% y%prestigeY%, ahk_group Nox, , Left, 1, NA
		Sleep, 10000
	}
	
	prestigeX = 0
	prestigeY = 0
	ReOpenSwordMasterMenu()
}

ReOpenSwordMasterMenu()
{
	global elapsedTime
	global startTime
	
	ControlClick, x38 y818, ahk_group Nox, , Left, 1, NA
	Sleep, 500
	if(!WinActive("ahk_group Nox"))
	{
		MakeNoxActiveWindow()
	}
	Send, {down}
	Sleep, 1000
	
	elapsedTime = 0
	startTime = %A_TickCount%
	
	LevelUpSwordMaster()
}

Tap()
{
	if(!WinActive("ahk_group Nox"))
	{
		MakeNoxActiveWindow()
	}
	Send, {Space}
	Sleep, 500
}

FairySearch()
{
	;0x8A1B52 -> valentine fairy
	;0xFF3F31 -> normal fairy
	PixelSearch, fairyX, fairyY, 75, 148, 475, 278, 0x8A1B52, , RGB FAST
	if(!ErrorLevel)
	{
		ControlClick, x%fairyX% y%fairyY%, ahk_group Nox, , Left, 3, NA
		Tap()
		Sleep, 2500
		CollectFairyReward()
	}
}

CollectFairyReward()
{
	ImageSearch, collectX, collectY, 262, 631, 447, 703, *200 Collect.png
	while(!ErrorLevel)
	{
		ControlClick, x%collectX% y%collectY%, ahk_group Nox, , Left, 3, NA
		Sleep, 500
		ImageSearch, collectX, collectY, 262, 631, 447, 703, *200 Collect.png
	}
}

VerifyEgg()
{
	ImageSearch, eggX, eggY, 4, 287, 59, 340, *50 Egg.png
	if(!ErrorLevel)
	{
		ControlClick, x%eggX% y%eggY%, ahk_group Nox, , Left, 3, NA
		
		Sleep, 1000
		ControlClick, x235 y439, ahk_group Nox, , Left, 20, NA
		Sleep, 1000
		ControlClick, x235 y439, ahk_group Nox, , Left, 20, NA
		Sleep, 1000
		ControlClick, x235 y439, ahk_group Nox, , Left, 20, NA
		Sleep, 1000
		ControlClick, x235 y439, ahk_group Nox, , Left, 20, NA
		Sleep, 1000
		ControlClick, x235 y439, ahk_group Nox, , Left, 20, NA
		Sleep, 1000
		ControlClick, x235 y439, ahk_group Nox, , Left, 20, NA	
	}
}

Start()
{
	global loopbreak
	
	LoadEssentials()
	while(true)
	{
		VerifyEgg()
		Tap()
		LevelUpSwordMaster()
		
		LevelUpHeroes()
		
		FairySearch()
		if(TimeToPrestige())
		{
			Prestige()
		}
	}
}

Test()
{
	global ResetTime
	MsgBox, %ResetTime%
	;ControlClick, x214 y344, ahk_group Nox, , Left, 20, NA
	;ControlClick, x263 y550, ahk_group Nox, , Left, 1, NA
	;Sleep, 300
	;ControlClick, x263 y490, ahk_group Nox, , Left, 1, NA
	;ControlSend, ahk_parent, T, ahk_group Nox
}

F11::Pause
Esc::ExitApp