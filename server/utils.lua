--- QB Inventory Project
-- Server-side code for the all the utils functions
-- @module utils
-- @author restray

--- Is the given number an unsigned integer?
-- @function isValidNumber
-- @tparam number nb	The number to check
-- @treturn bool		True if the number is an unsigned integer
function IsValidNumber(nb)
	return math.floor(nb) == nb and nb >= 0
end

--- Get the first avilable slot in the items list from inventory type for the item
-- @function getFirstAvailableSlot
-- @tparam string name				The inventory type name
-- @tparam Item[] items				The items list
-- @tparam Item item				The item to check
-- @treturn number					The first available slot or -1 if no slot is available
function GetFirstAvailableSlot(name, items, item)
	for i = 1, GetSlotsForInventory(name) do
		if not items[i] or (not item.unique and items[i].name == item.name) then
			return i
		end
	end
	return -1
end

--- Is the inventory opened
-- @function IsInventoryUsed
-- @tparam Inventories[][] inventory 		the array type (from Inventory variable)
-- @tparam string name 					the inventory type
-- @tparam number id 					id of the inventory
-- @tparam number source 				the player source id
-- @treturn bool						True if the inventory is opened by another player
function IsInventoryUsed(inventory, name, id, source)
    if inventory[id] and inventory[id].isOpen then
		if inventory[id].isOpen == source then
			return false
		elseif QBCore.Functions.GetPlayer(inventory[id].isOpen) then
			TriggerClientEvent('inventory:client:CheckOpenState', inventory[id].isOpen, name, id, inventory[id].label)
			return true
		else
			inventory[id].isOpen = false
		end
    end
    return false
end

--- Every condition related to a forbiden access to an inventory
-- @function IsInventoryIsInaccessible
-- @tparam string name 			The inventory type
-- @tparam number id 			Id of the inventory
-- @tparam Player Player 		The player QBCore Player Object from source
-- @treturn bool				True if the player can't access the inventory
function IsInventoryIsInaccessible(name, id, Player)
	-- Don't let non police to access police vehicles inventory
	if name == "trunk" and QBCore.Shared.SplitStr(id, "LSPD")[2] and Player.PlayerData.job and Player.PlayerData.job.name ~= "police" then
		return true
	end
	return false
end

--- Is the given name is specified in the config
-- @function IsValidInventoryType
-- @tparam string name		The inventory type
-- @treturn bool
function IsValidInventoryType(name)
	for _, v in ipairs(Config.InventoriesType) do
		if v == name then
			return true
		end
	end
	return false
end

--- Get the inventory max weight for specified player
-- @function GetMaxWeightsForInventory
-- @tparam string name						The inventory type
-- @tparam[opt] Inventories[][] other		The opened inventory array
-- @treturn number							The inventory max weight
function GetMaxWeightsForInventory(name, other)
	if other then
		return other.maxweight or Config.MaxWeights[name]
	end
	return Config.MaxWeights[name]
end

--- Get the inventory slots number for specified player
-- @function GetSlotsForInventory
-- @tparam string name					The inventory type
-- @tparam Inventories[][] other		The opened inventory array
-- @tparam Player player				The player who opened the inventory
-- @treturn number						The max number of slots
function GetSlotsForInventory(name, other, player)
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

--- Save inventories in the specified table of the database
-- @function SaveDatabaseInventories
-- @tparam string name					The inventory type
-- @tparam number id					The inventory id
-- @tparam Inventories[][] inventory	The opened inventory array
-- @tparam string columnName			The column name in the database
-- @treturn bool						True if the inventory is saved
function SaveDatabaseInventories(name, id, inventory, columnName)
	if not inventory.items then
		return false
	end

	-- Remove the description line in items
	for _, item in pairs(inventory.items) do
		item.description = nil
	end

	MySQL.Async.insert('INSERT INTO '..name..'items ('.. columnName ..', items) VALUES (:id, :items) ON DUPLICATE KEY UPDATE items = :items', {
		['id'] = id,
		['items'] = json.encode(inventory.items)
	})
	inventory.isOpen = false
	return true
end

--- Fetch items from the database
-- @function FetchItemsFromDatabase
-- @tparam string table				The database table name
-- @tparam string itemsColumn		The database table column name for items
-- @tparam string columnCondition	The database table column name for condition
-- @tparam string conditionValue	The condition value
-- @treturn[1] table				The fetched items
-- @treturn[2] bool					False if the database returns nothing
function FetchItemsFromDatabase(table, itemsColumn, columnCondition, conditionValue)
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

--- Is the recipe contain the from item
-- @function recipeContains
-- @tparam string[] recipe      A table of all the items name needed to craft the item
-- @tparam Item                 The item to craft
-- @treturn boolean             If the recipe is valid
function recipeContains(recipe, fromItem)
	for _, v in pairs(recipe.accept) do
		if v == fromItem.name then
			return true
		end
	end

	return false
end

--- Is the vehicle plate is owned by someone
-- @function IsVehicleOwned
-- @tparam string plate		The vehicle plate
-- @treturn bool
function IsVehicleOwned(plate)
    return not not MySQL.Sync.fetchScalar('SELECT 1 from player_vehicles WHERE plate = ?', {plate})
end

--- Is the inventory allow items to be dropped in?
-- @function IsInventoryDropAllowed
-- @tparam string name		The inventory type (Config.InventoriesType)
-- @treturn bool
function IsInventoryDropAllowed(name)
	for _, v in pairs(Config.DisableInventoryDrop) do
		if v == name then
			return false
		end
	end
	return true
end

--- Is the specified inventory a source player type?
-- @function IsPlayerInventory
-- @tparam string name		The inventory type
-- @treturn bool				Is the inventory a source player type?
function IsPlayerInventory(name)
	return name == "player" or name == "hotbar"
end

--- Is the specified inventory a any player type?
-- @function IsInventoryPlayerType
-- @see IsPlayerInventory
-- @tparam string name			The inventory type
-- @treturn bool				Is the inventory a player type?
function IsInventoryPlayerType(name)
	return IsPlayerInventory(name) or name == "otherplayer"
end

--- Add an item to the inventory
-- @function AddItemToInventory
-- @tparam string name			The inventory type to add the item to
-- @tparam Inventories[][] inventory		The inventory array to add the item to
-- @tparam int slot			The slot to add the item to
-- @tparam string itemName		The item name
-- @tparam int amount			The amount of the item to add
-- @tparam[opt] Item.info info	The item specific infos
-- @treturn bool				True if the item was added, false if not
function AddItemToInventory(name, inventory, slot, itemName, amount, info)
	amount = tonumber(amount)
	local ItemData = QBCore.Shared.Items[itemName:lower()]

	if not ItemData then
		return false
	end

	if inventory.items[slot] and inventory.items[slot].name == itemName and not ItemData.unique then
		if IsInventoryPlayerType(name) then
			Player.Functions.AddItem(itemName, amount, slot)
		else
			inventory.items[slot].amount = inventory.items[slot].amount + amount
		end
	else
		inventory.items[slot] = {
			name = ItemData["name"],
			amount = amount,
			info = info or "",
			label = ItemData["label"],
			description = ItemData["description"] or "",
			weight = ItemData["weight"],
			type = ItemData["type"],
			unique = ItemData["unique"],
			useable = ItemData["useable"],
			image = ItemData["image"],
			slot = slot,
		}
	end

	return true
end

--- Remove an item from the inventory
-- @function RemoveItemFromInventory
-- @tparam Inventories[][] inventory		The inventory array to remove the item from
-- @tparam number slot						The slot to remove the item from
-- @tparam string itemName					The item name
-- @tparam number amount					The amount of the item to remove
-- @treturn bool							True if the item was removed, false if not
function RemoveItemFromInventory(inventory, slot, itemName, amount)
	if not inventory or not inventory.items[slot] then
		return false
	end

	if inventory.items[slot].name == itemName then
		if inventory.items[slot].amount > amount then
			inventory.items[slot].amount = inventory.items[slot].amount - amount
		else
			inventory.items[slot] = nil
			if not next(inventory.items) then
				inventory.items = {}
			end
		end
	else
		return false
	end

	return true
end