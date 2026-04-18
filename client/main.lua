AddStateBagChangeHandler("dHeist:HeistActive", "global", function()
    Citizen.CreateThread(function()
        while GlobalState['dHeist:HeistActive'] do
            local playerPos = GetEntityCoords(PlayerPedId())
                if (#(playerPos - Config.BankLocation) < 20 and IsPlayerFreeAiming(PlayerId())) then
                    print('Starting')
                    TriggerServerEvent('dheist:server:startHeist')
                end

            Citizen.Wait(1000)
        end
    end)
end)