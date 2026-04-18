local guardGroupHash = GetHashKey("DHEIST_GUARDS")
local playerGroup = GetPedRelationshipGroupHash(PlayerPedId())
Citizen.CreateThread(function()
    AddRelationshipGroup("DHEIST_GUARDS")
    SetRelationshipBetweenGroups(5, guardGroupHash, playerGroup)
    SetRelationshipBetweenGroups(5, playerGroup, guardGroupHash)
end)

AddStateBagChangeHandler("isHeistGuard", nil, function(bagName, key, value)
    local netId = tonumber(bagName:match("entity:(%d+)"))
    if not netId then return end
    local entity = NetToPed(netId)

    local timer = 0
    while not DoesEntityExist(entity) and timer < 1000 do 
        Wait(100)
        entity = NetToPed(netId)
        timer = timer + 100
    end

    if DoesEntityExist(entity) and value then     
        SetPedRelationshipGroupHash(entity, guardGroupHash)
        
        local state = Entity(entity).state
        local weapon = state.guardWeapon or "WEAPON_CARBINERIFLE"

        SetEntityMaxHealth(entity, 500)
        SetEntityHealth(entity, 500)
        SetPedArmour(entity, 100)

        SetPedDropsWeaponsWhenDead(entity, false)
        
        GiveWeaponToPed(entity, GetHashKey(weapon), 250, false, true)
        SetCurrentPedWeapon(entity, GetHashKey(weapon), true)
        
        SetPedCombatAttributes(entity, 0, true)
        SetPedCombatAttributes(entity, 5, true)
        SetPedCombatAttributes(entity, 13, true)
        SetPedCombatAttributes(entity, 46, true)
        SetPedCombatAttributes(entity, 50, true)
        SetPedCombatAttributes(entity, 58, true)

        SetPedCombatAbility(entity, 100)
        SetPedCombatRange(entity, 2)
        SetPedAsCop(entity, true)
        SetPedConfigFlag(entity, 100, true)
    end
end)

AddStateBagChangeHandler("dHeist:HeistActive", "global", function(bagName, key, value)
    if not value then return end
    Citizen.CreateThread(function()
        local heistStarted = false
        while GlobalState['dHeist:HeistActive'] and not heistStarted do
            local playerPos = GetEntityCoords(PlayerPedId())
            if (#(playerPos - Config.BankLocation) < 20 and IsPlayerFreeAiming(PlayerId())) then
                    print('Starting Heist!')
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
    
    print("Usunięto " .. count .. " ciał strażników.")
end, false)