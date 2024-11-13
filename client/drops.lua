HoldingDrop = false
local bagObject = nil
local heldDrop = nil
CurrentDrop = nil

-- Functions

function GetDrops()
    QBCore.Functions.TriggerCallback('qb-inventory:server:GetCurrentDrops', function(drops)
        if not drops then return end
        for k, v in pairs(drops) do
            local bag = NetworkGetEntityFromNetworkId(v.entityId)
            if DoesEntityExist(bag) then
                exports['qb-target']:AddTargetEntity(bag, {
                    options = {
                        {
                            icon = 'fas fa-backpack',
                            label = Lang:t('menu.o_bag'),
                            action = function()
                                TriggerServerEvent('qb-inventory:server:openDrop', k)
                                CurrentDrop = k
                            end,
                        },
                    },
                    distance = 2.5,
                })
            end
        end
    end)
end

-- Events

RegisterNetEvent('qb-inventory:client:removeDropTarget', function(dropId)
    while not NetworkDoesNetworkIdExist(dropId) do Wait(10) end
    local bag = NetworkGetEntityFromNetworkId(dropId)
    while not DoesEntityExist(bag) do Wait(10) end
    exports['qb-target']:RemoveTargetEntity(bag)
end)

RegisterNetEvent('qb-inventory:client:setupDropTarget', function(dropId)
    while not NetworkDoesNetworkIdExist(dropId) do Wait(10) end
    local bag = NetworkGetEntityFromNetworkId(dropId)
    while not DoesEntityExist(bag) do Wait(10) end
    local newDropId = 'drop-' .. dropId
    exports['qb-target']:AddTargetEntity(bag, {
        options = {
            {
                icon = 'fas fa-backpack',
                label = Lang:t('menu.o_bag'),
                action = function()
                    TriggerServerEvent('qb-inventory:server:openDrop', newDropId)
                    CurrentDrop = newDropId
                end,
            },
            {
                icon = 'fas fa-hand-pointer',
                label = 'Pick up bag',
                action = function()
                    if IsPedArmed(PlayerPedId(), 4) then
                        return QBCore.Functions.Notify("You can not be holding a Gun and a Bag!", "error", 5500)
                    end
                    if HoldingDrop then
                        return QBCore.Functions.Notify("Your already holding a bag, Go Drop it!", "error", 5500)
                    end
                    AttachEntityToEntity(
                        bag,
                        PlayerPedId(),
                        GetPedBoneIndex(PlayerPedId(), Config.ItemDropObjectBone),
                        Config.ItemDropObjectOffset[1].x,
                        Config.ItemDropObjectOffset[1].y,
                        Config.ItemDropObjectOffset[1].z,
                        Config.ItemDropObjectOffset[2].x,
                        Config.ItemDropObjectOffset[2].y,
                        Config.ItemDropObjectOffset[2].z,
                        true, true, false, true, 1, true
                    )
                    bagObject = bag
                    HoldingDrop = true
                    heldDrop = newDropId
                    exports['qb-core']:DrawText('Press [G] to drop the bag')
                end,
            }
        },
        distance = 2.5,
    })
end)

-- NUI Callbacks

RegisterNUICallback('DropItem', function(item, cb)
    QBCore.Functions.TriggerCallback('qb-inventory:server:createDrop', function(dropId)
        if dropId then
            while not NetworkDoesNetworkIdExist(dropId) do Wait(10) end
            local bag = NetworkGetEntityFromNetworkId(dropId)
            SetModelAsNoLongerNeeded(bag)
            PlaceObjectOnGroundProperly(bag)
            FreezeEntityPosition(bag, true)
            local newDropId = 'drop-' .. dropId
            cb(newDropId)
        else
            cb(false)
        end
    end, item)
end)

-- Thread

CreateThread(function()
    while true do
        if HoldingDrop then
            if IsControlJustPressed(0, 47) then
                DetachEntity(bagObject, true, true)
                local coords = GetEntityCoords(PlayerPedId())
                local forward = GetEntityForwardVector(PlayerPedId())
                local x, y, z = table.unpack(coords + forward * 0.57)
                SetEntityCoords(bagObject, x, y, z - 0.9, false, false, false, false)
                FreezeEntityPosition(bagObject, true)
                exports['qb-core']:HideText()
                TriggerServerEvent('qb-inventory:server:updateDrop', heldDrop, coords)
                HoldingDrop = false
                bagObject = nil
                heldDrop = nil
            end
        end
        Wait(0)
    end
end)
