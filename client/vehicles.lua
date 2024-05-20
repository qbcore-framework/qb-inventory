-- Functions

local function IsBackEngine(vehModel)
    return BackEngineVehicles[vehModel]
end

local function OpenTrunk(vehicle)
    LoadAnimDict('amb@prop_human_bum_bin@idle_b')
    TaskPlayAnim(PlayerPedId(), 'amb@prop_human_bum_bin@idle_b', 'idle_d', 4.0, 4.0, -1, 50, 0, false, false, false)
    if IsBackEngine(GetEntityModel(vehicle)) then
        SetVehicleDoorOpen(vehicle, 4, false, false)
    else
        SetVehicleDoorOpen(vehicle, 5, false, false)
    end
end

function CloseTrunk()
    local vehicle, distance = QBCore.Functions.GetClosestVehicle()
    if vehicle == 0 or distance > 5 then return end
    LoadAnimDict('amb@prop_human_bum_bin@idle_b')
    TaskPlayAnim(PlayerPedId(), 'amb@prop_human_bum_bin@idle_b', 'exit', 4.0, 4.0, -1, 50, 0, false, false, false)
    if IsBackEngine(GetEntityModel(vehicle)) then
        SetVehicleDoorShut(vehicle, 4, false)
    else
        SetVehicleDoorShut(vehicle, 5, false)
    end
end

-- Callbacks

QBCore.Functions.CreateClientCallback('qb-inventory:client:vehicleCheck', function(cb)
    local ped = PlayerPedId()

    -- Glovebox
    local inVehicle = GetVehiclePedIsIn(ped, false)
    if inVehicle ~= 0 then
        local plate = GetVehicleNumberPlateText(inVehicle)
        local class = GetVehicleClass(inVehicle)
        local inventory = 'glovebox-' .. plate
        cb(inventory, class)
        return
    end

    -- Trunk
    local vehicle, distance = QBCore.Functions.GetClosestVehicle()
    if vehicle ~= 0 and distance < 5 then
        local pos = GetEntityCoords(ped)
        local dimensionMin, dimensionMax = GetModelDimensions(GetEntityModel(vehicle))
        local trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, (dimensionMin.y), 0.0)
        if BackEngineVehicles[GetEntityModel(vehicle)] then trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, (dimensionMax.y), 0.0) end
        if #(pos - trunkpos) < 1.5 then
            if GetVehicleDoorLockStatus(vehicle) < 2 then
                OpenTrunk(vehicle)
                local class = GetVehicleClass(vehicle)
                local plate = GetVehicleNumberPlateText(vehicle)
                local inventory = 'trunk-' .. plate
                cb(inventory, class)
            else
                QBCore.Functions.Notify(Lang:t('notify.vlocked'), 'error')
                return
            end
        end
    end
    cb(nil)
end)
