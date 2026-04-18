AddStateBagChangeHandler("dHeist:HeistActive", "global", function(bagName, key, value)
    Citizen.CreateThread(function()
        while value do
            local playerPos = GetEntityCoords(PlayerPedId())
                if (#(playerPos - Config.BankLocation) < 20 and IsPlayerFreeAiming(PlayerId())) then
                    print('Starting Heist!')
                    TriggerServerEvent('dheist:server:startHeist')
                end

            Citizen.Wait(1000)
        end
    end)
end)