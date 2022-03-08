#include "datascripts/keybinds.lua"

moddataPrefix = "savegame.mod.adjustablefire"

function saveFileInit()
	saveVersion = GetInt(moddataPrefix .. "Version")
	
	fireSpread = GetInt(moddataPrefix .. "FireSpread")
	maxFires = GetFloat(moddataPrefix .. "MaxFires")
	showFireCount = GetBool(moddataPrefix .. "ShowFireCount")
	
	loadKeyBinds()
	
	if saveVersion < 1 or saveVersion == nil then
		saveVersion = 1
		SetInt(moddataPrefix .. "Version", saveVersion)
		
		maxFires = 200
		SetInt(moddataPrefix .. "MaxFires", maxFires)
		
		fireSpread = 1
		SetFloat(moddataPrefix .. "FireSpread", fireSpread)
	end
	
	if saveVersion < 2 or saveVersion == nil then
		saveVersion = 2
		SetInt(moddataPrefix .. "Version", saveVersion)
		
		showFireCount = false
		SetBool(moddataPrefix .. "ShowFireCount", showFireCount)
	end
end

function loadKeyBinds()
	for i = 1, #bindOrder do
		local currBindID = bindOrder[i]
		local boundKey = GetString(moddataPrefix .. "Keybind" .. currBindID)
		
		if boundKey == nil or boundKey == "" then
			boundKey = getFromBackup(currBindID)
		end
		
		binds[currBindID] = boundKey
	end
end

function saveKeyBinds()
	for i = 1, #bindOrder do
		local currBindID = bindOrder[i]
		local boundKey = binds[currBindID]
		
		SetString(moddataPrefix .. "Keybind" .. currBindID, boundKey)
	end
end

function saveFloatValues()
	SetInt(moddataPrefix .. "MaxFires", maxFires)
	SetFloat(moddataPrefix .. "FireSpread", fireSpread)
	SetBool(moddataPrefix .. "ShowFireCount", showFireCount)
end