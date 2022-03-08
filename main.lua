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
	
	if InputPressed(binds["Clear_All_Fires"]) then
		local playerPos = GetPlayerTransform().pos
		local range = 500
		local minVec = VecAdd(playerPos, Vec(-range, -range, -range))
		local maxVec = VecAdd(playerPos, Vec(range, range, range))
		
		RemoveAabbFires(minVec, maxVec)
	end
end

function draw(dt)
	menu_draw(dt)
	
	if showFireCount and GetFireCount() > 0 then
		UiPush()
			UiAlign("left top")
			
			UiTranslate(UiWidth() * 0.02, UiHeight() * 0.02)
			
			UiColor(0, 0, 0, 0.75)
			
			UiRect(300, 40)
			
			UiTranslate(20, 20)
			
			UiFont("regular.ttf", 26)
			
			UiAlign("left middle")
			
			UiColor(1, 1, 1, 1)
			
			UiText("Fire count: " .. GetFireCount())
		UiPop()
	end
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