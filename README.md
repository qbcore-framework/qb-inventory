# qb-inventory

## Dependencies
- [qb-core](https://github.com/qbcore-framework/qb-core)
- [qb-logs](https://github.com/qbcore-framework/qb-logs) - For logging transfer and other history
- [qb-traphouse](https://github.com/qbcore-framework/qb-traphouse) - Trap house system for qbcore
- [rp-radio](https://github.com/qbcore-framework/rp-radio) - Radio system for communication
- [qb-drugs](https://github.com/qbcore-framework/qb-drugs) -  Drugs and weeds system
- [qb-shops](https://github.com/qbcore-framework/qb-shops) - Needed in order to add shops

## Screenshots
![General](https://imgur.com/cQWrQ4L.png)
![ID Card](https://imgur.com/YyLmgBN.png)
![Weapon](https://imgur.com/4Egycg6.png)
![Shop](https://imgur.com/kRgEMVk.png)
![Vending Machine](https://imgur.com/lSwba9S.png)
![Attachment Crafting](https://imgur.com/dEwa4pI.png)
![Glovebox](https://imgur.com/IXaODb2.png)
![Trunk](https://imgur.com/pLmK0iV.png)

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

Config.BinObjects = { --  Props which will be considered as trash bins
    "prop_bin_05a",
}

Config.VendingDrinksItem = { -- Shop inventory for vending machines
    [1] = {
        name = "kurkakola",
        price = 7,
        amount = 15,
        info = {},
        type = "item",
        slot = 1, -- Inventory slot item will be displayed
    },
    [2] = {
        name = "water_bottle",
        price = 5,
        amount = 15,
        info = {},
        type = "item",
        slot = 2,
    },
}

Config.VendingFoodItems = {
    [1] = {
        name = "twerks_candy",
        price = 4,
        amount = 15,
        info = {},
        type = "item",
        slot = 1,
    },
    [2] = {
        name = "snikkel_candy",
        price = 4,
        amount = 15,
        info = {},
        type = "item",
        slot = 2,
    },
}

Config.VendingCoffeeItems = {
    [1] = {
        name = "coffee",
        price = 5,
        amount = 15,
        info = {},
        type = "item",
        slot = 1,
    },
}

Config.VendingObjects = { -- Props which will be considered as vending machines
	{"prop_vend_soda_01", Config.VendingDrinksItem, 'Máquina de bebidas'}, -- Prop, MachineType, Name
	{"prop_vend_soda_02", Config.VendingDrinksItem, 'Máquina de bebidas'},
	{"prop_vend_water_01", Config.VendingDrinksItem, 'Máquina de bebidas'},
	{1114264700, Config.VendingDrinksItem, 'Máquina de bebidas'},
	{-654402915, Config.VendingFoodItems, 'Máquina de snacks'},
	{690372739, Config.VendingCoffeeItems, 'Máquina de cafe'}
}

Config.CraftingItems = { -- Crafting recipes
    [1] = {
        name = "lockpick", -- Item which will be gained from crafting
        amount = 50, -- Limit
        info = {},
        costs = { -- Requirements for crafting
            ["metalscrap"] = 22,
            ["plastic"] = 32,
        },
        type = "item",
        slot = 1,
        threshold = 0,
        points = 1,
    },
    [2] = {
        name = "screwdriverset",
        amount = 50,
        info = {},
        costs = {
            ["metalscrap"] = 30,
            ["plastic"] = 42,
        },
        type = "item",
        slot = 2,
        threshold = 0,
        points = 2,
    },
    [3] = {
        name = "electronickit",
        amount = 50,
        info = {},
        costs = {
            ["metalscrap"] = 30,
            ["plastic"] = 45,
            ["aluminum"] = 28,
        },
        type = "item",
        slot = 3,
        threshold = 0,
        points = 3,
    },
    [4] = {
        name = "radioscanner",
        amount = 50,
        info = {},
        costs = {
            ["electronickit"] = 2,
            ["plastic"] = 52,
            ["steel"] = 40,
        },
        type = "item",
        slot = 4,
        threshold = 0,
        points = 4,
    },
    [5] = {
        name = "gatecrack",
        amount = 50,
        info = {},
        costs = {
            ["metalscrap"] = 10,
            ["plastic"] = 50,
            ["aluminum"] = 30,
            ["iron"] = 17,
            ["electronickit"] = 1,
        },
        type = "item",
        slot = 5,
        threshold = 120,
        points = 5,
    },
    [6] = {
        name = "handcuffs",
        amount = 50,
        info = {},
        costs = {
            ["metalscrap"] = 36,
            ["steel"] = 24,
            ["aluminum"] = 28,
        },
        type = "item",
        slot = 6,
        threshold = 160,
        points = 6,
    },
    [7] = {
        name = "repairkit",
        amount = 50,
        info = {},
        costs = {
            ["metalscrap"] = 32,
            ["steel"] = 43,
            ["plastic"] = 61,
        },
        type = "item",
        slot = 7,
        threshold = 200,
        points = 7,
    },
    [8] = {
        name = "pistol_ammo",
        amount = 50,
        info = {},
        costs = {
            ["metalscrap"] = 50,
            ["steel"] = 37,
            ["copper"] = 26,
        },
        type = "item",
        slot = 8,
        threshold = 250,
        points = 8,
    },
    [9] = {
        name = "ironoxide",
        amount = 50,
        info = {},
        costs = {
            ["iron"] = 60,
            ["glass"] = 30,
        },
        type = "item",
        slot = 9,
        threshold = 300,
        points = 9,
    },
    [10] = {
        name = "aluminumoxide",
        amount = 50,
        info = {},
        costs = {
            ["aluminum"] = 60,
            ["glass"] = 30,
        },
        type = "item",
        slot = 10,
        threshold = 300,
        points = 10,
    },
    [11] = {
        name = "armor",
        amount = 50,
        info = {},
        costs = {
            ["iron"] = 33,
            ["steel"] = 44,
            ["plastic"] = 55,
            ["aluminum"] = 22,
        },
        type = "item",
        slot = 11,
        threshold = 350,
        points = 11,
    },
    [12] = {
        name = "drill",
        amount = 50,
        info = {},
        costs = {
            ["iron"] = 50,
            ["steel"] = 50,
            ["screwdriverset"] = 3,
            ["advancedlockpick"] = 2,
        },
        type = "item",
        slot = 12,
        threshold = 1750,
        points = 12,
    },
}

Config.AttachmentCrafting = { -- Attachment crafting recipes
    ["location"] = {x = 88.91, y = 3743.88, z = 40.77, h = 66.5, r = 1.0}, -- Marker location
    ["items"] = {
        [1] = {
            name = "pistol_extendedclip", -- Item which will be gained from crafting
            amount = 50, -- Limit
            info = {},
            costs = { -- Requirements for crafting
                ["metalscrap"] = 140,
                ["steel"] = 250,
                ["rubber"] = 60,
            },
            type = "item",
            slot = 1,
            threshold = 0,
            points = 1,
        },
        [2] = {
            name = "pistol_suppressor",
            amount = 50,
            info = {},
            costs = {
                ["metalscrap"] = 165,
                ["steel"] = 285,
                ["rubber"] = 75,
            },
            type = "item",
            slot = 2,
            threshold = 10,
            points = 2,
        },
        [3] = {
            name = "rifle_extendedclip",
            amount = 50,
            info = {},
            costs = {
                ["metalscrap"] = 190,
                ["steel"] = 305,
                ["rubber"] = 85,
                ["smg_extendedclip"] = 1,
            },
            type = "item",
            slot = 7,
            threshold = 25,
            points = 8,
        },
        [4] = {
            name = "rifle_drummag",
            amount = 50,
            info = {},
            costs = {
                ["metalscrap"] = 205,
                ["steel"] = 340,
                ["rubber"] = 110,
                ["smg_extendedclip"] = 2,
            },
            type = "item",
            slot = 8,
            threshold = 50,
            points = 8,
        },
        [5] = {
            name = "smg_flashlight",
            amount = 50,
            info = {},
            costs = {
                ["metalscrap"] = 230,
                ["steel"] = 365,
                ["rubber"] = 130,
            },
            type = "item",
            slot = 3,
            threshold = 75,
            points = 3,
        },
        [6] = {
            name = "smg_extendedclip",
            amount = 50,
            info = {},
            costs = {
                ["metalscrap"] = 255,
                ["steel"] = 390,
                ["rubber"] = 145,
            },
            type = "item",
            slot = 4,
            threshold = 100,
            points = 4,
        },
        [7] = {
            name = "smg_suppressor",
            amount = 50,
            info = {},
            costs = {
                ["metalscrap"] = 270,
                ["steel"] = 435,
                ["rubber"] = 155,
            },
            type = "item",
            slot = 5,
            threshold = 150,
            points = 5,
        },
        [8] = {
            name = "smg_scope",
            amount = 50,
            info = {},
            costs = {
                ["metalscrap"] = 300,
                ["steel"] = 469,
                ["rubber"] = 170,
            },
            type = "item",
            slot = 6,
            threshold = 200,
            points = 6,
        },
    }
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
