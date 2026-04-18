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