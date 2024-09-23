# cw-performance 🏎
### ⭐ Check out our [Tebex store](https://cw-scripts.tebex.io/category/2523396) for some cheap scripts ⭐
## Recommended companion script: [cw-mechtool](https://github.com/Coffeelot/cw-mechtool)
Simple little script to add ratings to cars depending on performance scores. The scoring checks acceleration, speed, handling, braking. Takes drivetrain into account.

The script itself is small and only contains the functionality to score vehicles and not any fancy way to display it. 
Motorcycles have **NOT** been tested with. Mainly used for cars.

> Note: As of May 5th 2024 CW performance is core agnostic and does not need QBcore anymore. 

# Preview 📽
[![YOUTUBE VIDEO](http://img.youtube.com/vi/tUQlQjmS5CA/0.jpg)](https://youtu.be/tUQlQjmS5CA)

# Links
### ⭐ Check out our [Tebex store](https://cw-scripts.tebex.io/category/2523396) for some cheap scripts ⭐


### [More free scripts](https://github.com/stars/Coffeelot/lists/cw-scripts)  👈

### Support, updates and script previews:

<a href="https://discord.gg/FJY4mtjaKr"> <img src="https://media.discordapp.net/attachments/1202695794537537568/1285652389080334337/discord.png?ex=66eb0c97&is=66e9bb17&hm=b1b2c17715f169f57cf646bb9785b0bf833b2e4037ef47609100ec8e902371df&=&format=webp" width="200"></a>


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
