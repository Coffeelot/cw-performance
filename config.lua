Config = {}

Config.UseNewHandling = true -- Based off Natives
Config.Debug = true
Config.UseCommand = true -- Enables checkscore command

-- This list holds the lower limits of the classes. So, for example:
-- A car that gets a score under 350 will be a D, a car that gets 351 becomes a C, a car that gets 451 will be a B
Config.Classes = {
    C = 350,
    B = 400,
    A = 600,
    S = 800,
    X = 1000
}

-- OLD BALANCE: USE IF NOT USING NEW HANDLING
-- Config.Balance = {
--     acceleration = 4,
--     speed = 3,
--     handling = 2,
--     braking = 1,
--     ratingMultiplier = 12
-- }

Config.Balance = {
    acceleration = 1.65,
    speed = 1.05,
    handling = 0.8,
    braking = 0.4,
    ratingMultiplier = 24
}
