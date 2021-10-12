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