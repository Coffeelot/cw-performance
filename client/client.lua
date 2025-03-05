local UseDebug = Config.Debug

local function debugLog(message, message2, message3)
    if UseDebug then
        print('^2CW-PERFORMANCE DEBUG:^0', message)
        if message2 then
            print(message2)
        end
        if message3 then
            print(message3)
        end
    end
end

local function notify(text, type)
    if Config.NotifySystem == 'ox' then
        lib.notify({
            title = text,
            type = type,
        })
    elseif Config.NotifySystem == 'qb' then
        local QBCore = exports['qb-core']:GetCoreObject()
        QBCore.Functions.Notify(text, type)
    else
        print('^6'..text)
    end
end

local function getFieldFromHandling(vehicle, field)
    return GetVehicleHandlingFloat(vehicle, 'CHandlingData', field)
end

local function normalize_acceleration(acceleration)
    local magic = Config.AccelerationMagic
    local adjusted_acceleration = acceleration - magic.adjust -- Adjust initial accelration
    adjusted_acceleration = adjusted_acceleration / magic.divide -- Divide acceleration
  
    -- apply a logistic curve to the input
    local normalized_acceleration = 1 / (1 + math.exp(magic.negMulti * (adjusted_acceleration - magic.adjustTwo )))
  
    -- adjust the output range to start at 1 and have a width of 9
    normalized_acceleration = normalized_acceleration * 9 + 1
  
  
    return normalized_acceleration
end

local function getVehicleDetails(vehicle)
    return {
        antiRoll = getFieldFromHandling(vehicle, "fAntiRollBarForce"),
        suspensionForce = getFieldFromHandling(vehicle, "fSuspensionForce"),
        reboundDamp = getFieldFromHandling(vehicle, "fSuspensionReboundDamp"),
        compDamp = getFieldFromHandling(vehicle, "fSuspensionCompDamp"),
        gripLow = getFieldFromHandling(vehicle, "fTractionCurveMin"),
        gripHigh = getFieldFromHandling(vehicle, "fTractionCurveMax"),
        lowSpeedTraction = getFieldFromHandling(vehicle, "fLowSpeedTractionLossMult"),
        camberStiffness = getFieldFromHandling(vehicle, "fCamberStiffnesss"),
        offroadGripLoss =  getFieldFromHandling(vehicle, "fTractionLossMult"),
    }
end exports("getVehicleDetails", getVehicleDetails)

local function createSortedList()
    local iList = {}
    
    for class, value in pairs(Config.Classes) do
        table.insert(iList, { class = class, startsAt = value })
    end
    
    table.sort(iList, function(a, b) return a.startsAt < b.startsAt end)
    
    return iList
end

local sortedClassList = createSortedList()



local function getClassLetter(score)
    local classToReturn = Config.LowestClass
    for _, classData in pairs(sortedClassList) do
        if classData.startsAt > score then return classToReturn end 
        classToReturn = classData.class
    end
    return classToReturn
end


function getVehicleInfo(vehicle)
    local fTractionCurveMax = getFieldFromHandling(vehicle, "fTractionCurveMax")
    local fTractionCurveMin = getFieldFromHandling(vehicle, "fTractionCurveMin")
    local fInitialDragCoeff = getFieldFromHandling(vehicle, "fInitialDragCoeff")
    local fLowSpeedTractionLossMult = getFieldFromHandling(vehicle, "fLowSpeedTractionLossMult")
    local fClutchChangeRateScaleUpShift = getFieldFromHandling(vehicle, "fClutchChangeRateScaleUpShift")
    local fSuspensionForce = getFieldFromHandling(vehicle, "fSuspensionForce")
    local fSuspensionReboundDamp = getFieldFromHandling(vehicle, "fSuspensionReboundDamp")
    local fSuspensionCompDamp = getFieldFromHandling(vehicle, "fSuspensionCompDamp")
    local fAntiRollBarForce = getFieldFromHandling(vehicle, "fAntiRollBarForce")
    local fDriveBiasFront = getFieldFromHandling(vehicle, "fDriveBiasFront")


    local awdDrivetrainAccelerationMod = 0.0
    local awdDrivetrainHandlingMod = 0.0
    if not(fDriveBiasFront == 0.0 or fDriveBiasFront == 1.0) then
        --awd
        awdDrivetrainAccelerationMod = Config.Mods.awdDrivetrainAcceleration
        awdDrivetrainHandlingMod = Config.Mods.awdDrivetrainAcceleration
    end

    local model = GetEntityModel(vehicle)

    local normalizedAcceleration = normalize_acceleration(GetVehicleAcceleration(vehicle))
    local accelScore = normalizedAcceleration + awdDrivetrainAccelerationMod*normalizedAcceleration + fClutchChangeRateScaleUpShift*Config.Mods.gearUpMultiplier
    local speedScore = GetVehicleEstimatedMaxSpeed(vehicle)/(fInitialDragCoeff+2.0)
    local brakingScore = GetVehicleMaxBraking(vehicle)*10.0

    -- HANDLING --
    local lowSpeedTraction = 1.0
    if Config.Mods.lowSpeedTractionLoss then 
        if fLowSpeedTractionLossMult >= 1.0 then
            lowSpeedTraction = lowSpeedTraction + (fLowSpeedTractionLossMult-lowSpeedTraction)*0.15
        else
            lowSpeedTraction = lowSpeedTraction - (lowSpeedTraction - fLowSpeedTractionLossMult)*0.15
        end
    end

    local handlingScore = (fTractionCurveMax + (fSuspensionForce+fSuspensionReboundDamp+fSuspensionCompDamp+fAntiRollBarForce)/4) * (fTractionCurveMin/lowSpeedTraction) + awdDrivetrainHandlingMod
    
    if UseDebug then
        print('====='..model..'=====')
        print('accel', accelScore)
        print('speed', speedScore)
        print('handling', handlingScore)
        print('braking', brakingScore)
        print('drivetrain', fDriveBiasFront)
     end
 
     -- Balance --
     local balance = Config.Balance
     local peformanceScore = math.floor(((accelScore ^ balance.acceleration) + (speedScore^balance.speed) + (handlingScore^balance.handling) + (brakingScore^balance.braking))* balance.ratingMultiplier )
    if UseDebug then
        print(' PI SCORING: ')
        print('accelScore', (accelScore ^ balance.acceleration))
        print('speedScore', (speedScore^balance.speed))
        print('handlingScore', (handlingScore^balance.handling))
        print('brakingScore', (brakingScore^balance.braking))
        print('Total:', peformanceScore )
    end
 
    local cheatMods = Config.CheatMods

    local info = {
        accel = accelScore + cheatMods.acceleration,
        speed = speedScore + cheatMods.speed,
        handling = handlingScore + cheatMods.handling,
        braking = brakingScore + cheatMods.braking,
        drivetrain = fDriveBiasFront,
    }
  
    local class = getClassLetter(peformanceScore)
    return info, class, peformanceScore
end exports('getVehicleInfo', getVehicleInfo)

local function getPerformanceClasses()
    return Config.Classes
end exports("getPerformanceClasses", getPerformanceClasses)

local function checkPerformance()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    
    if veh == 0 then
        notify("Not in a vehicle", 'error')
    else
        local score, class, perfRating = getVehicleInfo(veh)
        notify("This car is a "..class..perfRating, 'success')
        debugLog('score', json.encode(score, {indent=true}))
    end
end

RegisterNetEvent('cw-performance:client:CheckPerformance', function()
    checkPerformance()
end)

RegisterNetEvent('cw-performance:client:toggleDebug', function(debug)
   print('Setting debug to',debug)
   UseDebug = debug
end)

RegisterCommand("checkscore", function(source)
    if Config.UseCommand then
        checkPerformance()
    end
end, false)
