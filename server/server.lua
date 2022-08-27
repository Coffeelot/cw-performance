local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Commands.Add('checkscore', 'Check vehicle score',{}, false, function(source)
    if Config.UseCommand then
        TriggerClientEvent('cw-performance:client:CheckPerformance', source)
    else
        TriggerClientEvent('QBCore:Notify', src, "Command is not enabled", 'error', 5000)
    end
end, 'admin')

