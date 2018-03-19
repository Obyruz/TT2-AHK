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
Gui,2:Add,Button,x175 y10 w200 h30 gStart, Tap'N'Prestige

; BASIC TIMERS
Gui,2:Add,Text, x10 y50, BASIC TIMERS
Gui,2:Add,Text, x10 y70, Minutes between prestiges:
Gui,2:Add,Edit, x200 y68 w50 h20 Number
Gui,2:Add,UpDown, vResetTime Range1-300, 60
Gui,2:Add,Text, x10 y90, Minutes between leveling all heroes:
Gui,2:Add,Edit, x200 y88 w50 h20 Number
Gui,2:Add,UpDown, vHeroesTimer Range1-300, 10
Gui,2:Add,Text, x10 y110, Minutes between leveling sword master:
Gui,2:Add,Edit, x200 y108 w50 h20 Number
Gui,2:Add,UpDown, vSwordMasterTimer Range1-300, 10
Gui,2:Add,Text, x10 y130, Minutes between leveling best hero:
Gui,2:Add,Edit, x200 y128 w50 h20 Number
Gui,2:Add,UpDown, vBestHeroTimer Range0-300, 1

; SKILLS
Gui,2:Add,Text, x300 y50, SKILLS
Gui,2:Add,Text, x300 y70, Minutes between Heavenly Strike:
Gui,2:Add,Edit, x500 y68 w50 h20 Number
Gui,2:Add,UpDown, vHSTimer Range2-999, 7
Gui,2:Add,Text, x300 y90, Minutes between Deadly Strike:
Gui,2:Add,Edit, x500 y88 w50 h20 Number
Gui,2:Add,UpDown, vDSTimer Range2-999, 7
Gui,2:Add,Text, x300 y110, Minutes between Hand of Midas:
Gui,2:Add,Edit, x500 y108 w50 h20 Number
Gui,2:Add,UpDown, vHOMTimer Range2-999, 7
Gui,2:Add,Text, x300 y130, Minutes between Fire Sword:
Gui,2:Add,Edit, x500 y128 w50 h20 Number
Gui,2:Add,UpDown, vFSTimer Range2-999, 7
Gui,2:Add,Text, x300 y150, Minutes between War Cry:
Gui,2:Add,Edit, x500 y148 w50 h20 Number
Gui,2:Add,UpDown, vWCTimer Range2-999, 7
Gui,2:Add,Text, x300 y170, Minutes between Shadow Clone:
Gui,2:Add,Edit, x500 y168 w50 h20 Number
Gui,2:Add,UpDown, vSCTimer Range2-999, 7
Gui,2:Add,Text, x300 y190, Times to level up skills:
Gui,2:Add,Edit, x500 y188 w50 h20 Number
Gui,2:Add,UpDown, vTimesToLevelSkills Range0-300, 1

; BEHAVIOR
Gui,2:Add,Text, x10 y150, BEHAVIOR
Gui,2:Add,Checkbox, x10 y170 vClickClanShip, Click on Clan Ship(might click on fairy)
Gui,2:Add,Checkbox, x10 y190 vPickFairy, Click on fairies
Gui,2:Add,Checkbox, x30 y210 vWatchAD, Watch AD's
Gui,2:Add,Checkbox, x10 y230 vDoClanQuest, Do Clan Quest whenever available
Gui,2:Add,Button,x175 y250 w200 h30 g2GuiClose, Close
;Gui,2:Add,Button,x300 y210 w200 h20 g2GuiPause, Pause

Gui,2:Add,Text,x10 , Press F11 to pause.
Gui,2:Show,x1000 y200
return

2GuiClose:
	ExitApp

2GuiPause:
	Pause

startTime = 0
elapsedTime = 0
timesSkillsWereLeveled = 0

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
/*
	global Idle

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
	global elapsedTime
	
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

	timeToLevelHeroes := HeroesTimer * 60000

	Sleep, 200
	
	ReOpenHeroesMenu()
	
	ControlClick, x407 y685, ahk_group Nox, , Left, 1, NA
	
	if((Mod(elapsedTime, timeToLevelHeroes) < 7500) && VerifyActive())
	{
		
		ClanShipPower()
	/*	
		new hero color: 0xF9AB08 
		grayed out hero: 0x969696 
		same as above, just the darker part: 0x494949
	*/
		
		CheckStageTransition()
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
			CheckStageTransition()
			ImageSearch, endOfMenuX, endOfMenuY, 175, 785, 481, 816, EndOfMenu.png
		}
		
		Sleep, 200
		ControlClick, x403 y672, ahk_group Nox, , Left, 1, NA
		Sleep, 200
		ControlClick, x400 y753, ahk_group Nox, , Left, 1, NA
		Sleep, 200
		
		CheckStageTransition()
		ImageSearch, buyMaxX, buyMaxY, 331, 519, 479, 567, *100 BUYMax.png
		while(ErrorLevel)
		{
			if(!WinActive("ahk_group Nox"))
			{
				MakeNoxActiveWindow()
			}
			Send, {down}
			Sleep, 1000
			CheckStageTransition()
			ImageSearch, buyMaxX, buyMaxY, 331, 519, 479, 567, *100 BUYMax.png
		}
	}
}

ReOpenHeroesMenu()
{
	Sleep, 200
	;0x5B97A7, 121, 819
	;PixelSearch, heroMenuMaximizedX, heroMenuMaximizedY, 110, 800, 130, 830, , RGB FAST
	CheckStageTransition()
	ImageSearch, heroMenuMaximizedX, heroMenuMaximizedY, 81, 782, 150, 830, *50 HeroesMenuMaximized.png
	while(ErrorLevel)
	{
		Sleep, 100
		ControlClick, x121 y812, ahk_group Nox, , Left, 1, NA
		Sleep, 500
		Tap()
		Sleep, 500
		Tap()
		Sleep, 500
		CheckStageTransition()
		ImageSearch, heroMenuMinimizedX, heroMenuMinimizedY, 81, 782, 150, 830, *50 HeroesMenuMaximized.png
	}
	
	if(VerifyActive())
	{
		CheckStageTransition()
		ImageSearch, buyMaxX, buyMaxY, 331, 519, 479, 567, *100 BUYMax.png
		while(ErrorLevel)
		{
			if(!WinActive("ahk_group Nox"))
			{
				MakeNoxActiveWindow()
			}
			Send, {down}
			Sleep, 1000
			CheckStageTransition()
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
		ReOpenSwordMasterMenu()
		
		ControlClick, x409 y612, ahk_group Nox, , Left, 1, NA
	}
}

LevelUpSkills()
{
	global timesSkillsWereLeveled
	global TimesToLevelSkills
	
	if((timesSkillsWereLeveled < 1) and (TimesToLevelSkills > 0))
	{
		ReOpenSwordMasterMenu()
		
		CheckStageTransition()
		PixelSearch, newSkillX, newSkillY, 325, 669, 465, 736, 0xFCB608, , RGB FAST
		while(!ErrorLevel)
		{
			ControlClick, x%newSkillX% y%newSkillY%, ahk_group Nox, , Left, 1, NA
			Sleep, 100
			if(!WinActive("ahk_group Nox"))
			{
				MakeNoxActiveWindow()
			}
			Send, {T}
			Sleep, 200
			CheckStageTransition()
			PixelSearch, newSkillX, newSkillY, 325, 572, 477, 784, 0xFCB608, , RGB FAST
		}
		
		timesSkillsWereLeveled = 1
	}
	else if(timesSkillsWereLeveled < TimesToLevelSkills)
	{
		ReOpenSwordMasterMenu()
		
		CheckStageTransition()
		ImageSearch, HoMX, HoMY, 3, 529, 73, 610, *50 HandOfMidasMenu.png
		while(ErrorLevel)
		{
			Sleep, 400
			if(!WinActive("ahk_group Nox"))
			{
				MakeNoxActiveWindow()
			}
			Send, {T}
			CheckStageTransition()
			ImageSearch, HoMX, HoMY, 3, 529, 73, 610, *50 HandOfMidasMenu.png
		}
		
		ControlClick, x%HoMX%+400 y%HoMY%, ahk_group Nox, , Left, 1, NA
		
		CheckStageTransition()
		ImageSearch, WarCryX, WarCryY, 4, 688, 71, 761, *50 WarCryMenu.png
		while(ErrorLevel)
		{
			Sleep, 400
			if(!WinActive("ahk_group Nox"))
			{
				MakeNoxActiveWindow()
			}
			Send, {T}
			CheckStageTransition()
			ImageSearch, WarCryX, WarCryY, 4, 688, 71, 761, *50 WarCryMenu.png
		}
		
		ControlClick, x%WarCryX%+400 y%WarCryY%, ahk_group Nox, , Left, 1, NA
		
		timesSkillsWereLeveled = 1
	}
}

MinMenus()
{
	CheckStageTransition()
	PixelSearch, ,, 410, 479, 451, 498, 0x433830, , RGB FAST
	while(!ErrorLevel)
	{
		Sleep, 200
		ControlClick, x430 y507, ahk_group Nox, , Left, 1, NA
		Sleep, 400
		CheckStageTransition()
		PixelSearch, ,, 410, 479, 451, 498, 0x433830, , RGB FAST
	}
}

UseSkills()
{
	global elapsedTime
	global startTime
	global HSTimer
	global DSTimer
	global HOMTimer
	global FSTimer
	global WCTimer
	global SCTimer

	elapsedTime := A_TickCount - startTime

	firstSkillTimer := HSTimer * 60000
	secondSkillTimer := DSTimer * 60000
	thirdSkillTimer := HOMTimer * 60000
	fourthSkillTimer := FSTimer * 60000
	fifthSkillTimer := WCTimer * 60000
	sixthSkillTimer := SCTimer * 60000

	MakeNoxActiveWindow()

	if(Mod(elapsedTime, firstSkillTimer) < 15000)
	{
		MinMenus()
		CheckStageTransition()
		ImageSearch, HSX, HSY, 5, 705, 78, 779, *50 HSSkill.png
		ControlClick, x%HSX% y%HSY%, ahk_group Nox, , Left, 1, NA
		Sleep, 200
	}
	if(Mod(elapsedTime, secondSkillTimer) < 15000)
	{
		MinMenus()
		CheckStageTransition()
		ImageSearch, DSX, DSY, 80, 705, 158, 779, *50 DSSkill.png
		ControlClick, x%DSX% y%DSY%, ahk_group Nox, , Left, 1, NA
		Sleep, 200
	}
	if(Mod(elapsedTime, thirdSkillTimer) < 15000)
	{
		MinMenus()
		CheckStageTransition()
		ImageSearch, HoMX, HoMY, 161, 707, 240, 779, *50 HoMSkill.png
		ControlClick, x%HoMX% y%HoMY%, ahk_group Nox, , Left, 1, NA
		Sleep, 200
	}
	if(Mod(elapsedTime, fourthSkillTimer) < 15000)
	{
		MinMenus()
		CheckStageTransition()
		ImageSearch, FSX, FSY, 241, 705, 320, 779, *50 FSSkill.png
		ControlClick, x%FSX% y%FSY%, ahk_group Nox, , Left, 1, NA
		Sleep, 200
	}
	if(Mod(elapsedTime, fifthSkillTimer) < 15000)
	{
		MinMenus()
		CheckStageTransition()
		ImageSearch, WarCryX, WarCryY, 316, 705, 401, 780, *50 WarCrySkill.png
		ControlClick, x%WarCryX% y%WarCryY%, ahk_group Nox, , Left, 1, NA
		Sleep, 200
	}
	if(Mod(elapsedTime, sixthSkillTimer) < 15000)
	{
		MinMenus()
		CheckStageTransition()
		ImageSearch, SCX, SCY, 390, 705, 480, 779, *50 SCSkill.png
		ControlClick, x%SCX% y%SCY%, ahk_group Nox, , Left, 1, NA
		Sleep, 200
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
	CheckStageTransition()
	ImageSearch, prestigeX, prestigeY, 329, 703, 478, 786, *200 OpenPrestigeMenu.png
	while(ErrorLevel)
	{
		if(!WinActive("ahk_group Nox"))
		{
			MakeNoxActiveWindow()
		}
		SendInput, {Up}
		Sleep, 3000
		CheckStageTransition()
		ImageSearch, prestigeX, prestigeY, 329, 703, 478, 786, *200 OpenPrestigeMenu.png
	}

	ControlClick, x%prestigeX% y%prestigeY%, ahk_group Nox, , Left, 1, NA
	Sleep, 1000
	CheckStageTransition()
	ImageSearch, prestigeX, prestigeY, 168, 631, 315, 690, *200 Prestige.png
	ControlClick, x%prestigeX% y%prestigeY%, ahk_group Nox, , Left, 1, NA
	Sleep, 1000
	CheckStageTransition()
	ImageSearch, prestigeX, prestigeY, 257, 538, 405, 597, *200 ConfirmPrestige.png
	ControlClick, x%prestigeX% y%prestigeY%, ahk_group Nox, , Left, 1, NA
	Sleep, 10000
	
	CheckStageTransition()
	ImageSearch, prestigeX, prestigeY, 168, 631, 315, 690, *200 Prestige.png
	while(!ErrorLevel)
	{
		CheckStageTransition()
		ImageSearch, prestigeX, prestigeY, 168, 631, 315, 690, *200 Prestige.png
		ControlClick, x%prestigeX% y%prestigeY%, ahk_group Nox, , Left, 1, NA
		Sleep, 1000
		CheckStageTransition()
		ImageSearch, prestigeX, prestigeY, 257, 538, 405, 597, *200 ConfirmPrestige.png
		ControlClick, x%prestigeX% y%prestigeY%, ahk_group Nox, , Left, 1, NA
		Sleep, 15000
	}
	
	prestigeX = 0
	prestigeY = 0
	ResetTimer()
}

ReOpenSwordMasterMenu()
{
	CheckStageTransition()
	ImageSearch, swordMenuMaximizedX, swordMenuMaximizedY, 5, 788, 65, 830, *100 SwordMenuMaximized.png
	while(ErrorLevel)
	{
		ControlClick, x40 y814, ahk_group Nox, , Left, 1, NA
		Sleep, 500
		Tap()
		Sleep, 500
		Tap()
		Sleep, 500
		CheckStageTransition()
		ImageSearch, swordMenuMaximizedX, swordMenuMaximizedY, 5, 788, 65, 830, *100 SwordMenuMaximized.png
	}
	
	CheckStageTransition()
	ImageSearch, buyMaxX, buyMaxY, 331, 519, 479, 567, *100 BUYMax.png
	while(ErrorLevel && VerifyActive())
	{
		if(!WinActive("ahk_group Nox"))
		{
			MakeNoxActiveWindow()
		}
		Send, {down}
		Sleep, 1000
		CheckStageTransition()
		ImageSearch, buyMaxX, buyMaxY, 331, 519, 479, 567, *100 BUYMax.png
	}
}

ResetTimer()
{
	global elapsedTime
	global startTime
	global timesSkillsWereLeveled

	ReOpenSwordMasterMenu()
	
	elapsedTime = 0
	startTime = %A_TickCount%
	timesSkillsWereLeveled = 0
	
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
		ControlClick, x31 y138, ahk_group Nox, , Left, 1, NA
		Sleep, 200
		ControlClick, x31 y138, ahk_group Nox, , Left, 1, NA
		Sleep, 3000
		CheckStageTransition()
		CollectFairyReward()
	}
}

CheckStageTransition()
{
	ImageSearch, , , 30, 362, 444, 678, *25 StageTransition.png
	while(!ErrorLevel)
	{
		Sleep, 1000
		ImageSearch, , , 30, 362, 444, 678, *25 StageTransition.png
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
			Sleep, 500
			Tap()
			Sleep, 500		
			WatchAdd()
			CollectFairyReward()
		}
	}
}

WatchAdd()
{
	global WatchAD
	CheckStageTransition()
	ImageSearch, watchX, watchY, 100, 500, 550, 800, *100 Watch.png
	if (!ErrorLevel)
	{
		if(WatchAD)
		{
			while(!ErrorLevel)
			{
				ControlClick, x%watchX% y%watchY%, ahk_group Nox, , Left, 1, NA
				Sleep, 500
				ImageSearch, watchX, watchY, 100, 500, 550, 800, *100 Watch.png
			}
			; While?
			Sleep, 35000
			Send {Esc}
			Sleep, 5000
			CheckStageTransition()
			ImageSearch, ErrorWatchAdX, ErrorWatchAdY, 144, 528, 336, 597, *100 ErrorWatchAd.png
			while(!ErrorLevel)
			{
				ControlClick, x245 y566, ahk_group Nox, , Left, 1, NA
				ImageSearch, ErrorWatchAdX, ErrorWatchAdY, 144, 528, 336, 597, *100 ErrorWatchAd.png
			}
		} else {
			ControlClick, x122 y665, ahk_group Nox, , Left, 1, NA
		}
	}
}

CollectFairyReward()
{
	CheckStageTransition()
	global WatchAD
	if (WatchAD) {
		xmin := 154
		xmax := 330
		ymin := 640
		ymax := 690
	}
	else {
		xmin := 262
		xmax := 447
		ymin := 631
		ymax := 703
	}
	ImageSearch, collectX, collectY, xmin, ymin, xmax, ymax, *50 Collect.png
	while(!ErrorLevel)
	{
		ControlClick, x%collectX% y%collectY%, ahk_group Nox, , Left, 3, NA
		Sleep, 500
		ControlClick, x384 y667, ahk_group Nox, , Left, 1, NA
		Sleep, 500
		ControlClick, x384 y667, ahk_group Nox, , Left, 1, NA
		Sleep, 500
		ControlClick, x384 y667, ahk_group Nox, , Left, 1, NA
		Sleep, 500
		ControlClick, x384 y667, ahk_group Nox, , Left, 1, NA
		Sleep, 500
		CheckStageTransition()
		ImageSearch, collectX, collectY, xmin, ymin, xmax, ymax, *50 Collect.png
	}
}

ClanQuest()
{
	global DoClanQuest
	global startTime
	
	timeBeforeClanQuest := A_TickCount
	
	if(DoClanQuest)
	{
		CheckStageTransition()
		ImageSearch, clanQuestX, clanQuestY, 53, 35, 105, 79, *50 ClanQuestAvailable.png
		if(!ErrorLevel)
		{
			Sleep, 100
			ControlClick, x%clanQuestX% y%clanQuestY%, ahk_group Nox, , Left, 1, NA
			Sleep, 400
			CheckStageTransition()
			ImageSearch, clanQuestX, clanQuestY, 53, 35, 105, 79, *50 ClanQuestAvailable.png
			while(!ErrorLevel)
			{
				ControlClick, x%clanQuestX% y%clanQuestY%, ahk_group Nox, , Left, 1, NA
				Sleep, 1000
				CheckStageTransition()
				ImageSearch, clanQuestX, clanQuestY, 53, 35, 105, 79, *50 ClanQuestAvailable.png				
			}
		
			CheckStageTransition()
			PixelSearch, bossX, bossY, 90, 746, 114, 765, 0x36364B, , RGB FAST
			while(!ErrorLevel)
			{
				ControlClick, x%bossX% y%bossY%, ahk_group Nox, , Left, 1, NA
				Sleep, 1000
				CheckStageTransition()
				PixelSearch, bossX, bossY, 90, 746, 114, 765, 0x36364B, , RGB FAST
			}
			
			Sleep, 2000
			
			CheckStageTransition()
			ImageSearch, fightX, fightY, 202, 735, 421, 795, *100 Fight.png
			while(!ErrorLevel)
			{
				ControlClick, x%fightX% y%fightY%, ahk_group Nox, , Left, 1, NA
				Sleep, 1000
				CheckStageTransition()
				ImageSearch, fightX, fightY, 202, 735, 421, 795, *100 Fight.png
			}
			
			Sleep, 2500
			
			bossStart := A_TickCount
			bossTimer := 0
			while(bossTimer < 31000)
			{
				Tap()
				Sleep, 500
				bossTimer := A_TickCount - bossStart
			}
			
			CheckStageTransition()
			PixelSearch, continueX, continueY, 104, 714, 374, 748, 0xFFFFFF, , RGB FAST
			while(ErrorLevel)
			{
				Sleep, 500
				CheckStageTransition()
				PixelSearch, continueX, continueY, 104, 714, 374, 748, 0xFFFFFF, , RGB FAST
			}
			
			ControlClick, x%continueX% y%continueY%, ahk_group Nox, , Left, 1, NA
			
			Sleep, 1000
			
			CheckStageTransition()
			PixelSearch, clanCloseX, clanCloseY, 397, 59, 432, 89, 0x433830, , RGB FAST
			while(!ErrorLevel)
			{
				ControlClick, x%clanCloseX% y%clanCloseY%, ahk_group Nox, , Left, 1, NA
				Sleep, 1000
				CheckStageTransition()
				PixelSearch, clanCloseX, clanCloseY, 397, 59, 432, 89, 0x433830, , RGB FAST
			}
		}
		
		timeAfterClanQuest := A_TickCount
		timeInClanQuest := timeAfterClanQuest - timeBeforeClanQuest
		
		startTime := startTime + timeInClanQuest
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
		VerifyEgg()
		Tap()
		LevelUpSwordMaster()
		LevelUpSkills()
		ClanShipPower()
		LevelUpHeroes()
		UseSkills()
		
		FairySearch()
		ClanQuest()
		if(TimeToPrestige())
		{
			Prestige()
		}
	}
}

Test()
{
	;LevelUpSkills()
	;while(true)
	;{
		;ControlClick, x214 y344, ahk_group Nox, , Left, 20, NA
		;ControlClick, x263 y550, ahk_group Nox, , Left, 1, NA
		;Sleep, 300
		;ControlClick, x263 y490, ahk_group Nox, , Left, 1, NA
		;ControlSend, , {Space Down}, ahk_group Nox
		;Sleep, 2000
		;ControlSend, , {Space Up}, ahk_group Nox
	;}
}

F11::Pause
F10::Test()