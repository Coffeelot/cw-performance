local QBCore = exports['qb-core']:GetCoreObject()
local useDebug = Config.Debug
QBCore.Commands.Add('checkscore', 'Check vehicle score',{}, false, function(source)
    if Config.UseCommand then
        TriggerClientEvent('cw-performance:client:CheckPerformance', source)
    else
        TriggerClientEvent('QBCore:Notify', src, "Command is not enabled", 'error', 5000)
    end
end, 'admin')


QBCore.Commands.Add('cwdebugperformance', 'toggle debug for performance', {}, true, function(source, args)
    useDebug = not useDebug
    print('debug is now:', useDebug)
    TriggerClientEvent('cw-performance:client:toggleDebug',source, useDebug)
end, 'admin')