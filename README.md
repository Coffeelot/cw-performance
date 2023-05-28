# cw-performance 🏎
## Recommended companion script: [cw-mechtool](https://github.com/Coffeelot/cw-mechtool)
Simple little script to add ratings to cars depending on performance scores. The scoring checks acceleration, speed, handling, braking. Takes drivetrain into account.

The script itself is small and only contains the functionality to score vehicles and not any fancy way to display it. 
Motorcycles have **NOT** been tested with. Mainly used for cars.

# Preview 📽
[![YOUTUBE VIDEO](http://img.youtube.com/vi/tUQlQjmS5CA/0.jpg)](https://youtu.be/tUQlQjmS5CA)

# Developed by Coffeelot and Wuggie
[More scripts by us](https://github.com/stars/Coffeelot/lists/cw-scripts)  👈\
**Support, updates and script previews**:

[![Join The discord!](https://cdn.discordapp.com/attachments/977876510620909579/1013102122985857064/discordJoin.png)](https://discord.gg/FJY4mtjaKr)

**All our scripts are and will remain free**. If you want to support what we do, you can buy us a coffee here:

[![Buy Us a Coffee](https://www.buymeacoffee.com/assets/img/guidelines/download-assets-sm-2.svg)](https://www.buymeacoffee.com/cwscriptbois)

# Config 🔧
**Debug**: Activate debug output (this will print all scores in console). Default is*true*\
**UseCommand**: Allow the /checkscore command. Default is *true*\
**Balance**: These values are the balance in the final scoring. If you feel like something matters to much or to little you can play with these.\

# Implementations

## Basic use
If you want to use the script you can add this line to get the scores, class brand and rating from anywhere:
```local info, class, brand, perfRating = exports['cw-performance']:getVehicleInfo(GetVehiclePedIsIn(PlayerPedId()))```
You can then use the info.x to get any specific score (info.accel for acceleration for example), class for the letter-class (A-F), brand for the brand of the car, 

## Add to [QB-racing](https://github.com/ItsANoBrainer/qb-racing) 🚗
Basic (just showing class):
In qb-racing/client/main.lua find the NetEvent called `"qb-racing:Client:OpenMainMenu"` and add this to the top 
`local info, class, perfRating = exports['cw-performance']:getVehicleInfo(GetPlayersLastVehicle())` 
then add this to the header options (before `isHeadermenu = tue`) `txt = 'You are currently in an ' .. class .. perfRating.. " class car",`

Should look something like this:

![Image](https://i.imgur.com/y9KSuJg.png)

If you want a more advanced version, join the discord and check there is a download link for our version of qb-racing which includes class-based racing and restrictions. 

## Add app 📱
If you want to add the phone app, check the PHONE.md in the implementations folder.
