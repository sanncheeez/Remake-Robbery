local shops = {
    {x = -1222.47, y = -908.69, z = 12.33}
}

local npcModels = {'mp_m_shopkeep_01'}
local robberyCooldown = 1800
local lastRobberyTime = {}

function loadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end
end

function createNPC(model, coords)
    loadModel(model)
    local npc = CreatePed(4, model, coords.x, coords.y, coords.z - 1, 0.0, false, true)
    FreezeEntityPosition(npc, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    return npc
end

Citizen.CreateThread(function()
    for i=1, #shops, 1 do
        local shop = shops[i]
        shop.npc = createNPC(npcModels[1], {x = shop.x, y = shop.y, z = shop.z})
        lastRobberyTime[i] = 0 
    end
end)

function isPlayerAimingAtNPC(npc)
    local _, target = GetEntityPlayerIsFreeAimingAt(PlayerId())
    return target == npc
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for i=1, #shops, 1 do
            local shop = shops[i]
            local npc = shop.npc
            local npcCoords = GetEntityCoords(npc)
            local distance = GetDistanceBetweenCoords(playerCoords, npcCoords, true)

            if distance < 3.0 then
                if IsPlayerFreeAiming(PlayerId()) and isPlayerAimingAtNPC(npc) then
                    SendNUIMessage({
                        action = 'showNotification',
                        text = 'Recuerda presionar la tecla [E] para comenzar el robo',
                        duration = 5000
                    })
                    
                    if IsControlJustReleased(1, 38) then
                        local currentTime = GetGameTimer() / 1000

                        if currentTime - lastRobberyTime[i] >= robberyCooldown then
                            lastRobberyTime[i] = currentTime 
                            TaskStartScenarioInPlace(npc, 'WORLD_HUMAN_WELDING', 0, true)

                            if lib.progressCircle({
                                duration = 10000,
                                position = 'bottom',
                                useWhileDead = false,
                                canCancel = true,
                                disable = {
                                    car = true,
                                },
                            }) then
                                ClearPedTasksImmediately(npc)
                                local blackMoney = math.random(500, 2000)
                                TriggerServerEvent('dardinero:giveBlackMoney', blackMoney)
                            else
                                ClearPedTasksImmediately(npc)
                                ESX.ShowNotification('El robo fue cancelado')
                            end
                        else
                            ESX.ShowNotification('Debes esperar antes de poder robar nuevamente')
                        end
                    end
                end
            end
        end
    end
end)
