Config = {}

Config.VendingObjects = {
    "prop_vend_soda_01",
    "prop_vend_soda_02",
    "prop_vend_water_01"
}

Config.BinObjects = {
    "prop_bin_05a",
}

Config.VendingItem = {
    [1] = {
        name = "kurkakola",
        price = 4,
        amount = 50,
        info = {},
        type = "item",
        slot = 1,
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

Config.CraftingItems = {
	[1] = {
		label = 'Lockpick',
		itemname = 'lockpick',
		slot = 1,
		amount = 50,
		info = {},
		addingpoints = 1,
		pointsneeded = 0,
		type = 'item',
		costs = {
			[1] = {
				label = 'Metalscrap',
				itemname = 'metalscrap',
				amount = 3,
			},
			[2] = {
				label = 'Plastic',
				itemname = 'plastic',
				amount = 4,
			},
		},
	},
	[2] = {
		label = 'Screwdriverset',
		itemname = 'screwdriverset',
		slot = 2,
		amount = 50,
		info = {},
		addingpoints = 2,
		pointsneeded = 0,
		type = 'item',
		costs = {
			[1] = {
				label = 'Metalscrap',
				itemname = 'metalscrap',
				amount = 8,
		  },
			[2] = {
				label = 'Plastic',
				itemname = 'plastic',
				amount = 6,
			},
		},
	},
	[3] = {
		label = 'Electronickit',
		itemname = 'electronickit',
		slot = 3,
		amount = 50,
		info = {},
		addingpoints = 3,
		pointsneeded = 0,
		type = 'item',
		costs = {
			[1] = {
				label = 'Metalscrap',
				itemname = 'metalscrap',
				amount = 5,
			},
			[2] = {
				label = 'Plastic',
				itemname = 'plastic',
				amount = 4,
			},
			[3] = {
				label = 'Aluminum',
				itemname = 'aluminum',
				amount = 6,
			},
		},
	},
	[4] = {
		label = 'Radioscanner',
		itemname = 'radioscanner',
		slot = 4,
		amount = 50,
		info = {},
		addingpoints = 3,
		pointsneeded = 0,
		type = 'item',
		costs = {
			[1] = {
				label = 'Electronickit',
				itemname = 'electronickit',
				amount = 2,
			},
			[2] = {
				label = 'Plastic',
				itemname = 'plastic',
				amount = 4,
			},
			[3] = {
				label = 'Steel',
				itemname = 'steel',
				amount = 5,
			},
		},
	},
	[5] = {
		label = 'Gatecrack',
		itemname = 'gatecrack',
		slot = 5,
		amount = 50,
		info = {},
		addingpoints = 5,
		pointsneeded = 120,
		type = 'item',
		costs = {
			[1] = {
				label = 'Metalscrap',
				itemname = 'metalscrap',
				amount = 4,
			},
			[2] = {
				label = 'Plastic',
				itemname = 'plastic',
				amount = 3,
			},
			[3] = {
				label = 'Aluminum',
				itemname = 'aluminum',
				amount = 4,
			},
			[4] = {
				label = 'Iron',
				itemname = 'iron',
				amount = 5,
			},
			[5] = {
				label = 'Electronickit',
				itemname = 'electronickit',
				amount = 1,
			},			  
		},
	},
	[6] = {
		label = 'Handcuffs',
		itemname = 'handcuffs',
		slot = 6,
		amount = 50,
		info = {},
		addingpoints = 6,
		pointsneeded = 160,
		type = 'item',
		costs = {
			[1] = {
				label = 'Metalscrap',
				itemname = 'metalscrap',
				amount = 4,
			},
			[2] = {
				label = 'Steel',
				itemname = 'steel',
				amount = 4,
			},
			[3] = {
				label = 'Aluminum',
				itemname = 'aluminum',
				amount = 4,
			},
		},
	},
	[7] = {
		label = 'Repairkit',
		itemname = 'repairkit',
		slot = 7,
		amount = 50,
		info = {},
		addingpoints = 7,
		pointsneeded = 200,
		type = 'item',
		costs = {
			[1] = {
				label = 'Metalscrap',
				itemname = 'metalscrap',
				amount = 4,
			},
			[2] = {
				label = 'Steel',
				itemname = 'steel',
				amount = 5,
			},
			[3] = {
				label = 'Plastic',
				itemname = 'plastic',
				amount = 7,
			},
		},
	},
	[8] = {
		label = 'Pistol Ammo',
		itemname = 'pistol_ammo',
		slot = 8,
		amount = 50,
		info = {},
		addingpoints = 8,
		pointsneeded = 250,
		type = 'item',
		costs = {
			[1] = {
				label = 'Metalscrap',
				itemname = 'metalscrap',
				amount = 5,
			},
			[2] = {
				label = 'Steel',
				itemname = 'steel',
				amount = 5,
			},
			[3] = {
				label = 'Copper',
				itemname = 'copper',
				amount = 5,
			},
		},
	},
	[9] = {
		label = 'Iron Oxide',
		itemname = 'ironoxide',
		slot = 9,
		amount = 50,
		info = {},
		addingpoints = 9,
		pointsneeded = 300,
		type = 'item',
		costs = {
			[1] = {
				label = 'Iron',
				itemname = 'iron',
				amount = 6,
			},
			[2] = {
				label = 'Glass',
				itemname = 'glass',
				amount = 6,
			},
		},
	},
	[10] = {
		label = 'Aluminum Oxide',
		itemname = 'aluminumoxide',
		slot = 10,
		amount = 50,
		info = {},
		addingpoints = 10,
		pointsneeded = 300,
		type = 'item',
		costs = {
			[1] = {
				label = 'Aluminum',
				itemname = 'aluminum',
				amount = 6,
			},
			[2] = {
				label = 'Glass',
				itemname = 'glass',
				amount = 6,
			},
		},
	},
	[11] = {
		label = 'Armor',
		itemname = 'armor',
		slot = 11,
		amount = 50,
		info = {},
		addingpoints = 11,
		pointsneeded = 350,
		type = 'item',
		costs = {
			[1] = {
				label = 'Iron',
				itemname = 'iron',
				amount = 5,
			},
			[2] = {
				label = 'Steel',
				itemname = 'steel',
				amount = 5,
			},
			[3] = {
				label = 'Plastic',
				itemname = 'plastic',
				amount = 6,
			},
			[4] = {
				label = 'Aluminum',
				itemname = 'aluminum',
				amount = 5,
			},
		},
	},
	[12] = {
		label = 'Drill',
		itemname = 'drill',
		slot = 12,
		amount = 50,
		info = {},
		addingpoints = 11,
		pointsneeded = 350,
		type = 'item',
		costs = {
			[1] = {
				label = 'Iron',
				itemname = 'iron',
				amount = 5,
			},
			[2] = {
				label = 'Steel',
				itemname = 'steel',
				amount = 6,
			},
			[3] = {
				label = 'Screwdriverset',
				itemname = 'screwdriverset',
				amount = 3,
			},
			[4] = {
				label = 'Advancedlockpick',
				itemname = 'advancedlockpick',
				amount = 5,
			},
		},
	},
	[13] = {
		label = 'ATM Explosive',
		itemname = 'atm_explosive',
		slot = 13,
		amount = 50,
		info = {},
		addingpoints = 11,
		pointsneeded = 5,
		type = 'item',
		costs = {
			[1] = {
				label = 'Iron',
				itemname = 'iron',
				amount = 1,
			},
			[2] = {
				label = 'Steel',
				itemname = 'steel',
				amount = 1,
			},
			[3] = {
				label = 'Screwdriverset',
				itemname = 'screwdriverset',
				amount = 1,
			},
			[4] = {
				label = 'Thermite',
				itemname = 'thermite',
				amount = 1,
			},
		},
	},
}

Config.AttachmentCraftingLocation = vector3(88.91, 3743.88, 40.77) 

Config.AttachmentCrafting = {
	[1] = {
		label = 'Pistol Extendedclip',
		itemname = 'pistol_extendedclip',
		slot = 1,
		amount = 50,
		info = {},
		addingpoints = 1,
		pointsneeded = 0,
		type = 'item',
		costs = {
			[1] = {
				label = 'Metalscrap',
				itemname = 'metalscrap',
				amount = 2,
			},
			[2] = {
				label = 'Steel',
				itemname = 'steel',
				amount = 5,
			},
			[3] = {
				label = 'Rubber',
				itemname = 'rubber',
				amount = 2,
			},
		},
	},
	[2] = {
		label = 'Pistol Suppressor',
		itemname = 'pistol_suppressor',
		slot = 2,
		amount = 50,
		info = {},
		addingpoints = 2,
		pointsneeded = 10,
		type = 'item',
		costs = {
			[1] = {
				label = 'Metalscrap',
				itemname = 'metalscrap',
				amount = 1,
			},
			[2] = {
				label = 'Steel',
				itemname = 'steel',
				amount = 2,
			},
			[3] = {
				label = 'Rubber',
				itemname = 'rubber',
				amount = 8,
			},
		},
	},
	[3] = {
		label = 'Smg Extendedclip',
		itemname = 'smg_extendedclip',
		slot = 3,
		amount = 50,
		info = {},
		addingpoints = 3,
		pointsneeded = 30,
		type = 'item',
		costs = {
			[1] = {
				label = 'Metalscrap',
				itemname = 'metalscrap',
				amount = 3,
			},
			[2] = {
				label = 'Steel',
				itemname = 'steel',
				amount = 7,
			},
			[3] = {
				label = 'Rubber',
				itemname = 'rubber',
				amount = 2,
			},
		},
	},
	[4] = {
		label = 'Micro Smg Extendedclip',
		itemname = 'microsmg_extendedclip',
		slot = 4,
		amount = 50,
		info = {},
		addingpoints = 4,
		pointsneeded = 50,
		type = 'item',
		costs = {
			[1] = {
				label = 'Metal scrap',
				itemname = 'metalscrap',
				amount = 3,
			},
			[2] = {
				label = 'Steel',
				itemname = 'steel',
				amount = 6,
			},
			[3] = {
				label = 'Rubber',
				itemname = 'rubber',
				amount = 2,
			},
		},
	},
	[5] = {
		label = 'Smg Drum',
		itemname = 'smg_drum',
		slot = 5,
		amount = 50,
		info = {},
		addingpoints = 5,
		pointsneeded = 75,
		type = 'item',
		costs = {
			[1] = {
				label = 'Metalscrap',
				itemname = 'metalscrap',
				amount = 5,
			},
			[2] = {
				label = 'Steel',
				itemname = 'steel',
				amount = 8,
			},
			[3] = {
				label = 'Rubber',
				itemname = 'rubber',
				amount = 6,
			},
		},
	},
	[6] = {
		label = 'Smg Scope',
		itemname = 'smg_scope',
		slot = 6,
		amount = 50,
		info = {},
		addingpoints = 6,
		pointsneeded = 100,
		type = 'item',
		costs = {
			[1] = {
				label = 'Metalscrap',
				itemname = 'metalscrap',
				amount = 4,
			},
			[2] = {
				label = 'Steel',
				itemname = 'steel',
				amount = 5,
			},
			[3] = {
				label = 'Rubber',
				itemname = 'rubber',
				amount = 2,
			},
		},
	},
	[7] = {
		label = 'Assaultrifle Extendedclip',
		itemname = 'assaultrifle_extendedclip',
		slot = 7,
		amount = 50,
		info = {},
		addingpoints = 7,
		pointsneeded = 150,
		type = 'item',
		costs = {
			[1] = {
				label = 'Metalscrap',
				itemname = 'metalscrap',
				amount = 6,
			},
			[2] = {
				label = 'steel',
				itemname = 'steel',
				amount = 8,
			},
			[3] = {
				label = 'Rubber',
				itemname = 'rubber',
				amount = 2,
			},
			[4] = {
				label = 'Smg Extendedclip',
				itemname = 'smg_extendedclip',
				amount = 1,
			},
		},
	},
	[8] = {
		label = 'Assault Rifle Drum',
		itemname = 'assaultrifle_drum',
		slot = 8,
		amount = 50,
		info = {},
		addingpoints = 8,
		pointsneeded = 200,
		type = 'item',
		costs = {
			[1] = {
				label = 'Metalscrap',
				itemname = 'metalscrap',
				amount = 5,
			},
			[2] = {
				label = 'Steel',
				itemname = 'steel',
				amount = 9,
			},
			[3] = {
				label = 'Rubber',
				itemname = 'rubber',
				amount = 4,
			},
			[4] = {
				label = 'Smg Extendedclip',
				itemname = 'smg_extendedclip',
				amount = 2,
			},
		},
	},
}

MaxInventorySlots = 41

BackEngineVehicles = {
    [`ninef`] = true,
    [`adder`] = true,
    [`vagner`] = true,
    [`t20`] = true,
    [`infernus`] = true,
    [`zentorno`] = true,
    [`reaper`] = true,
    [`comet2`] = true,
    [`comet3`] = true,
    [`jester`] = true,
    [`jester2`] = true,
    [`cheetah`] = true,
    [`cheetah2`] = true,
    [`prototipo`] = true,
    [`turismor`] = true,
    [`pfister811`] = true,
    [`ardent`] = true,
    [`nero`] = true,
    [`nero2`] = true,
    [`tempesta`] = true,
    [`vacca`] = true,
    [`bullet`] = true,
    [`osiris`] = true,
    [`entityxf`] = true,
    [`turismo2`] = true,
    [`fmj`] = true,
    [`re7b`] = true,
    [`tyrus`] = true,
    [`italigtb`] = true,
    [`penetrator`] = true,
    [`monroe`] = true,
    [`ninef2`] = true,
    [`stingergt`] = true,
    [`surfer`] = true,
    [`surfer2`] = true,
    [`gp1`] = true,
    [`autarch`] = true,
    [`tyrant`] = true
}

Config.MaximumAmmoValues = {
    ["pistol"] = 250,
    ["smg"] = 250,
    ["shotgun"] = 200,
    ["rifle"] = 250,
}
