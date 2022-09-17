#include "datascripts/inputList.lua"
#include "datascripts/keybinds.lua"
#include "scripts/ui.lua"
#include "scripts/utils.lua"
#include "scripts/textbox.lua"

local menuOpened = false
local menuOpenLastFrame = false

local rebinding = nil

local erasingBinds = 0
local erasingValues = 0

local menuWidth = 0.20
local menuHeight = 0.35

local fireSpreadBox = nil
local maxFiresBox = nil

function menu_init()
	
end

function menu_tick(dt)
	if PauseMenuButton(toolReadableName .. " Settings") then
		menuOpened = true
	end
	
	if menuOpened and not menuOpenLastFrame then
		menuUpdateActions()
		menuOpenActions()
	end
	
	menuOpenLastFrame = menuOpened
	
	if rebinding ~= nil then
		local lastKeyPressed = getKeyPressed()
		
		if lastKeyPressed ~= nil then
			binds[rebinding] = lastKeyPressed
			rebinding = nil
		end
	end
	
	textboxClass_tick()
	
	if erasingBinds > 0 then
		erasingBinds = erasingBinds - dt
	end
end

function drawTitle()
	UiPush()
		UiFont("bold.ttf", 45)
		
		local titleText = toolReadableName .. " Settings"
		
		local titleBoxWidth, titleBoxHeight = UiGetTextSize(titleText)
		
		UiTranslate(0, -40 - titleBoxHeight / 2)
		
		UiPush()
			UiColorFilter(0, 0, 0, 0.25)
			UiImageBox("MOD/sprites/square.png", titleBoxWidth + 20, titleBoxHeight + 20, 10, 10)
		UiPop()
		
		UiAlign("center middle")
		
		UiText(titleText)
	UiPop()
end

function bottomMenuButtons()
	UiPush()
		UiFont("regular.ttf", 26)
	
		UiButtonImageBox("MOD/sprites/square.png", 6, 6, 0, 0, 0, 0.5)
		
		UiAlign("center bottom")
		
		local buttonWidth = 250
		
		UiPush()
			UiTranslate(0, -50)
			if erasingValues > 0 then
				UiPush()
				c_UiColor(Color4.Red)
				if UiTextButton("Are you sure?" , buttonWidth, 40) then
					resetValues()
					erasingValues = 0
				end
				UiPop()
			else
				if UiTextButton("Reset values to defaults" , buttonWidth, 40) then
					erasingValues = 5
				end
			end
		UiPop()
		
		
		--[[UiPush()
			--UiAlign("right bottom")
			--UiTranslate(230, 0)
			UiTranslate(0, -50)
			if erasingBinds > 0 then
				UiPush()
				c_UiColor(Color4.Red)
				if UiTextButton("Are you sure?" , buttonWidth, 40) then
					resetKeybinds()
					erasingBinds = 0
				end
				UiPop()
			else
				if UiTextButton("Reset binds to defaults" , buttonWidth, 40) then
					erasingBinds = 5
				end
			end
		UiPop()]]--
		
		
		UiPush()
			--UiAlign("left bottom")
			--UiTranslate(-230, 0)
			if UiTextButton("Close" , buttonWidth, 40) then
				menuCloseActions()
			end
		UiPop()
	UiPop()
end

function disableButtonStyle()
	UiButtonImageBox("MOD/sprites/square.png", 6, 6, 0, 0, 0, 0.5)
	UiButtonPressColor(1, 1, 1)
	UiButtonHoverColor(1, 1, 1)
	UiButtonPressDist(0)
end

function greenAttentionButtonStyle()
	local greenStrength = math.sin(GetTime() * 5) - 0.5
	local otherStrength = 0.5 - greenStrength
	
	if greenStrength < otherStrength then
		greenStrength = otherStrength
	end
	
	UiButtonImageBox("MOD/sprites/square.png", 6, 6, otherStrength, greenStrength, otherStrength, 0.5)
end

function menu_draw(dt)
	if not isMenuOpen() then
		return
	end
	
	UiMakeInteractive()
	
	UiPush()
		UiBlur(0.75)
		
		UiAlign("center middle")
		UiTranslate(UiWidth() * 0.5, UiHeight() * 0.5)
		
		UiPush()
			UiColorFilter(0, 0, 0, 0.25)
			UiImageBox("MOD/sprites/square.png", UiWidth() * menuWidth, UiHeight() * menuHeight, 10, 10)
		UiPop()
		
		UiWordWrap(UiWidth() * menuWidth)
		
		UiTranslate(0, -UiHeight() * (menuHeight / 2))
		
		drawTitle()
		
		UiTranslate(UiWidth() * (menuWidth / 10), 0)
		
		--UiTranslate(0, 30)
		
		UiFont("regular.ttf", 26)
		UiAlign("left middle")
		
		UiPush()
			UiTranslate(0, 50)
			for i = 1, #bindOrder do
				local id = bindOrder[i]
				local key = binds[id]
				drawRebindable(id, key)
				UiTranslate(0, 50)
			end
		UiPop()
		
		setupTextBoxes()
		
		UiTranslate(0, 50 * (#bindOrder + 1))
		
		textboxClass_render(maxFiresBox)
		
		UiTranslate(0, 50)
		
		textboxClass_render(fireSpreadBox)
		
		UiTranslate(-150, 50)
		
		drawToggle("Show fire count: ", showFireCount, function(i) showFireCount = i end)
	UiPop()
	
	UiPush()
		UiTranslate(UiWidth() * 0.5, UiHeight() * 0.5)
		--UiTranslate(0, -UiHeight() * (menuHeight / 2))
		UiTranslate(0, UiHeight() * (menuHeight / 2) - 10)
		
		bottomMenuButtons()
	UiPop()

	textboxClass_drawDescriptions()
end

function setupTextBoxes()
	local textBox01, newBox01 = textboxClass_getTextBox(1)
	local textBox02, newBox02 = textboxClass_getTextBox(2)
	
	if newBox01 then
		textBox01.name = "Fire Spread"
		textBox01.value = fireSpread .. ""
		textBox01.numbersOnly = true
		textBox01.limitsActive = true
		textBox01.numberMin = 0
		textBox01.numberMax = 99999999999
		textBox01.description = "How fast the fire spreads.\nMin: 0\nDefault: 1\nMax: 99999999999"
		textBox01.onInputFinished = function(v) SetFloat("game.fire.spread", tonumber(v)) fireSpread = tonumber(v) end
		
		fireSpreadBox = textBox01
	end
	
	if newBox02 then
		textBox02.name = "Max Fires"
		textBox02.value = maxFires .. ""
		textBox02.numbersOnly = true
		textBox02.limitsActive = true
		textBox02.numberMin = 0
		textBox02.numberMax = 1215752192
		textBox02.description = "Max amount of fires.\nSetting to 0 doesn't actually disable fires.\nEngine tries to limit to 1400.\nMin: 0\nDefault: 200\nMax: 1215752192"
		textBox02.onInputFinished = function(v) SetInt("game.fire.maxcount", tonumber(v)) maxFires = tonumber(v) end
		
		maxFiresBox = textBox02
	end
end

function drawRebindable(id, key)
	UiPush()
		UiButtonImageBox("MOD/sprites/square.png", 6, 6, 0, 0, 0, 0.5)
	
		--UiTranslate(UiWidth() * menuWidth / 1.5, 0)
	
		UiAlign("right middle")
		UiText(bindNames[id] .. "")
		
		--UiTranslate(UiWidth() * menuWidth * 0.1, 0)
		
		UiAlign("left middle")
		
		if rebinding == id then
			c_UiColor(Color4.Green)
		else
			c_UiColor(Color4.Yellow)
		end
		
		if UiTextButton(key:upper(), 40, 40) then
			rebinding = id
		end
	UiPop()
end

function menuOpenActions()
	
end

function menuUpdateActions()
	--[[if resolutionBox ~= nil then
		resolutionBox.value = resolution .. ""
	end]]--
end

function menuCloseActions()
	menuOpened = false
	rebinding = nil
	erasingBinds = 0
	erasingValues = 0
	saveKeyBinds()
	saveFloatValues()
end

function resetValues()
	menuUpdateActions()
	resetKeybinds()
	maxFiresBox.value = 200
	fireSpreadBox.value = 1
	showFireCount = false
	
	SetInt("game.fire.maxcount", 200)
	SetFloat("game.fire.spread", 1)
end

function isMenuOpen()
	return menuOpened
end

function setMenuOpen(val)
	menuOpened = val
end