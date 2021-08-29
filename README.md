# qb-inventory

## Dependencies
- [qb-core](https://github.com/qbcore-framework/qb-core)
- [qb-logs](https://github.com/qbcore-framework/qb-logs) - For logging transfer and other history
- [qb-traphouse](https://github.com/qbcore-framework/qb-traphouse) - Trap house system for qbcore
- [rp-radio](https://github.com/qbcore-framework/rp-radio) - Radio system for communication
- [qb-drugs](https://github.com/qbcore-framework/qb-drugs) -  Drugs and weeds system
- [qb-shops](https://github.com/qbcore-framework/qb-shops) - Needed in order to add shops

## Screenshots
![General](https://i.imgur.com/GR0MDFN.png)
![ID Card](https://i.imgur.com/C6gAOWi.png)
![Weapon](https://i.imgur.com/RbCvHJb.png)
![Shop](https://i.imgur.com/7Da7UEX.png)
![Crafting](https://i.imgur.com/peONaL9.png)
![Glovebox](https://i.imgur.com/LjDEYWa.png)
![Trunk](https://i.imgur.com/IoGYZbv.png)

## Features
- Item crafting
- Weapon attachment crafting
- Stashes (Personal and/or Shared)
- Vehicle Trunk & Glovebox
- Weapon serial number
- Shops
- Item Drops

## Installation
### Manual
- Download the script and put it in the `[qb]` directory.
- Import `qb-inventory.sql` in your database
- Add the following code to your server.cfg/resouces.cfg
```
ensure qb-core
ensure qb-logs
ensure qb-inventory
ensure qb-traphouse
ensure qb-radio
ensure qb-drugs
ensure qb-shops
```

## Configuration
```
Config = {} -- Don't touch

local StringCharset = {} -- Don't touch
local NumberCharset = {} -- Don't touch

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end -- Don't touch
for i = 65,  90 do table.insert(StringCharset, string.char(i)) end -- Don't touch
for i = 97, 122 do table.insert(StringCharset, string.char(i)) end -- Don't touch

Config.RandomStr = function(length) -- Don't touch
	if length > 0 then
		return Config.RandomStr(length-1) .. StringCharset[math.random(1, #StringCharset)]
	else
		return ''
	end
end

Config.RandomInt = function(length) -- Don't touch
	if length > 0 then
		return Config.RandomInt(length-1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

Config.VendingObjects = { -- Props which will be considered as vending machines
    "prop_vend_soda_01",
    "prop_vend_soda_02",
    "prop_vend_water_01"
}

Config.BinObjects = { --  Props which will be considered as trash bins
    "prop_bin_05a",
}

Config.VendingItem = { -- Shop inventory for vending machines
    [1] = {
        name = "kurkakola", -- Item name
        price = 4, -- Price per item
        amount = 50, -- Stock amount
        info = {},
        type = "item",
        slot = 1, -- Inventory slot item will be displayed
    },
    [2] = {
        name = "water_bottle",
        price = 4,
        amount = 50,
        info = {},
        type = "item",
        slot = 2,
    },
}

MaxInventorySlots = 41 -- Player inventory slot amount

BackEngineVehicles = { -- Vehicles which has its engine on back side of the vehicle
    'ninef',
    'adder',
    'vagner',
    't20',
    'infernus',
    'zentorno',
    'reaper',
    'comet2',
    'comet3',
    'jester',
    'jester2',
    'cheetah',
    'cheetah2',
    'prototipo',
    'turismor',
    'pfister811',
    'ardent',
    'nero',
    'nero2',
    'tempesta',
    'vacca',
    'bullet',
    'osiris',
    'entityxf',
    'turismo2',
    'fmj',
    're7b',
    'tyrus',
    'italigtb',
    'penetrator',
    'monroe',
    'ninef2',
    'stingergt',
    'surfer',
    'surfer2',
    'comet3',
}

Config.MaximumAmmoValues = { -- Weapon specific maximum ammo count
    ["pistol"] = 250,
    ["smg"] = 250,
    ["shotgun"] = 200,
    ["rifle"] = 250,
}
```
