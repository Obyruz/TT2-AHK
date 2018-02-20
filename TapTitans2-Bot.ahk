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
Gui,2:Add,Button,x30 y10 w200 h20 gStart, Tap'N'Prestige
Gui,2:Add,Text, x10 y50, Minutes between prestiges:
Gui,2:Add,Edit, x200 y48 w50 h20 Number
Gui,2:Add,UpDown, vResetTime Range1-300, 60
Gui,2:Add,Text, x10 y70, Minutes between leveling all heroes:
Gui,2:Add,Edit, x200 y68 w50 h20 Number
Gui,2:Add,UpDown, vHeroesTimer Range1-300, 10
Gui,2:Add,Text, x10 y90, Minutes between leveling sword master:
Gui,2:Add,Edit, x200 y88 w50 h20 Number
Gui,2:Add,UpDown, vSwordMasterTimer Range1-300, 10
Gui,2:Add,Text, x10 y110, Minutes between leveling best hero:
Gui,2:Add,Edit, x200 y108 w50 h20 Number
Gui,2:Add,UpDown, vBestHeroTimer Range0-300, 1
Gui,2:Add,Checkbox, x10 y130 vClickClanShip, Click on Clan Ship(might click on fairy)
Gui,2:Add,Checkbox, x10 y150 vPickFairy, Click on fairies
;Gui,2:Add,Checkbox, x10 y170 vIdle, Run with game on background
Gui,2:Add,Button,x30 w200 h20 g2GuiClose, Close

Gui,2:Add,Text,, Press F11 to pause.
Gui,2:Show,x1000 y200
return

2GuiClose:
	ExitApp


startTime = 0
elapsedTime = 0


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

VerifyActive()
{
	return 1

/*	global Idle

	if(!Idle)
	{
		return 1
	}
	else
	{
		return 0
	}
*/
}

GetNoxPositions()
{
	if(VerifyIfNoxIsOpen() && VerifyActive())
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

LevelUpBestHero()
{
	global BestHeroTimer
	timeToLevelBestHero := BestHeroTimer * 60000
	
	if(Mod(elapsedTime, timeToLevelBestHero) < 5000)
	{
		ReOpenHeroesMenu()
		
		ControlClick, x407 y685, ahk_group Nox, , Left, 1, NA
	}
}

LevelUpHeroes()
{
	global startTime
	global elapsedTime
	global HeroesTimer
	elapsedTime := A_TickCount - startTime
	timeToLevelHeroes := HeroesTimer * 60000

	Sleep, 200
	
	ReOpenHeroesMenu()
	
	ControlClick, x407 y685, ahk_group Nox, , Left, 1, NA
	
	if((Mod(elapsedTime, timeToLevelHeroes) < 7500) && VerifyActive())
	{
		
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

ReOpenHeroesMenu()
{
	ImageSearch, heroMenuMinimizedX, heroMenuMinimizedY, 81, 782, 162, 830, *50 HeroesMenu.png
	while(!ErrorLevel)
	{
		Sleep, 100
		ControlClick, x121 y812, ahk_group Nox, , Left, 1, NA
		Sleep, 500
		Tap()
		Sleep, 500
		Tap()
		Sleep, 500
		ImageSearch, heroMenuMinimizedX, heroMenuMinimizedY, 81, 782, 162, 830, *50 HeroesMenu.png
	}
	
	if(VerifyActive())
	{
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

LevelUpSwordMaster()
{
	global elapsedTime
	global SwordMasterTimer
	
	timeToLevelSwordMaster := SwordMasterTimer * 60000
	
	if(Mod(elapsedTime, timeToLevelSwordMaster) < 7500)
	{
		ImageSearch, swordMenuMinimizedX, swordMenuMinimizedY, 0, 793, 77, 830, *100 SwordMenuMinimized.png
		while(!ErrorLevel)
		{
			ControlClick, x40 y814, ahk_group Nox, , Left, 1, NA
			Sleep, 500
			Tap()
			Sleep, 500
			Tap()
			Sleep, 500
			ImageSearch, swordMenuMinimizedX, swordMenuMinimizedY, 0, 793, 77, 830, *100 SwordMenuMinimized.png
		}
		
		ImageSearch, buyMaxX, buyMaxY, 331, 519, 479, 567, *100 BUYMax.png
		while(ErrorLevel && verifyActive())
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
}

TimeToPrestige()
{
	global elapsedTime
	global startTime
	global ResetTime
	
	elapsedTime := A_TickCount - startTime
	userResetTime := ResetTime * 60000
	
	if(elapsedTime > userResetTime)
	{
		return 1
	}
	return 0
}

Prestige()
{
	while(!WinActive("ahk_group Nox"))
	{
		SoundBeep, 500, 1000
		Sleep, 100
	}
	
	ReOpenSwordMasterMenu()
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
	
	ImageSearch, swordMenuMinimizedX, swordMenuMinimizedY, 0, 793, 77, 830, *100 SwordMenuMinimized.png
	while(!ErrorLevel)
	{
		ControlClick, x40 y814, ahk_group Nox, , Left, 1, NA
		Sleep, 500
		Tap()
		Sleep, 500
		Tap()
		Sleep, 500
		ImageSearch, swordMenuMinimizedX, swordMenuMinimizedY, 0, 793, 77, 830, *100 SwordMenuMinimized.png
	}
	
	elapsedTime = 0
	startTime = %A_TickCount%
	
	LevelUpSwordMaster()
}

Tap()
{
	ControlClick, x235 y439, ahk_group Nox, , Left, 20, NA
	Sleep, 500
}

ClanShipPower()
{
	global ClickClanShip
	
	if(ClickClanShip)
	{
		;0xFFFFE4
		;PixelSearch, clanShipX, clanShipY, 6, 120, 94, 149, 0xFFFFFF, , RGB FAST
		;if(!ErrorLevel)
		PixelSearch, fairyX, fairyY, 0, 101, 189, 221, 0x8A1B52, , RGB FAST
		if(ErrorLevel)
		{
			ControlClick, x31 y138, ahk_group Nox, , Left, 1, NA
		}
		
		Sleep, 3000
		CollectFairyReward()
	}
}

FairySearch()
{
	global PickFairy
	
	if(PickFairy)
	{
		;0x8A1B52 -> valentine fairy
		;0xFF3F31 -> normal fairy
		PixelSearch, fairyX, fairyY, 75, 148, 475, 278, 0x8A1B52, , RGB FAST
		if(!ErrorLevel)
		{
			ControlClick, x%fairyX% y%fairyY%, ahk_group Nox, , Left, 3, NA
			Tap()
			Sleep, 500
			Tap()
			Sleep, 500
			Tap()
			Sleep, 500
			Tap()
			Sleep, 500
			Tap()
			Sleep, 500
			CollectFairyReward()
		}
	}
}

CollectFairyReward()
{
	ImageSearch, collectX, collectY, 262, 631, 447, 703, *200 Collect.png
	while(!ErrorLevel)
	{
		ControlClick, x%collectX% y%collectY%, ahk_group Nox, , Left, 3, NA
		Sleep, 500
		Tap()
		Sleep, 500
		Tap()
		Sleep, 500
		Tap()
		Sleep, 500
		Tap()
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
		Tap()
		Sleep, 500
		Tap()
		Sleep, 500
		Tap()
		Sleep, 500
		Tap()
		Sleep, 500
		Tap()
		Sleep, 500
		Tap()
	}
}

Start()
{
	Gui,2:Submit, Nohide
	
	LoadEssentials()
	
	while(true)
	{
		Gui,2:Submit, Nohide
		VerifyEgg()
		Gui,2:Submit, Nohide
		Tap()
		Gui,2:Submit, Nohide
		LevelUpSwordMaster()
		Gui,2:Submit, Nohide
		ClanShipPower()
		Gui,2:Submit, Nohide
		LevelUpHeroes()
		Gui,2:Submit, Nohide
		
		FairySearch()
		Gui,2:Submit, Nohide
		if(TimeToPrestige())
		{
			Gui,2:Submit, Nohide
			Prestige()
		}
	}
}

Test()
{
	;ControlClick, x214 y344, ahk_group Nox, , Left, 20, NA
	;ControlClick, x263 y550, ahk_group Nox, , Left, 1, NA
	;Sleep, 300
	;ControlClick, x263 y490, ahk_group Nox, , Left, 1, NA
	;ControlSend, ahk_parent, T, ahk_group Nox
}

F11::Pause