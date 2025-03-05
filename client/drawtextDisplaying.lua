if not Config.AllowDrawTextDisplay then return end 
local displayActive = false

local function draw3DText(coords, text, scale, color)
    local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)
    if onScreen then
        SetTextScale(scale, scale)
        SetTextProportional(1)
        SetTextColour(color.r, color.g, color.b, color.a)
        SetTextEntry("STRING")
        SetTextCentre(1)
        SetTextFont(4)
        SetTextDropShadow()
        SetTextOutline()
        AddTextComponentString(text)
        DrawText(x, y)
    end
end

local function drawMarker(vehCoords, labelCoords, classColor)
    DrawMarker(Config.DrawTextSetup.markerType, 
        vehCoords.x, vehCoords.y, vehCoords.z, 
        0.0, 0.0, 0.0, 
        0.0, 0.0, 180.0, 
        Config.DrawTextSetup.baseSize, Config.DrawTextSetup.baseSize, 
        math.abs((labelCoords.z - 0.5) - vehCoords.z), 
        classColor.r, 
        classColor.g, 
        classColor.b, 
        classColor.a, 
        false, false, 2, nil, nil, false, false
    )
end

local function handleDrawingForVehicle(vehicle)
    local _, class, performanceScore = getVehicleInfo(vehicle)
    if class and performanceScore then
        -- Get color for the specific class, default to black (X) if not found
        local classColor = Config.ClassColors[class] or Config.ClassColors['X']
        
        local text = string.format("%s%d", class, math.floor(performanceScore))
        local vehCoords = GetEntityCoords(vehicle)
        local labelHeight = vehCoords.z + Config.DrawTextSetup.height
        local labelCoords = vector3(vehCoords.x, vehCoords.y, labelHeight)
        
        draw3DText(labelCoords, text, 0.55, classColor)
        if Config.DrawTextSetup.showPillar then
            drawMarker(vehCoords, labelCoords, classColor)
        end
        drawMarker(vehCoords, labelCoords, classColor)
    end
end

local function showPerformanceIndex()
    while displayActive do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local vehicles = lib.getNearbyVehicles(playerCoords, Config.DrawTextSetup.distance) -- Fetch vehicles within 50m radius
        for _, vehicleData in ipairs(vehicles) do
            if DoesEntityExist(vehicleData.vehicle) then
                handleDrawingForVehicle(vehicleData.vehicle)
            end
        end
        local Player = PlayerPedId()
        local vehicle = GetVehiclePedIsUsing(Player)
        if vehicle and DoesEntityExist(vehicle) then
            handleDrawingForVehicle(vehicle)
        end
        Wait(0) -- Update every frame
    end
end

lib.addKeybind({
    name = 'show_performance',
    description = 'Hold to Show Vehicle vehicle Class and PI',
    defaultKey = 'LMENU',
    onPressed = function()
        if not Config.DrawTextAuthFunc() then return end
        displayActive = true
        showPerformanceIndex()
    end,
    onReleased = function()
        if not Config.DrawTextAuthFunc() then return end
        displayActive = false
    end
})
