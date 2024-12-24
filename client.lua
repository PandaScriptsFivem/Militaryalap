-- HUD 
Citizen.CreateThread(function()
    local ped = PlayerPedId()
    while true do
        Wait(500)
        local health = math.floor(GetEntityHealth(ped) / 2)
        local armor = math.floor(GetPedArmour(ped))
        local hudMegjelenites = not IsPauseMenuActive()

        SendNUIMessage({
            showHud = hudMegjelenites,
            health = hudMegjelenites and health or nil,
            armor = hudMegjelenites and armor or nil
        })
    end
end)

-- guggolás
local crouched, proned = false, false
local crouchKey, proneKey = 36, 314

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        if DoesEntityExist(ped) and not IsEntityDead(ped) then
            DisableControlAction(0, proneKey, true)
            DisableControlAction(0, crouchKey, true)

            if not IsPauseMenuActive() then
                if IsDisabledControlJustPressed(0, crouchKey) and not proned then
                    RequestAnimSet("move_ped_crouched")

                    if crouched then
                        ResetPedMovementClipset(ped)
                        crouched = false
                    else
                        SetPedMovementClipset(ped, "move_ped_crouched", 0.55)
                        crouched = true
                    end
                elseif IsDisabledControlJustPressed(0, proneKey) and not crouched and not proned then
                    RequestAnimSet("move_crawl")
                    if proned then
                        ClearPedTasksImmediately(ped)
                        proned = false
                    else
                        ClearPedTasksImmediately(ped)
                        proned = true
                    end
                end
            end
        else
            proned = false
            crouched = false
        end
    end
end)

-- noragdoll meg ilyesmi
Citizen.CreateThread(function()
    while true do
        Wait(500) 
        local ped = PlayerPedId()
        
        if IsPedReloading(ped) then
            ClearPedTasks(ped, true)
        end

        for _, veh in ipairs(GetGamePool('CVehicle')) do
            SetVehicleTyresCanBurst(veh, false)
        end

        if IsPedArmed(ped, 6) then
            SetWeaponRecoilShakeAmplitude(GetSelectedPedWeapon(ped), 0)
            SetPedAccuracy(ped, 100)
        end

        SetPedCanRagdoll(ped, false)
        SetEntityCanBeDamaged(ped, not (IsPedFalling(ped) or IsPedInParachuteFreeFall(ped)))
        NetworkOverrideClockTime(12, 0, 0)
    end
end)

-- Kurva cuccok
local spawnedPeds = {}

local function loadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(10)
    end
end

local function unloadModel(model)
    SetModelAsNoLongerNeeded(model)
end

local function spawnPedWithText(pedData)
    loadModel(pedData.model)
    local ped = CreatePed(4, pedData.model, pedData.location.x, pedData.location.y, pedData.location.z - 1.0, 0.0, false, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    spawnedPeds[pedData] = ped

    CreateThread(function()
        while DoesEntityExist(ped) do
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = #(playerCoords - pedData.location)

            if distance < 10.0 then
                ESX.Game.Utils.DrawText3D(pedData.location + vector3(0, 0, pedData.textOffset), pedData.text, 1.0, 4)
            end

            if distance < 3.0 and IsControlJustPressed(1, 38) then 
                TriggerEvent(pedData.event, pedData.args)
            end

            Wait(0)
        end
    end)
end

local function unloadPed(pedData)
    if spawnedPeds[pedData] then
        DeleteEntity(spawnedPeds[pedData])
        spawnedPeds[pedData] = nil
        unloadModel(pedData.model)
    end
end

CreateThread(function()
    while true do
        Wait(1000)  
        local playerCoords = GetEntityCoords(PlayerPedId())

        for _, pedData in pairs(Config.Peds) do
            local distance = #(playerCoords - pedData.location)

            if distance < 40.0 and not spawnedPeds[pedData] then
                spawnPedWithText(pedData) 
            elseif distance >= 40.0 and spawnedPeds[pedData] then
                unloadPed(pedData)  
            end
        end
    end
end)

-- Halál dolgok:

local isDead = false

AddEventHandler('esx:onPlayerDeath', function()
    if isDead then return end
    isDead = true
    local respawnTime = Config.DeathRespawnTime

    lib.showTextUI("Újraéledés : " .. respawnTime .. " másodperc múlva", { position = "top-center", icon = "clock" })

    while respawnTime > 0 do
        lib.showTextUI("Újraéledés : " .. respawnTime .. " másodperc múlva", { position = "top-center", icon = "clock" })
        Citizen.Wait(1000)
        respawnTime = respawnTime - 1
    end

    lib.hideTextUI()
    TriggerServerEvent('militaryalap:getFaction')
end)

RegisterNetEvent('militaryalap:respawnPlayer')
AddEventHandler('militaryalap:respawnPlayer', function(coords)
    isDead = false
    local playerPed = PlayerPedId()
    ESX.Game.Teleport(playerPed, coords)
    
    SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false)
  NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
  SetPlayerInvincible(ped, false)
  ClearPedBloodDamage(ped)

  TriggerEvent('esx_basicneeds:resetStatus')
  TriggerServerEvent('esx:onPlayerSpawn')
  TriggerEvent('esx:onPlayerSpawn')
  TriggerEvent('playerSpawned')
end)
-- LOADOUT
local money = 0

if Config.loadout == true then
    RegisterNetEvent("militaryalap:loadout")
    AddEventHandler("militaryalap:loadout", function ()
        ESX.TriggerServerCallback('militaryalap:penzakurvanak', function(moneyAmount)
            money = moneyAmount 

            local options = {
                {
                    title = 'Egyenleged: $' .. money,
                    icon = 'money-bill'
                }
            }

            for kitName, kitData in pairs(Config.kits) do
              

                table.insert(options, {
                    title = kitName:gsub("^%l", string.upper) .. " Felszerelés",
                    description = kitName:gsub("^%l", string.upper) .. " megvásárlása",
                    icon = 'gun',
                    metadata = {
                        {label = 'Ár: ', value = kitData.price}
                    },
                    onSelect = function()
                        TriggerServerEvent("militaryalap:getkit", kitName)
                    end
                })
            end

            lib.registerContext({
                id = 'loadout',
                title = 'Felszerelés vásárlása',
                options = options
            })

            lib.showContext('loadout')
        end)
    end)
end

-- Tároló
RegisterNetEvent("militaryalap:tarolo")
AddEventHandler("militaryalap:tarolo", function()
    TriggerServerEvent("militaryalap:forcetarolo")
end)
-- Bolt
RegisterNetEvent("militaryalap:Bolt")
AddEventHandler("militaryalap:Bolt", function()
    exports.ox_inventory:openInventory('shop', { type = 'Bolt' })
end)
-- kocsikiker
RegisterNetEvent("militaryalap:autokiker")
AddEventHandler("militaryalap:autokiker", function()
    local options = {{}}

    for _, kocsi in pairs(Config.kocsikiker) do
        table.insert(options, {
            title = kocsi.lebol, 
            description = 'Kattints a kiválasztáshoz', 
            icon = kocsi.icon, 
            onSelect = function()
                local vehicles = GetVehiclesInArea(Config.kocsisapwn, 2.0) 

                if #vehicles > 0 then
                    lib.notify({
                        title = 'jármü kikérő',
                        id = "ASdasdasdasdasdasda",
                        description = 'Egy jármü elfoglalta a helyett!',
                        type = 'error'
                    })                
                else
                    ESX.Game.SpawnVehicle(kocsi.model, Config.kocsisapwn, 1.0, function(vehicle)
                        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                    end)
                end
            end
        }
        )
    end

    lib.registerContext({
        id = 'kocsiker',
        title = 'Autó kikérő',
        options = options
    })

    lib.showContext('kocsiker')
end)
-- Kocsi tarolo

local playerPed = PlayerPedId()

local center = Config.kocsidel
local uiText = "[E] - Kocsi lerakása"
 
local point = lib.points.new({
  coords = center,
  distance = 20,
})
 
local marker = lib.marker.new({
  coords = center,
  type = 1,
  color = {r = 190, g = 30, b = 30, a = 150},
  width = 7,
})
 
    

function point:nearby()
  marker:draw()
 
  if self.currentDistance < 3.5 then
    if not lib.isTextUIOpen() then
      lib.showTextUI("[E] - Kocsi lerakása")
    end
 
    if IsControlJustPressed(0, 51) then     
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        ESX.Game.DeleteVehicle(vehicle)
    end
  else
  local isOpen, currentText = lib.isTextUIOpen()
    if isOpen and currentText == uiText then
      lib.hideTextUI()
    end
  end
end



-- SafeZone By fusti

local function setControlData(toggle)
    DisableControlAction(0, 25,  toggle)
    DisableControlAction(0, 140, toggle)
    DisableControlAction(0, 263, toggle)
    DisableControlAction(0, 142, toggle)
    DisablePlayerFiring(cache.playerId, not toggle)
end

local notify = Config.SafeZones.notify
local vehicleConfig = Config.SafeZones.vehicle
local alpha = Config.SafeZones.alpha
local player = Config.SafeZones.player

local function hitOrLeave(state)
    if player.godMode then
        SetEntityInvincible(cache.ped, state)
    end

    SetPlayerCanDoDriveBy(cache.playerId, not state)

    if not IsPedInAnyVehicle(cache.ped, false) then
        return
    end

    if vehicleConfig.limit then
        SetEntityMaxSpeed(cache.vehicle, state and (vehicleConfig.maxSpeed * (vehicleConfig.metric == 'mph' and 2.23 or 3.6)) or 1000.0)
    end

    if alpha.setEntityAlpha then
        if state then
            return SetEntityAlpha(cache.vehicle, alpha.alphaLevel, false)
        end
        ResetEntityAlpha(cache.vehicle)
    end
end

for k,v in pairs(Config.SafeZones.positions) do
    if Config.useBlip then 
        local radius = Config.SafeZones.blip
        local blip = AddBlipForRadius(v.coord, v.radius)
        SetBlipColour(blip, radius.colour)
        SetBlipAlpha(blip, radius.alpha)
        
    end

    local zone = lib.zones.sphere({coords = v.coord, radius = v.radius, debug = v.debug})
    function zone:onEnter()
        lib.notify({title = notify.EnterTitle, description = notify.EnterDescription, type = notify.EnterType, duration = notify.EnterDuration})
        hitOrLeave(true)
    end
    function zone:inside()
        setControlData(true)
    end
    function zone:onExit()
        lib.notify({title = notify.LeftTitle, description = notify.LeftDescription, type = notify.LeftType, duration = notify.LeftDuration})
        hitOrLeave(false)
        setControlData(false)
    end
end


--- FPS BOOST
--- 

---@diagnostic disable: missing-parameter
lib.registerContext({
    id = 'fps_menu',
    title = 'FPS Beállítások',
    options = {
        {
            title = 'FPS Boost',
            description = 'Válaszd ki a kívánt FPS boost szintet',
            icon = 'fas fa-bolt',
            onSelect = function()
                local input = lib.inputDialog('Válassz FPS Boost szintet', {
                    {
                        type = 'select',
                        label = 'FPS Boost Szint',
                        options = {
                            {value = 'ultra_low', label = 'Nagyon Alacsony'},
                            {value = 'low', label = 'Alacsony'},
                            {value = 'medium', label = 'Közepes'},
                            {value = 'high', label = 'Magas'}
                        },
                        required = true
                    }
                })

                if not input then return end
                FPSboot(input[1])
            end
        },
        {
            title = 'Kikapcsolás',
            description = 'FPS boost Kikapcsolása',
            icon = 'times-circle',
            onSelect = function()
                FPSoff()
            end
        }
    }
})

function FPSboot(level)
    if level == "ultra_low" then
        SetTimecycleModifier('yell_tunnel_nodirect')
        SetInstancePriorityHint(5)
        RopeDrawShadowEnabled(false)
        CascadeShadowsClearShadowSampleType()
        CascadeShadowsSetAircraftMode(false)
        CascadeShadowsEnableEntityTracker(true)
        CascadeShadowsSetDynamicDepthMode(false)
        CascadeShadowsSetEntityTrackerScale(0.0)
        CascadeShadowsSetDynamicDepthValue(0.0)
        CascadeShadowsSetCascadeBoundsScale(0.0)
        SetFlashLightFadeDistance(0.0)
        SetLightsCutoffDistanceTweak(0.0)
        DistantCopCarSirens(false)
        SetArtificialLightsState(true)
    elseif level == "low" then
        SetTimecycleModifier('yell_tunnel_nodirect')
        SetInstancePriorityHint(3)
        RopeDrawShadowEnabled(false)
        CascadeShadowsSetAircraftMode(false)
        CascadeShadowsEnableEntityTracker(true)
        CascadeShadowsSetDynamicDepthMode(false)
        CascadeShadowsSetEntityTrackerScale(1.0)
        CascadeShadowsSetDynamicDepthValue(1.0)
        CascadeShadowsSetCascadeBoundsScale(1.0)
        SetFlashLightFadeDistance(5.0)
        SetLightsCutoffDistanceTweak(5.0)
        DistantCopCarSirens(false)
    elseif level == "medium" then
        SetTimecycleModifier('yell_tunnel_nodirect')
        SetInstancePriorityHint(2)
        RopeDrawShadowEnabled(false)
        CascadeShadowsSetAircraftMode(true)
        CascadeShadowsEnableEntityTracker(true)
        CascadeShadowsSetDynamicDepthMode(false)
        CascadeShadowsSetEntityTrackerScale(3.0)
        CascadeShadowsSetDynamicDepthValue(3.0)
        CascadeShadowsSetCascadeBoundsScale(3.0)
        SetFlashLightFadeDistance(7.0)
        SetLightsCutoffDistanceTweak(7.0)
        DistantCopCarSirens(false)
    elseif level == "high" then
        SetTimecycleModifier('yell_tunnel_nodirect')
        SetInstancePriorityHint(0)
        RopeDrawShadowEnabled(true)
        CascadeShadowsSetAircraftMode(true)
        CascadeShadowsEnableEntityTracker(true)
        CascadeShadowsSetDynamicDepthMode(true)
        CascadeShadowsSetEntityTrackerScale(5.0)
        CascadeShadowsSetDynamicDepthValue(5.0)
        CascadeShadowsSetCascadeBoundsScale(5.0)
        SetFlashLightFadeDistance(10.0)
        SetLightsCutoffDistanceTweak(10.0)
        DistantCopCarSirens(true)
    end
end

function FPSoff()
    SetInstancePriorityHint(0)
    SetTimecycleModifier()
    ClearTimecycleModifier()
    ClearExtraTimecycleModifier()
    RopeDrawShadowEnabled(true)
    CascadeShadowsSetAircraftMode(true)
    CascadeShadowsEnableEntityTracker(true)
    CascadeShadowsSetDynamicDepthMode(true)
    CascadeShadowsSetEntityTrackerScale(5.0)
    CascadeShadowsSetDynamicDepthValue(5.0)
    CascadeShadowsSetCascadeBoundsScale(5.0)
    SetFlashLightFadeDistance(10.0)
    SetLightsCutoffDistanceTweak(10.0)
    DistantCopCarSirens(true)
    SetArtificialLightsState(true)
end

if Config.FPSBoost then
    function SetFPSBoostByCurrentFPS()
        local fps = GetFPS()  
    
        if fps > 100 then
            FPSboot("high")
        elseif fps > 60 then
            FPSboot("medium")
        elseif fps > 30 then
            FPSboot("low")
        else
            FPSboot("ultra_low")
        end
    end
    function GetFPS()
        return (1 / GetFrameTime())
    end

RegisterCommand("fps", function (source, args, raw)
    SetFPSBoostByCurrentFPS()  
    lib.showContext('fps_menu')
end)
end

function GetVehiclesInArea(center, radius)
    local vehicles = {}
    local allVehicles = GetGamePool('CVehicle') 

    for _, vehicle in ipairs(allVehicles) do
        local dist = Vdist(center.x, center.y, center.z, GetEntityCoords(vehicle)) 
        if dist <= radius then
            table.insert(vehicles, vehicle)
        end
    end

    return vehicles
end