RegisterCommand("checkscore", function(source , rawCommand )
    if Config.UseCommand and source > 0 then
        TriggerClientEvent('cw-performance:client:CheckPerformance', source)
    end
end, true)
