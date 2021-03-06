--[[

    GIBE SUPPORT PLOX v0.1 - Astoriane Support Bundle - TEMPLATE

]]

if myHero.charName ~= "Zyra" then return end

local _ScriptName = "SuppPlox"
local _ScriptVersion = 0.1
local _ScriptAuthor = "Astoriane"

local AutoUpdate = false
local SrcLibURL = "https://raw.github.com/TheRealSource/public/master/common/SourceLib.lua"
local SrcLibPath = LIB_PATH .. "SourceLib.lua"
local SrcLibDownload = false

local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "Astoriane/BoL-Scripts/SuppPlox/master/" .. _ScriptName .. " - " .. myHero.charName .. ".lua"

local orbwalker = "SOW"

function SendMessage(msg)

    PrintChat("<font color='#7D1935'><b>[" .. _ScriptName .. " " .. myHero.charName .. "]</b> </font><font color='#FFFFFF'>" .. tostring(msg) .. "</font>")

end

if FileExist(SrcLibPath) then

    require "SourceLib"
    SrcLibDownload = false

else

    SrcLibDownload = true
    DownloadFile(SrcLibURL, SrcLibPath, function() SendMessage("Downloaded SourceLib, please reload. (Double F9)") end)

end

if SrcLibDownload == true then

    SendMessage("SourceLib was not found. Downloading...")
    return

end

if AutoUpdate then

    SourceUpdater(ScriptName .. " - " .. myHero.charName, tostring(ScriptVersion), UPDATE_HOST, UPDATE_PATH, SCRIPT_PATH .. GetCurrentEnv().FILE_NAME):CheckUpdate()

end

local libs = Require(_ScriptName .. " Libs")
libs:Add("VPrediction", "https://raw.githubusercontent.com/Hellsing/BoL/master/common/VPrediction.lua")
libs:Add("SOW", "https://raw.githubusercontent.com/Hellsing/BoL/master/common/SOW.lua")
libs:Add("Prodiction", "https://bitbucket.org/Klokje/public-klokjes-bol-scripts/raw/ec830facccefb3b52212dba5696c08697c3c2854/Test/Prodiction/Prodiction.lua")

libs:Check()

if libs.downloadNeeded == true then return end

local Recalling

function OnLoad()

    __initVars()
    __load()
    __initLibs()
    __initMenu()
    __initPriorities()
    __initOrbwalkers()

end

function OnTick()

    if not _G.SuppPlox_Loaded then return end

    carryKey    = Menu.keys.carry
    harassKey   = Menu.keys.harass
    farmKey     = Menu.keys.farm

    if carryKey     then Combo(Target)  end
    if harassKey    then Harass(Target) end
    if farmKey      then Farm()         end

    if Menu.ks.enabled then KS() end

    Update()

end 

function OnUnload()

    if not _G.SuppPlox_Loaded then return end

end

function OnDraw()

    if not _G.SuppPlox_Loaded then return end

    __draw()

end

function OnProcessSpell(unit, spell)

    if not _G.SuppPlox_Loaded then return end

end

function OnCreateObj(obj)

    if not _G.SuppPlox_Loaded then return end

end

function OnDeleteObj(obj)

    if not _G.SuppPlox_Loaded then return end

end

-- INITIALIZE GLOBAL VARIABLES --
function __initVars()

    _G.SuppPlox_Loaded = false
    _G.SuppPlox_AutoItems = true

    SpellTable = {
    
        [_Q] = {

            name = "Deadly Bloom",
            ready = false,
            range = 800,
            width = 100, width2 = 150,
            speed = 1400,
            delay = 0.5,
            self = false,
            ally = false

        },

        [_W] = {

            name = "Rampant Growth",
            ready = false,
            range = 840,
            width = 10,
            speed = math.huge,
            delay = 0.2432,
            self = false,
            ally = false

        },

        [_E] = {

            name = "Grasping Roots",
            ready = false,
            range = 1000,
            width = 40,
            speed = 1200,
            delay = 0.5,
            self = false,
            ally = false

        },

        [_R] = {

            name = "Stranglethorns",
            ready = false,
            range = 700,
            width = 500,
            speed = math.huge,
            delay = 0.500,
            self = false,
            ally = false

        }

    }

    ItemTable = {
    
        [3092] = { id = "frost",      name = "Frost Queen's Claim",        range = 850, slot = nil, ready = false },
        [3143] = { id = "randuin",       name = "Randuin's Omen",             range = 500, slot = nil, ready = false },
        [3190] = { id = "locket",   name = "Locket of the Iron Solari",  range = 600, slot = nil, ready = false },
        [3222] = { id = "crucible",       name = "Mikael's Crucible",          range = 600, slot = nil, ready = false }

    }

    PriorityTable = {
        AP = {
            "Annie", "Ahri", "Akali", "Anivia", "Annie", "Azir", "Brand", "Cassiopeia", "Diana", "Evelynn", "FiddleSticks", "Fizz", "Gragas", "Heimerdinger", "Karthus",
            "Kassadin", "Katarina", "Kayle", "Kennen", "Leblanc", "Lissandra", "Lux", "Malzahar", "Mordekaiser", "Morgana", "Nidalee", "Orianna",
            "Ryze", "Sion", "Swain", "Syndra", "Teemo", "TwistedFate", "Veigar", "Viktor", "Vladimir", "Xerath", "Ziggs", "Zyra", "Velkoz"
        },

        Support = {
            "Alistar", "Blitzcrank", "Braum", "Janna", "Karma", "Leona", "Lulu", "Nami", "Nunu", "Sona", "Soraka", "Taric", "Thresh", "Zilean", "Braum"
        },

        Tank = {
            "Amumu", "Chogath", "DrMundo", "Galio", "Hecarim", "Malphite", "Maokai", "Nasus", "Rammus", "Sejuani", "Nautilus", "Shen", "Singed", "Skarner", "Volibear",
            "Warwick", "Yorick", "Zac"
        },

        AD_Carry = {
            "Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jayce", "Jinx", "KogMaw", "Lucian", "MasterYi", "MissFortune", "Pantheon", "Quinn", "Shaco", "Sivir",
            "Talon","Tryndamere", "Tristana", "Twitch", "Urgot", "Varus", "Vayne", "Yasuo", "Zed"
        },

        Bruiser = {
            "Aatrox", "Darius", "Elise", "Fiora", "Gangplank", "Garen", "Irelia", "JarvanIV", "Jax", "Khazix", "LeeSin", "Nocturne", "Olaf", "Poppy",
            "Renekton", "Rengar", "Riven", "Rumble", "Shyvana", "Trundle", "Udyr", "Vi", "MonkeyKing", "XinZhao"
        }
    }

end

-- LOAD SEQUENCE --
function __load()

    SendMessage("SuppPlox by Astoriane")
    SendMessage("Script version v" .. _ScriptVersion .. " loaded for " .. myHero.charName)

    if _G.Activator then 
        SendMessage("Activator Detected. Disabling AutoItems...")
        if _G.SuppPlox_AutoItems == true then _G.SuppPlox_AutoItems = false end
    else
        SendMessage("Activator not Detected. Using SuppPlox_AutoItems")
        if not _G.SuppPlox_AutoItems then _G.SuppPlox_AutoItems = true end
    end

end

-- LIBRARY INITIALIZATION --
function __initLibs()

    VP = VPrediction()
    SOWi = SOW(VP)
    PROD = Prodiction

    enemyMinions = minionManager(MINION_ENEMY, GetMaxRange(), myHero, MINION_SORT_HEALTH_ASC)

end

-- INITIALIZE MENU --
function __initMenu()

    Menu = scriptConfig("[" .. _ScriptName .. "] " .. myHero.charName, "SuppPlox"..myHero.charName)

    Menu:addSubMenu("[" .. myHero.charName.. "] Keybindings", "keys")
        Menu.keys:addParam("carry", "Carry Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, 32)
        Menu.keys:addParam("harass", "Harass Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte('C'))
        Menu.keys:addParam("farm", "Lane Clear Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte('V'))


    Menu:addSubMenu("[" .. myHero.charName.. "] Combo", "combo")
        Menu.combo:addParam("useQ", "Enable Q (".. SpellTable[_Q].name ..")", SCRIPT_PARAM_ONOFF, true)
        Menu.combo:addParam("useW", "Enable W (".. SpellTable[_W].name ..")", SCRIPT_PARAM_ONOFF, true)
        Menu.combo:addParam("useE", "Enable E (".. SpellTable[_E].name ..")", SCRIPT_PARAM_ONOFF, true)
        Menu.combo:addParam("useR", "Enable R (".. SpellTable[_R].name ..")", SCRIPT_PARAM_ONOFF, true)
        Menu.combo:addParam("mana", "Min Mana For Combo", SCRIPT_PARAM_SLICE, 0, 0, 100, 0)

    Menu:addSubMenu("[" .. myHero.charName.. "] Harass", "harass")
        Menu.harass:addParam("useQ", "Enable Q (".. SpellTable[_Q].name ..")", SCRIPT_PARAM_ONOFF, true)
        Menu.harass:addParam("useW", "Enable W (".. SpellTable[_W].name ..")", SCRIPT_PARAM_ONOFF, true)
        Menu.harass:addParam("useE", "Enable E (".. SpellTable[_E].name ..")", SCRIPT_PARAM_ONOFF, true)
        Menu.harass:addParam("useR", "Enable R (".. SpellTable[_R].name ..")", SCRIPT_PARAM_ONOFF, true)
        Menu.harass:addParam("mana", "Min Mana For Harass", SCRIPT_PARAM_SLICE, 0, 0, 100, 0)

    Menu:addSubMenu("[" .. myHero.charName.. "] Farm", "farm")
        Menu.farm:addParam("useQ", "Enable Q (".. SpellTable[_Q].name ..")", SCRIPT_PARAM_ONOFF, true)
        Menu.farm:addParam("useW", "Enable W (".. SpellTable[_W].name ..")", SCRIPT_PARAM_ONOFF, true)
        Menu.farm:addParam("useE", "Enable E (".. SpellTable[_E].name ..")", SCRIPT_PARAM_ONOFF, true)
        Menu.farm:addParam("mana", "Min Mana For Lane Clear", SCRIPT_PARAM_SLICE, 0, 0, 100, 0)

    Menu:addSubMenu("[" .. myHero.charName.. "] Killsteal", "ks")
        Menu.ks:addParam("enabled", "Enable Auto KS", SCRIPT_PARAM_ONOFF, false)

    Menu:addSubMenu("[" .. myHero.charName.. "] Orbwalk", "orbwalk")
        SOWi:LoadToMenu(Menu.orbwalk)

    Menu:addSubMenu("[" .. myHero.charName.. "] Items", "item")
        for ItemID, Values in pairs(ItemTable) do

            Menu.item:addParam(string.lower(tostring(Values.id)), "Enable " .. tostring(Values.name), SCRIPT_PARAM_ONOFF, true)

        end

    Menu:addSubMenu("[" .. myHero.charName.. "] Draw", "draw")
        Menu.draw:addParam("enabled", "Enable All Drawings", SCRIPT_PARAM_ONOFF, true)
        Menu.draw:addParam("drawAA", "Draw AutoAttack Range", SCRIPT_PARAM_ONOFF, true)
        Menu.draw:addParam("drawQ", "Draw ".. SpellTable[_Q].name .." Range", SCRIPT_PARAM_ONOFF, true)
        Menu.draw:addParam("drawW", "Draw ".. SpellTable[_W].name .." Range", SCRIPT_PARAM_ONOFF, true)
        Menu.draw:addParam("drawE", "Draw ".. SpellTable[_E].name .." Range", SCRIPT_PARAM_ONOFF, true)
        Menu.draw:addParam("drawR", "Draw ".. SpellTable[_R].name .." Range", SCRIPT_PARAM_ONOFF, true)
        Menu.draw:addParam("drawTarget", "Draw Circle on Target", SCRIPT_PARAM_ONOFF, true)
        Menu.draw:addParam("lfc", "Use Lag Free Circles", SCRIPT_PARAM_ONOFF, true)

    Menu:addSubMenu("[" .. myHero.charName.. "] Misc", "misc")
        Menu.misc:addParam("packet", "Use Packets to Cast Spells", SCRIPT_PARAM_ONOFF, false)
        if VIP_USER then
            Menu.misc:addParam("pred", "Prediction", SCRIPT_PARAM_LIST, 1, {"Prodiction", "VPrediction"})
        else
            Menu.misc:addParam("info", "Prediction: VPrediction", SCRIPT_PARAM_INFO, "")
        end

    if VIP_USER then

        Menu:addSubMenu("Choose Skin", "skin")

    end

    TargetSelector = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1250, DAMAGE_MAGIC, true)
    TargetSelector.name = "Swag"
    Menu:addTS(TargetSelector)

end

-- DETECT AND INITIALIZE ORBWALKERS --
function __initOrbwalkers()

    if _G.Reborn_Loaded then

        SendMessage("SAC:R Detected. Disabling SOW.")
        orbwalker = "SAC"
        Menu.orbwalk.Enabled = false

    elseif _G.MMA_Loaded then

        SendMessage("MMA Detected. Disabling SOW.")
        orbwalker = "MMA"
        Menu.orbwalk.Enabled = false

    elseif _G.SxOrbMenu then

        SendMessage("SxOrbwalk Detected. Disabling SOW.")
        orbwalker = "SxOrb"
        Menu.orbwalk.Enabled = false

    end

    if not _G.SuppPlox_Loaded then _G.SuppPlox_Loaded = true end

end

-- TICK UPDATE --
function Update()

    -- SKILLS --
    for i in pairs(SpellTable) do
        SpellTable[i].ready = myHero:CanUseSpell(i) == READY
    end
    -- SKILLS --

    -- ITEMS --
    for ItemID in pairs(ItemTable) do
        if GetInventoryHaveItem(ItemID) then
            ItemTable[ItemID].slot = GetInventorySlotItem(ItemID)
            ItemTable[ItemID].ready = myHero:CanUseSpell(ItemTable[ItemID].slot) == READY
        end

    end
    -- ITEMS --

    TargetSelector:update()
    Target = GetTarget()

end

-- SCRIPT FUNCTIONS --
function Combo(target)

    if ValidTarget(target) and target ~= nil and target.type == myHero.type then

        if myManaPct() >= Menu.combo.mana and Menu.combo.useQ then CastQ(target) end
        if myManaPct() >= Menu.combo.mana and Menu.combo.useW then CastW(target) end
        if myManaPct() >= Menu.combo.mana and Menu.combo.useE then CastE(target) end
        if myManaPct() >= Menu.combo.mana and Menu.combo.useR then CastR(target) end

    end

end

function Harass(target)

    if ValidTarget(target) and target ~= nil and target.type == myHero.type and (myManaPct() >= Menu.harass.mana) then

        if Menu.harass.useQ then CastQ(target) end
        if Menu.harass.useW then CastW(target) end
        if Menu.harass.useE then CastE(target) end

    end

end

function Farm()

end

-- SKILL FUNCTIONS --
function CastQ(target)

end

function CastW(target)

end

function CastE(target)

end

function CastR(target)

end

function KS()

end

-- MAIN DRAW FUNCTION --
function __draw()

    DrawCircles()
    DrawText()

end
-- MAIN DRAW FUNCION --

-- DRAW FUNCTIONS -- 
function DrawCircles()

    if Menu and Menu.draw and Menu.draw.enabled then

        if Menu.draw.lfc then -- LAG FREE CIRCLES

            if Menu.draw.drawAA then DrawCircleLFC(myHero.x, myHero.y, myHero.z, GetTrueRange(), ARGB(255,255,255,255)) end -- DRAW AA RANGE

            if Menu.draw.drawQ and SpellTable[_Q].ready then DrawCircleLFC(myHero.x, myHero.y, myHero.z, SpellTable[_Q].range, ARGB(255,255,255,255)) end -- DRAW Q RANGE

            if Menu.draw.drawW and SpellTable[_W].ready then DrawCircleLFC(myHero.x, myHero.y, myHero.z, SpellTable[_W].range, ARGB(255,255,255,255)) end -- DRAW W RANGE

            if Menu.draw.drawE and SpellTable[_E].ready then DrawCircleLFC(myHero.x, myHero.y, myHero.z, SpellTable[_E].range, ARGB(255,255,255,255)) end -- DRAW E RANGE

            if Menu.draw.drawR and SpellTable[_R].ready then DrawCircleLFC(myHero.x, myHero.y, myHero.z, SpellTable[_R].range, ARGB(255,255,255,255)) end -- DRAW R RANGE

            if Menu.draw.drawTarget and GetTarget() ~= nil then DrawCircleLFC(GetTarget().x, GetTarget().y, GetTarget().z, 150, ARGB(255,255,255,255)) end -- DRAW TARGET

        else -- NORMAL CIRCLES

            if Menu.draw.drawAA then DrawCircle(myHero.x, myHero.y, myHero.z, GetTrueRange(), ARGB(255,255,255,255)) end -- DRAW AA RANGE

            if Menu.draw.drawQ and SpellTable[_Q].ready then DrawCircle(myHero.x, myHero.y, myHero.z, SpellTable[_Q].range, ARGB(255,255,255,255)) end -- DRAW Q RANGE

            if Menu.draw.drawW and SpellTable[_W].ready then DrawCircle(myHero.x, myHero.y, myHero.z, SpellTable[_W].range, ARGB(255,255,255,255)) end -- DRAW W RANGE

            if Menu.draw.drawE and SpellTable[_E].ready then DrawCircle(myHero.x, myHero.y, myHero.z, SpellTable[_E].range, ARGB(255,255,255,255)) end -- DRAW E RANGE

            if Menu.draw.drawR and SpellTable[_R].ready then DrawCircle(myHero.x, myHero.y, myHero.z, SpellTable[_R].range, ARGB(255,255,255,255)) end -- DRAW R RANGE

            if Menu.draw.drawTarget and GetTarget() ~= nil then DrawCircle(GetTarget().x, GetTarget().y, GetTarget().z, 150, ARGB(255,255,255,255)) end -- DRAW TARGET

        end

    end

end

function DrawText()

end
-- DRAW FUNCTIONS --

function __initPriorities()

    if heroManager.iCount < 10 and (GetGame().map.shortName == "twistedTreeline" or heroManager.iCount < 6) then

        SendMessage("Too few champs to arrange priorities.")

    elseif heroManager.iCount == 6 then

        ArrangePrioritiesTT()

    else

        ArrangePriorities()

    end

end

function SetPriority(table, hero, priority)

    for i = 1, #table, 1 do

        if hero.charName:find(table[i]) ~= nil then
            TS_SetHeroPriority(priority, hero.charName)
        end

    end

end

function ArrangePriorities()

    for _, enemy in ipairs(GetEnemyHeroes()) do

        SetPriority(PriorityTable.AD_Carry, enemy, 1)
        SetPriority(PriorityTable.AP, enemy, 2)
        SetPriority(PriorityTable.Support, enemy, 3)
        SetPriority(PriorityTable.Bruiser, enemy, 4)
        SetPriority(PriorityTable.Tank, enemy, 5)

    end

end

function ArrangePrioritiesTT()

    for _, enemy in ipairs(GetEnemyHeroes()) do

        SetPriority(PriorityTable.AD_Carry, enemy, 1)
        SetPriority(PriorityTable.AP, enemy, 1)
        SetPriority(PriorityTable.Support, enemy, 2)
        SetPriority(PriorityTable.Bruiser, enemy, 2)
        SetPriority(PriorityTable.Tank, enemy, 3)

    end

end

-- SUPP PLOX GLOBAL FUNCTIONS --
function myManaPct() return (myHero.mana * 100) / myHero.maxMana end
function targetHealthPct(target) return (target.health * 100) / target.maxHealth end

function GetMaxRange()

    return math.max(myHero.range, SpellTable[_Q].range, SpellTable[_W].range, SpellTable[_E].range, SpellTable[_R].range)

end

function GetTrueRange()
    return myHero.range + GetDistance(myHero, myHero.minBBox)
end

function GetHitBoxRadius(target)

    return GetDistance(target.minBBox, target.maxBBox)/2

end


function CountObjectsNearPos(pos, range, radius, objects)
    local n = 0
    for i, object in ipairs(objects) do
        if GetDistanceSqr(pos, object) <= radius * radius then
            n = n + 1
        end
    end
    return n
end

function GetClosestAlly()
    local distance = 25000
    local closest = nil
    for i=1, heroManager.iCount do
        currentAlly = heroManager:GetHero(i)
        if currentAlly.team == myHero.team and currentAlly.charName ~= myHero.charName and not currentAlly.dead and myHero:GetDistance(currentAlly) < distance then
            distance = person:GetDistance(currentAlly)
            closest = currentAlly
        end
    end
    return closest
end

-- Lag free circles (by barasia, vadash and viseversa)
function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
    radius = radius or 300
  quality = math.max(8,round(180/math.deg((math.asin((chordlength/(2*radius)))))))
  quality = 2 * math.pi / quality
  radius = radius*.92
    local points = {}
    for theta = 0, 2 * math.pi + quality, quality do
        local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
        points[#points + 1] = D3DXVECTOR2(c.x, c.y)
    end
    DrawLines2(points, width or 1, color or 4294967295)
end

function round(num) 
 if num >= 0 then return math.floor(num+.5) else return math.ceil(num-.5) end
end

function DrawCircleLFC(x, y, z, radius, color)
    local vPos1 = Vector(x, y, z)
    local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
    local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
    local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
    if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
        DrawCircleNextLvl(x, y, z, radius, 1, color, 75) 
    end
end

function GetTarget()

    TargetSelector:update()

    if orbwalker == 'SAC' then

        if _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then

            return _G.AutoCarry.Attack_Crosshair.target

        end

    end

    if orbwalker == 'MMA' then

        if _G.MMA_Target and _G.MMA_Target.type == myHero.type then

            return _G.MMA_Target

        end

    end

    if orbwalker == 'SxOrb' then

        if SxOrb and SxOrb:GetTarget() and SxOrb:GetTarget().type == myHero.type then

            return SxOrb:GetTarget()

        end

    end

    return TargetSelector.target

end

function GenerateSpellPacket(spell, x, y, fromX, fromY, target)

    return { spellID = spell, toX = x, toY = y, fromX = fromX or myHero.x, fromY = fromY or myHero.y } or { spellID = spell, targetNetworkId = target.networkID } or nil

end
-- SUPP PLOX GLOBAL FUNCTIONS --