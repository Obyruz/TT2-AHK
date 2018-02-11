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
;Gui,2:Add,Edit, x10 y50 w200 h20 Number
;Gui,2:Add,UpDown, vResetTime Range1-300, 90
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
		ControlClick, x232 y335, ahk_group Nox, , Left, 1, NA
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
		ImageSearch, heroMenuMinimizedX, heroMenuMinimizedY, 74, 660, 111, 688, *100 HeroesMenu.png
		while(!ErrorLevel)
		{
			Sleep, 100
			ControlClick, x100 y679, ahk_group Nox, , Left, 1, NA
			Sleep, 1000
			ImageSearch, heroMenuMinimizedX, heroMenuMinimizedY, 74, 660, 111, 688, *100 HeroesMenu.png
		}
		
		Tap()
	/*	
		new hero color: 0xF9AB08 
		grayed out hero: 0x969696 
		same as above, just the darker part: 0x494949
		first hero coords(rectangle): 277, 482, 389, 530
	*/
		
		ImageSearch, endOfMenuX, endOfMenuY, 3, 627, 396, 689, EndOfMenu.png
		while(ErrorLevel)
		{
			ControlClick, x337 y510, ahk_group Nox, , Left, 1, NA
			Sleep, 400
			if(!WinActive("ahk_group Nox"))
			{
				MakeNoxActiveWindow()
			}
			Send, {T}
			ImageSearch, endOfMenuX, endOfMenuY, 3, 627, 396, 689, EndOfMenu.png
		}
		
		Sleep, 200
		ControlClick, x337 y559, ahk_group Nox, , Left, 1, NA
		Sleep, 200
		ControlClick, x337 y621, ahk_group Nox, , Left, 1, NA
		Sleep, 200
		
		ImageSearch, buyMaxX, buyMaxY, 280, 249, 390, 467, *100 BUYMax.png
		while(ErrorLevel)
		{
			if(!WinActive("ahk_group Nox"))
			{
				MakeNoxActiveWindow()
			}
			Send, {down}
			Sleep, 1000
			ImageSearch, buyMaxX, buyMaxY, 280, 249, 390, 467, *100 BUYMax.png
		}
	}
}

ReOpenHeroMenu()
{
	ControlClick, x100 y679, ahk_group Nox, , Left, 1, NA
	Sleep, 500
	
	LevelUpHeroes()
}

LevelUpSwordMaster()
{
	ImageSearch, swordMenuMinimizedX, swordMenuMinimizedY, 5, 652, 59, 691, *100 SwordMenuMinimized.png
	while(!ErrorLevel)
	{
		ControlClick, x32 y672, ahk_group Nox, , Left, 1, NA
		Sleep, 500
		ImageSearch, swordMenuMinimizedX, swordMenuMinimizedY, 5, 652, 59, 691, *100 SwordMenuMinimized.png
	}
	
	ImageSearch, buyMaxX, buyMaxY, 280, 249, 390, 467, *100 BUYMax.png
	while(ErrorLevel)
	{
		if(!WinActive("ahk_group Nox"))
		{
			MakeNoxActiveWindow()
		}
		Send, {down}
		Sleep, 1000
		ImageSearch, buyMaxX, buyMaxY, 280, 249, 390, 467, *100 BUYMax.png
	}
	
	ControlClick, x330 y510, ahk_group Nox, , Left, 1, NA
}

TimeToPrestige()
{
	global elapsedTime
	global startTime
	
	elapsedTime := A_TickCount - startTime
	
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
	ImageSearch, prestigeX, prestigeY, 245, 565, 393, 658, *200 OpenPrestigeMenu.png

	while(ErrorLevel)
	{
		if(!WinActive("ahk_group Nox"))
		{
			MakeNoxActiveWindow()
		}
		SendInput, {Up}
		Sleep, 3000
		ImageSearch, prestigeX, prestigeY, 245, 565, 393, 658, *200 OpenPrestigeMenu.png
	}

	ControlClick, x%prestigeX% y%prestigeY%, ahk_group Nox, , Left, 1, NA
	Sleep, 1000
	ImageSearch, prestigeX, prestigeY, 139, 522, 261, 569, *200 Prestige.png
	ControlClick, x%prestigeX% y%prestigeY%, ahk_group Nox, , Left, 1, NA
	Sleep, 1000
	ImageSearch, prestigeX, prestigeY, 210, 444, 331, 495, *200 ConfirmPrestige.png
	ControlClick, x%prestigeX% y%prestigeY%, ahk_group Nox, , Left, 1, NA
	Sleep, 10000
	
	ImageSearch, prestigeX, prestigeY, 139, 522, 261, 569, *200 Prestige.png
	while(!ErrorLevel)
	{
		ImageSearch, prestigeX, prestigeY, 139, 522, 261, 569, *200 Prestige.png
		ControlClick, x%prestigeX% y%prestigeY%, ahk_group Nox, , Left, 1, NA
		Sleep, 1000
		ImageSearch, prestigeX, prestigeY, 210, 444, 331, 495, *200 ConfirmPrestige.png
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
	
	ControlClick, x32 y672, ahk_group Nox, , Left, 1, NA
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
	PixelSearch, fairyX, fairyY, 68, 110, 386, 228, 0x8A1B52, , RGB FAST
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
	ImageSearch, collectX, collectY, 220, 534, 363, 574, *200 Collect.png
	if(!ErrorLevel)
	{
		ControlClick, x%collectX% y%collectY%, ahk_group Nox, , Left, 3, NA
	}
}

VerifyEgg()
{
	ImageSearch, eggX, eggY, 2, 240, 50, 289, *50 Egg.png
	if(!ErrorLevel)
	{
		ControlClick, x%eggX% y%eggY%, ahk_group Nox, , Left, 3, NA
		
		Sleep, 1000
		ControlClick, x198 y344, ahk_group Nox, , Left, 20, NA
		Sleep, 1000
		ControlClick, x198 y344, ahk_group Nox, , Left, 20, NA
		Sleep, 1000
		ControlClick, x198 y344, ahk_group Nox, , Left, 20, NA
		Sleep, 1000
		ControlClick, x198 y344, ahk_group Nox, , Left, 20, NA
		Sleep, 1000
		ControlClick, x198 y344, ahk_group Nox, , Left, 20, NA
		Sleep, 1000
		ControlClick, x198 y344, ahk_group Nox, , Left, 20, NA	
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