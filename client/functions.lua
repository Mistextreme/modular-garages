local currentGarage = nil
local currentImpound = nil
local previewVehicle = nil
local currentZone = nil

function T(key, ...)
    if Locales[Config.Locale] and Locales[Config.Locale][key] then
        return string.format(Locales[Config.Locale][key], ...)
    else
        return "Translation [" .. key .. "] not found!"
    end
end

function OpenGarageMenu(garage)
    if not garage then return end
    
    currentGarage = garage
    currentImpound = nil
    
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "open",
        garage = garage,
        isImpound = false,
        config = {
            themeColor = Config.ThemeColor,
            locale = Config.Locale
        }
    })
    
    TriggerServerEvent("modular-garages:server:fetchVehicles", garage)
end

function OpenImpoundMenu(impound)
    if not impound then return end
    
    currentImpound = impound
    currentGarage = nil
    
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "open",
        impound = impound,
        isImpound = true,
        config = {
            themeColor = Config.ThemeColor,
            locale = Config.Locale
        }
    })
    
    TriggerServerEvent("modular-garages:server:fetchImpoundedVehicles", impound)
end

function CloseMenu()
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "close"
    })
    
    DeletePreviewVehicle()
    currentGarage = nil
    currentImpound = nil
end

function SpawnPreviewVehicle(model, coords)
    DeletePreviewVehicle()
    
    if type(model) == "string" then
        model = GetHashKey(model)
    end
    
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    
    previewVehicle = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w or 0.0, false, false)
    SetEntityAlpha(previewVehicle, 200, false)
    SetEntityCollision(previewVehicle, false, false)
    FreezeEntityPosition(previewVehicle, true)
    SetVehicleDoorsLocked(previewVehicle, 2)
    SetModelAsNoLongerNeeded(model)
    
    return previewVehicle
end

function DeletePreviewVehicle()
    if previewVehicle and DoesEntityExist(previewVehicle) then
        DeleteEntity(previewVehicle)
        previewVehicle = nil
    end
end

function GetEmptySpawnPoint(coords)
    if type(coords) == "table" and coords[1] then
        for _, coord in ipairs(coords) do
            if IsSpawnPointClear(coord) then
                return coord
            end
        end
        return coords[1]
    else
        return coords
    end
end

function IsSpawnPointClear(coords)
    local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
    return vehicle == 0
end

function GetCurrentGarage()
    return currentGarage
end

function GetCurrentImpound()
    return currentImpound
end

function IsInZone()
    return currentZone ~= nil
end