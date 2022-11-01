Config = {}

Config.Debug = true
Config.UseCommand = true -- Enables checkscore command

-- This list holds the lower limits of the classes. So, for example:
-- A car that gets a score under 350 will be a D, a car that gets 351 becomes a C, a car that gets 451 will be a B
Config.Classes = {
    C = 350,
    B = 450,
    A = 600,
    S = 700,
    X = 900
}

Config.Balance = {
    acceleration = 4,
    speed = 3,
    handling = 2,
    braking = 1,
    ratingMultiplier = 12
}

