local QBCore = exports['qb-core']:GetCoreObject()

local function getFieldFromHandling(vehicle, field)
    return GetVehicleHandlingFloat(vehicle, 'CHandlingData', field)
end

local function getVehicleFromVehList(hash)
	for _, v in pairs(QBCore.Shared.Vehicles) do
		if hash == v.hash then
			return v.name, v.brand
		end
	end
end


function getVehicleInfo(vehicle)
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
    local fSuspensionReboundComp = getFieldFromHandling(vehicle, "fSuspensionCompDamp")
    local fAntiRollBarForce = getFieldFromHandling(vehicle, "fAntiRollBarForce")
    local fBrakeForce = getFieldFromHandling(vehicle, "fBrakeForce")
    local drivetrain = 0.0 
    if fDriveBiasFront > 0.5 then
        --fwd
        drivetrain = 1.0-fDriveBiasFront
    else
        --rwd
        drivetrain = fDriveBiasFront
    end

    local score = {
        accel = 0.0,
        speed = 0.0,
        handling = 0.0,
        braking = 0.0,
        drivetrain = 0.0,
    }

    score.drivetrain = drivetrain

    local force = fInitialDriveForce
    if fInitialDriveForce > 0 and fInitialDriveForce < 1 then
        force = (force + drivetrain*0.15) * 1.1
    end

    -- SPEED -- 
    local speedScore = ((fInitialDriveMaxFlatVel / fInitialDragCoeff) * (fTractionCurveMax + fTractionCurveMin)) / 40
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
    local handlingScore = (fTractionCurveMax + (fSuspensionReboundDamp+fSuspensionReboundComp+fAntiRollBarForce)/3) * (fTractionCurveMin/lowSpeedTraction) + drivetrain
    score.handling = handlingScore

    -- BRAKING -- 
    local brakingScore = ((fTractionCurveMin / fTractionCurveMax ) * fBrakeForce) * 7
    score.braking = brakingScore

    if Config.Debug then
       print('====='..vehicleModel..'=====')
       print('accel', accelScore)
       print('speed', speedScore)
       print('handling', handlingScore)
       print('braking', brakingScore)
       print('drivetrain', drivetrain)
    end
    
    -- Balance -- 
    local balance = Config.Balance
    local peformanceScore = math.floor(((accelScore * balance.acceleration) + (speedScore*balance.speed) + (handlingScore*balance.handling) + (brakingScore*balance.braking)) * balance.ratingMultiplier )
    
    
    if Config.Debug then
       print('PerfRating: ', peformanceScore)
    end
    
    -- Get class --
    local class = "F"
    if peformanceScore > 900 then
        class = "X"
    elseif peformanceScore > 700 then
        class = "S"
    elseif peformanceScore > 600 then
        class = "A"
    elseif peformanceScore > 450 then
        class = "B"
    elseif peformanceScore > 350 then
        class = "C"
    else
        class = "D"
    end
    
    return score, class, peformanceScore, vehicleModel, vehicleBrand
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
