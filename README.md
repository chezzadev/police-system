# Police System
### Configuration
```lua
local maxsecs = 500 -- Max seconds police can put people in jail for --
```
### Perms/Ranks
**Ranks** (Only two for now more in the future if wanted)
Located in your **Database** in the **Rank** **Column**
* **'0'** - Not an Officer
* **'1'** - Normal police officer (Access to general actions and most options)
* **'2'** - Chief (Can add or remove other officers from the server)

#### Image: https://i.gyazo.com/a136756d7df8c4453416296f5029e78b.png

### Installation 
* Install like any other FiveM Resource.
* Then make sure to run the **SQL** file that is included in the resource to make it function correctly.
* Join the game and it should create a new line in the database with your Steam Hex and rank next to it. Make sure to change the rank to 2 if you are an admin, so you can access the **Police Management** tab within the Menu.
* Once done, load into your server and hit 'F5' and the menu should pop. Happy policing ! :)

### Requirements
* [MySQL-Async](https://forum.fivem.net/t/release-mysql-async-library-3-0-8/21881)

### Credits
* @Warxander - [WarMenu](https://forum.fivem.net/t/release-0-9-8-final-warmenu-lua-menu-framework/41249) Framework 
* @Huurkiller20 - Helped testing out the resource.

### Support
* Comment on the fivem post, I will try my best to help you :) (https://forum.fivem.net/t/release-simple-police-system-sql-menu-jail-much-more/397483)
