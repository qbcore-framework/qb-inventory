local QBCore = exports['qb-core']:GetCoreObject()
local Inventories = {}

-- Populate the inventories
for _, v in ipairs(Config.InventoriesType) do
	Inventories[v] = {}
end

-- Is the given number an unsigned integer?
-- @param {number} nb	The number to check
-- @return {boolean}	True if the number is an unsigned integer
local function isValidNumber(nb)
	return math.floor(nb) == nb and nb >= 0
end

-- Is the inventory is opened
-- @param {array} inventory 	the array type (from Inventory variable)
-- @param {string} name 		the inventory name
-- @param {int} id 				id of the inventory
-- @param {int} source 			the player source id
-- @return {bool}				True if the inventory is opened by another player
local function IsInventoryUsed(inventory, name, id, source)
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

-- Save inventories in the specified table of the database
-- @param {string} name			the inventory name
-- @param {int} id				the inventory id
-- @param {array} inventory		the opened inventory array
-- @param {string} columnName	the column name in the database
-- @return {bool}				true if the inventory is saved
local function SaveDatabaseInventories(name, id, inventory, columnName)
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
-- @param {array} other 	the opened inventory array
-- @return {array}
local function GetItemsForInventory(name, id, other, Player)
	if name == "player" then
		return Player.PlayerData.items
	elseif name == "drop" then
		if Inventories[name][id] then
			return Inventories[name][id].items
		end
	elseif name == "glovebox" then
		return FetchItemsFromDatabase('gloveboxitems', 'items', 'plate', id)
	elseif name == "stash" then
		return FetchItemsFromDatabase('stashitems', 'items', 'stash', id)
	elseif name == "trunk" then
		return FetchItemsFromDatabase('trunkitems', 'items', 'plate', id)
	elseif name == "shop" then
		local items = {}
		if other.items and next(other.items) then
			for _, item in pairs(other.items) do
				local itemInfo = QBCore.Shared.Items[item.name:lower()]
				if itemInfo then
					items[item.slot] = {
						name = itemInfo["name"],
						amount = tonumber(item.amount),
						info = item.info or "",
						label = itemInfo["label"],
						description = itemInfo["description"] or "",
						weight = itemInfo["weight"],
						type = itemInfo["type"],
						unique = itemInfo["unique"],
						useable = itemInfo["useable"],
						price = item.price,
						image = itemInfo["image"],
						slot = item.slot,
					}
				end
			end
		end
		return items
	elseif name == "otherplayer" then
		local OtherPlayer = QBCore.Functions.GetPlayer(tonumber(id))
		if OtherPlayer then
			Wait(250)
			return OtherPlayer.PlayerData.items
		end
	end

	if other then
		return other.items
	end
	return {}
end

-- Is the vehicle plate is owned by someone
-- @param {string} plate		the vehicle plate
-- @return {bool}
local function IsVehicleOwned(plate)
    return not not MySQL.Sync.fetchScalar('SELECT 1 from player_vehicles WHERE plate = ?', {plate})
end

RegisterNetEvent('inventory:server:OpenInventory', function(name, id, other)
	local src = source

	if Player(src).state.inv_busy then
		TriggerClientEvent('QBCore:Notify', src, 'Not Accessible', 'error')
		return
	end

	local Player = QBCore.Functions.GetPlayer(src)

	if not (name and id) then
		TriggerClientEvent("inventory:client:OpenInventory", src, {}, Player.PlayerData.items)
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
	if IsInventoryUsed(inventory, name, id, src) or IsInventoryIsInaccessible(name, Player) then
		TriggerClientEvent('QBCore:Notify', src, 'Already in use!', 'error')
		return
	end
	
	-- Get the maxweight and slots of the inventory type
	local maxweight = GetMaxWeightsForInventory(name, other, Player)
	local slots = GetSlotsForInventory(name, other, Player)

	-- Load inventories datas function and assure to not overwrite the inventory
	if not inventory[id] then
		inventory[id] = {}
	end
	inventory[id].isOpen = src
	inventory[id].label = Lang:t(name).."-"..id

	-- Populate the Inventory[type] variable from Database
	local loadedItems = GetItemsForInventory(name, id, other)
	if loadedItems and next(loadedItems) then
		inventory[id].items = loadedItems
	else
		inventory[id].items = {}
	end

	-- Set the target inventory: name, label, maxweight, slots, items
	local targetInventory = {
		name = name.."-"..id,
		label = inventory[id].label,
		maxweight = maxweight,
		slots = slots,
		inventory = inventory[id].items
	}

	TriggerClientEvent("inventory:client:OpenInventory", src, {}, Player.PlayerData.items, targetInventory)
end)

-- @deprecated
RegisterNetEvent('inventory:server:addTrunkItems', function(_, _)
	print("[QBCore] inventory:server:addTrunkItems is deprecated, use inventory:server:addItem instead")
end)

-- Add item to the inventory
-- @param {string} name		the inventory name
-- @param {int} id			the inventory id
-- @param {array} item		the item name
-- @todo
AddEventHandler('inventory:server:addItem', function(name, id, item)

end)

-- RegisterNetEvent('inventory:server:combineItem', function(item, fromItem, toItem)
-- end)

-- RegisterNetEvent('inventory:server:CraftItems', function(itemName, itemCosts, amount, toSlot, points)
-- end)

-- RegisterNetEvent('inventory:server:CraftAttachment', function(itemName, itemCosts, amount, toSlot, points)
-- end)

-- A server event handler to let the client set an inventory closed state
-- @param {bool} isOpen		Is the new inventory state open?
-- @param {string} name		The inventory name
-- @param {int} id			The inventory id
-- @return {void}
RegisterNetEvent('inventory:server:SetIsOpenState', function(IsOpen, name, id)
	if not IsOpen then
		if Inventories[name] and Inventories[name][id] then
			Inventories[name][id].isOpen = false
		end
	end
end)

-- A server event to save the inventory items
-- @param {string} name		The inventory name (in the config)
-- @param {int} id			The inventory id
-- @return {void}
RegisterNetEvent('inventory:server:SaveInventory', function(name, id)
	if not IsValidInventoryType(name) then
		-- @todo Anticheat notification
		return
	end

	if name == "trunk" or name == "glovebox" then
		if IsVehicleOwned(id) then
			SaveDatabaseInventories(name, id, Inventories[name][id], "plate")
		end
	elseif name == "stash" then
		SaveDatabaseInventories(name, id, Inventories[name][id], "stash")
	elseif name == "drop" then
		if Inventories[name][id] then
			Inventories[name][id].isOpen = false
			if not Inventories[name][id].items or not next(Inventories[name][id].items) then
				Inventories[name][id] = nil
				TriggerClientEvent("inventory:client:RemoveDropItem", -1, id)
			end
		end
	end
end)

-- Use the item on the given slot
-- @param {number} slot		The slot to use the item
-- @return {void}
RegisterNetEvent('inventory:server:UseItemSlot', function(slot)
	local src = source
	if Player(src).state.inv_busy then
		TriggerClientEvent('QBCore:Notify', src, 'Not Accessible', 'error')
		return
	end

	local Player = QBCore.Functions.GetPlayer(src)
	local itemData = Player.Functions.GetItemBySlot(slot)

	-- is the item a usable item?
	if itemData and (itemData.type == "weapon" or itemData.useable) then
		if itemData.type == "weapon" then
			if itemData.info.quality then
				TriggerClientEvent("inventory:client:UseWeapon", src, itemData, itemData.info.quality > 0)
			else
				TriggerClientEvent("inventory:client:UseWeapon", src, itemData, true)
			end
		elseif itemData.useable then
			TriggerClientEvent("QBCore:Client:UseItem", src, itemData)
		end

		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[itemData.name], "use")
	end
end)

-- Use the item specified
-- @param {string} name		The inventory name
-- @param {string} item		The item name
RegisterNetEvent('inventory:server:UseItem', function(name, item)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)

	if name == "player" or name == "hotbar" then
		local itemData = Player.Functions.GetItemBySlot(item.slot)
		if itemData then
			TriggerClientEvent("QBCore:Client:UseItem", src, itemData)
		end
	end
end)

-- Is the inventory allow items to be dropped in?
-- @param {string} name		The inventory name (Config.InventoriesType)
-- @return {bool}
local function IsInventoryDropAllowed(name)
	for _, v in pairs(Config.DisableInventoryDrop) do
		if v == name then
			return false
		end
	end
	return true
end

-- Is the specified inventory a player type
-- @param {string} name		The inventory name
-- @return {bool}
local function IsPlayerInventory(name)
	return name == "player" or name == "hotbar"
end

local function IsInventoryPlayerType(name)
	return IsPlayerInventory(name) or name == "otherplayer"
end

-- Add an item to the inventory
-- @param {string} name			The inventory type to add the item to
-- @param {array} inventory		The inventory array to add the item to
-- @param {int} slot			The slot to add the item to
-- @param {string} itemName		The item name
-- @param {int} amount			The amount of the item to add
-- @param {array} info			The item specific infos
-- @return {bool|item}			False if can't be added, True if added, the item if swapped
local function AddItemToInventory(name, inventory, slot, itemName, amount, info, itemData)
	amount = tonumber(amount)
	local ItemData = QBCore.Shared.Items[itemName:lower()]

	if not ItemData then
		return false
	end

	if inventory.items[slot] and inventory.items[slot].name == itemName and not ItemData.unique then
		if IsInventoryPlayerType(name) then
			Player.Functions.AddItem(itemData.name, amount, slot)
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

local function RemoveItemFromInventory(inventory, slot, itemName, amount)
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
	end

	return true
end

-- Get the adaptated methods for the inventory type
-- @param {string} name		The inventory type
-- @param {number} id		The inventory id
-- @param {number} src		The source player (optional)
-- @return {array|nil}		The methods (Get, Add, Delete) or nil if not found
local function GetInventoryMethod(name, id, src)
	-- Ensure the drop inventory exists or create it
	if name == "drop" and not Inventories[name][id] then
		id = math.random(10000, 99999) .. ""
		while Inventories[name][id] ~= nil do
			id = math.random(10000, 99999) .. ""
		end

		Inventories[name][id] = {
			items = {}
		}
	end

	if IsInventoryPlayerType(name) then
		local Player = QBCore.Functions.GetPlayer(id)
		if Player then
			return {
				Get = function(slot)
					return Player.Functions.GetItemBySlot(slot)
				end,
				Add = function(itemName, amount, slot, info)
					return Player.Functions.AddItem(itemName, amount, slot, info)
				end,
				Delete = function(itemName, amount, slot)
					TriggerClientEvent("inventory:client:CheckWeapon", Player.PlayerData.source, itemName)
					return Player.Functions.RemoveItem(itemName, amount, slot)
				end,
			}
		end
	else
		if Inventories[name] and Inventories[name][id] then
			return {
				Get = function(slot)
					return Inventories[name][id].items[slot]
				end,
				Add = function(itemName, amount, slot, info)
					if name == "drop" then
						TriggerClientEvent("inventory:client:DropItemAnim", src)
						TriggerClientEvent("inventory:client:AddDropItem", -1, id, src, GetEntityCoords(GetPlayerPed(src)))
					end
					return AddItemToInventory(name, Inventories[name][id], slot, itemName, amount, info)
				end,
				Delete = function(itemName, amount, slot)
					return RemoveItemFromInventory(Inventories[name][id], slot, itemName, amount)
				end,
			}
		end
	end

	return nil
end

local function ChargePlayer(src, id, itemData, amount)
	local Player = QBCore.Functions.GetPlayer(src)

	local ShopType = QBCore.Shared.SplitStr(id, "_")[1]:lower()
	local ShopName = QBCore.Shared.SplitStr(id, "_")[2]
	local ItemType = QBCore.Shared.SplitStr(itemData.name, "_")[1]

	if ItemType == "weapon" then
		itemData.info.serie = tostring(QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(4))
	end

	local price
	if itemData.unique then
		amount = 1
		price = tonumber(itemData.price)
	else
		price = tonumber((itemData.price * amount))
	end

	local ShopTypeEventFunctions = {
		dealer = function() TriggerClientEvent('qb-drugs:client:updateDealerItems', src, itemData, amount) end,
		itemshop = function() TriggerClientEvent('qb-shops:client:UpdateShop', src, ShopName, itemData, amount) end,
	}

	local AllowBankAccount = true
	local bankBalance = Player.PlayerData.money["bank"]
	if ShopType == "dealer" then
		AllowBankAccount = false
	end

	-- Remove money from the player
	local PaymentType
	if Player.Functions.RemoveMoney("cash", price, ShopType.."-bought-item") then
		PaymentType = "cash"
	elseif AllowBankAccount and bankBalance >= price then
		PaymentType = "bank"
		Player.Functions.RemoveMoney("bank", price, ShopType.."-bought-item")
	else
		TriggerClientEvent('QBCore:Notify', src, "You don't have enough cash..", "error") --[[ Add translation ]]
		return false
	end

	if ShopTypeEventFunctions[ShopType] then
		ShopTypeEventFunctions[ShopType]()
	end
	TriggerClientEvent('QBCore:Notify', src, itemData.label .. " bought with "..PaymentType.."!", "success")
	TriggerEvent("qb-log:server:CreateLog", "shops", ShopType .. " item bought", "green", "**"..GetPlayerName(src) .. "** bought a " .. itemData.label .. " for $"..price.." with "..PaymentType)
	return true
end

-- Move an item from one inventory to another
-- @param {string} fromInventory		The inventory to move the item from (Config.InventoriesType)
-- @param {string} toInventory			The inventory to move the item to (Config.InventoriesType)
-- @param {int} fromSlot				The slot to move the item from
-- @param {int} toSlot					The slot to move the item to
-- @param {number} amount				The amount of the item to move
-- @return {void}
RegisterNetEvent('inventory:server:SetInventoryData', function(fromInventory, toInventory, fromSlot, toSlot, amount)
	local src = source

	-- Force type number on slots
	fromSlot = tonumber(fromSlot)
	toSlot = tonumber(toSlot)

	-- Inventory getters for types and ids
	local fromInventoryType = QBCore.Shared.SplitStr(fromInventory, "-")[1]
	local fromInventoryId = fromInventory:sub((fromInventoryType .. "-"):len() + 1, fromInventory:len())
	local toInventoryType = QBCore.Shared.SplitStr(toInventory, "-")[1]
	local toInventoryId = toInventory:sub((toInventoryType .. "-"):len() + 1, toInventory:len())

	if IsPlayerInventory(fromInventoryType) then
		fromInventoryId = src
	end
	if IsPlayerInventory(toInventoryType) then
		toInventoryId = src
	end

	if not IsInventoryDropAllowed(toInventoryType) then
		return
	end

	if not isValidNumber(amount) then
		-- @todo Anticheat notification "Invalid amount format"
		return
	end

	-- To Inventory Type checker, if nil: set to drop
	if not IsValidInventoryType(toInventoryType) then
		toInventoryType = "drop"
	end

	-- From Inventory Type checker, if nil: throw an error
	if not IsValidInventoryType(fromInventoryType) then
		print("[QBCore] [Inventory Debug] Invalid inventory type from "..json.encode(fromInventoryType))
		return
	end

	-- Is the inventories opened by another user
	if IsInventoryUsed(Inventories[fromInventoryType], fromInventoryType, fromInventoryId, src)
	or IsInventoryUsed(Inventories[toInventoryType], toInventoryType, toInventoryId, src) then
		TriggerClientEvent('QBCore:Notify', src, 'Not Accessible', 'error')
		return
	end

	-- Get the inventory methods
	local fromInventoryMethod = GetInventoryMethod(fromInventoryType, fromInventoryId, src)
	local toInventoryMethod = GetInventoryMethod(toInventoryType, toInventoryId, src)
	if not toInventoryMethod or not fromInventoryMethod then
		-- @todo Anticheat notification "Invalid inventory"
		return
	end

	local fromItemData = fromInventoryMethod.Get(fromSlot)
	local toItemData = toInventoryMethod.Get(toSlot)
	if not fromItemData then
		TriggerClientEvent("QBCore:Notify", src, "Item doesn't exist!", "error")
		return
	end
	if fromItemData.unique then
		amount = 1
	end
	amount = tonumber(amount) or fromItemData.amount
	if amount > fromItemData.amount then
		return
	end

	local isMovingAllItem = amount == fromItemData.amount

	-- Target slot is used by an item
	if toItemData then
		if toItemData.unique or fromItemData.unique then
			if not isMovingAllItem then
				TriggerClientEvent("QBCore:Notify", src, "Item is unique!", "error")
				return
			end

			fromInventoryMethod.Delete(fromItemData.name, fromItemData.amount, fromSlot)
			toInventoryMethod.Delete(toItemData.name, toItemData.amount, toSlot)

			fromInventoryMethod.Add(toItemData.name, toItemData.amount, fromSlot, toItemData.info)
			toInventoryMethod.Add(fromItemData.name, fromItemData.amount, toSlot, fromItemData.info)

		elseif toItemData.name ~= fromItemData.name then
			if not isMovingAllItem then
				TriggerClientEvent("QBCore:Notify", src, "You can't move item in this slot!", "error")
				return
			end

			fromInventoryMethod.Delete(fromItemData.name, fromItemData.amount, fromSlot)
			toInventoryMethod.Delete(toItemData.name, toItemData.amount, toSlot)

			fromInventoryMethod.Add(toItemData.name, toItemData.amount, fromSlot, toItemData.info)
			toInventoryMethod.Add(fromItemData.name, fromItemData.amount, toSlot, fromItemData.info)
		elseif toItemData.name == fromItemData.name then
			fromInventoryMethod.Delete(fromItemData.name, amount, fromSlot)
			toInventoryMethod.Add(fromItemData.name, amount, toSlot)
		end
	else
		fromInventoryMethod.Delete(fromItemData.name, amount, fromSlot)
		toInventoryMethod.Add(fromItemData.name, amount, toSlot, fromItemData.info)
	end

	-- @todo Check weight and restore item if it is too heavy

	-- @todo Charge the player or restore
	if fromInventoryType == "shop" then
		if not ChargePlayer(src, fromInventoryId, fromItemData, amount) then
			fromInventoryMethod.Add(fromItemData.name, amount, fromSlot, fromItemData.info)
			toInventoryMethod.Delete(fromItemData.name, amount, toSlot)
			TriggerClientEvent("inventory:client:closeInventory", src)
			return
		end
	end

	-- the player's radio is shut down
	if fromItemData.name:lower() == "radio" then
		TriggerClientEvent('Radio.Set', src, false)
	end
end)

-- Save the specified item in the stash
-- @deprecated
RegisterNetEvent('qb-inventory:server:SaveStashItems', function(id, items)
	print("[QBCore] [WARNING] qb-inventory:server:SaveStashItems is deprecated, use inventory:server:SaveInventory instead")
	Inventories.stash[id].items = items
	SaveDatabaseInventories("stash", id, Inventories.stash[id], "stash")
end)

QBCore.Functions.CreateCallback('qb-inventory:server:GetStashItems', function(_, cb, id)
	cb(FetchItemsFromDatabase('stashitems', 'items', 'stash', id))
end)

RegisterServerEvent("inventory:server:GiveItem", function(target, name, amount, slot)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local OtherPlayer = QBCore.Functions.GetPlayer(tonumber(target))
	local dist = #(GetEntityCoords(GetPlayerPed(src))-GetEntityCoords(GetPlayerPed(target)))

	-- Exclusion cases
	if Player == OtherPlayer then
		return TriggerClientEvent('QBCore:Notify', src, "You can't give yourself an item?")
	elseif dist > 2 then
		return TriggerClientEvent('QBCore:Notify', src, "You are too far away to give items!")
	end

	-- Get item from player inventory slot
	local item = Player.Functions.GetItemBySlot(slot)
	if not item or item.name ~= name then
		return TriggerClientEvent('QBCore:Notify', src, "Incorrect item found try again!")
	end

	if amount == 0 then
		amount = item.amount
	end

	if not isValidNumber(amount) or amount > item.amount then
		TriggerClientEvent('QBCore:Notify', src,  "You do not have enough of the item", "error")
		return
	end

	if Player.Functions.RemoveItem(item.name, amount, item.slot) then
		if OtherPlayer.Functions.AddItem(item.name, amount, false, item.info) then
			TriggerClientEvent('inventory:client:ItemBox',target, QBCore.Shared.Items[item.name], "add")
			TriggerClientEvent('QBCore:Notify', target, "You Received "..amount..' '..item.label.." From "..Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname)
			TriggerClientEvent("inventory:client:UpdatePlayerInventory", target, true)
			TriggerClientEvent('inventory:client:ItemBox',src, QBCore.Shared.Items[item.name], "remove")
			TriggerClientEvent('QBCore:Notify', src, "You gave " .. OtherPlayer.PlayerData.charinfo.firstname.." "..OtherPlayer.PlayerData.charinfo.lastname.. " " .. amount .. " " .. item.label .."!")
			TriggerClientEvent("inventory:client:UpdatePlayerInventory", src, true)
			TriggerClientEvent('qb-inventory:client:giveAnim', src)
			TriggerClientEvent('qb-inventory:client:giveAnim', target)
		else
			Player.Functions.AddItem(item.name, amount, item.slot, item.info)
			TriggerClientEvent('QBCore:Notify', src,  "The other players inventory is full!", "error")
			TriggerClientEvent('QBCore:Notify', target,  "Your inventory is full!", "error")
			TriggerClientEvent("inventory:client:UpdatePlayerInventory", src, false)
			TriggerClientEvent("inventory:client:UpdatePlayerInventory", target, false)
		end
	else
		TriggerClientEvent('QBCore:Notify', src,  "You do not have enough of the item", "error")
	end
end)

QBCore.Commands.Add("giveitem", "Give An Item (Admin Only)", {{name="id", help="Player ID"},{name="item", help="Name of the item (not a label)"}, {name="amount", help="Amount of items"}}, true, function(source, args)
	local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
	local amount = tonumber(args[3])
	local itemData = QBCore.Shared.Items[tostring(args[2]):lower()]
	if Player then
		if amount > 0 then
			if itemData then
				-- check iteminfo
				local info = {}
				if itemData["name"] == "id_card" then
					info.citizenid = Player.PlayerData.citizenid
					info.firstname = Player.PlayerData.charinfo.firstname
					info.lastname = Player.PlayerData.charinfo.lastname
					info.birthdate = Player.PlayerData.charinfo.birthdate
					info.gender = Player.PlayerData.charinfo.gender
					info.nationality = Player.PlayerData.charinfo.nationality
				elseif itemData["name"] == "driver_license" then
					info.firstname = Player.PlayerData.charinfo.firstname
					info.lastname = Player.PlayerData.charinfo.lastname
					info.birthdate = Player.PlayerData.charinfo.birthdate
					info.type = "Class C Driver License"
				elseif itemData["type"] == "weapon" then
					amount = 1
					info.serie = tostring(QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(4))
				elseif itemData["name"] == "harness" then
					info.uses = 20
				elseif itemData["name"] == "markedbills" then
					info.worth = math.random(5000, 10000)
				elseif itemData["name"] == "labkey" then
					info.lab = exports["qb-methlab"]:GenerateRandomLab()
				elseif itemData["name"] == "printerdocument" then
					info.url = "https://cdn.discordapp.com/attachments/870094209783308299/870104331142189126/Logo_-_Display_Picture_-_Stylized_-_Red.png"
				end

				if Player.Functions.AddItem(itemData["name"], amount, false, info) then
					TriggerClientEvent('QBCore:Notify', source, "You Have Given " ..GetPlayerName(tonumber(args[1])).." "..amount.." "..itemData["name"].. "", "success")
				else
					TriggerClientEvent('QBCore:Notify', source,  "Can't give item!", "error")
				end
			else
				TriggerClientEvent('QBCore:Notify', source,  "Item Does Not Exist", "error")
			end
		else
			TriggerClientEvent('QBCore:Notify', source,  "Invalid Amount", "error")
		end
	else
		TriggerClientEvent('QBCore:Notify', source,  "Player Is Not Online", "error")
	end
end, "admin")