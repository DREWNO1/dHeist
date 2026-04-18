Citizen.CreateThread(function()
    local bankLocation = Config.BankLocation
    while true do
        local playerPos = GetEntityCoords(PlayerPedId())

        if (#(playerPos - bankLocation) < 20 and IsPlayerFreeAiming(PlayerId())) then
            print('startign')
            TriggerServerEvent('dheist:server:startHeist')
        end

        Citizen.Wait(1000)
    end
end)