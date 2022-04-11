local QBCore = exports['qb-core']:GetCoreObject()
local Inventories = {}

-- Populate the inventories
for _, v in ipairs(Config.InventoriesType) do
	Inventories[v] = {}
end

local function GetStashItems(id)
	local items = {}

	-- Get items from Database
	local result = MySQL.Sync.fetchScalar('SELECT items FROM stashitems WHERE stash = ?', {id})
	if not result then
		return items -- Return empty table
	end

	-- Parsing item results
	local stashItems = json.decode(result)
	if not stashItems then
		return items -- Return empty table
	end

	-- Add items into stash array
	for _, item in pairs(stashItems) do
		local itemInfo = QBCore.Shared.Items[item.name:lower()]
		if itemInfo then
			items[item.slot] = {
				name = itemInfo["name"],
				amount = math.floor(tonumber(item.amount)), -- Assure the player there is no digit amounts
				info = item.info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] or "",
				weight = itemInfo["weight"],
				type = itemInfo["type"],
				unique = itemInfo["unique"],
				useable = itemInfo["useable"],
				image = itemInfo["image"],
				slot = item.slot,
			}
		end
	end

	return items
end

-- Is the inventory is opened
-- @param {array} inventory 	the array type (from Inventory variable)
-- @param {string} name 		the inventory name
-- @param {int} the id 			id of the inventory
-- @return {bool}
local function IsInventoryUsed(inventory, name, id)
    if inventory[id] and inventory[id].isOpen then
		if QBCore.Functions.GetPlayer(inventory[id].isOpen) then
			TriggerClientEvent('inventory:client:CheckOpenState', inventory[id].isOpen, name, id, inventory[id].label)
			return true
		else
			inventory[id].isOpen = false
		end
    end
    return false
end

-- Is the given name is specified in the config
-- @param {string} name		the inventory name
-- @return {bool}
local function IsValidInventoryType(name)
	for _, v in ipairs(Config.InventoriesType) do
		if v == name then
			return true
		end
	end
	return false
end

-- Get the inventory max weight for specified player
-- @param {string} name		the inventory name
-- @param {array} inventory	the opened inventory array
-- @param {Player} player	the player who opened the inventory
-- @return {int}
local function GetMaxWeightsForInventory(name, other, player)
	if other then
		return other.maxweight or Config.MaxWeights[name]
	end
	return Config.MaxWeights[name]
end

local function IsInventoryIsInaccessible(name, Player)
	return false
end

-- Get the inventory slots number for specified player
-- @param {string} name		the inventory name
-- @param {array} inventory	the opened inventory array
-- @param {Player} player	the player who opened the inventory
-- @return {int}
local function GetSlotsForInventory(name, other, player)
	if name == "otherplayer" then
		if player.PlayerData.job.name == "police" and player.PlayerData.job.onduty then
			return Config.MaxSlots[name]
		else
			return Config.MaxSlots[name] - 1
		end
	end

	if other then
		return other.slots or Config.MaxSlots[name]
	end
	return Config.MaxSlots[name]
end

-- Fetch items from the database
-- @param {string} table			the database table name
-- @param {string} itemsColumn		the database table column name for items
-- @param {string} columnCondition	the database table column name for condition
-- @param {any} conditionValue		the condition value
local function FetchItemsFromDatabase(table, itemsColumn, columnCondition, conditionValue)
	local items = {}
	local result = MySQL.Sync.fetchScalar('SELECT '.. itemsColumn ..' FROM '.. table ..' WHERE '.. columnCondition ..' = ?', {conditionValue})
	
	if not result then
		return items -- Return empty table
	end

	-- Parsing item results
	local fetchedItems = json.decode(result)
	if not fetchedItems or not next(fetchedItems) then
		return items -- Return empty table
	end

	-- Add items into array
	for _, item in pairs(fetchedItems) do
		local itemInfo = QBCore.Shared.Items[item.name:lower()]
		if itemInfo then
			items[item.slot] = {
				name = itemInfo["name"],
				amount = math.floor(tonumber(item.amount)), -- Assure the player there is no digit amounts
				info = item.info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] or "",
				weight = itemInfo["weight"],
				type = itemInfo["type"],
				unique = itemInfo["unique"],
				useable = itemInfo["useable"],
				image = itemInfo["image"],
				slot = item.slot,
			}
		end
	end

	return items
end

-- Get the inventory items from name and ID
-- @param {string} name		the inventory name
-- @param {int} id			the inventory id
-- @return {array}
local function GetItemsForInventory(name, id)
	if name == "player" then

	elseif name == "drop" then
	elseif name == "glovebox" then
		return FetchItemsFromDatabase('gloveboxitems', 'items', 'plate', id)
	elseif name == "stash" then
		return FetchItemsFromDatabase('stashitems', 'items', 'stash', id)
	elseif name == "trunk" then
		return FetchItemsFromDatabase('trunkitems', 'items', 'plate', id)
	elseif name == "shop" then
	elseif name == "traphouse" then
	elseif name == "crafting" then
	elseif name == "attachment_crafting" then
	elseif name == "otherplayer" then
		local OtherPlayer = QBCore.Functions.GetPlayer(tonumber(id))
		if OtherPlayer then
			Wait(250)
			return OtherPlayer.PlayerData.items
		end
	end
	return {}
end

RegisterNetEvent('inventory:server:OpenInventory', function(name, id, other)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)

	if Player(src).state.inv_busy then
		TriggerClientEvent('QBCore:Notify', src, 'Not Accessible', 'error')
		return
	end

	if not (name and id) then
		TriggerClientEvent("inventory:client:OpenInventory", src, Player.PlayerData.items)
		return
	end

    -- Is the given inventory name and ID are safe and valid?
	if not IsValidInventoryType(name) or not id then
		TriggerClientEvent('QBCore:Notify', src, 'Invalid Inventory', 'error')
		return
	end

	-- Get the inventory type array
	local inventory = Inventories[name]

	-- Is the inventory is opened?
	if IsInventoryUsed(inventory, name, id) or IsInventoryIsInaccessible(name, Player) then
		TriggerClientEvent('QBCore:Notify', src, 'Already in use!', 'error')
		return
	end
	
	-- Get the maxweight and slots of the inventory type
	local maxweight = GetMaxWeightsForInventory(name, other, Player)
	local slots = GetSlotsForInventory(name, other, Player)

	-- Load inventories datas function
	inventory[id] = {
		items = {},
		isOpen = src,
		label = Lang:t(name).."-"..id,
	}

	-- Populate the Inventory[type] variable from Database
	local loadedItems = GetItemsForInventory(name, id)
	if next(loadedItems) then
		inventory[id].items = loadedItems
	end
	
	-- Set the target inventory: name, label, maxweight, slots, items
	local targetInventory = {
		name = name.."-"..id,
		label = inventory[id].label,
		maxweight = maxweight,
		slots = slots,
		items = inventory[id].items
	}

	TriggerClientEvent("inventory:client:OpenInventory", src, Player.PlayerData.items, targetInventory)
end)

-- RegisterNetEvent('inventory:server:addTrunkItems', function(plate, items)
-- end)

-- RegisterNetEvent('inventory:server:combineItem', function(item, fromItem, toItem)
-- end)

-- RegisterNetEvent('inventory:server:CraftItems', function(itemName, itemCosts, amount, toSlot, points)
-- end)

-- RegisterNetEvent('inventory:server:CraftAttachment', function(itemName, itemCosts, amount, toSlot, points)
-- end)

-- RegisterNetEvent('inventory:server:SetIsOpenState', function(IsOpen, type, id)
-- end)

-- RegisterNetEvent('inventory:server:SaveInventory', function(type, id)
-- end)

-- RegisterNetEvent('inventory:server:UseItemSlot', function(slot)
-- end)

-- RegisterNetEvent('inventory:server:UseItem', function(inventory, item)
-- end)

-- RegisterNetEvent('inventory:server:SetInventoryData', function(fromInventory, toInventory, fromSlot, toSlot, amount)
-- end)

-- RegisterNetEvent('qb-inventory:server:SaveStashItems', function(stashId, items)
-- end)

-- RegisterServerEvent("inventory:server:GiveItem", function(target, name, amount, slot)
-- end)