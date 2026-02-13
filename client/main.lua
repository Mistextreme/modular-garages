local zones = {}
local inParkingZone = {}

CreateThread(function()
    -- Create garage zones
    for garageName, garageData in pairs(Config.Garages) do
        -- Menu zone
        local menuZone = BoxZone:Create(
            vector3(garageData.menuPoint.x, garageData.menuPoint.y, garageData.menuPoint.z),
            Config.ZoneSizes.menu * 2,
            Config.ZoneSizes.menu * 2,
            {
                name = "garage_menu_" .. garageName,
                heading = garageData.menuPoint.w or 0.0,
                debugPoly = Config.Debug,
                minZ = garageData.menuPoint.z - 1.0,
                maxZ = garageData.menuPoint.z + 2.0
            }
        )
        
        menuZone:onPlayerInOut(function(isPointInside)
            if isPointInside then
                currentZone = garageName
                CreateThread(function()
                    while IsInZone() and currentZone == garageName do
                        Wait(0)
                        if Config.DrawMarker then
                            DrawMarker(
                                Config.Marker.menu.type,
                                garageData.menuPoint.x,
                                garageData.menuPoint.y,
                                garageData.menuPoint.z - 1.0,
                                0.0, 0.0, 0.0,
                                0.0, 0.0, 0.0,
                                Config.Marker.menu.scaleX,
                                Config.Marker.menu.scaleY,
                                Config.Marker.menu.scaleZ,
                                Config.Marker.menu.red,
                                Config.Marker.menu.green,
                                Config.Marker.menu.blue,
                                Config.Marker.menu.alpha,
                                Config.Marker.menu.bobUpAndDown,
                                Config.Marker.menu.faceCamera,
                                2,
                                Config.Marker.menu.rotate,
                                nil, nil, false
                            )
                        end
                        
                        local playerCoords = GetEntityCoords(PlayerPedId())
                        local distance = #(playerCoords - vector3(garageData.menuPoint.x, garageData.menuPoint.y, garageData.menuPoint.z))
                        
                        if distance < Config.ZoneSizes.menu then
                            DisplayHelpText(T("open_garage"))
                            
                            if IsControlJustReleased(0, 38) then -- E key
                                OpenGarageMenu(garageName)
                            end
                        end
                    end
                end)
            else
                if currentZone == garageName then
                    currentZone = nil
                end
            end
        end)
        
        -- Parking zone
        local parkingZone = BoxZone:Create(
            vector3(garageData.parkingPoint.x, garageData.parkingPoint.y, garageData.parkingPoint.z),
            Config.ZoneSizes.parking * 2,
            Config.ZoneSizes.parking * 2,
            {
                name = "garage_parking_" .. garageName,
                heading = garageData.parkingPoint.w or 0.0,
                debugPoly = Config.Debug,
                minZ = garageData.parkingPoint.z - 1.0,
                maxZ = garageData.parkingPoint.z + 2.0
            }
        )
        
        parkingZone:onPlayerInOut(function(isPointInside)
            inParkingZone[garageName] = isPointInside
            
            if isPointInside then
                CreateThread(function()
                    while inParkingZone[garageName] do
                        Wait(0)
                        if Config.DrawMarker then
                            DrawMarker(
                                Config.Marker.parking.type,
                                garageData.parkingPoint.x,
                                garageData.parkingPoint.y,
                                garageData.parkingPoint.z - 1.0,
                                0.0, 0.0, 0.0,
                                0.0, 0.0, 0.0,
                                Config.Marker.parking.scaleX,
                                Config.Marker.parking.scaleY,
                                Config.Marker.parking.scaleZ,
                                Config.Marker.parking.red,
                                Config.Marker.parking.green,
                                Config.Marker.parking.blue,
                                Config.Marker.parking.alpha,
                                Config.Marker.parking.bobUpAndDown,
                                Config.Marker.parking.faceCamera,
                                2,
                                Config.Marker.parking.rotate,
                                nil, nil, false
                            )
                        end
                        
                        local playerPed = PlayerPedId()
                        if IsPedInAnyVehicle(playerPed, false) then
                            local playerCoords = GetEntityCoords(playerPed)
                            local distance = #(playerCoords - vector3(garageData.parkingPoint.x, garageData.parkingPoint.y, garageData.parkingPoint.z))
                            
                            if distance < Config.ZoneSizes.parking then
                                DisplayHelpText(T("park_vehicle"))
                                
                                if IsControlJustReleased(0, 38) then -- E key
                                    local vehicle = GetVehiclePedIsIn(playerPed, false)
                                    local plate = string.gsub(GetVehicleNumberPlateText(vehicle), "^%s*(.-)%s*$", "%1")
                                    local props = GetVehicleProps(vehicle)
                                    
                                    -- Check if vehicle type matches garage type
                                    local vehicleClass = GetVehicleClass(vehicle)
                                    local garageType = Config.GarageTypes[garageData.type]
                                    
                                    if garageType and not HasValue(garageType.classes, vehicleClass) then
                                        Notify(T("incorrect_type"), "error")
                                        return
                                    end
                                    
                                    if Config.ExitAnimation then
                                        TaskLeaveVehicle(playerPed, vehicle, 0)
                                        Wait(1500)
                                    end
                                    
                                    TriggerServerEvent("modular-garages:server:parkVehicle", NetworkGetNetworkIdFromEntity(vehicle), plate, garageName, props)
                                end
                            end
                        end
                    end
                end)
            end
        end)
        
        -- Create blip
        local blipConfig = garageData.blip or Config.Blip.Garage
        if not blipConfig.disabled then
            local blip = AddBlipForCoord(garageData.menuPoint.x, garageData.menuPoint.y, garageData.menuPoint.z)
            SetBlipSprite(blip, blipConfig.sprite)
            SetBlipDisplay(blip, blipConfig.display)
            SetBlipScale(blip, blipConfig.scale)
            SetBlipColour(blip, blipConfig.color)
            SetBlipAsShortRange(blip, true)
            
            local garageType = Config.GarageTypes[garageData.type]
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(garageData.label or (garageType and garageType.blipLabel) or "Garage")
            EndTextCommandSetBlipName(blip)
        end
        
        table.insert(zones, menuZone)
        table.insert(zones, parkingZone)
    end
    
    -- Create impound zones
    for impoundName, impoundData in pairs(Config.Impounds) do
        -- Menu zone
        local menuZone = BoxZone:Create(
            vector3(impoundData.menuPoint.x, impoundData.menuPoint.y, impoundData.menuPoint.z),
            Config.ZoneSizes.menu * 2,
            Config.ZoneSizes.menu * 2,
            {
                name = "impound_menu_" .. impoundName,
                heading = impoundData.menuPoint.w or 0.0,
                debugPoly = Config.Debug,
                minZ = impoundData.menuPoint.z - 1.0,
                maxZ = impoundData.menuPoint.z + 2.0
            }
        )
        
        menuZone:onPlayerInOut(function(isPointInside)
            if isPointInside then
                currentZone = impoundName
                CreateThread(function()
                    while IsInZone() and currentZone == impoundName do
                        Wait(0)
                        if Config.DrawMarker then
                            DrawMarker(
                                Config.Marker.menu.type,
                                impoundData.menuPoint.x,
                                impoundData.menuPoint.y,
                                impoundData.menuPoint.z - 1.0,
                                0.0, 0.0, 0.0,
                                0.0, 0.0, 0.0,
                                Config.Marker.menu.scaleX,
                                Config.Marker.menu.scaleY,
                                Config.Marker.menu.scaleZ,
                                Config.Marker.menu.red,
                                Config.Marker.menu.green,
                                Config.Marker.menu.blue,
                                Config.Marker.menu.alpha,
                                Config.Marker.menu.bobUpAndDown,
                                Config.Marker.menu.faceCamera,
                                2,
                                Config.Marker.menu.rotate,
                                nil, nil, false
                            )
                        end
                        
                        local playerCoords = GetEntityCoords(PlayerPedId())
                        local distance = #(playerCoords - vector3(impoundData.menuPoint.x, impoundData.menuPoint.y, impoundData.menuPoint.z))
                        
                        if distance < Config.ZoneSizes.menu then
                            DisplayHelpText(T("open_impound"))
                            
                            if IsControlJustReleased(0, 38) then -- E key
                                OpenImpoundMenu(impoundName)
                            end
                        end
                    end
                end)
            else
                if currentZone == impoundName then
                    currentZone = nil
                end
            end
        end)
        
        -- Create blip
        local blipConfig = Config.Blip.Impound
        if not blipConfig.disabled then
            local blip = AddBlipForCoord(impoundData.menuPoint.x, impoundData.menuPoint.y, impoundData.menuPoint.z)
            SetBlipSprite(blip, blipConfig.sprite)
            SetBlipDisplay(blip, blipConfig.display)
            SetBlipScale(blip, blipConfig.scale)
            SetBlipColour(blip, blipConfig.color)
            SetBlipAsShortRange(blip, true)
            
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(impoundData.label or "Impound")
            EndTextCommandSetBlipName(blip)
        end
        
        table.insert(zones, menuZone)
    end
end)

function DisplayHelpText(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function HasValue(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        for _, zone in ipairs(zones) do
            zone:destroy()
        end
        DeletePreviewVehicle()
        inParkingZone = {}
    end
end)
