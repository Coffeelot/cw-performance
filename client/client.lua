local QBCore = exports['qb-core']:GetCoreObject()
local useDebug = Config.Debug

local function getFieldFromHandling(vehicle, field)
    return GetVehicleHandlingFloat(vehicle, 'CHandlingData', field)
end

local function getVehicleFromVehList(hash)
	local found = false
    for _, v in pairs(QBCore.Shared.Vehicles) do
		if hash == v.hash then
            found = true
			return v.name, v.brand
		end
	end
    if not found then
        if useDebug then
           print('It seems like you have not added your vehicles to the vehicles.lua')
        end
        return 'model not found', 'brand not found'

    end
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

local function newHandling(vehicle)
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
    local drivetrainMod = 0.0


    local awdDrivetrainAccelerationMod = 0.0
    local awdDrivetrainHandlingMod = 0.0
    if fDriveBiasFront == 0.0 or fDriveBiasFront == 1.0 then
        --fwd or rwd
        drivetrainMod = 0.0
    else
        --awd
        awdDrivetrainAccelerationMod = Config.Mods.awdDrivetrainAcceleration
        awdDrivetrainHandlingMod = Config.Mods.awdDrivetrainAcceleration
    end

    local model = GetEntityModel(vehicle)
    local vehicleModel, vehicleBrand = getVehicleFromVehList(model)

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
    
    if useDebug then
        print('====='..vehicleModel..'=====')
        print('accel', accelScore)
        print('speed', speedScore)
        print('handling', handlingScore)
        print('braking', brakingScore)
        print('drivetrain', fDriveBiasFront)
     end
 
     -- Balance --
     local balance = Config.Balance
     local peformanceScore = math.floor(((accelScore ^ balance.acceleration) + (speedScore^balance.speed) + (handlingScore^balance.handling) + (brakingScore^balance.braking))* balance.ratingMultiplier )
    if useDebug then
        print(' PI SCORING: ')
        print('accelScore', (accelScore ^ balance.acceleration))
        print('speedScore', (speedScore^balance.speed))
        print('handlingScore', (handlingScore^balance.handling))
        print('brakingScore', (brakingScore^balance.braking))
        print('Total:', peformanceScore )
    end
 
    local cheatMods = Config.CheatMods

    local score = {
        accel = accelScore + cheatMods.acceleration,
        speed = speedScore + cheatMods.speed,
        handling = handlingScore + cheatMods.handling,
        braking = brakingScore + cheatMods.braking,
        drivetrain = fDriveBiasFront,
    }
 
     if useDebug then
        print('PerfRating: ', peformanceScore)
     end
 
     -- Get class --
     local class = "D"
     if peformanceScore > Config.Classes.X then
         class = "X"
     elseif peformanceScore > Config.Classes.S then
         class = "S"
     elseif peformanceScore > Config.Classes.A then
         class = "A"
     elseif peformanceScore > Config.Classes.B then
         class = "B"
     elseif peformanceScore > Config.Classes.C then
         class = "C"
     end
 
     return score, class, peformanceScore, vehicleModel, vehicleBrand
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

function getVehicleInfo(vehicle)
    if Config.UseNewHandling then return newHandling(vehicle) end
    local model = GetEntityModel(vehicle)
    local vehicleModel, vehicleBrand = getVehicleFromVehList(model)

    local fInitialDriveMaxFlatVel = getFieldFromHandling(vehicle, "fInitialDriveMaxFlatVel")
    local fInitialDriveForce = getFieldFromHandling(vehicle, "fInitialDriveForce")
    local fClutchChangeRateScaleUpShift = getFieldFromHandling(vehicle, "fClutchChangeRateScaleUpShift")
    local nInitialDriveGears = getFieldFromHandling(vehicle, "nInitialDriveGears")
    local fDriveBiasFront = getFieldFromHandling(vehicle, "fDriveBiasFront")
    local fInitialDragCoeff = getFieldFromHandling(vehicle, "fInitialDragCoeff")
    local fTractionCurveMax = getFieldFromHandling(vehicle, "fTractionCurveMax")
    local fTractionCurveMin = getFieldFromHandling(vehicle, "fTractionCurveMin")
    local fLowSpeedTractionLossMult = getFieldFromHandling(vehicle, "fLowSpeedTractionLossMult")
    local fSuspensionReboundDamp = getFieldFromHandling(vehicle, "fSuspensionReboundDamp")
    local fSuspensionCompDamp = getFieldFromHandling(vehicle, "fSuspensionCompDamp")
    local fAntiRollBarForce = getFieldFromHandling(vehicle, "fAntiRollBarForce")
    local fBrakeForce = getFieldFromHandling(vehicle, "fBrakeForce")
    local drivetrainMod = 0.0

    if fDriveBiasFront > 0.5 then
        --fwd
        drivetrainMod = 1.0-fDriveBiasFront
    else
        --rwd
        drivetrainMod = fDriveBiasFront
    end

    local score = {
        accel = 0.0,
        speed = 0.0,
        handling = 0.0,
        braking = 0.0,
        drivetrain = 0.0,
    }

    score.drivetrain = fDriveBiasFront

    local force = fInitialDriveForce
    if fInitialDriveForce > 0 and fInitialDriveForce < 1 then
        force = (force + drivetrainMod*0.15) * 1.2
    end

    -- SPEED --
    local speedScore = ((fInitialDriveMaxFlatVel / fInitialDragCoeff) * (fTractionCurveMax + fTractionCurveMin)) / 30
    score.speed = speedScore

    -- ACCELERATION --
    local accelScore = (fInitialDriveMaxFlatVel * force + (fClutchChangeRateScaleUpShift*0.7)) / 10
    score.accel = accelScore

    -- HANDLING --
    local lowSpeedTraction = 1.0
    if fLowSpeedTractionLossMult >= 1.0 then
        lowSpeedTraction = lowSpeedTraction + (fLowSpeedTractionLossMult-lowSpeedTraction)*0.15
    else
        lowSpeedTraction = lowSpeedTraction - (lowSpeedTraction - fLowSpeedTractionLossMult)*0.15
    end
    local handlingScore = (fTractionCurveMax + (fSuspensionReboundDamp+fSuspensionCompDamp+fAntiRollBarForce)/3) * (fTractionCurveMin/lowSpeedTraction) + drivetrainMod
    score.handling = handlingScore

    -- BRAKING --
    local brakingScore = ((fTractionCurveMin / fTractionCurveMax ) * fBrakeForce) * 7
    score.braking = brakingScore

    if useDebug then
       print('====='..vehicleModel..'=====')
       print('accel', accelScore)
       print('speed', speedScore)
       print('handling', handlingScore)
       print('braking', brakingScore)
       print('drivetrain', fDriveBiasFront)
    end

    -- Balance --
    local balance = Config.OldBalance
    local peformanceScore = math.floor(((accelScore * balance.acceleration) + (speedScore*balance.speed) + (handlingScore*balance.handling) + (brakingScore*balance.braking)) * balance.ratingMultiplier )


    if useDebug then
       print('PerfRating: ', peformanceScore)
    end

    -- Get class --
    local class = "D"
    if peformanceScore > Config.Classes.X then
        class = "X"
    elseif peformanceScore > Config.Classes.S then
        class = "S"
    elseif peformanceScore > Config.Classes.A then
        class = "A"
    elseif peformanceScore > Config.Classes.B then
        class = "B"
    elseif peformanceScore > Config.Classes.C then
        class = "C"
    end

    return score, class, peformanceScore, vehicleModel, vehicleBrand
end

function getPerformanceClasses()
    return Config.Classes
end

RegisterNetEvent('cw-performance:client:CheckPerformance', function()
    local veh = GetVehiclePedIsIn(PlayerPedId())

    if veh == 0 then
        QBCore.Functions.Notify("Not in a vehicle", 'error')
    else
        local info, class, perfRating = getVehicleInfo(veh)
        QBCore.Functions.Notify("This car is a "..class..perfRating, 'success')
    end
end)

RegisterNetEvent('cw-performance:client:toggleDebug', function(debug)
   print('Setting debug to',debug)
   useDebug = debug
end)
