-- Criado por Thalles Vitor --
-- EXP Pokemon System --

-- Table of EXP
-- Name of Pokemon
-- experience: the experience which the pokemon will give to player
local pokemonsExp =
{
   ["Rattata"] = {experience = 10},
   ["Caterpie"] = {experience = 10},
   ["Weedle"] = {experience = 10},
   ["Gloom"] = {experience = 20},
}

local pokemonExpAttributeName = "exp" -- name of the attribute exp
local pokemonLevelAttributeName = "level" -- name of the attribute of pokemon level
local maximumExpBase = 5000 -- 5000 is a default pokemon experience to up level (if pokemon is level 1 = 5000 * 1)
local pokemonMaxLevel = 100 -- pokemon max level

function onKill(cid, target)
   if not isPlayer(cid) then -- If the killer not is a player
      return true
   end

   if not isCreature(target) then -- If the target not is a creature don't will execute the script
      return true
   end

   local summon = getCreatureSummons(cid)[1]
   if not isSummon(summon) then -- If the userdata table summon is not a summon (if player don't have a summon)
      return true
   end

   local tableP = pokemonsExp[getCreatureName(target)]
   if not tableP then -- If cannot find the pokemon name in the table
      print("The pokemon: " .. getCreatureName(target) .. " cannot find in the table: pokemonsExp.")
      return true
   end

   local slot = getPlayerSlotItem(cid, 8)
   if slot.uid <= 0 then -- Check if the player have a pokeball in slot (8)
      return true
   end

   local level = getItemAttribute(slot.uid, pokemonLevelAttributeName)
   level = tonumber(level) -- convert attribute to tonumber (number)

   if level >= pokemonMaxLevel then -- Check if level pokemon reached in the limit
      return true
   end

   local newLevel = level + 1 -- Add level more one to advance level
   if getItemAttribute(slot.uid, pokemonExpAttributeName) < level * maximumExpBase then
      doItemSetAttribute(slot.uid, pokemonExpAttributeName, getItemAttribute(slot.uid, pokemonExpAttributeName)+tableP.experience)

      doSendAnimatedText(getThingPos(summon), "+" .. tableP.experience, COLOR_GREEN)
      doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Your pokemon gained: " .. tableP.experience .. " experience per kill: " .. getCreatureName(target) .. ".")
   else
      doItemSetAttribute(slot.uid, pokemonLevelAttributeName, newLevel)
      doItemSetAttribute(slot.uid, pokemonExpAttributeName, 0)

      doSendAnimatedText(getThingPos(summon), "LEVEL UP!", COLOR_WHITE)
      doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Congratulations! Your pokemon advanced from level: " .. level .. " to level: " .. newLevel .. ".")
   
      adjustStatus(summon, slot.uid, true, true) -- function from level system to update creature status / tag name
   end
   return true
end