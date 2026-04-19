local guardGroupHash = GetHashKey("DHEIST_GUARDS")
local playerGroup = GetPedRelationshipGroupHash(PlayerPedId())

AddRelationshipGroup("DHEIST_GUARDS")

guardGroupHash = GetHashKey("DHEIST_GUARDS")

SetRelationshipBetweenGroups(5, guardGroupHash, playerGroup)
SetRelationshipBetweenGroups(5, playerGroup, guardGroupHash)

if Config.Debug.activated then
    Citizen.CreateThread(function()
        while true do
            local sleep = 1000
            local playerCoords = GetEntityCoords(PlayerPedId())
            
            local peds = GetGamePool('CPed')
            
            for _, ped in ipairs(peds) do
                if Entity(ped).state.isHeistGuard then
                    local pedCoords = GetEntityCoords(ped)
                    local dist = #(playerCoords - pedCoords)

                    if dist < 10.0 then
                        sleep = 0
                        
                        local health = GetEntityHealth(ped)
                        local maxHealth = GetEntityMaxHealth(ped)
                        local armor = GetPedArmour(ped)
                        local weapon = Entity(ped).state.guardWeapon or "Brak"
                        
                        local debugText = string.format(
                            "~r~[GUARD]~s~\n" ..
                            "HP: %d/%d\n" ..
                            "Pancerz: %d\n" ..
                            "Bron: %s\n",
                            health, maxHealth, armor, weapon
                        )

                        DrawText3D(vector3(pedCoords.x, pedCoords.y, pedCoords.z), debugText)
                    end
                end
            end
            Wait(sleep)
        end
    end)
end

local function GetDoor()
    return GetClosestObjectOfType(
        Config.VaultDoors.coords.x,
        Config.VaultDoors.coords.y,
        Config.VaultDoors.coords.z,
        20.0,
        Config.VaultDoors.hash,
        false, false, false
    )
end

local function RequestControl(entity)
    NetworkRequestControlOfEntity(entity)

    local timeout = 0
    while not NetworkHasControlOfEntity(entity) and timeout < 100 do
        Citizen.Wait(10)
        timeout = timeout + 1
    end

    return NetworkHasControlOfEntity(entity)
end

local function EaseInOut(x)
    local c1 = 1.70158;
    local c3 = c1 + 1;

    return 1 + c3 * (x - 1)^3 + c1 * (x - 1)^2;
end

function OpenVault()
    local door = GetDoor()
    
    if not DoesEntityExist(door) then
        if Config.Debug.activated then print("Nie znaleziono drzwi!") end
        return
    end
    
    if not RequestControl(door) then
        if Config.Debug.activated then print("Brak kontroli nad drzwiami!") end
        return
    end
    
    FreezeEntityPosition(door, true)
    Citizen.CreateThread(function()
        local start = GetEntityHeading(door)
        local target = Config.VaultDoors.openHeading

        local diff = ((target - start + 180) % 360) - 180

        local duration = 8000
        local startTime = GetGameTimer()

        while true do
            local now = GetGameTimer()
            local t = (now - startTime) / duration

            if t >= 1.0 then break end

            local eased = EaseInOut(t)
            local heading = start + diff * eased

            SetEntityHeading(door, heading)
            Citizen.Wait(0)
        end

        SetEntityHeading(door, (start + diff) % 360.0)

        if Config.Debug.activated then print("Skarbiec otwarty)") end
    end)
end

function CloseVault()
    local door = GetDoor()
    
    if DoesEntityExist(door) then
        FreezeEntityPosition(door, true)
        Citizen.CreateThread(function()
            SetEntityHeading(door, Config.VaultDoors.coords.w)
            if Config.Debug.activated then print("zamkniete") end
        end)
    end
end


function DrawText3D(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

AddStateBagChangeHandler("isHeistGuard", nil, function(bagName, key, value)
    if not value then return end
    
    local netId = tonumber(bagName:match("entity:(%d+)"))
    if not netId then return end

    Citizen.CreateThread(function()    
        local timer = 0
        while not NetworkDoesNetworkIdExist(netId) and timer < 100 do
            Wait(0)
            timer = timer + 1
        end
        if not NetworkDoesNetworkIdExist(netId) then return end
        
        local entity = NetToPed(netId)
        timer = 0
        while not DoesEntityExist(entity) and timer < 100 do
            Wait(0)
            entity = NetToPed(netId)
            timer = timer + 1
        end
        if DoesEntityExist(entity) then
            SetPedRelationshipGroupHash(entity, guardGroupHash)
            SetPedDropsWeaponsWhenDead(entity, false)

            local state = Entity(entity).state
            local health = state.guardHealth
            local weapon = state.guardWeapon
            local weaponHash = GetHashKey(weapon)

            GiveWeaponToPed(entity, weaponHash, 999, false, true)
            SetCurrentPedWeapon(entity, weaponHash, true)
            SetPedInfiniteAmmo(entity, true, weaponHash)
            

            SetPedMaxHealth(entity, health)
            SetEntityHealth(entity, health)
            SetPedArmour(entity, 100)
            for _, v in pairs(Config.GuardsCombatAttributes) do
                SetPedCombatAttributes(entity, v, true)
            end

            SetPedCombatMovement(entity, 3)
            SetPedCombatRange(entity, 2)
            SetPedAsCop(entity, true)

            for k, v in pairs(Config.GuardsFlags) do
                SetPedConfigFlag(entity, v, true)
            end

            SetPedConfigFlag(entity, 118, false)
        end
    end)
end)

RegisterNetEvent('dheist:client:openVault')
AddEventHandler('dheist:client:openVault', function()
    OpenVault()
end)

AddStateBagChangeHandler("dHeist:HeistActive", "global", function(bagName, key, value)
    if not value then return end
    Citizen.CreateThread(function()
        CloseVault()
        local heistStarted = false
        while GlobalState['dHeist:HeistActive'] and not heistStarted do
            local playerPos = GetEntityCoords(PlayerPedId())
            if (#(playerPos - Config.BankLocation) < 20 and IsPlayerFreeAiming(PlayerId())) then
                    if Config.Debug.activated then print('Starting Heist!') end
                    heistStarted = true
                    TriggerServerEvent('dheist:server:startHeist')
                end

            Citizen.Wait(1000)
        end
    end)
end)

RegisterCommand('clearbodies', function()
    local playerPos = GetEntityCoords(PlayerPedId())
    local handle, ped = FindFirstPed()
    local success
    local count = 0

    repeat
        local pedPos = GetEntityCoords(ped)
        if IsPedDeadOrDying(ped, true) and #(playerPos - pedPos) < 50.0 then
            if Entity(ped).state.isHeistGuard then
                DeleteEntity(ped)
                count = count + 1
            end
        end
        success, ped = FindNextPed(handle)
    until not success
    EndFindPed(handle)
    
    if Config.Debug.activated then print("Usunięto " .. count .. " ciał strażników.") end
end, false)