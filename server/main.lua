ESX = exports["es_extended"]:getSharedObject()

Heist = {
    id = 'seed',
    active = false,
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

        while remaining > 0 do
            if (remaining == 600) then
            end

            Citizen.Wait(1000 * 60)
            remaining = remaining - 60
        end

        print("Cooldown end!")
        
        Heist.active = true
        
        NotifyPhoneHolders()
    end)
end




function StartHeist(player)
    if(Heist.active) then
        local xPlayer = ESX.GetPlayerFromId(player)
        if xPlayer then
            local playerCoords = xPlayer.getCoords(true)
            if (#(playerCoords - Config.BankLocation) < 20) then
                Heist.active = false
                print("wystartowano napad!")
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


RegisterNetEvent('dheist:server:getPhone')
AddEventHandler('dheist:server:getPhone', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local hasPhone = xPlayer.getInventoryItem("dealer_phone").count

    if hasPhone < 1 then
        xPlayer.addInventoryItem("dealer_phone", 1)
        xPlayer.showNotification('Otrzymałeś telefon od dealera.')
    else
        xPlayer.showNotification('Masz już taki telefon.')
    end
end)

function NotifyPhoneHolders()
    local xPlayers = ESX.GetExtendedPlayers()
    for _, xPlayer in pairs(xPlayers) do
        local phoneCount = xPlayer.getInventoryItem('dealer_phone').count
        if phoneCount > 0 then
            xPlayer.triggerEvent('dheist:client:heistphone:sendNotification')
        end
    end
end


ESX.RegisterCommand('heistinfo', 'admin', function(xPlayer, args, showError)
        print("Active: ", Heist.active, ", lastHeist: ",  Heist.lastHeist)
end, false)


AddEventHandler('onResourceStart', function()
    Heist.active = true
    NotifyPhoneHolders()
end)