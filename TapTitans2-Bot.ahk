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
Gui,2:Add,Button,x10 y30 w200 h20 gTest, Control Click
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
		Click, 232, 335
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
			Click, 100, 679
			Sleep, 500
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
			Click, 337, 510
			Sleep, 400
			Send, {T}
			ImageSearch, endOfMenuX, endOfMenuY, 3, 627, 396, 689, EndOfMenu.png
		}
		
		Sleep, 200
		Click, 337, 559
		Sleep, 200
		Click, 337, 621
		Sleep, 200
		
		ImageSearch, buyMaxX, buyMaxY, 280, 249, 390, 467, *100 BUYMax.png
		while(ErrorLevel)
		{
			Send, {down}
			Sleep, 1000
			ImageSearch, buyMaxX, buyMaxY, 280, 249, 390, 467, *100 BUYMax.png
		}
	}
}

ReOpenHeroMenu()
{
	Click, 100, 679	
	Sleep, 500
	
	LevelUpHeroes()
}

LevelUpSwordMaster()
{
	ImageSearch, swordMenuMinimizedX, swordMenuMinimizedY, 5, 652, 59, 691, *100 SwordMenuMinimized.png
	while(!ErrorLevel)
	{
		Click, 32, 672
		Sleep, 500
		ImageSearch, swordMenuMinimizedX, swordMenuMinimizedY, 5, 652, 59, 691, *100 SwordMenuMinimized.png
	}
	
	ImageSearch, buyMaxX, buyMaxY, 280, 249, 390, 467, *100 BUYMax.png
	while(ErrorLevel)
	{
		Send, {down}
		Sleep, 1000
		ImageSearch, buyMaxX, buyMaxY, 280, 249, 390, 467, *100 BUYMax.png
	}
	
	Click, 330, 510
}

TimeToPrestige()
{
	global elapsedTime
	global startTime
	
	elapsedTime := A_TickCount - startTime
	
	if(elapsedTime > 5400000)
	{
		return 1
	}
	return 0
}

Prestige()
{
	LevelUpSwordMaster()
	Sleep, 500
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
	
	ImageSearch, prestigeX, prestigeY, 139, 522, 261, 569, *200 Prestige.png
	while(!ErrorLevel)
	{
		ImageSearch, prestigeX, prestigeY, 139, 522, 261, 569, *200 Prestige.png
		Click, %prestigeX%, %prestigeY%
		Sleep, 1000
		ImageSearch, prestigeX, prestigeY, 210, 444, 331, 495, *200 ConfirmPrestige.png
		Click, %prestigeX%, %prestigeY%
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
	
	Click, 32, 672
	Sleep, 500
	Send, {down}
	Sleep, 1000
	
	elapsedTime = 0
	startTime = %A_TickCount%
	
	LevelUpSwordMaster()
}

Tap()
{
	Send, {Space}
	Sleep, 500
}

FairySearch()
{
	PixelSearch, fairyX, fairyY, 68, 110, 386, 228, 0xFF3F31, , RGB FAST
	if(!ErrorLevel)
	{
		Click, %fairyX%, %fairyY%, 3
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
		Click, %collectX%, %collectY%, 3
	}
}

VerifyEgg()
{
	ImageSearch, eggX, eggY, 2, 240, 50, 289, *50 Egg.png
	if(!ErrorLevel)
	{
		Click, %eggX%, %eggY%, 3
		
		Sleep, 500
		Click, 198, 344, 20
		Sleep, 500
		Click, 198, 344, 20
		Sleep, 500
		Click, 198, 344, 20
		Sleep, 500
		Click, 198, 344, 20
		Sleep, 500
		Click, 198, 344, 20
		Sleep, 500
		Click, 198, 344, 20		
	}
}

Start()
{
	global loopbreak
	
	LoadEssentials()
	while(true)
	{
		if(WinActive("ahk_group Nox"))
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
		else
		{
			MakeNoxActiveWindow()
		}
	}
}

F11::Pause
Esc::ExitApp