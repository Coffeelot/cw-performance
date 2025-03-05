Config = {}
Config.Debug = false

Config.UseCommand = true -- Enables checkscore command
Config.AdminOnly = false -- Only allow using checkscore for admins
Config.NotifySystem = 'ox' -- supported: 'ox' and 'qb'. If none of these it will print to console. See fucntion 'notify' in client.lua to add your preffered notification system

-- This list holds the lower limits of the classes. So, for example:
-- A car that gets a score under 350 will be a D, a car that gets 351 becomes a C, a car that gets 451 will be a B
Config.LowestClass = 'E'
Config.Classes = {
    D = 250,
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
    adjust = 0.07,           -- 1. This will lower the base impact of vehicle acceleration (acceleration-adjust)
    divide = 0.6,            -- This is what we divide the previus result by: (acceleration-adjust)/divide
    negMulti = -9,           -- This is how much the exponential is multiplied by
    adjustTwo = 0.4,         -- this is mainly to make the acceleration above certain limits lower it's impact (as it tends to just become less impactful at higer degrees)
}

Config.Mods = {
    awdDrivetrainHandling = 3,       -- AWD impact on handling
    awdDrivetrainAcceleration = 0.1, -- AWD impact on acceleration (0.0-1.0 is best)
    gearUpMultiplier = 0.9,          -- Gear change speed impact on acceleration
    suspensionDivider = 4,           -- Suspension and roll impact on handling (higher means more)
    lowSpeedTractionLoss = false,    -- LowSpeedtractionLossMult has effect on handling (commonly set to 0.0 for realism)
}

-- This is used to balance the different individual scores to the main performance index. Ei if acceleration is 1.5 and speed is 1.0 that means acceleration has 50% more impact over speed in the final score
-- ratingMultiplier is used to multiply the total. Helpful if you want to move the final score up/down for all vehicles
Config.Balance = {
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

-- THE FOLLOWING REQUIRES OXLIB
Config.AllowDrawTextDisplay = true -- If enabled you can use a hotkey to display classes over vehicles. Make sure oxlib is imported in the fxmanifest

Config.DrawTextSetup = {
    height = 2.0, -- height above vehicle the label displays
    distance = 20.0, -- Distance from players where performance index is visible
    showPillar = true, -- if false then disables pillar, if your arent into that kinda thing
    markerType = 1, -- marker type, 0 is a cone and 1 is pillar. Google fivem markers for more
    baseSize = 0.04, -- Pillar size
    defaultButton = 'F6' -- see https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
}

Config.ClassColors = {
    A = { r = 180, g = 50, b = 50, a = 255 },    -- Muted Red
    B = { r = 180, g = 100, b = 50, a = 255 },   -- Muted Orange
    C = { r = 50, g = 180, b = 50, a = 255 },    -- Muted Green
    D = { r = 50, g = 50, b = 180, a = 255 },    -- Muted Blue
    E = { r = 100, g = 100, b = 100, a = 255 },  -- Muted Gray
    S = { r = 100, g = 50, b = 150, a = 255 },   -- Muted Purple
    X = { r = 225, g = 225, b = 225, a = 255 }      -- Dark Gray/Black
}

Config.DrawTextAuthFunc = function() 
    -- Add whatever checks you want here
    return true
end