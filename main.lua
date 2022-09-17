#include "scripts/utils.lua"
#include "scripts/savedata.lua"
#include "scripts/menu.lua"
#include "datascripts/keybinds.lua"
#include "datascripts/inputList.lua"

toolName = "adjustablefire"
toolReadableName = "Adjustable Fire"

local menu_disabled = false

fireSpread = 1
maxFires = 200

local fireClearActive = false

function init()
	saveFileInit()
	menu_init()
	
	SetInt("game.fire.maxcount", maxFires)
	SetFloat("game.fire.spread", fireSpread)
end

function tick(dt)
	if not menu_disabled then
		menu_tick(dt)
	end
	
	if InputPressed(binds["Toggle_No_Fire"]) and not isMenuOpen() then
		fireClearActive = not fireClearActive
	end
	
	if InputPressed(binds["Clear_All_Fires"]) or (fireClearActive and GetFireCount() > 0) then
		local playerPos = GetPlayerTransform().pos
		local range = 500
		local minVec = VecAdd(playerPos, Vec(-range, -range, -range))
		local maxVec = VecAdd(playerPos, Vec(range, range, range))
		
		RemoveAabbFires(minVec, maxVec)
	end
end

function draw(dt)
	menu_draw(dt)
	
	
	UiPush()
		UiAlign("left top")
		
		UiTranslate(UiHeight() * 0.02, UiHeight() * 0.02)
		
		UiFont("regular.ttf", 26)
		
		UiAlign("left top")
		
		local margin = 20
		
		if showFireCount then
			local fireCountText = "Fire count: " .. GetFireCount()
			local fireTextWidth, fireTextHeight = UiGetTextSize(fireCountText)
			UiColor(0, 0, 0, 0.75)
		
			UiRect(fireTextWidth + margin, fireTextHeight + margin / 2)
			
			UiTranslate(margin / 2, margin / 4)
			
			UiColor(1, 1, 1, 1)
		
			UiText(fireCountText)
			
			UiTranslate(-margin / 2, -margin / 4)
			
			UiTranslate(0, fireTextHeight + margin)
		end
		
		if fireClearActive then
			local text = "No fire active!"
			
			local textWidth, textHeight = UiGetTextSize(text)
			
			UiColor(0, 0, 0, 0.75)
			
			UiRect(textWidth + margin, textHeight + margin / 2)
			
			UiTranslate(margin / 2, margin / 4)
			
			UiColor(1, 1, 1, 1)
			
			UiText(text)
		end
	UiPop()
end

-- UI Functions (excludes sound specific functions)
-- Creation Functions

-- Object handlers

-- Tool Functions

-- Particle Functions

-- Action functions

-- Sprite Functions

-- UI Sound Functions

-- Misc Functions