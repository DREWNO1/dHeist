function DisplayGetPhoneMessage()
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName("[E] Weź ode mnie ~g~Telefon.")
    EndTextCommandDisplayHelp(0, false, true, -1)
end

Citizen.CreateThread(function() 
    local pedPos = Config.PedLocation
    local model = GetHashKey('s_m_y_dealer_01')

    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(10)
    end
    
    local ped = CreatePed(1, model, pedPos.x, pedPos.y, pedPos.z, pedPos.w, 1);
    
    SetPedComponentVariation(ped, 3, 0, 0, 0)
    SetPedComponentVariation(ped, 4, 0, 0, 0)
    SetPedComponentVariation(ped, 0, 1, 0, 0)
    
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    SetModelAsNoLongerNeeded(model)

    while true do
        local playerPos = GetEntityCoords(PlayerPedId())
        local time = 250

        if(#(playerPos - vec3(pedPos.x, pedPos.y, pedPos.z)) < 2) then
            time = 1;
            DisplayGetPhoneMessage()
            if(IsControlJustReleased(0, 38)) then
                TriggerServerEvent('dheist:server:getPhone')
            end
        end

    
        Citizen.Wait(time)
    end

end)

