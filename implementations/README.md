# config.lua
Add this in Config.PhoneApplications. You might need to change the slot and the job
```
["tuner"] = {
    app = "tuner",
    color = "white",
    icon = "fas fa-circle",
    style = "color:#c01d2e",
    tooltipText = "Red Sun Tuner App",
    tooltipPos = "bottom",
    job = 'mechanic',
    blockedjobs = {},
    slot = 20,
    Alerts = 0,
},
```

# The app
Add the RSL.png in the img folder (qb-phone/html/img)
Add tuner.js to the js folder (qb-phone/html/js)
Add tuner.css to the css folder (qb-phone/html/css)

# Index.html
In the Qb-phone/html/index.html:
At the list of CSS File's (marked by comment saying `<!-- CSS File's -->`) add this:
```
<link rel="stylesheet" href="./css/tuner.css">
```
Head down to the apps (marked by comment saying `<!-- Container for all application's -->`) and add this 
```
<div class="tuner-app">
    <div class="tuner-app-header">
        <img src="./img/RSL.png" class="tuner-header-image">
    </div>
     <div class="tuner-homescreen">
        <div class="tuner-cardetails">
            <div id="tuner-rating" class="tuner-detail-rating"><span class="tuner-answer"></span></div>
                <div>
                    <div id="tuner-accel" class="tuner-detail-box"><span class="tuner-detail">Acceleration</span><span class="tuner-answer"></span></div>
                    <div id="tuner-speed" class="tuner-detail-box"><span class="tuner-detail">Speed</span><span class="tuner-answer"></span></div>
                    <div id="tuner-handling" class="tuner-detail-box"><span class="tuner-detail">Handling</span><span class="tuner-answer"></span></div>
                    <div id="tuner-braking" class="tuner-detail-box"><span class="tuner-detail">Braking</span><span class="tuner-answer"></span></div>
                    <div id="tuner-drivetrain" class="tuner-detail-box last"><span class="tuner-detail">drivetrain</span><span class="tuner-answer"></span></div>
                </div>
                <div class="tuner-group">
                    <div id="tuner-brand" class="tuner-detail-box"><span class="tuner-detail">Brand</span><span class="tuner-answer"></span></div>
                    <div id="tuner-model" class="tuner-detail-box"><span class="tuner-detail">Model</span><span class="tuner-answer"></span></div>
                </div>
                <div class="tuner-reload">
                    <i class="fas fa-redo"></i>
                </div>
        </div>
    </div>
</div>
```
Head down to the bottom of the file and in the list of JS files (marked by comment saying `<!-- JavaScript File's -->`) and add this:
```
<script src="./js/tuner.js"></script>
```

# Client
In the qb-phone/client/main.lua add callback somewhere:
```lua

local function getVehicleFromVehList(hash)
    for _, v in pairs(QBCore.Shared.Vehicles) do
		if hash == joaat(v.hash) then
			return v.name, v.brand
		end
	end
    print('^1It seems like you have not added your vehicle ('..GetDisplayNameFromVehicleModel(hash)..') to the vehicles.lua')
    return 'model not found', 'brand not found'
end

RegisterNUICallback('UpdateVehicle', function(data, cb)
    local info, class, perfRating = exports['cw-performance']:getVehicleInfo(GetPlayersLastVehicle())
    loal model, brand = getVehicleFromVehList(GetEntityModel(GetPlayersLastVehicle()))
    local data = {
        brand = brand,
        rating = class..''..perfRating,
        accel = math.floor(info.accel*10)/10,
        speed =  math.floor(info.speed*10)/10,
        handling =  math.floor(info.handling*10)/10,
        braking =  math.floor(info.braking*10)/10,
        drivetrain = info.drivetrain,
        model = model
    }
    cb(data)
end)
```