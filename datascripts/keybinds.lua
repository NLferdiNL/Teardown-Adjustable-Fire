#include "scripts/utils.lua"

binds = {
	Clear_All_Fires = "l",
}

local bindBackup = deepcopy(binds)

bindOrder = {
	"Clear_All_Fires",
}
		
bindNames = {
	Clear_All_Fires = "Clear All Fires",
}

function resetKeybinds()
	binds = deepcopy(bindBackup)
end

function getFromBackup(id)
	return bindBackup[id]
end