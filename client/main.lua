--[[
    Pigeon Hands Up: client.

    X puts the player's hands up, and again puts them down. /kneel kneels with the hands behind the head,
    and again gets up. While hands are up or the player is kneeling, they can't shoot, aim, punch or open
    the weapon wheel, and while kneeling they can't move either.

    Other resources (police, robberies) can read the replicated `handsUp` state bag, which is 'up', 'kneel'
    or nil, or the IsHandsUp and IsKneeling exports. Animations are synced by the game, so everyone sees them.
]]

local RESOURCE = GetCurrentResourceName()

local HANDS = { dict = 'missminuteman_1ig_2', anim = 'handsup_base' }
local KNEEL = { dict = 'random@arrests', down = 'idle_2_hands_up', idle = 'kneeling_arrest_idle', up = 'kneeling_arrest_get_up' }

local LOOP_UPPER = 1 | 16 | 32      -- looping, upper body only, on top of walking
local LOOP_UPPER_STILL = 1 | 16     -- the same without walking
local LOOP = 1
local ONCE = 0

-- Shooting, aiming, melee and the weapon wheel.
local BLOCKED = { 24, 25, 37, 44, 140, 141, 142, 143, 257, 263, 264 }
-- Moving, jumping and sprinting, while kneeling.
local STILL = { 21, 22, 30, 31, 32, 33, 34, 35, 36 }

-- 'auto' follows ox_lib's language (the ox:locale convar), and English when that isn't set.
local locale = Config.Locale == 'auto' and GetConvar('ox:locale', 'en') or Config.Locale
local strings = Locales[locale] or Locales.en

local pose                      -- nil, 'up' or 'kneel'
local lastMessage = -math.huge

local function notify(key)
    if not Config.ShowMessages then return end
    local now = GetGameTimer()
    if now - lastMessage < 2000 then return end
    lastMessage = now
    local text = strings[key] or Locales.en[key]
    local mode = Config.Notifications
    if mode == 'ox_lib' or (mode == 'auto' and GetResourceState('ox_lib') == 'started') then
        TriggerEvent('ox_lib:notify', { title = strings.title, description = text, type = 'error' })
    else
        BeginTextCommandThefeedPost('STRING')
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandThefeedPostTicker(false, false)
    end
end

local function loadDict(dict)
    if HasAnimDictLoaded(dict) then return true end
    RequestAnimDict(dict)
    local giveUp = GetGameTimer() + 3000
    while not HasAnimDictLoaded(dict) and GetGameTimer() < giveUp do Wait(0) end
    return HasAnimDictLoaded(dict)
end

local function setPose(value)
    pose = value
    LocalPlayer.state:set('handsUp', value, true)
end

local function cantHere(ped)
    return IsPedInAnyVehicle(ped, false) or IsPedSwimming(ped) or IsPedFalling(ped)
        or IsPedRagdoll(ped) or IsPedDeadOrDying(ped, true)
end

local function handsUp()
    local ped = PlayerPedId()
    if cantHere(ped) then
        notify('cant')
        return
    end
    if not loadDict(HANDS.dict) then return end
    TaskPlayAnim(ped, HANDS.dict, HANDS.anim, 4.0, 4.0, -1, Config.WalkWithHandsUp and LOOP_UPPER or LOOP_UPPER_STILL, 0.0, false, false, false)
    setPose('up')
end

local function handsDown()
    StopAnimTask(PlayerPedId(), HANDS.dict, HANDS.anim, 2.0)
    setPose(nil)
end

local function kneel()
    local ped = PlayerPedId()
    if cantHere(ped) then
        notify('cant')
        return
    end
    if pose == 'up' then StopAnimTask(ped, HANDS.dict, HANDS.anim, 2.0) end
    if not loadDict(KNEEL.dict) then return end
    setPose('kneel')
    CreateThread(function()
        TaskPlayAnim(ped, KNEEL.dict, KNEEL.down, 4.0, 4.0, -1, ONCE, 0.0, false, false, false)
        Wait(math.floor(GetAnimDuration(KNEEL.dict, KNEEL.down) * 1000))
        if pose == 'kneel' then
            TaskPlayAnim(ped, KNEEL.dict, KNEEL.idle, 8.0, 8.0, -1, LOOP, 0.0, false, false, false)
        end
    end)
end

local function getUp()
    local ped = PlayerPedId()
    setPose(nil)
    if loadDict(KNEEL.dict) then
        TaskPlayAnim(ped, KNEEL.dict, KNEEL.up, 8.0, 8.0, -1, ONCE, 0.0, false, false, false)
    end
end

-- While in a pose: keep the weapons away and, kneeling, keep still. If something else ends the pose
-- (a ragdoll, death, a vehicle, another animation), it's let go.
CreateThread(function()
    while true do
        if pose then
            local ped = PlayerPedId()
            if IsPedDeadOrDying(ped, true) or IsPedRagdoll(ped) or IsPedInAnyVehicle(ped, false) then
                setPose(nil)
            elseif pose == 'up' and not IsEntityPlayingAnim(ped, HANDS.dict, HANDS.anim, 3) then
                setPose(nil)
            else
                for _, control in ipairs(BLOCKED) do DisableControlAction(0, control, true) end
                if pose == 'kneel' then
                    for _, control in ipairs(STILL) do DisableControlAction(0, control, true) end
                end
            end
            Wait(0)
        else
            Wait(250)
        end
    end
end)

---------------------------------------------------------------------------
-- Keys, commands and exports

RegisterCommand(Config.HandsUpCommand, function()
    if pose == 'up' then handsDown()
    elseif pose == 'kneel' then getUp()
    else handsUp() end
end, false)
RegisterKeyMapping(Config.HandsUpCommand, strings.key_hands_up or Locales.en.key_hands_up, 'keyboard', Config.HandsUpKey)

RegisterCommand(Config.KneelCommand, function()
    if pose == 'kneel' then getUp() else kneel() end
end, false)
RegisterKeyMapping(Config.KneelCommand, strings.key_kneel or Locales.en.key_kneel, 'keyboard', Config.KneelKey or '')

--- True while the player's hands are up, standing or kneeling.
exports('IsHandsUp', function() return pose ~= nil end)

--- True while the player is kneeling.
exports('IsKneeling', function() return pose == 'kneel' end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= RESOURCE or not pose then return end
    ClearPedTasks(PlayerPedId())
    LocalPlayer.state:set('handsUp', nil, true)
end)
