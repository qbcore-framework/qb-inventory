--- QB Inventory Project
-- Server-side code for the qb-inventory mod, containing events, utils functions, etc...
-- @module server
-- @author restray
-- @todo Need to translate the whole script

QBCore = exports['qb-core']:GetCoreObject()

--- All the inventories table
-- @table Inventories
-- @tfield string type		Table that contains all inventories types (see Config.InventoriesType)
-- @tfield number type.id	Table that contains all inventories
local Inventories = {}

-- Populate the inventories
for _, v in ipairs(Config.InventoriesType) do
	Inventories[v] = {}
end

--- Get the inventory items from name and ID
-- @tparam string name						The inventory type
-- @tparam number id						The inventory id
-- @tparam[opt] Inventories[][] other 		The opened inventory array
-- @tparam[optchain] Player Player		 	The opened inventory array
-- @treturn[1] Inventories[][].items		The inventory items
-- @treturn[2] table						Empty table, meaning no items were find in the inventory
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

--- Get the adaptated methods for the inventory type
-- @tparam string name				The inventory type
-- @tparam number id				The inventory id
-- @tparam[opt] number src			The source player
-- @treturn[1] InventoryMethods		The methods
-- @treturn[2] nil					If the inventory type is not found
-- @export
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
		if QBCore.Functions.GetPlayer(id) then
			return {
				GetAll = function()
					-- Refresh player inventory
					local Player = QBCore.Functions.GetPlayer(id)
					return Player.PlayerData.items
				end,
				Get = function(slot)
					local Player = QBCore.Functions.GetPlayer(id)
					return Player.Functions.GetItemBySlot(slot)
				end,
				Set = function (items)
					local Player = QBCore.Functions.GetPlayer(id)
					return Player.Functions.SetInventory(items, true)
				end,
				Add = function(itemName, amount, slot, info)
					local Player = QBCore.Functions.GetPlayer(id)
					return Player.Functions.AddItem(itemName, amount, slot, info)
				end,
				Delete = function(itemName, amount, slot)
					local Player = QBCore.Functions.GetPlayer(id)
					TriggerClientEvent("inventory:client:CheckWeapon", Player.PlayerData.source, itemName)
					return Player.Functions.RemoveItem(itemName, amount, slot)
				end,
			}
		end
	else
		if Inventories[name] and Inventories[name][id] then
			return {
				GetAll = function()
					return Inventories[name][id].items
				end,
				Get = function(slot)
					return Inventories[name][id].items[slot]
				end,
				Set = function(items)
					Inventories[name][id].items = items
					return true
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

--- Make a user pay an item (like shop, dealers...)
-- @tparam number src		The source player
-- @tparam string id		The inventory full id
-- @tparam Item itemData	The item data
-- @tparam number amount	The amount of the item to pay
-- @treturn boolean			True if the player has enough money
local function ChargePlayer(src, id, itemData, amount)
	local Player = QBCore.Functions.GetPlayer(src)

	local ShopType = QBCore.Shared.SplitStr(id, "_")[1]:lower()
	local ShopName = QBCore.Shared.SplitStr(id, "_")[2]

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

--- Server event when a player wants to open an inventory
-- @event inventory:server:OpenInventory
-- @tparam string name					the inventory type (Config.InventoriesType)
-- @tparam number id					the inventory id
-- @tparam[opt] Inventories[][] other	the opened inventory array (optionnal)
RegisterNetEvent('inventory:server:OpenInventory', function(name, id, other)
	local src = source

	if Player(src).state.inv_busy then
		TriggerClientEvent('QBCore:Notify', src, 'Not Accessible', 'error')
		return
	end

	local Player = QBCore.Functions.GetPlayer(src)

	if not (name and id) then
		return TriggerClientEvent("inventory:client:OpenInventory", src, {}, Player.PlayerData.items)
	end

    -- Is the given inventory name and ID are safe and valid?
	if not IsValidInventoryType(name) or not id then
		TriggerClientEvent("inventory:client:closeInventory", src)
		return TriggerClientEvent('QBCore:Notify', src, 'Invalid Inventory', 'error')
	end

	-- Get the inventory type array
	local inventory = Inventories[name]

	-- Is the inventory is opened?
	if IsInventoryUsed(inventory, name, id, src) then
		TriggerClientEvent("inventory:client:closeInventory", src)
		return TriggerClientEvent('QBCore:Notify', src, 'Already in use!', 'error')
	end
	if IsInventoryIsInaccessible(name, id, Player) then
		TriggerClientEvent("inventory:client:closeInventory", src)
		return TriggerClientEvent('QBCore:Notify', src, "It seems like you don't have the keys", 'error')
	end
	
	-- Get the maxweight and slots of the inventory type
	local maxweight = GetMaxWeightsForInventory(name, other)
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

--- Add item to the inventory
-- Only for server side, be carefull on the usage of this event, can cause major security issues
-- @event inventory:server:addItem
-- @tparam string name		the inventory type
-- @tparam number id		the inventory id
-- @tparam name item		the item name
-- @tparam number amount	the item amount
-- @tparam table info		the item infos
AddEventHandler('inventory:server:addItem', function(name, id, item, amount, info)
	amount = tonumber(amount)
	if not IsValidNumber(amount) or amount < 1 then
		return
	end

	if not IsValidInventoryType(name) or not id then
		print("[inventory:server:addItem] Invalid inventory type or no ID provided")
		return
	end

	if IsInventoryUsed(Inventories[name], name, id, 0) then
		print("[inventory:server:addItem] Inventory is already in used")
		return
	end

	if not Inventories[name][id] then
		Inventories[name][id] = {}
	end
	Inventories[name][id].isOpen = false
	Inventories[name][id].label = Lang:t(name).."-"..id

	-- Populate the Inventory[type] variable from Database
	local loadedItems = GetItemsForInventory(name, id)
	if loadedItems and next(loadedItems) then
		Inventories[name][id].items = loadedItems
	else
		Inventories[name][id].items = {}
	end
	
	item = QBCore.Shared.Items[item.name]
	if not item then
		print("[inventory:server:addItem] Invalid item name")
		return
	end

	local slot = GetFirstAvailableSlot(name, Inventories[name][id].items, item)
	if slot < 0 then
		print("[inventory:server:addItem] No available slot")
		return
	end

	AddItemToInventory(name, Inventories[name][id], slot, item, amount, info)
end)

--- Combine two items in the player inventory
-- @event inventory:server:combineItem
-- @tparam string item		The reward item name
-- @tparam string fromItem	The item that is used to be combine
-- @tparam string toItem	The item that is the result of the combine
RegisterNetEvent('inventory:server:combineItem', function(item, fromItem, toItem)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)

	-- Check that inputs are not nil
	-- Most commonly when abusing this exploit, this values are left as
	if not fromItem or not toItem then
		return
	end

	-- Check that they have the items
	fromItem = Player.Functions.GetItemByName(fromItem)
	toItem = Player.Functions.GetItemByName(toItem)
	if not fromItem or not toItem then
		return
	end

	-- Check the recipe is valid
	local recipe = QBCore.Shared.Items[toItem.name].combinable
	if not recipe or recipe.reward ~= item or not recipeContains(recipe, fromItem) then
		return
	end

	TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add')

	Player.Functions.AddItem(item, 1)
	Player.Functions.RemoveItem(fromItem.name, 1)
	Player.Functions.RemoveItem(toItem.name, 1)
end)

--- Server event when a player wants to craft an item from a crafting table
-- @tparam string craftType		The crafting table type ("crafting" or "attachmentcrafting")
-- @tparam string itemName		The item name being crafted
-- @tparam Items[] itemCosts	The items needed to craft the item
-- @tparam number amount		The amount of items crafted
-- @tparam number toSlot		The slot where the crafted item is put
-- @tparam number points		The points earned by crafting the item
-- @treturn void
local function HandleCraftEvent(craftType, itemName, itemCosts, amount, toSlot, points)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)

	amount = tonumber(amount)
	if not (IsValidNumber(amount) and amount > 0) then
		return
	end

	if not itemName or not itemCosts then
		return
	end

	for k, v in pairs(itemCosts) do
		Player.Functions.RemoveItem(k, v * amount)
	end

	-- Check if the player already has an item set in the targetted slot
	local slot = Player.Functions.GetItemBySlot(toSlot)
	if slot and slot.name:lower() == itemName:lower() then
		Player.Functions.AddItem(itemName, amount, toSlot)
	else
		Player.Functions.AddItem(itemName, amount)
	end
	
	Player.Functions.SetMetaData(craftType.."grep", Player.PlayerData.metadata[craftType.."grep"] + (points * amount))
	TriggerClientEvent("inventory:client:UpdatePlayerInventory", src, false)
end

--- Craft item event from a crafting table
-- @event inventory:server:CraftItems
-- @see HandleCraftEvent
RegisterNetEvent('inventory:server:CraftItems', function(itemName, itemCosts, amount, toSlot, points)
	HandleCraftEvent("crafting", itemName, itemCosts, amount, toSlot, points)
end)

--- Craft a weapon attachment from a crafting table
-- @event inventory:server:CraftAttachment
-- @see HandleCraftEvent
RegisterNetEvent('inventory:server:CraftAttachment', function(itemName, itemCosts, amount, toSlot, points)
	HandleCraftEvent("attachmentcrafting", itemName, itemCosts, amount, toSlot, points)
end)

--- A server event handler to let the client set an inventory closed state
-- @event inventory:server:SetIsOpenState
-- @tparam bool isOpen		Is the new inventory state open?
-- @tparam string name		The inventory type
-- @tparam number id		The inventory id
-- @todo Check that the inventory type is valid
-- @todo Check if the inventory is opened by the player
RegisterNetEvent('inventory:server:SetIsOpenState', function(IsOpen, name, id)
	if not IsOpen then
		if Inventories[name] and Inventories[name][id] then
			Inventories[name][id].isOpen = false
		end
	end
end)

--- A server event to save the specified inventory name
-- @event inventory:server:SaveInventory
-- @tparam string name			The inventory type (in the config)
-- @tparam number id			The inventory id
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

--- Use the item on the given slot
-- @event inventory:server:UseItemSlot
-- @tparam number slot		The slot to use the item
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

--- Use the item specified
-- @event inventory:server:UseItem
-- @tparam string name		The inventory type
-- @tparam string item		The item name
RegisterNetEvent('inventory:server:UseItem', function(name, item)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)

	if IsPlayerInventory(name) then
		local itemData = Player.Functions.GetItemBySlot(item.slot)
		if itemData then
			TriggerClientEvent("QBCore:Client:UseItem", src, itemData)
		end
	end
end)

--- Move an item from one inventory to another
-- @event inventory:server:SetInventoryData
-- @tparam string fromInventory			The inventory to move the item from (Config.InventoriesType)
-- @tparam string toInventory			The inventory to move the item to (Config.InventoriesType)
-- @tparam number fromSlot				The slot to move the item from
-- @tparam number toSlot				The slot to move the item to
-- @tparam[opt] number amount			The amount of the item to move (if not specified, move all)
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

	if not IsValidNumber(amount) then
		-- @todo Anticheat notification "Invalid amount format"
		return
	end

	-- To Inventory Type checker, if unknown set to drop
	if not IsValidInventoryType(toInventoryType) then
		toInventoryType = "drop"
	end
	-- From Inventory Type checker, if nil: throw an error
	if not IsValidInventoryType(fromInventoryType) then
		print("[QBCore] [Inventory Debug] Invalid inventory type from "..json.encode(fromInventoryType))
		TriggerClientEvent("inventory:client:closeInventory", src)
		return
	end

	if not IsInventoryDropAllowed(toInventoryType) then
		return
	end

	-- Is the inventories opened by another user
	if IsInventoryUsed(Inventories[fromInventoryType], fromInventoryType, fromInventoryId, src)
	or IsInventoryUsed(Inventories[toInventoryType], toInventoryType, toInventoryId, src) then
		TriggerClientEvent('QBCore:Notify', src, 'Not Accessible', 'error')
		TriggerClientEvent("inventory:client:closeInventory", src)
		return
	end

	-- Get the inventory methods
	local fromInventoryMethod = GetInventoryMethod(fromInventoryType, fromInventoryId, src)
	local toInventoryMethod = GetInventoryMethod(toInventoryType, toInventoryId, src)
	if not toInventoryMethod or not fromInventoryMethod then
		-- @todo Anticheat notification "Invalid inventory"
		return
	end

	-- Get items at slots
	local fromItemData = fromInventoryMethod.Get(fromSlot)
	local toItemData = toInventoryMethod.Get(toSlot)

	-- Backup inventory items to restore them if an error occures
	local backupFromItemData = json.decode(json.encode(fromInventoryMethod.GetAll()))
	local backupToItemData = json.decode(json.encode(toInventoryMethod.GetAll()))

	-- Check if the incoming item is valid
	if not fromItemData then
		TriggerClientEvent("QBCore:Notify", src, "Item doesn't exist!", "error")
		TriggerClientEvent("inventory:client:closeInventory", src)
		return
	end

	-- Set item infos to generate
	local ItemType = QBCore.Shared.SplitStr(fromItemData.name, "_")[1]
	if ItemType == "weapon" and not fromItemData.info.serie then
		fromItemData.info.serie = tostring(QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(4))
	end

	-- Manage amount of items
	if fromItemData.unique then
		amount = 1
	end
	amount = tonumber(amount) or fromItemData.amount
	if amount > fromItemData.amount then
		TriggerClientEvent("inventory:client:closeInventory", src)
		return
	end

	local isMovingAllItem = amount == fromItemData.amount

	-- Retrieving error message
	local sendingError = false
	local function IsError(cond)
		if not cond then
			sendingError = true
		end
	end

	-- Target slot is used by an item
	if toItemData then
		-- Swap unique items
		if toItemData.unique or fromItemData.unique then
			if not IsInventoryDropAllowed(fromInventoryType) then
				TriggerClientEvent('QBCore:Notify', src, "You can't swap items with this inventory.", 'error')
				TriggerClientEvent("inventory:client:closeInventory", src)
				return
			end
			if not isMovingAllItem then
				TriggerClientEvent("QBCore:Notify", src, "Item is unique!", "error")
				TriggerClientEvent("inventory:client:closeInventory", src)
				return
			end

			IsError(fromInventoryMethod.Delete(fromItemData.name, fromItemData.amount, fromSlot))
			IsError(toInventoryMethod.Delete(toItemData.name, toItemData.amount, toSlot))

			IsError(fromInventoryMethod.Add(toItemData.name, toItemData.amount, fromSlot, toItemData.info))
			IsError(toInventoryMethod.Add(fromItemData.name, fromItemData.amount, toSlot, fromItemData.info))

		-- Swap items
		elseif toItemData.name ~= fromItemData.name then
			if not IsInventoryDropAllowed(fromInventoryType) then
				TriggerClientEvent('QBCore:Notify', src, "You can't swap items with this inventory.", 'error')
				TriggerClientEvent("inventory:client:closeInventory", src)
				return
			end
			if not isMovingAllItem then
				TriggerClientEvent("QBCore:Notify", src, "You can't move item in this slot!", "error")
				TriggerClientEvent("inventory:client:closeInventory", src)
				return
			end

			IsError(fromInventoryMethod.Delete(fromItemData.name, fromItemData.amount, fromSlot))
			IsError(toInventoryMethod.Delete(toItemData.name, toItemData.amount, toSlot))

			IsError(fromInventoryMethod.Add(toItemData.name, toItemData.amount, fromSlot, toItemData.info))
			IsError(toInventoryMethod.Add(fromItemData.name, fromItemData.amount, toSlot, fromItemData.info))
		-- Add items
		elseif toItemData.name == fromItemData.name then
			IsError(fromInventoryMethod.Delete(fromItemData.name, amount, fromSlot))
			IsError(toInventoryMethod.Add(fromItemData.name, amount, toSlot))
		end
	-- 
	else
		IsError(fromInventoryMethod.Delete(fromItemData.name, amount, fromSlot))
		IsError(toInventoryMethod.Add(fromItemData.name, amount, toSlot, fromItemData.info))
	end

	-- If there is an error in adding the item
	-- or the total weight is too heavy for the target inventory type
	-- or the total weight is too heavy for the source inventory type (when the drop is enabled in it)
	if sendingError
	or QBCore.Player.GetTotalWeight(toInventoryMethod.GetAll()) > GetMaxWeightsForInventory(toInventoryType, Inventories[toInventoryType][toInventoryId])
	or (
		IsInventoryDropAllowed(fromInventoryType)
		and QBCore.Player.GetTotalWeight(fromInventoryMethod.GetAll()) > GetMaxWeightsForInventory(fromInventoryType, Inventories[fromInventoryType][fromInventoryId])
	) then
		-- Reset items informations
		fromInventoryMethod.Set(backupFromItemData)
		toInventoryMethod.Set(backupToItemData)

		-- Assume the error messages are handled by the inventory methods
		if not sendingError then
			TriggerClientEvent("QBCore:Notify", src, "The inventory is too full", "error")
		end

		-- Force close the inventory
		TriggerClientEvent("inventory:client:closeInventory", src)
		return
	end

	-- Charge the player when he moves an item in a shop
	if fromInventoryType == "shop" then
		if not ChargePlayer(src, fromInventoryId, fromItemData, amount) then
			fromInventoryMethod.Set(backupFromItemData)
			toInventoryMethod.Set(backupToItemData)
	
			TriggerClientEvent("inventory:client:closeInventory", src)
			return
		end
	end

	-- the player's radio is shut down
	if fromItemData.name:lower() == "radio" then
		TriggerClientEvent('Radio.Set', src, false)
	end
end)

--- Save the specified item in the stash
-- @event inventory:server:GiveItem
-- @tparam number target 	Target Player ID
-- @tparam string name 		Item name
-- @tparam number amount 	Given amount
-- @tparam number slot 		Slot where the item come from
-- @todo Adapt the event to the new system
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

	if not IsValidNumber(amount) or amount > item.amount then
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

--- Used to be the event to set the items in a trunk.
-- @event inventory:server:addTrunkItems
-- @deprecated
-- @see inventory:server:addItem
RegisterNetEvent('inventory:server:addTrunkItems', function(_, _)
	print("[QBCore] inventory:server:addTrunkItems is deprecated, use inventory:server:addItem instead")
end)

--- Save the specified item in the stash
-- @event qb-inventory:server:SaveStashItems
-- @deprecated
RegisterNetEvent('qb-inventory:server:SaveStashItems', function(id, items)
	print("[QBCore] [WARNING] qb-inventory:server:SaveStashItems is deprecated, use inventory:server:SaveInventory instead")
	Inventories.stash[id].items = items
	SaveDatabaseInventories("stash", id, Inventories.stash[id], "stash")
end)
QBCore.Functions.CreateCallback('qb-inventory:server:GetStashItems', function(_, cb, id)
	cb(FetchItemsFromDatabase('stashitems', 'items', 'stash', id))
end)
