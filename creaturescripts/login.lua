-- Login System of Server --
-- CALLBACK --
local events = {"LookSystem", "PokeLevel"}

function onLogin(cid)
	-- Events --
		for i = 1, #events do
			registerCreatureEvent(cid, events[i])
		end
	--
	return true
end