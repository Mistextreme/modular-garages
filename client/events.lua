RegisterNetEvent("modular-garages:client:receiveVehicles", function(vehicles)
    SendNUIMessage({
        action = "receiveVehicles",
        vehicles = vehicles
    })
end)

RegisterNetEvent("modular-garages:client:spawnVehicle", function(userVehicle, garage, impound)
    local garageData = garage and Config.Garages[garage] or nil
    local impoundData = impound and Config.Impounds[impound] or nil
    
    if not garageData and not impoundData then return end
    
    local spawnCoords = garageData and garageData.outCoords or impoundData.outCoords
    spawnCoords = GetEmptySpawnPoint(spawnCoords)
    
    local model = userVehicle.model
    local plate = userVehicle.plate
    local props = userVehicle.props
    
    if type(model) == "string" then
        model = GetHashKey(model)
    end
    
    SpawnVehicle(model, vector3(spawnCoords.x, spawnCoords.y, spawnCoords.z), spawnCoords.w or 0.0, plate, props)
    
    CloseMenu()
end)