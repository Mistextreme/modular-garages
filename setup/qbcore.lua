if GetResourceState("qb-core") ~= "started" then return end

MySQL.Async.fetchAll("SHOW COLUMNS FROM player_vehicles LIKE 'isFavorite'", {}, function(result)
    if result[1] == nil then
        MySQL.Async.execute([[
        ALTER TABLE player_vehicles
        ADD COLUMN isFavorite tinyint(1) NOT NULL DEFAULT 0;
        ]])
        print("Added column isFavorite to player_vehicles table")
    end
end)
