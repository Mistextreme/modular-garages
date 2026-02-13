RegisterNetEvent("modular-garages:server:fetchVehicles", function(garage)
    local src = source
    local vehicles = FetchUserVehicles(src, garage)
    TriggerClientEvent("modular-garages:client:receiveVehicles", src, vehicles)
end)

RegisterNetEvent("modular-garages:server:fetchImpoundedVehicles", function(impound)
    local src = source
    local vehicles = FetchImpoundedUserVehicles(src, impound)
    TriggerClientEvent("modular-garages:client:receiveVehicles", src, vehicles)
end)

RegisterNetEvent("modular-garages:server:spawnVehicle", function(plate, garage, impound)
    local src = source
    local userVehicle = GetUserOwnedVehicle(src, plate)

    if not userVehicle then
        return Notify(src, T("vehicle_not_owned"), "error")
    end

    SpawnVehicle(src, plate, userVehicle, garage, impound)
end)

RegisterNetEvent("modular-garages:server:parkVehicle", function(vehicleNetId, plate, garage, props)
    local src = source
    local userVehicle = GetUserOwnedVehicle(src, plate)

    if not userVehicle then
        return Notify(src, T("vehicle_not_owned"), "error")
    end

    local vehicleEntity = NetworkGetEntityFromNetworkId(vehicleNetId)
    ParkVehicle(src, vehicleEntity, plate, garage, props)
    Notify(src, T("vehicle_parked") or "Vehicle parked successfully!", "success")
end)

RegisterNetEvent("modular-garages:server:favoriteVehicle", function(plate, isFavorite, garage)
    local src = source
    FavoriteVehicle(src, plate, isFavorite, garage)
end)