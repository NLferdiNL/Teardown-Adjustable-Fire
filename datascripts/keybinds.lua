#include "scripts/utils.lua"

binds = {
	Clear_All_Fires = "l",
	Toggle_No_Fire = "k",
}

local bindBackup = deepcopy(binds)

bindOrder = {
	"Clear_All_Fires",
	"Toggle_No_Fire",
}
		
bindNames = {
	Clear_All_Fires = "Clear All Fires",
	Toggle_No_Fire = "Toggle No Fire",
}

function resetKeybinds()
	binds = deepcopy(bindBackup)
end

function getFromBackup(id)
	return bindBackup[id]
end