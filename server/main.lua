ESX = exports["es_extended"]:getSharedObject()

local spawnedGuards = {}
local Messages = {
    heistActive = "Wygląda na to że przy wejściu do skarbca zbierają się ochroniarze!",
    heistStarted = "Coś się dzieje w banku!"
}

local Heist = {
    id = 'seed',
    location = "bank_1",
    cooldown = 60,
    modifiers = {},
    startedBy = nil,
    lastHeist = nil
}

function FinishHeist()
    Heist.lastHeist = os.time()

    print("Zakończono napad!")

    Citizen.CreateThread(function()
        local remaining = Heist.cooldown

        if(Config.Debug) then remaining = Config.DebugCooldown end

        print(remaining)
        while remaining > 0 do
            if (remaining == 600) then
            end

            Citizen.Wait(1000 * 60)
            remaining = remaining - 60
        end

        print("Cooldown end!")
        
        GlobalState["dHeist:HeistActive"] = true
        
        NotifyPhoneHolders(Messages.heistActive)
    end)
end


function StartHeist(player)
    if(GlobalState["dHeist:HeistActive"]) then
        local xPlayer = ESX.GetPlayerFromId(player)
        if xPlayer then
            local playerCoords = xPlayer.getCoords(true)
            if (#(playerCoords - Config.BankLocation) < 20) then
                GlobalState["dHeist:HeistActive"] = false
                SpawnGuards()
                NotifyPhoneHolders(Messages.heistStarted)
                Citizen.Wait(1000*60)
                FinishHeist()
            end
        end
    else 
        print("napad jest w trakcie!")
    end
end

RegisterNetEvent('dheist:server:startHeist')
AddEventHandler('dheist:server:startHeist', function()
    StartHeist(source)
end)

function SpawnGuards()
    local guardsNumber = math.random(Config.MinimumGuards, #Config.BankGuards)
    local availableGuardsPositions = {table.unpack(Config.BankGuards)}

    for _, netId in ipairs(spawnedGuards) do
        local entity = NetworkGetEntityFromNetworkId(netId)
        if DoesEntityExist(entity) then
            DeleteEntity(entity)
        end
    end

    spawnedGuards = {}

    for i = 1, guardsNumber do
        if #availableGuardsPositions == 0 then break end

        local randomIndex = math.random(1, #availableGuardsPositions)
        local spawnPosition = availableGuardsPositions[randomIndex]
        local weapons = {"WEAPON_CARBINERIFLE", "WEAPON_PUMP_SHOTGUN", "WEAPON_SMG"}

        table.remove(availableGuardsPositions, randomIndex)

        local model = GetHashKey(Config.GuardModel)
        local ped = CreatePed(4, model, spawnPosition.x, spawnPosition.y, spawnPosition.z, spawnPosition.w, true, true)

        local selectedWeapon = weapons[math.random(1, #weapons)]

        Entity(ped).state.isHeistGuard = true
        Entity(ped).state.guardWeapon = selectedWeapon

        table.insert(spawnedGuards, NetworkGetNetworkIdFromEntity(ped))
    end

    print("Zespawnowano strażników w ilości ", guardsNumber)
end


RegisterNetEvent('dheist:server:getPhone')
AddEventHandler('dheist:server:getPhone', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local hasPhone = xPlayer.getInventoryItem("dealer_phone").count

    if hasPhone < 1 then
        xPlayer.addInventoryItem("dealer_phone", 1)
        xPlayer.showNotification('Otrzymałeś telefon od dealera.')
    else
        xPlayer.showNotification('Masz już taki telefon.')
    end
end)

function NotifyPhoneHolders(message)
    local xPlayers = ESX.GetExtendedPlayers()
    for _, xPlayer in pairs(xPlayers) do
        local phoneCount = xPlayer.getInventoryItem('dealer_phone').count
        if phoneCount > 0 then
            xPlayer.triggerEvent('dheist:client:heistphone:sendNotification', message)
        end
    end
end


ESX.RegisterCommand('heistinfo', 'admin', function(xPlayer, args, showError)
        print("Active: ", GlobalState["dHeist:HeistActive"], ", lastHeist: ",  Heist.lastHeist)
end, false)


AddEventHandler('onResourceStart', function()
    GlobalState["dHeist:HeistActive"] = false
    Citizen.Wait(1000)
    NotifyPhoneHolders(Messages.heistActive)
    GlobalState["dHeist:HeistActive"] = true
end)