Config = {}

Config.UseNewHandling = true -- Based off Natives
Config.Debug = false
Config.UseCommand = true -- Enables checkscore command
Config.NotifySystem = 'qb' -- supported: 'ox' and 'qb'. If none of these it will print to console. See fucntion 'notify' in client.lua to add your preffered notification system
-- This list holds the lower limits of the classes. So, for example:
-- A car that gets a score under 350 will be a D, a car that gets 351 becomes a C, a car that gets 451 will be a B
Config.Classes = {
    C = 350,
    B = 400,
    A = 600,
    S = 800,
    X = 1000
}

-- Short note: "acceleration" is used in the following block as a name for mainly fInitialDriveForce, 
-- but it also includes other values like fInitialDriveMaxFlatVel and gearing values. 
-- This value is derived from the native GetVehicleAcceleration
Config.AccelerationMagic = { -- This is modifiers for the acceleration calculcation. Update if you like messing around
    adjust = 0.07, -- 1. This will lower the base impact of vehicle acceleration (acceleration-adjust)
    divide = 0.6, -- This is what we divide the previus result by: (acceleration-adjust)/divide
    negMulti = -9, -- This is how much the exponential is multiplied by
    adjustTwo = 0.4, -- this is mainly to make the acceleration above certain limits lower it's impact (as it tends to just become less impactful at higer degrees)
}

Config.Mods = {
    awdDrivetrainHandling = 3, -- AWD impact on handling
    awdDrivetrainAcceleration = 0.1, -- AWD impact on acceleration (0.0-1.0 is best)
    gearUpMultiplier = 0.9, -- Gear change speed impact on acceleration
    suspensionDivider = 4, -- Suspension and roll impact on handling (higher means more)
    lowSpeedTractionLoss = false, -- LowSpeedtractionLossMult has effect on handling (commonly set to 0.0 for realism)
}

Config.Balance = { -- USE TO BALANCE THE HANDLING SCORE TO HOWEVER YOU WANT
    acceleration = 1.3,
    speed = 1.3,
    handling = 1.3,
    braking = 0.55,
    ratingMultiplier = 16
}

Config.CheatMods = { -- USE THESE IF YOU WANNA DISPLAY MORE "PRETTY" NUMBERS. DOEST NOT AFFECT SCORE JUST THE VISUAL SCORES
    acceleration = 0.0,
    speed = 0.0,
    handling = 0.0,
    braking = 0.0,
}

Config.OldBalance = { -- OLD BALANCE: USE IF NOT USING NEW HANDLING
    acceleration = 4,
    speed = 3,
    handling = 2,
    braking = 1,
    ratingMultiplier = 12
}