-- Thalles Vitor --
-- To active level system search my name in the file --

function adjustWildPoke(cid, optionalLevel)
if isMonster(cid) and pokes[getCreatureName(cid)] then

    local level = (optionalLevel and optionalLevel >= 1) and optionalLevel or getPokemonLevel(cid)  --alterado v1.8
	
	if level == nil then
	print("O Pokemon " .. getCreatureName(cid) .. " esta bugado!")
	end
	

	setPlayerStorageValue(cid, 1000, level) --alterado v1.8
    setPlayerStorageValue(cid, 1001, pokes[getCreatureName(cid)].offense * level * 4)
	setPlayerStorageValue(cid, 1002, pokes[getCreatureName(cid)].defense)
	setPlayerStorageValue(cid, 1003, pokes[getCreatureName(cid)].agility)                                  
	setPlayerStorageValue(cid, 1004, (pokes[getCreatureName(cid)].vitality * level) / 2)
	setPlayerStorageValue(cid, 1005, pokes[getCreatureName(cid)].specialattack * level * 7)
	setPlayerStorageValue(cid, 1020, pokes[getCreatureName(cid)].specialdefense)
	
    doRegainSpeed(cid)	     --alterado!
    setCreatureMaxHealth(cid, (getVitality(cid) * HPperVITwild)) 
    doCreatureAddHealth(cid,  getCreatureMaxHealth(cid))
   
    if pokes[getCreatureName(cid)].exp then
       local exp = pokes[getCreatureName(cid)].exp * baseExpRate + pokes[getCreatureName(cid)].vitality * pokemonExpPerLevelRate
       setPlayerStorageValue(cid, 1006, (exp * generalExpRate/2)*10)
       if getPlayerStorageValue(cid, 22546) == 1 then
          setPlayerStorageValue(cid, 1006, 750)
          doSetCreatureDropLoot(cid, false)      
       end   
	end
end
end       

function getPokemonXMLOutfit(name)                --alterado v1.9 \/
local path = "data/monster/pokes/Shiny/"..name..".xml"
local tpw = io.type(io.open(path))

if not tpw then
   path = "data/monster/pokes/geracao 2/"..name..".xml"
   tpw = io.type(io.open(path))
end
if not tpw then
   path = "data/monster/pokes/geracao 1/"..name..".xml"
   tpw = io.type(io.open(path))
end
if not tpw then
   path = "data/monster/pokes/"..name..".xml"
   tpw = io.type(io.open(path))
end   
if not tpw then
   return print("[getPokemonXMLOutfit] Poke with name: "..name.." ins't in any paste on monster/pokes/") and 2
end
   local arq = io.open(path, "a+")
   local txt = arq:read("*all")
   arq:close()
   local a, b = txt:find('look type="(.-)"')
   txt = string.sub(txt, a + 11, b - 1)
return tonumber(txt)
end 

function doEvolutionOutfit(cid, oldout, outfit)
	if not isCreature(cid) then return true end
		if getCreatureOutfit(cid).lookType == oldout then
			doSetCreatureOutfit(cid, {lookType = outfit}, -1)
		else
			doSetCreatureOutfit(cid, {lookType = oldout}, -1)
		end
end

function doSendEvolutionEffect(cid, pos, evolution, turn, ssj, evolve, f, h)
	if not isCreature(cid) then
		doSendAnimatedText(pos, "CANCEL", 215)
	    return true 
    end
	if evolve then
		doEvolvePokemon(getCreatureMaster(cid), {uid = cid}, evolution, 0, 0)
	return true
	end
	doSendMagicEffect(pos, 18)
		if ssj then
			sendSSJEffect(evo)
		end
	doEvolutionOutfit(cid, f, h)
	addEvent(doSendEvolutionEffect, math.pow(1900, turn/20), cid, getThingPos(cid), evolution, turn - 1, turn == 19, turn == 2, f, h)
end

function sendSSJEffect(cid)
	if not isCreature(cid) then return true end
	local pos1 = getThingPos(cid)
	local pos2 = getThingPos(cid)
	pos2.x = pos2.x + math.random(-1, 1)
	pos2.y = pos2.y - math.random(1, 2)
	doSendDistanceShoot(pos1, pos2, 37)
	addEvent(sendSSJEffect, 45, cid)
end

function sendFinishEvolutionEffect(cid, alternate)
	if not isCreature(cid) then return true end
	local pos1 = getThingPos(cid)

	if alternate then
		local pos = {
		[1] = {-2, 0},
		[2] = {-1, -1},
		[3] = {0, -2},
		[4] = {1, -1},
		[5] = {2, 0},
		[6] = {1, 1},
		[7] = {0, 2},
		[8] = {-1, 1}}
		for a = 1, 8 do
			local pos2 = getThingPos(cid)
			pos2.x = pos2.x + pos[a][1]
			pos2.y = pos2.y + pos[a][2]
			local pos = getThingPos(cid)
			doSendDistanceShoot(pos2, pos, 37)
			addEvent(doSendDistanceShoot, 300, pos, pos2, 37)
		end
	else
		for a = 0, 3 do
			doSendDistanceShoot(pos1, getPosByDir(pos1, a), 37)
		end
		for a = 4, 7 do
			addEvent(doSendDistanceShoot, 600, pos1, getPosByDir(pos1, a), 37)
		end
	end
end

function doEvolvePokemon(cid, item2, theevo, stone1, stone2)

	if not isCreature(cid) then return true end

	if not pokes[theevo] or not pokes[theevo].offense then
	doReturnPokemon(cid, item2.uid, getPlayerSlotItem(cid, 8), pokeballs[getPokeballType(getPlayerSlotItem(cid, 8).itemid)].effect, false, true)
	return true
	end

	local owner = getCreatureMaster(item2.uid)
	local pokeball = getPlayerSlotItem(cid, 8)
	local description = "Contains a "..theevo.."."
	local pct = getCreatureHealth(item2.uid) / getCreatureMaxHealth(item2.uid)

		doItemSetAttribute(pokeball.uid, "hp", pct)

		doItemSetAttribute(pokeball.uid, "poke", theevo)
		doItemSetAttribute(pokeball.uid, "description", "Contains a "..theevo..".")

		doPlayerSendTextMessage(cid, 27, "Congratulations! Your "..getPokeName(item2.uid).." evolved into a "..theevo.."!")		

		doSendMagicEffect(getThingPos(item2.uid), 18)
		doTransformItem(getPlayerSlotItem(cid, 7).uid, fotos[theevo])
		doSendMagicEffect(getThingPos(cid), 173)

		local oldpos = getThingPos(item2.uid)
		local oldlod = getCreatureLookDir(item2.uid)
		doRemoveCreature(item2.uid)

		doSummonMonster(cid, theevo)
		local pk = getCreatureSummons(cid)[1]

		doTeleportThing(pk, oldpos, false)
		doCreatureSetLookDir(pk, oldlod)

		sendFinishEvolutionEffect(pk, true)
		addEvent(sendFinishEvolutionEffect, 550, pk, true)
		addEvent(sendFinishEvolutionEffect, 1050, pk)
		
		doPlayerRemoveItem(cid, stone1, 1)
		doPlayerRemoveItem(cid, stone2, 1)

		doAddPokemonInOwnList(cid, theevo)

		local happy = getItemAttribute(pokeball.uid, "happy")

		doItemSetAttribute(pokeball.uid, "happy", happy + happyGainedOnEvolution)

		if happy + happyGainedOnEvolution > 255 then
			doItemSetAttribute(pokeball.uid, "happy", 255)
		end

		adjustStatus(pk, pokeball.uid, true, false)

		if useKpdoDlls then
			doUpdateMoves(cid)
		end
end

function doMathDecimal(number, casas)

	if math.floor(number) == number then return number end

	local c = casas and casas + 1 or 3

	for a = 0, 10 do
		if math.floor(number) < math.pow(10, a) then
			local str = string.sub(""..number.."", 1, a + c)
			return tonumber(str)	
		end
	end

return number
end

function doAdjustWithDelay(cid, pk, health, vit, status)
if isCreature(cid) then                                   
   adjustStatus(pk, getPlayerSlotItem(cid, 8).uid, health, vir, status)
end
end

function setBoost(cid, boost)
local boostc = boost
local boostcalculator = boostc * 500
local vida = 0
if(boost == 1) then
vida = 50
elseif(boost == 50) then
vida = 100
end
return vida;
end

function adjustStatus(pk, item, health, vite, conditions)

	if not isCreature(pk) then return true end

	-- Thalles Vitor - Level System Check if pokemon has level attribute in pokeball  --
	if not getItemAttribute(item, "level") then
		doItemSetAttribute(item, "level", 1)
		doItemSetAttribute(item, "exp", 0)
	end
	--

	local gender = getItemAttribute(item, "gender") and getItemAttribute(item, "gender") or 0
	addEvent(doCreatureSetSkullType, 10, pk, gender)

	-- Thalles Vitor - Level System (BUFFS PER LEVEL) --
		local buffLevel = 1.0
		local level = getItemAttribute(item, "level") or 1
		if level >= 10 and level <= 10 then
			buffLevel = 1.1
		elseif level >= 20 and level <= 20 then
			buffLevel = 1.2
		elseif level >= 30 and level <= 30 then
			buffLevel = 1.7
		elseif level >= 40 and level <= 40 then
			buffLevel = 1.8
		elseif level >= 50 and level <= 50 then
			buffLevel = 1.9
		elseif level >= 60 and level <= 60 then
			buffLevel = 2.0
		elseif level >= 70 and level <= 70 then
			buffLevel = 2.1
		elseif level >= 80 and level <= 80 then
			buffLevel = 2.2
		elseif level >= 90 and level <= 90 then
			buffLevel = 2.3
		elseif level >= 100 and level <= 100 then
			buffLevel = 2.4
		end
	--

	-- Thalles Vitor - Added  * buffLevel in the status
	-- You will remove  * buffLevel of any status --
    setPlayerStorageValue(pk, 1001, pokes[getCreatureName(pk)].offense * (getMasterLevel(pk) + getPokemonBoost(pk)) * buffLevel)
	setPlayerStorageValue(pk, 1002, pokes[getCreatureName(pk)].defense * buffLevel)             
	setPlayerStorageValue(pk, 1003, pokes[getCreatureName(pk)].agility * buffLevel)
	setPlayerStorageValue(pk, 1004, pokes[getCreatureName(pk)].vitality * 75 + (50 * getPokemonBoost(pk)) * buffLevel)
	setPlayerStorageValue(pk, 1005, pokes[getCreatureName(pk)].specialattack * (getMasterLevel(pk) + getPokemonBoost(pk) )*9 * buffLevel)
	setPlayerStorageValue(pk, 1020, pokes[getCreatureName(pk)].specialdefense + (2 * getPokemonBoost(pk)) * buffLevel)
	
	if gender == SEX_MALE then
	setPlayerStorageValue(pk, 1001, pokes[getCreatureName(pk)].offense * (getMasterLevel(pk) + getPokemonBoost(pk)) + 20)
	end
	if gender == SEX_FEMALE then
	setPlayerStorageValue(pk, 1004, pokes[getCreatureName(pk)].vitality * 75 + (50 * getPokemonBoost(pk)) + 90)
	end
	if vite == true then
		local pct = getCreatureHealth(pk) / getCreatureMaxHealth(pk)
		local vit = getVitality(pk)
		setCreatureMaxHealth(pk, ( vit * HPperVITsummon ))
		doCreatureAddHealth(pk, pct * vit * HPperVITsummon)
	end
                                                                      
	doRegainSpeed(pk)  

	local nick = getItemAttribute(item, "poke")

    if isGhostPokemon(pk) then
       setPlayerStorageValue(pk, 8981, 1)
       updateGhostWalk(pk)
    end
    	

	if getItemAttribute(item, "nick") then
		nick = getItemAttribute(item, "nick")
	end

	setPlayerStorageValue(pk, 1007, nick)
	
	-- Thalles Vitor --
		local lvl = getItemAttribute(item, "level") or 1
		nick = nick .. " [" .. lvl .. "]"
	--
	
	-- If the function doCreatureSetNick don't exist in the source, will be necessary add her in the source.
	doCreatureSetNick(pk, nick)

	if not getItemAttribute(item, "happy") then
		doItemSetAttribute(item, "happy", 120)
	end

	if not getItemAttribute(item, "hunger") then
		doItemSetAttribute(item, "hunger", 5)
	end

	local happy = getItemAttribute(item, "happy")
		if happy < 0 then
			happy = 1
		end
	setPlayerStorageValue(pk, 1008, happy)

	local hunger = getItemAttribute(item, "hunger")
	setPlayerStorageValue(pk, 1009, hunger)

	if health == true then
		local mh = HPperVITsummon * getVitality(pk)
		local rd = 1 - (tonumber(getItemAttribute(item, "hp")))
		setCreatureMaxHealth(pk, mh)                                  
		doCreatureAddHealth(pk, getCreatureMaxHealth(pk))
		doCreatureAddHealth(pk, -(getCreatureMaxHealth(pk) * rd))
	end

	if isSummon(pk) and conditions then
		local burn = getItemAttribute(item, "burn")   
		if burn and burn >= 0 then
		   local ret = {id = pk, cd = burn, check = false, damage = getItemAttribute(item, "burndmg"), cond = "Burn"}
		   addEvent(doCondition2, 3500, ret)
		end

		local poison = getItemAttribute(item, "poison")
		if poison and poison >= 0 then
		   local ret = {id = pk, cd = poison, check = false, damage = getItemAttribute(item, "poisondmg"), cond = "Poison"}
		   addEvent(doCondition2, 1500, ret)
		end

        local confuse = getItemAttribute(item, "confuse")
		if confuse and confuse >= 0 then
		   local ret = {id = pk, cd = confuse, check = false, cond = "Confusion"}
		   addEvent(doCondition2, 1200, ret)                                                
		end

        local sleep = getItemAttribute(item, "sleep")
		if sleep and sleep >= 0 then
		   local ret = {id = pk, cd = sleep, check = false, first = true, cond = "Sleep"}
		   doCondition2(ret)
		end
		
		local miss = getItemAttribute(item, "miss")     
		if miss and miss >= 0 then      
        end
        
        local fear = getItemAttribute(item, "fear")
        if fear and fear >= 0 then
           local ret = {id = pk, cd = fear, check = false, skill = getItemAttribute(item, "fearSkill"), cond = "Fear"}
           doCondition2(ret)
        end
        
        local silence = getItemAttribute(item, "silence")
        if silence and silence >= 0 then      
           local ret = {id = pk, cd = silence, eff = getItemAttribute(item, "silenceEff"), check = false, cond = "Silence"}
           doCondition2(ret)
        end                                     
        
        local stun = getItemAttribute(item, "stun")
        if stun and stun >= 0 then
           local ret = {id = pk, cd = stun, eff = getItemAttribute(item, "stunEff"), check = false, spell = getItemAttribute(item, "stunSpell"), cond = "Stun"}
           doCondition2(ret)
        end 
                                                       
        local paralyze = getItemAttribute(item, "paralyze")
        if paralyze and paralyze >= 0 then
           local ret = {id = pk, cd = paralyze, eff = getItemAttribute(item, "paralyzeEff"), check = false, first = true, cond = "Paralyze"}
           doCondition2(ret)
        end  
                                                     
        local slow = getItemAttribute(item, "slow")
        if slow and slow >= 0 then
           local ret = {id = pk, cd = slow, eff = getItemAttribute(item, "slowEff"), check = false, first = true, cond = "Slow"}
           doCondition2(ret)
        end                                              
        
        local leech = getItemAttribute(item, "leech")
        if leech and leech >= 0 then
           local ret = {id = pk, cd = leech, attacker = 0, check = false, damage = getItemAttribute(item, "leechdmg"), cond = "Leech"}
           doCondition2(ret)
        end                               
        
        for i = 1, 3 do
            local buff = getItemAttribute(item, "Buff"..i)
            if buff and buff >= 0 then
               local ret = {id = pk, cd = buff, eff = getItemAttribute(item, "Buff"..i.."eff"), check = false, 
               buff = getItemAttribute(item, "Buff"..i.."skill"), first = true, attr = "Buff"..i}
               doCondition2(ret)
            end
        end
               
	end
	                                                                      --alterado v1.9
    if getItemAttribute(item, "boost") and getItemAttribute(item, "boost") >= 50 and getItemAttribute(item, "aura") then
       sendAuraEffect(pk, auraSyst[getItemAttribute(item, "aura")])        
    end
    
    if getPlayerStorageValue(getCreatureMaster(pk), 6598754) >= 1 then
        setPlayerStorageValue(pk, 6598754, 1)                               
    elseif getPlayerStorageValue(getCreatureMaster(pk), 6598755) >= 1 then
        setPlayerStorageValue(pk, 6598755, 1)
    end

return true
end

function setWildPokemonLevel(cid, optionalLevel, optionalStatus, optionalNick, optionalExtraExp)

	if not isCreature(cid) then return true end
	if not pokes[getCreatureName(cid)] then return true end  --alterado v2.6

	local levelRange = 0
	local off = 0
	local def = 0
	local agi = 0
	local spatk = 0
	local vit = 0
	local this = getCreatureName(cid)
	local ee = 1

	if optionalExtraExp then
		ee = optionalExtraExp
	end


	if optionalLevel and tonumber(optionalLevel) >= 1 then                --alterado v2.8\/
	    levelRange = optionalLevel
	else
	    levelRange = math.random(pokes[this].wildLvl) 
	end                                                                                          

	local status = getPokemonStatus(this)
		if status then
			off = status.off
			def = status.def
			agi = status.agi
			vit = status.vit
			spatk = status.spatk
		end

	setPlayerStorageValue(cid, 1000, (levelRange > 100 and 100 or levelRange)) --alterado v2.8

	if optionalStatus and optionalStatus.off then
		setPlayerStorageValue(cid, 1001, optionalStatus.offense)
		setPlayerStorageValue(cid, 1002, optionalStatus.defense)
		setPlayerStorageValue(cid, 1003, optionalStatus.agility)
		setPlayerStorageValue(cid, 1004, optionalStatus.vitality)
		setPlayerStorageValue(cid, 1005, optionalStatus.specialattack)
		setPlayerStorageValue(cid, 1020, optionalStatus.specialdefense)
		setPlayerStorageValue(cid, 1011, optionalStatus.offense)
		setPlayerStorageValue(cid, 1012, optionalStatus.defense)
		setPlayerStorageValue(cid, 1013, optionalStatus.agility)
		setPlayerStorageValue(cid, 1014, optionalStatus.vitality)
		setPlayerStorageValue(cid, 1015, optionalStatus.specialattack)
		setPlayerStorageValue(cid, 1021, optionalStatus.specialdefense)
	else
		setPlayerStorageValue(cid, 1001, 5 + math.random(off * levelRange * 0.9, off * levelRange * 1.8))
		setPlayerStorageValue(cid, 1002, 5 + math.random(def * levelRange * 0.9, def * levelRange * 1.8))
		setPlayerStorageValue(cid, 1003, math.random(agi * levelRange * 0.9, agi * levelRange * 1.8))
		setPlayerStorageValue(cid, 1004, math.random(vit * levelRange * 0.9, vit * levelRange * 1.8))
		setPlayerStorageValue(cid, 1005, 5 + math.random(spatk * levelRange * 0.9, spatk * levelRange * 1.8))
		setPlayerStorageValue(cid, 1011, getPlayerStorageValue(cid, 1001))
		setPlayerStorageValue(cid, 1012, getPlayerStorageValue(cid, 1002))
		setPlayerStorageValue(cid, 1013, getPlayerStorageValue(cid, 1003))
		setPlayerStorageValue(cid, 1014, getPlayerStorageValue(cid, 1004))
		setPlayerStorageValue(cid, 1015, getPlayerStorageValue(cid, 1005))
		setPlayerStorageValue(cid, 1021, getPlayerStorageValue(cid, 1020))
	end

	doRegainSpeed(cid)

	setCreatureMaxHealth(cid, getCreatureMaxHealth(cid) + getPlayerStorageValue(cid, 1004) * HPperVIT * vitReductionForWild)
	doCreatureAddHealth(cid, getCreatureMaxHealth(cid))
    
	if pokes[getCreatureName(cid)].exp then
		--getMonsterInfo(getCreatureName(cid)).experience
		local exp = (50 + pokes[getCreatureName(cid)].exp) * baseExpRate + pokes[getCreatureName(cid)].vitality * levelRange * pokemonExpPerLevelRate
		setPlayerStorageValue(cid, 1006, exp * generalExpRate * ee)
		if getPlayerStorageValue(cid, 22546) == 1 then
          setPlayerStorageValue(cid, 1006, 750)
          doSetCreatureDropLoot(cid, false)         --edited golden arena
       end  
	end

	local wildshow = wildBeforeNames and "Wild " or ""
	if optionalNick then
		if hideWildsLevel then
			doCreatureSetNick(cid, optionalNick)
		else
			doCreatureSetNick(cid, optionalNick.." ["..getWildPokemonLevel(cid).."]")
		end
	else
		if hideWildsLevel then
			doCreatureSetNick(cid, ""..wildshow..""..getCreatureName(cid).."")
		else
			doCreatureSetNick(cid, ""..wildshow..""..getCreatureName(cid).." ["..getWildPokemonLevel(cid).."]")
		end
	end
end

function getOffense(cid)
	if not isCreature(cid) then return 0 end
return tonumber(getPlayerStorageValue(cid, 1001))
end

function getDefense(cid)
	if not isCreature(cid) then return 0 end
return tonumber(getPlayerStorageValue(cid, 1002))
end

function getSpecialDefense(cid)
	if not isCreature(cid) then return 0 end
return tonumber(getPlayerStorageValue(cid, 1020))
end

function getSpeed(cid)
	if not isCreature(cid) then return 0 end
return tonumber(getPlayerStorageValue(cid, 1003))
end

function getVitality(cid)
	if not isCreature(cid) then return 0 end
return tonumber(getPlayerStorageValue(cid, 1004))
end

function getSpecialAttack(cid)
	if not isCreature(cid) then return 0 end
return tonumber(getPlayerStorageValue(cid, 1005))
end

function getHappiness(cid)
	if not isCreature(cid) then return 0 end
return tonumber(getPlayerStorageValue(cid, 1008))
end

function getPokemonLevel(cid, dex)
if not isCreature(cid) then return 0 end 
    if not dex then                      --alterado v1.9
       if ehMonstro(cid) and getPlayerStorageValue(cid, 1000) > 0 then  
          return getPlayerStorageValue(cid, 1000)
       elseif ehMonstro(cid) then 
          return pokes[getCreatureName(cid)].wildLvl             
       end
    end   
return pokes[getCreatureName(cid)].level
end

function getPokemonLevelByName(name)
return pokes[name] and pokes[name].level or 0  --alterado v1.9
end

function getMasterLevel(poke)
    if not isSummon(poke) then return 0 end
return getPlayerLevel(getCreatureMaster(poke))
end

function getPokemonBoost(poke)
    if not isSummon(poke) then return 0 end
return getItemAttribute(getPlayerSlotItem(getCreatureMaster(poke), 8).uid, "boost") or 0
end

function getPokeballBoost(ball)
    if not isPokeball(ball.itemid) then return 0 end  --alterado v1.8
return getItemAttribute(ball.uid, "boost") or 0
end

function getPokeName(cid)
	if not isSummon(cid) then return getCreatureName(cid) end
	if getCreatureName(cid) == "Evolution" then return getPlayerStorageValue(cid, 1007) end
	
local item = getPlayerSlotItem(getCreatureMaster(cid), 8)
	if getItemAttribute(item.uid, "nick") then
	   return getItemAttribute(item.uid, "nick")
	end
return getCreatureName(cid)
end

function getPokeballName(item, truename)
if not truename and getItemAttribute(item, "nick") then
return getItemAttribute(item, "nick")
end
return getItemAttribute(item, "poke")
end

function getPokemonName(cid)
return getCreatureName(cid)
end

function getPokemonGender(cid) --alterado v1.9
return getCreatureSkullType(cid)
end

function setPokemonGender(cid, gender)
if isCreature(cid) and gender then        --alterado v1.8
   doCreatureSetSkullType(cid, gender)
   return true
end
return false
end

function getWildPokemonExp(cid)
return getPlayerStorageValue(cid, 1006)
end