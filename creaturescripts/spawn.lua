local shinys = {
"Venusaur", "Charizard", "Blastoise", "Butterfree", "Beedrill", "Pidgeot", "Rattata", "Raticate", "Raichu", "Zubat", "Golbat", "Paras", "Parasect", 
"Venonat", "Venomoth", "Growlithe", "Arcanine", "Abra", "Alakazam", "Tentacool", "Tentacruel", "Farfetch'd", "Grimer", "Muk", "Gengar", "Onix", "Krabby", 
"Kingler", "Voltorb", "Electrode", "Cubone", "Marowak", "Hitmonlee", "Hitmonchan", "Tangela", "Horsea", "Seadra", "Scyther", "Jynx", "Electabuzz", "Pinsir", 
"Magikarp", "Gyarados", "Snorlax", "Dragonair", "Dratini"}
local raros = {"Dragonite"} 

-- Thalles Vitor - Level System --
	local legendaryPokemons = {"Mew", "Mewtwo", "Articuno", "Moltres", "Zapdos", "Registeel", "Regirock", "Regice", "Rayquaza"}
--

local function doSetRandomGender(cid)
	if not isCreature(cid) then return true end
	if isSummon(cid) then return true end
	local gender = 0
	local name = getCreatureName(cid)
	if not newpokedex[name] then return true end
	local rate = newpokedex[name].gender
	if rate == 0 then
		gender = 3
	elseif rate == 1000 then
		gender = 4
	elseif rate == -1 then
		gender = 1
	elseif math.random(1, 1000) <= rate then
		gender = 4
	else
		gender = 3
	end
		
	doCreatureSetSkullType(cid, gender)
end

-- Thalles Vitor - Level System Wild --
local function doMonsterSetLevel(cid)
	if not isCreature(cid) then -- If is not a creature
		return true
	end

	if isSummon(cid) then -- If creature is a summon
		return true
	end

	-- If pokemon legendary is in legendaryPokemons array her will have levels 90 to 100
	-- If pokemon is not in array her will have levels 5 to 25
	if isInArray(legendaryPokemons, getCreatureName(cid)) then
		local level = math.random(90, 100) -- legendarys will have a random level min (90) to max (100)
		doCreatureSetNick(cid, getCreatureName(cid) .. " [" .. level .. "]")
		setPlayerStorageValue(cid, 1000, level)
	else
		local level = math.random(5, 25) -- normal pokemons will have a random level min (5) to max (25)
		doCreatureSetNick(cid, getCreatureName(cid) .. " [" .. level .. "]")
		setPlayerStorageValue(cid, 1000, level)
	end
	return true
end

local function doShiny(cid)
if isCreature(cid) then
   if isSummon(cid) then return true end
   if getPlayerStorageValue(cid, 74469) >= 1 then return true end
   if getPlayerStorageValue(cid, 22546) >= 1 then return true end 
   if isNpcSummon(cid) then return true end
   if getPlayerStorageValue(cid, 637500) >= 1 then return true end  --alterado v1.9
   
if isInArray(shinys, getCreatureName(cid)) then  --alterado v1.9 \/
   chance = 0.1    --1% chance        
elseif isInArray(raros, getCreatureName(cid)) then   --n coloquem valores menores que 0.1 !!
   chance = 0.1   --1% chance       
else
   return true
end    
    if math.random(1, 1000) <= chance*10 then  
      doSendMagicEffect(getThingPos(cid), 18)               
      local name, pos = "Shiny ".. getCreatureName(cid), getThingPos(cid)
      doRemoveCreature(cid)
      local shi = doCreateMonster(name, pos, false)
      setPlayerStorageValue(shi, 74469, 1)      
   else
       setPlayerStorageValue(cid, 74469, 1)
   end                                        --/\
else                                                            
return true
end
end
local function doZorua(cid)
if isCreature(cid) then
   if isSummon(cid) then return true end
   if getPlayerStorageValue(cid, 74469) >= 1 then return true end
   if getPlayerStorageValue(cid, 22546) >= 1 then return true end 
   if isNpcSummon(cid) then return true end
   if getPlayerStorageValue(cid, 637500) >= 1 then return true end  --alterado v1.9
   
if os.date("%X") >= "00:00:00" and os.date("%X") <= "03:00:00" then
chance = 5.75
elseif os.date("%X") >= "03:01:00" and os.date("%X") <= "05:00:00" then
chance = 5.50
elseif os.date("%X") >= "05:01:00" and os.date("%X") <= "07:00:00" then
chance = 5
elseif os.date("%X") >= "07:00:00" and os.date("%X") <= "12:00:00" then
chance = 5.20
elseif os.date("%X") >= "12:01:00" and os.date("%X") <= "16:00:00" then
chance = 5.10
elseif os.date("%X") >= "16:01:00" and os.date("%X") <= "18:00:00" then
chance = 5.10
elseif os.date("%X") >= "18:01:00" and os.date("%X") <= "20:00:00" then
chance = 5.15
elseif os.date("%X") >= "20:01:00" and os.date("%X") <= "22:00:00" then
chance = 5.18
elseif os.date("%X") >= "22:01:00" and os.date("%X") <= "23:59:59" then
chance = 5.30
else
chance = 5
end

   local test = math.random(1,20000)
        
    if test <= chance*5 then  
      doSendMagicEffect(getThingPos(cid), 18)   
	  local lvl = math.random(10, 30)	  
      local name, pos = "Zorua", getThingPos(cid)
      local shi = doCreateMonster(name, pos , false)
	  doSetCreatureOutfit(shi, getCreatureOutfit(cid), -1)
	  doCreatureSetNick(shi, getCreatureName(cid))
      doRemoveCreature(cid)
      setPlayerStorageValue(shi, 74469, 1) 
	  print("Um " .. name .. " foi spawnado em X=" .. pos.x .. " Y=" .. pos.y .. " Z=" .. pos.z)	  
   else
      setPlayerStorageValue(cid, 74469, 1)
   end                                        --/\
else                                                            
return true
end
end
                                                                
function onSpawn(cid)

    registerCreatureEvent(cid, "Experience")
	registerCreatureEvent(cid, "GeneralConfiguration")
	registerCreatureEvent(cid, "DirectionSystem")
	registerCreatureEvent(cid, "CastSystem")
	
	if isSummon(cid) then
		registerCreatureEvent(cid, "SummonDeath")
	return true
	end
	
	addEvent(doSetRandomGender, 5, cid)
	addEvent(doShiny, 10, cid)
	addEvent(doZorua, 10, cid)
	addEvent(doMonsterSetLevel, 5, cid) -- Thalles Vitor - Level System --
	addEvent(adjustWildPoke, 5, cid)

return true
end