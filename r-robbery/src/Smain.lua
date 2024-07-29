RegisterServerEvent('dardinero:giveBlackMoney')
AddEventHandler('dardinero:giveBlackMoney', function(amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        xPlayer.addAccountMoney('black_money', amount)
        TriggerClientEvent('esx:showNotification', source, 'Has robado ~g~$'.. amount ..'~s~ en dinero negro')
    else
        print(('dardinero:giveBlackMoney: %s no se encontró el jugador!'):format(source))
    end
end)
