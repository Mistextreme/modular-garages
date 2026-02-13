if GetResourceState("es_extended") ~= "started" then return end

MySQL.Async.fetchAll("SHOW COLUMNS FROM owned_vehicles LIKE 'isFavorite'", {}, function(result)
    if result[1] == nil then
        MySQL.Async.execute([[
        ALTER TABLE owned_vehicles
        ADD COLUMN isFavorite tinyint(1) NOT NULL DEFAULT 0;
        ]])
        print("Added column isFavorite to owned_vehicles table")
    end
end)
