QBCore = exports['qb-core']:GetCoreObject()
Inventories = {}
Drops = {}
RegisteredShops = {}

CreateThread(function()
    MySQL.query('SELECT * FROM inventories', {}, function(result)
        if result and #result > 0 then
            for i = 1, #result do
                local inventory = result[i]
                local cacheKey = inventory.identifier
                Inventories[cacheKey] = {
                    items = json.decode(inventory.items) or {},
                    isOpen = false
                }
            end
            print(#result .. ' inventories successfully loaded')
        end
    end)
end)

CreateThread(function()
    while true do
        for k, v in pairs(Drops) do
            if v and (v.createdTime + (Config.CleanupDropTime * 60) < os.time()) and not Drops[k].isOpen then
                local entity = NetworkGetEntityFromNetworkId(v.entityId)
                if DoesEntityExist(entity) then DeleteEntity(entity) end
                Drops[k] = nil
            end
        end
        Wait(Config.CleanupDropInterval * 60000)
    end
end)

-- Handlers

AddEventHandler('playerDropped', function()
    for _, inv in pairs(Inventories) do
        if inv.isOpen == source then
            inv.isOpen = false
        end
    end
end)

AddEventHandler('txAdmin:events:serverShuttingDown', function()
    for inventory, data in pairs(Inventories) do
        if data.isOpen then
            MySQL.prepare('INSERT INTO inventories (identifier, items) VALUES (?, ?) ON DUPLICATE KEY UPDATE items = ?', { inventory, json.encode(data.items), json.encode(data.items) })
        end
    end
end)

RegisterNetEvent('QBCore:Server:UpdateObject', function()
    if source ~= '' then return end
    QBCore = exports['qb-core']:GetCoreObject()
end)

AddEventHandler('QBCore:Server:PlayerLoaded', function(Player)
    QBCore.Functions.AddPlayerMethod(Player.PlayerData.source, 'AddItem', function(item, amount, slot, info, reason)
        return AddItem(Player.PlayerData.source, item, amount, slot, info, reason)
    end)

    QBCore.Functions.AddPlayerMethod(Player.PlayerData.source, 'RemoveItem', function(item, amount, slot, reason)
        return RemoveItem(Player.PlayerData.source, item, amount, slot, reason)
    end)

    QBCore.Functions.AddPlayerMethod(Player.PlayerData.source, 'GetItemBySlot', function(slot)
        return GetItemBySlot(Player.PlayerData.source, slot)
    end)

    QBCore.Functions.AddPlayerMethod(Player.PlayerData.source, 'GetItemByName', function(item)
        return GetItemByName(Player.PlayerData.source, item)
    end)

    QBCore.Functions.AddPlayerMethod(Player.PlayerData.source, 'GetItemsByName', function(item)
        return GetItemsByName(Player.PlayerData.source, item)
    end)

    QBCore.Functions.AddPlayerMethod(Player.PlayerData.source, 'ClearInventory', function(filterItems)
        ClearInventory(Player.PlayerData.source, filterItems)
    end)

    QBCore.Functions.AddPlayerMethod(Player.PlayerData.source, 'SetInventory', function(items)
        SetInventory(Player.PlayerData.source, items)
    end)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    local Players = QBCore.Functions.GetQBPlayers()
    for k in pairs(Players) do
        QBCore.Functions.AddPlayerMethod(k, 'AddItem', function(item, amount, slot, info)
            return AddItem(k, item, amount, slot, info)
        end)

        QBCore.Functions.AddPlayerMethod(k, 'RemoveItem', function(item, amount, slot)
            return RemoveItem(k, item, amount, slot)
        end)

        QBCore.Functions.AddPlayerMethod(k, 'GetItemBySlot', function(slot)
            return GetItemBySlot(k, slot)
        end)

        QBCore.Functions.AddPlayerMethod(k, 'GetItemByName', function(item)
            return GetItemByName(k, item)
        end)

        QBCore.Functions.AddPlayerMethod(k, 'GetItemsByName', function(item)
            return GetItemsByName(k, item)
        end)

        QBCore.Functions.AddPlayerMethod(k, 'ClearInventory', function(filterItems)
            ClearInventory(k, filterItems)
        end)

        QBCore.Functions.AddPlayerMethod(k, 'SetInventory', function(items)
            SetInventory(k, items)
        end)

        Player(k).state.inv_busy = false
    end
end)

-- Functions

function checkWeapon(source, item)
    local currentWeapon = type(item) == 'table' and item.name or item
    local ped = GetPlayerPed(source)
    local weapon = GetSelectedPedWeapon(ped)
    local weaponInfo = QBCore.Shared.Weapons[weapon]
    if weaponInfo and weaponInfo.name == currentWeapon then
        RemoveWeaponFromPed(ped, weapon)
        TriggerClientEvent('qb-weapons:client:UseWeapon', source, { name = currentWeapon }, false)
    end
end

-- Events

RegisterNetEvent('qb-inventory:server:openVending', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    -- Validate coords exist and are reasonable
    if not data or not data.coords then return end
    
    local playerPed = GetPlayerPed(src)
    local playerCoords = GetEntityCoords(playerPed)
    local vendingCoords = vector3(data.coords.x, data.coords.y, data.coords.z)
    
    -- Validate player is near the vending machine
    local distance = #(playerCoords - vendingCoords)
    if distance > 5.0 then return end
    
    CreateShop({
        name = 'vending',
        label = 'Vending Machine',
        coords = data.coords,
        slots = #Config.VendingItems,
        items = Config.VendingItems
    })
    OpenShop(src, 'vending')
end)

RegisterNetEvent('qb-inventory:server:closeInventory', function(inventory)
    local src = source
    local QBPlayer = QBCore.Functions.GetPlayer(src)
    if not QBPlayer then return end
    
    if not inventory then return end
    
    Player(source).state.inv_busy = false
    if inventory:find('shop%-') then return end
    if inventory:find('otherplayer%-') then
        local targetId = tonumber(inventory:match('otherplayer%-(.+)'))
        if not targetId then return end
        
        -- Validate the player actually has access to this inventory
        local targetPlayer = QBCore.Functions.GetPlayer(targetId)
        if not targetPlayer then return end
        
        -- Check distance
        local playerPed = GetPlayerPed(src)
        local targetPed = GetPlayerPed(targetId)
        local playerCoords = GetEntityCoords(playerPed)
        local targetCoords = GetEntityCoords(targetPed)
        local distance = #(playerCoords - targetCoords)
        
        if distance > 5.0 then return end
        
        Player(targetId).state.inv_busy = false
        return
    end
    if Drops[inventory] then
        -- Validate player has access to this drop
        local drop = Drops[inventory]
        local playerPed = GetPlayerPed(src)
        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(playerCoords - drop.coords)
        
        if distance > 2.5 then return end
        
        Drops[inventory].isOpen = false
        if #Drops[inventory].items == 0 and not Drops[inventory].isOpen then -- if no listeed items in the drop on close
            TriggerClientEvent('qb-inventory:client:removeDropTarget', -1, Drops[inventory].entityId)
            Wait(500)
            local entity = NetworkGetEntityFromNetworkId(Drops[inventory].entityId)
            if DoesEntityExist(entity) then DeleteEntity(entity) end
            Drops[inventory] = nil
        end
        return
    end
    if not Inventories[inventory] then return end
    
    -- Validate the inventory is open by this player
    if Inventories[inventory].isOpen ~= src then return end
    
    Inventories[inventory].isOpen = false
    MySQL.prepare('INSERT INTO inventories (identifier, items) VALUES (?, ?) ON DUPLICATE KEY UPDATE items = ?', { inventory, json.encode(Inventories[inventory].items), json.encode(Inventories[inventory].items) })
end)

RegisterNetEvent('qb-inventory:server:useItem', function(item)
    local src = source
    if not item or not item.slot then return end
    
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local itemData = GetItemBySlot(src, item.slot)
    if not itemData then return end
    
    -- Validate the item matches what client sent (prevent slot manipulation)
    if item.name and item.name:lower() ~= itemData.name:lower() then return end
    
    local itemInfo = QBCore.Shared.Items[itemData.name]
    if not itemInfo then return end
    
    if itemData.type == 'weapon' then
        TriggerClientEvent('qb-weapons:client:UseWeapon', src, itemData, itemData.info.quality and itemData.info.quality > 0)
        TriggerClientEvent('qb-inventory:client:ItemBox', src, itemInfo, 'use')
    elseif itemData.name == 'id_card' then
        UseItem(itemData.name, src, itemData)
        TriggerClientEvent('qb-inventory:client:ItemBox', source, itemInfo, 'use')
        local playerPed = GetPlayerPed(src)
        local playerCoords = GetEntityCoords(playerPed)
        local players = QBCore.Functions.GetPlayers()
        
        -- Use server-side itemData.info instead of client-provided item.info
        if itemData.info then
            local gender = itemData.info.gender == 0 and 'Male' or 'Female'
            for _, v in pairs(players) do
                local targetPed = GetPlayerPed(v)
                local dist = #(playerCoords - GetEntityCoords(targetPed))
                if dist < 3.0 then
                    TriggerClientEvent('chat:addMessage', v, {
                        template = '<div class="chat-message advert" style="background: linear-gradient(to right, rgba(5, 5, 5, 0.6), #74807c); display: flex;"><div style="margin-right: 10px;"><i class="far fa-id-card" style="height: 100%;"></i><strong> {0}</strong><br> <strong>Civ ID:</strong> {1} <br><strong>First Name:</strong> {2} <br><strong>Last Name:</strong> {3} <br><strong>Birthdate:</strong> {4} <br><strong>Gender:</strong> {5} <br><strong>Nationality:</strong> {6}</div></div>',
                        args = {
                            'ID Card',
                            itemData.info.citizenid or '',
                            itemData.info.firstname or '',
                            itemData.info.lastname or '',
                            itemData.info.birthdate or '',
                            gender,
                            itemData.info.nationality or ''
                        }
                    })
                end
            end
        end
    elseif itemData.name == 'driver_license' then
        UseItem(itemData.name, src, itemData)
        TriggerClientEvent('qb-inventory:client:ItemBox', src, itemInfo, 'use')
        local playerPed = GetPlayerPed(src)
        local playerCoords = GetEntityCoords(playerPed)
        local players = QBCore.Functions.GetPlayers()
        
        -- Use server-side itemData.info instead of client-provided item.info
        if itemData.info then
            for _, v in pairs(players) do
                local targetPed = GetPlayerPed(v)
                local dist = #(playerCoords - GetEntityCoords(targetPed))
                if dist < 3.0 then
                    TriggerClientEvent('chat:addMessage', v, {
                        template = '<div class="chat-message advert" style="background: linear-gradient(to right, rgba(5, 5, 5, 0.6), #657175); display: flex;"><div style="margin-right: 10px;"><i class="far fa-id-card" style="height: 100%;"></i><strong> {0}</strong><br> <strong>First Name:</strong> {1} <br><strong>Last Name:</strong> {2} <br><strong>Birth Date:</strong> {3} <br><strong>Licenses:</strong> {4}</div></div>',
                        args = {
                            'Drivers License',
                            itemData.info.firstname or '',
                            itemData.info.lastname or '',
                            itemData.info.birthdate or '',
                            itemData.info.type or ''
                        }
                    }
                    )
                end
            end
        end
    else
        UseItem(itemData.name, src, itemData)
        TriggerClientEvent('qb-inventory:client:ItemBox', src, itemInfo, 'use')
    end
end)

RegisterNetEvent('qb-inventory:server:openDrop', function(dropId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    -- Validate dropId format
    if not dropId or type(dropId) ~= 'string' then return end
    if dropId:find('drop%-') ~= 1 then return end
    
    local playerPed = GetPlayerPed(src)
    local playerCoords = GetEntityCoords(playerPed)
    local drop = Drops[dropId]
    if not drop then return end
    if drop.isOpen then return end
    local distance = #(playerCoords - drop.coords)
    if distance > 2.5 then return end
    local formattedInventory = {
        name = dropId,
        label = dropId,
        maxweight = drop.maxweight,
        slots = drop.slots,
        inventory = drop.items
    }
    drop.isOpen = true
    TriggerClientEvent('qb-inventory:client:openInventory', source, Player.PlayerData.items, formattedInventory)
end)

RegisterNetEvent('qb-inventory:server:updateDrop', function(dropId, coords)
    local src = source
    local drop = Drops[dropId]
    if not drop then return end
    
    -- Validate that the player is near the drop (within reasonable distance)
    local playerPed = GetPlayerPed(src)
    local playerCoords = GetEntityCoords(playerPed)
    local distance = #(playerCoords - drop.coords)
    
    -- Allow update if player is within 5 meters of the drop (reasonable for dropping a held bag)
    if distance > 5.0 then
        return
    end
    
    -- Validate that the new coordinates are reasonable (not too far from player)
    local newDistance = #(playerCoords - coords)
    if newDistance > 2.0 then
        return
    end
    
    Drops[dropId].coords = coords
end)

RegisterNetEvent('qb-inventory:server:snowball', function(action)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    -- Validate action is valid
    if action ~= 'add' and action ~= 'remove' then return end
    
    -- Rate limiting: Only allow one action per second
    if not Player.PlayerData.metadata.lastSnowballAction then
        Player.PlayerData.metadata.lastSnowballAction = 0
    end
    
    local currentTime = os.time()
    if currentTime - Player.PlayerData.metadata.lastSnowballAction < 1 then
        return
    end
    
    Player.PlayerData.metadata.lastSnowballAction = currentTime
    
    if action == 'add' then
        -- Validate player doesn't already have snowball before adding
        if not HasItem(src, 'weapon_snowball', 1) then
            AddItem(src, 'weapon_snowball', 1, false, false, 'qb-inventory:server:snowball')
        end
    elseif action == 'remove' then
        -- Validate player has snowball before removing
        if HasItem(src, 'weapon_snowball', 1) then
            RemoveItem(src, 'weapon_snowball', 1, false, 'qb-inventory:server:snowball')
        end
    end
end)

-- Callbacks

QBCore.Functions.CreateCallback('qb-inventory:server:GetCurrentDrops', function(_, cb)
    cb(Drops)
end)

QBCore.Functions.CreateCallback('qb-inventory:server:createDrop', function(source, cb, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then
        cb(false)
        return
    end
    
    -- Validate item data
    if not item or not item.name or not item.amount or not item.fromSlot then
        cb(false)
        return
    end
    
    -- Validate item exists in shared items
    local itemInfo = QBCore.Shared.Items[item.name:lower()]
    if not itemInfo then
        cb(false)
        return
    end
    
    -- Validate amount is positive and reasonable
    local amount = tonumber(item.amount)
    if not amount or amount <= 0 or amount > 10000 then
        cb(false)
        return
    end
    
    -- Validate slot is valid
    local slot = tonumber(item.fromSlot)
    if not slot or slot < 1 or slot > Config.MaxSlots then
        cb(false)
        return
    end
    
    -- Verify player actually has this item in this slot
    local playerItem = GetItemBySlot(src, slot)
    if not playerItem or playerItem.name:lower() ~= item.name:lower() then
        cb(false)
        return
    end
    
    -- Verify player has enough of this item
    if playerItem.amount < amount then
        cb(false)
        return
    end
    
    local playerPed = GetPlayerPed(src)
    local playerCoords = GetEntityCoords(playerPed)
    
    -- Create the item object for the drop using server-validated data
    local dropItem = {
        name = itemInfo.name,
        amount = amount,
        info = playerItem.info or {},
        type = itemInfo.type,
        label = itemInfo.label,
        description = itemInfo.description or '',
        weight = itemInfo.weight,
        unique = itemInfo.unique,
        useable = itemInfo.useable,
        image = itemInfo.image,
        slot = 1 -- Will be set properly when added to drop
    }
    
    if RemoveItem(src, item.name, amount, slot, 'dropped item') then
        if dropItem.type == 'weapon' then checkWeapon(src, dropItem) end
        TaskPlayAnim(playerPed, 'pickup_object', 'pickup_low', 8.0, -8.0, 2000, 0, 0, false, false, false)
        local bag = CreateObjectNoOffset(Config.ItemDropObject, playerCoords.x + 0.5, playerCoords.y + 0.5, playerCoords.z, true, true, false)
        local dropId = NetworkGetNetworkIdFromEntity(bag)
        local newDropId = 'drop-' .. dropId
        local itemsTable = setmetatable({ dropItem }, {
            __len = function(t)
                local length = 0
                for _ in pairs(t) do length += 1 end
                return length
            end
        })
        if not Drops[newDropId] then
            Drops[newDropId] = {
                name = newDropId,
                label = 'Drop',
                items = itemsTable,
                entityId = dropId,
                createdTime = os.time(),
                coords = playerCoords,
                maxweight = Config.DropSize.maxweight,
                slots = Config.DropSize.slots,
                isOpen = true
            }
            TriggerClientEvent('qb-inventory:client:setupDropTarget', -1, dropId)
        else
            table.insert(Drops[newDropId].items, dropItem)
        end
        cb(dropId)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('qb-inventory:server:attemptPurchase', function(source, cb, data)
    local itemInfo = data.item
    local amount = data.amount
    local shop = string.gsub(data.shop, 'shop%-', '')
    local Player = QBCore.Functions.GetPlayer(source)

    if amount < 0 then cb(false) return end

    if not Player then
        cb(false)
        return
    end

    local shopInfo = RegisteredShops[shop]
    if not shopInfo then
        cb(false)
        return
    end

    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)
    if shopInfo.coords then
        local shopCoords = vector3(shopInfo.coords.x, shopInfo.coords.y, shopInfo.coords.z)
        if #(playerCoords - shopCoords) > 10 then
            cb(false)
            return
        end
    end

    if shopInfo.items[itemInfo.slot].name ~= itemInfo.name then -- Check if item name passed is the same as the item in that slot
        cb(false)
        return
    end

    if amount > shopInfo.items[itemInfo.slot].amount or shopInfo.items[itemInfo.slot].amount <= 0 then
        TriggerClientEvent('QBCore:Notify', source, 'Cannot purchase larger quantity than currently in stock', 'error')
        cb(false)
        return
    end

    if not CanAddItem(source, itemInfo.name, amount) then
        TriggerClientEvent('QBCore:Notify', source, 'Cannot hold item', 'error')
        cb(false)
        return
    end

    local price = shopInfo.items[itemInfo.slot].price * amount
    if Player.PlayerData.money.cash >= price then
        Player.Functions.RemoveMoney('cash', price, 'shop-purchase')
        AddItem(source, itemInfo.name, amount, nil, itemInfo.info, 'shop-purchase')
        shopInfo.items[itemInfo.slot].amount -= amount
        TriggerEvent('qb-shops:server:UpdateShopItems', shop, itemInfo, amount)
        cb(true)
    else
        TriggerClientEvent('QBCore:Notify', source, 'You do not have enough money', 'error')
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('qb-inventory:server:giveItem', function(source, cb, target, item, amount, slot, info)
    local player = QBCore.Functions.GetPlayer(source)
    if not player or player.PlayerData.metadata['isdead'] or player.PlayerData.metadata['inlaststand'] or player.PlayerData.metadata['ishandcuffed'] then
        cb(false)
        return
    end
    local playerPed = GetPlayerPed(source)

    local Target = QBCore.Functions.GetPlayer(target)
    if not Target or Target.PlayerData.metadata['isdead'] or Target.PlayerData.metadata['inlaststand'] or Target.PlayerData.metadata['ishandcuffed'] then
        cb(false)
        return
    end
    local targetPed = GetPlayerPed(target)

    local pCoords = GetEntityCoords(playerPed)
    local tCoords = GetEntityCoords(targetPed)
    if #(pCoords - tCoords) > 5 then
        cb(false)
        return
    end

    local itemInfo = QBCore.Shared.Items[item:lower()]
    if not itemInfo then
        cb(false)
        return
    end

    local hasItem = HasItem(source, item)
    if not hasItem then
        cb(false)
        return
    end

    local itemAmount = GetItemByName(source, item).amount
    if itemAmount <= 0 then
        cb(false)
        return
    end

    local giveAmount = tonumber(amount)
    if giveAmount > itemAmount then
        cb(false)
        return
    end

    -- Get the actual item from player's inventory to use server-side info
    local playerItem = slot and GetItemBySlot(source, slot) or GetItemByName(source, item)
    if not playerItem or playerItem.name:lower() ~= item:lower() then
        cb(false)
        return
    end
    
    -- Verify the amount matches
    if playerItem.amount < giveAmount then
        cb(false)
        return
    end
    
    local removeItem = RemoveItem(source, item, giveAmount, slot, 'Item given to ID #' .. target)
    if not removeItem then
        cb(false)
        return
    end

    -- Use server-side item info instead of client-provided info
    local giveItem = AddItem(target, item, giveAmount, false, playerItem.info, 'Item given from ID #' .. source)
    if not giveItem then
        cb(false)
        return
    end

    if itemInfo.type == 'weapon' then checkWeapon(source, item) end
    TriggerClientEvent('qb-inventory:client:giveAnim', source)
    TriggerClientEvent('qb-inventory:client:ItemBox', source, itemInfo, 'remove', giveAmount)
    TriggerClientEvent('qb-inventory:client:giveAnim', target)
    TriggerClientEvent('qb-inventory:client:ItemBox', target, itemInfo, 'add', giveAmount)
    if Player(target).state.inv_busy then TriggerClientEvent('qb-inventory:client:updateInventory', target) end
    cb(true)
end)

-- Item move logic

local function getItem(inventoryId, src, slot)
    local items = {}
    if inventoryId == 'player' then
        local Player = QBCore.Functions.GetPlayer(src)
        if Player and Player.PlayerData.items then
            items = Player.PlayerData.items
        end
    elseif inventoryId:find('otherplayer-') then
        local targetId = tonumber(inventoryId:match('otherplayer%-(.+)'))
        local targetPlayer = QBCore.Functions.GetPlayer(targetId)
        if targetPlayer and targetPlayer.PlayerData.items then
            items = targetPlayer.PlayerData.items
        end
    elseif inventoryId:find('drop-') == 1 then
        if Drops[inventoryId] and Drops[inventoryId]['items'] then
            items = Drops[inventoryId]['items']
        end
    else
        if Inventories[inventoryId] and Inventories[inventoryId]['items'] then
            items = Inventories[inventoryId]['items']
        end
    end

    for _, item in pairs(items) do
        if item.slot == slot then
            return item
        end
    end
    return nil
end

local function getIdentifier(inventoryId, src)
    if inventoryId == 'player' then
        return src
    elseif inventoryId:find('otherplayer-') then
        return tonumber(inventoryId:match('otherplayer%-(.+)'))
    else
        return inventoryId
    end
end

-- Validates if a player can access a specific inventory
local function canAccessInventory(src, inventoryId)
    if inventoryId == 'player' then
        return true -- Player always has access to their own inventory
    elseif inventoryId:find('otherplayer-') then
        local targetId = tonumber(inventoryId:match('otherplayer%-(.+)'))
        if not targetId then return false end
        
        local targetPlayer = QBCore.Functions.GetPlayer(targetId)
        if not targetPlayer then return false end
        
        -- Check if target player's inventory is marked as busy (being accessed)
        if not Player(targetId).state.inv_busy then return false end
        
        -- Check distance between players
        local playerPed = GetPlayerPed(src)
        local targetPed = GetPlayerPed(targetId)
        local playerCoords = GetEntityCoords(playerPed)
        local targetCoords = GetEntityCoords(targetPed)
        local distance = #(playerCoords - targetCoords)
        
        if distance > 5.0 then return false end
        
        return true
    elseif inventoryId:find('drop-') == 1 then
        local drop = Drops[inventoryId]
        if not drop then return false end
        
        -- Check if drop is open (being accessed)
        if not drop.isOpen then return false end
        
        -- Check distance to drop
        local playerPed = GetPlayerPed(src)
        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(playerCoords - drop.coords)
        
        if distance > 2.5 then return false end
        
        return true
    else
        -- Stash or other inventory
        local inventory = Inventories[inventoryId]
        if not inventory then return false end
        
        -- Check if inventory is open by this player
        if inventory.isOpen ~= src then return false end
        
        return true
    end
end

RegisterNetEvent('qb-inventory:server:SetInventoryData', function(fromInventory, toInventory, fromSlot, toSlot, fromAmount, toAmount)
    if toInventory:find('shop%-') then return end
    if not fromInventory or not toInventory or not fromSlot or not toSlot or not fromAmount or not toAmount or fromAmount < 0 or toAmount < 0 then return end
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    -- Validate access to both inventories
    if not canAccessInventory(src, fromInventory) then
        return
    end
    
    if not canAccessInventory(src, toInventory) then
        return
    end

    fromSlot, toSlot, fromAmount, toAmount = tonumber(fromSlot), tonumber(toSlot), tonumber(fromAmount), tonumber(toAmount)

    local fromItem = getItem(fromInventory, src, fromSlot)
    local toItem = getItem(toInventory, src, toSlot)

    if fromItem then
        if not toItem and toAmount > fromItem.amount then return end
        if fromInventory == 'player' and toInventory ~= 'player' then checkWeapon(src, fromItem) end

        local fromId = getIdentifier(fromInventory, src)
        local toId = getIdentifier(toInventory, src)

        if toItem and fromItem.name == toItem.name then
            if RemoveItem(fromId, fromItem.name, toAmount, fromSlot, 'stacked item') then
                AddItem(toId, toItem.name, toAmount, toSlot, toItem.info, 'stacked item')
            end
        elseif not toItem and toAmount < fromAmount then
            if RemoveItem(fromId, fromItem.name, toAmount, fromSlot, 'split item') then
                AddItem(toId, fromItem.name, toAmount, toSlot, fromItem.info, 'split item')
            end
        else
            if toItem then
                local fromItemAmount = fromItem.amount
                local toItemAmount = toItem.amount

                if RemoveItem(fromId, fromItem.name, fromItemAmount, fromSlot, 'swapped item') and RemoveItem(toId, toItem.name, toItemAmount, toSlot, 'swapped item') then
                    AddItem(toId, fromItem.name, fromItemAmount, toSlot, fromItem.info, 'swapped item')
                    AddItem(fromId, toItem.name, toItemAmount, fromSlot, toItem.info, 'swapped item')
                end
            else
                if RemoveItem(fromId, fromItem.name, toAmount, fromSlot, 'moved item') then
                    AddItem(toId, fromItem.name, toAmount, toSlot, fromItem.info, 'moved item')
                end
            end
        end
    end
end)
