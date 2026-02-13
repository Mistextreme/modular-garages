if GetResourceState("es_extended") ~= "started" then return end

local ESX = exports["es_extended"]:getSharedObject()
local OutVehicles = {}

function FetchUserVehicles(source, garage)
    local vehicles = {}

    local query = "SELECT * FROM owned_vehicles WHERE owner = @owner AND stored = 1"

    if Config.ParkingType == "specific" then
        query = "SELECT * FROM owned_vehicles WHERE owner = @owner AND parking = @garage AND stored = 1"
    end

    local res = MySQL.query.await(query, {
        ["@owner"] = ESX.GetPlayerFromId(source).identifier,
        ["@garage"] = garage,
    })

    for _, v in ipairs(res) do
        vehicles[#vehicles + 1] = ConvertVehicleTable(v)
    end

    return vehicles
end

function FetchImpoundedUserVehicles(source, impound)
    local vehicles = {}

    local res = MySQL.query.await(
        "SELECT * FROM owned_vehicles WHERE owner = @owner AND (stored = 0 or pound IS NOT NULL)", {
            ["@owner"] = ESX.GetPlayerFromId(source).identifier,
        })

    for _, v in ipairs(res) do
        vehicles[#vehicles + 1] = ConvertVehicleTable(v)
    end

    return vehicles
end

function SpawnVehicle(src, plate, userVehicle, garage, impound)
    if
        OutVehicles[plate] and
        NetworkGetEntityFromNetworkId(OutVehicles[plate]) ~= 0 and
        DoesEntityExist(NetworkGetEntityFromNetworkId(OutVehicles[plate]))
    then
        return Notify(src, T("already_out"), "error")
    end

    TriggerClientEvent("modular-garages:client:spawnVehicle", src, userVehicle, garage, impound)
    MySQL.update("UPDATE owned_vehicles SET stored = ?, parking = ?, pound = ? WHERE plate = ?", {
        Config.AutoImpound and 0 or 1,
        Config.AutoImpound and nil or garage,
        Config.AutoImpound and next(Config.Impounds) or nil,
        plate
    })
end

function ParkVehicle(source, vehicleEntity, plate, garage, props)
    if not DoesEntityExist(vehicleEntity) then return end
    DeleteEntity(vehicleEntity)
    MySQL.update("UPDATE owned_vehicles SET stored = ?, parking = ?, vehicle = ? WHERE plate = ?", {
        1,
        garage,
        json.encode(props, { indent = true }),
        plate
    })

    OutVehicles[plate] = nil
end

function FavoriteVehicle(source, plate, isFavorite, garage)
    MySQL.update.await("UPDATE owned_vehicles SET isFavorite = ? WHERE plate = ?", {
        isFavorite and 1 or 0,
        plate
    })
    TriggerClientEvent("modular-garages:client:receiveVehicles", source, FetchUserVehicles(source, garage))
end

--- Notify
---@param source any Player source
---@param msg string Message to show
---@param type "error" | "success" | "info"
function Notify(source, msg, type)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.showNotification(source, msg)
end

--- Gets all of the vehicles owned by the player
---@param source any Player source
---@param plate string Vehicle plate
function GetUserOwnedVehicle(source, plate)
    local query = "SELECT * FROM owned_vehicles WHERE owner = @owner AND plate = @plate"
    local res = MySQL.query.await(query, {
        ["@owner"] = ESX.GetPlayerFromId(source).identifier,
        ["@plate"] = plate,
    })

    if not next(res) then return nil end

    return ConvertVehicleTable(res[1])
end

function ConvertVehicleTable(vehicle)
    local vehicleData = json.decode(vehicle.vehicle)

    return {
        plate = vehicle.plate,
        model = vehicleData.model,
        owner = vehicle.owner,
        state = vehicle.stored == 1 and "in" or "out",
        garage = vehicle.parking,
        props = vehicleData,
        fuel = vehicleData and vehicleData.fuelLevel or 100,
        health = vehicleData and vehicleData.bodyHealth or 1000,
        isFavorite = vehicle.isFavorite,
    }
end

function ImpoundVehicle(plate, impound)
    if not plate then return end

    impound = impound or next(Config.Impounds)

    MySQL.update("UPDATE owned_vehicles SET stored = ?, parking = ?, pound = ? WHERE plate = ?", {
        1,
        nil,
        impound,
        plate
    })
end

exports("ImpoundVehicle", ImpoundVehicle)

RegisterNetEvent("modular-garages:server:vehicleSpawned", function(plate, vehicleEntity)
    if not plate or not vehicleEntity then return end

    OutVehicles[plate] = vehicleEntity
end)
