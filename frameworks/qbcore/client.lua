if GetResourceState("qb-core") ~= "started" then return end

local QBCore = exports["qb-core"]:GetCoreObject()

function SpawnVehicle(vehicle, coords, heading, plate, props)
    QBCore.Functions.SpawnVehicle(vehicle, function(spawnedVehicle)
        TriggerServerEvent("modular-garages:server:vehicleSpawned", plate, NetworkGetNetworkIdFromEntity(spawnedVehicle))

        SetEntityHeading(spawnedVehicle, heading)
        SetVehicleNumberPlateText(spawnedVehicle, plate)
        props.plate = props.plate or plate
        SetVehicleProps(spawnedVehicle, props)

        if Config.PlaceIntoVehicle then
            TaskWarpPedIntoVehicle(PlayerPedId(), spawnedVehicle, -1)
        end
    end, coords, true)
end

function SetVehicleProps(vehicle, props)
    QBCore.Functions.SetVehicleProperties(vehicle, props)
end

function GetVehicleProps(vehicle)
    return QBCore.Functions.GetVehicleProperties(vehicle)
end

function Notify(message, type)
    QBCore.Functions.Notify(message, type)
end
