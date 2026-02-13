RegisterNUICallback("close", function(data, cb)
    CloseMenu()
    cb("ok")
end)

RegisterNUICallback("spawnVehicle", function(data, cb)
    local plate = data.plate
    
    if not plate then
        cb("error")
        return
    end
    
    local garage = GetCurrentGarage()
    local impound = GetCurrentImpound()
    
    TriggerServerEvent("modular-garages:server:spawnVehicle", plate, garage, impound)
    cb("ok")
end)

RegisterNUICallback("previewVehicle", function(data, cb)
    local model = data.model
    
    if not model then
        DeletePreviewVehicle()
        cb("ok")
        return
    end
    
    local garage = GetCurrentGarage()
    local impound = GetCurrentImpound()
    
    local garageData = garage and Config.Garages[garage] or nil
    local impoundData = impound and Config.Impounds[impound] or nil
    
    if not garageData and not impoundData then
        cb("error")
        return
    end
    
    local previewCoords = garageData and garageData.previewCarCoords or impoundData.previewCarCoords
    
    if previewCoords then
        SpawnPreviewVehicle(model, previewCoords)
    end
    
    cb("ok")
end)

RegisterNUICallback("favoriteVehicle", function(data, cb)
    local plate = data.plate
    local isFavorite = data.isFavorite
    
    if not plate then
        cb("error")
        return
    end
    
    local garage = GetCurrentGarage()
    
    TriggerServerEvent("modular-garages:server:favoriteVehicle", plate, isFavorite, garage)
    cb("ok")
end)