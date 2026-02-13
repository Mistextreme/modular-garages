Config = {}

Config.Debug = false

Config.ThemeColor = "#5899E2" -- "rgb(255, 0, 255) | #5899E2"

Config.Locale = "en"

Config.ExitAnimation = true     -- Whether to play an animation when exiting a vehicle

Config.PlaceIntoVehicle = true  -- If you want to place the player into the vehicle when they spawn it.

Config.ParkingType = "specific" -- "specific | global"
-- Specific: Vehicles are stored in a garage and can only be accessed from that specific garage.
-- Global: Vehicles are stored globally and can be accessed from any garage.

Config.AutoImpound = true -- Automatically impound vehicles when they are not parked in a garage.

Config.ZoneSizes = {      -- How big you want your zones to be. Keep in mind that this does not change the size of the marker.
    menu = 1.25,
    parking = 1.5,
}

Config.Blip = {
    Garage = {
        sprite = 357,
        color = 3,
        disabled = false,
        display = 4,
        scale = 0.7,
    },
    Impound = {
        sprite = 68,
        color = 1,
        disabled = false,
        display = 4,
        scale = 0.7,
    }
}

Config.DrawMarker = true -- Recommended. Draws a marker whenever you get close to a garage.

Config.Marker = {
    menu = {
        type = 2, -- https://docs.fivem.net/docs/game-references/markers/
        scaleX = 1.5,
        scaleY = 1.5,
        scaleZ = 1.5,
        red = 88,
        green = 153,
        blue = 226,
        alpha = 100,
        bobUpAndDown = false,
        faceCamera = false,
        rotate = false,
    },
    parking = {
        type = 2, -- https://docs.fivem.net/docs/game-references/markers/
        scaleX = 3.0,
        scaleY = 3.0,
        scaleZ = 1.0,
        red = 88,
        green = 153,
        blue = 226,
        alpha = 100,
        bobUpAndDown = false,
        faceCamera = false,
        rotate = false,
    }
}

Config.GarageTypes = { -- Vehicle Classes: https://docs.fivem.net/natives/?_0x29439776AAA00A62
    ["normal"] = {
        blipLabel = "Garage",
        classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 12, 13, 18, 20, 22 }
    },
    ["boat"] = {
        blipLabel = "Boat Garage",
        classes = { 14 }
    },
    ["helicopter"] = {
        blipLabel = "Helicopter Garage",
        classes = { 15 }
    },
    ["plane"] = {
        blipLabel = "Plane Garage",
        classes = { 16 }
    },
    ["all"] = {
        blipLabel = "Garage",
        classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22 }
    }
}

Config.Garages = {
    -- ["example_garage"] = {
    --     label = "Example Garage",
    --     type = "normal", -- What type of garage it is. Has to be in Config.GarageTypes
    --     menuPoint = vector4(213.9194, -808.7855, 31.0149, 25.0), -- Where you open the menu
    --     parkingPoint = vector4(217.5845, -783.7661, 30.8127, 230.7362), -- Where you park your vehicle
    --     outCoords = vector4(231.5774, -792.9274, 30.5983, 161.8895), -- Where the vehicle spawns when you take it out. Can be a table of multiple coords and will prefer the one where the area is empty.
    --     previewCarCoords = vector4(215.3518, -775.9796, 30.4456, 249.4238), -- Where the preview car spawns
    --     blip = { -- Overrides Config.Blip (optional)
    --         sprite = 357,
    --         color = 3,
    --         disabled = true,
    --         display = 4,
    --         scale = 0.7,
    --     }
    -- },
    ["legionsquare"] = {
        label = "Legion Square",
        type = "all",
        menuPoint = vector4(213.9194, -808.7855, 31.0149, 25.0),
        parkingPoint = vector4(217.5845, -783.7661, 30.8127, 230.7362),
        outCoords = { -- Prefers the area where it is empty, otherwise it will spawn at the first coords.
            vector4(215.2797, -804.1174, 30.8138, 61.5623),
            vector4(215.6418, -801.0688, 30.8087, 70.8351),
        },
        previewCarCoords = vector4(215.3518, -775.9796, 30.4456, 249.4238),

    },
    ["cityhall"] = {
        label = "Cityhall Parking",
        type = "normal",
        menuPoint = vector4(275.5151, -344.9059, 45.1734, 163.3547),
        parkingPoint = vector4(290.9989, -337.9551, 44.9625, 235.0019),
        outCoords = vector4(273.8862, -330.5411, 44.9224, 159.9451),
        previewCarCoords = vector4(270.1851, -322.5742, 44.5069, 249.0184),
    },
    ["ammunation"] = {
        label = "Ammunation rooftop",
        type = "normal",
        menuPoint = vector4(22.5045, -1102.7903, 38.1521, 277.7565),
        parkingPoint = vector4(16.2111, -1066.7554, 38.1522, 45.5411),
        outCoords = vector4(-3.8973, -1062.9597, 38.1521, 330.6602),
        previewCarCoords = vector4(43.9695, -1066.6580, 37.7382, 69.4308),
    },
    ["casino"] = {
        label = "Casino Parking",
        type = "normal",
        menuPoint = vector4(886.2733, -0.9191, 78.7650, 65.2892),
        parkingPoint = vector4(866.7205, -28.3682, 78.7641, 149.1868),
        outCoords = vector4(885.4515, -39.9464, 78.7642, 266.0305),
        previewCarCoords = vector4(905.2908, -11.5201, 78.3502, 147.0523),
    },
    ["vinewood"] = {
        label = "Vinewood Parking",
        type = "normal",
        menuPoint = vector4(-340.7706, 266.6100, 85.6795, 192.5330),
        parkingPoint = vector4(-334.5128, 290.9206, 85.8154, 11.7070),
        outCoords = vector4(-345.0571, 290.2445, 85.1877, 136.7437),
        previewCarCoords = vector4(-327.9069, 281.4577, 85.9354, 93.1839),
    },
    ["beach"] = {
        label = "Beach Parking",
        type = "normal",
        menuPoint = vector4(-2030.1995, -465.6168, 11.6040, 225.2858),
        parkingPoint = vector4(-2038.8328, -450.0008, 11.1218, 48.1409),
        outCoords = vector4(-2012.5389, -472.4169, 11.1024, 48.8877),
        previewCarCoords = vector4(-2031.2469, -481.9097, 11.2983, 319.2163),
    },
    ["pier"] = {
        type = "normal",
        menuPoint = vector4(-1602.2089, -1045.4957, 13.0338, 307.0944),
        parkingPoint = vector4(-1601.9718, -1034.0599, 12.6460, 140.0528),
        outCoords = vector4(-1574.5337, -1008.4267, 12.6050, 139.3074),
        previewCarCoords = vector4(-1561.1893, -1030.2882, 12.6040, 74.1463),
    },
    ["grove"] = {
        label = "Grove-Street Parking",
        type = "normal",
        menuPoint = vector4(-207.1227, -1692.9043, 34.1937, 269.8786),
        parkingPoint = vector4(-226.9525, -1699.1947, 33.5410, 103.4616),
        outCoords = vector4(-216.5096, -1711.4375, 32.7034, 307.4335),
        previewCarCoords = vector4(-223.4159, -1707.0890, 33.5002, 36.6384),
    },
    ["lsia"] = {
        label = "LSIA Parking",
        type = "normal",
        menuPoint = vector4(-1056.6107, -2645.6755, 13.4186, 77.7450),
        parkingPoint = vector4(-1039.0859, -2666.4280, 13.4180, 240.2225),
        outCoords = vector4(759.5648, -2982.9695, 5.3871, 177.7998),
        previewCarCoords = vector4(-1050.9481, -2666.7092, 13.4174, 300.8984),
    },
    ["harbor"] = {
        label = "harbor Parking",
        type = "normal",
        menuPoint = vector4(771.4258, -2991.1704, 6.0209, 135.4984),
        parkingPoint = vector4(762.9547, -2956.1504, 5.3870, 0.9921),
        outCoords = vector4(759.2340, -2981.6301, 5.3877, 178.0797),
        previewCarCoords = vector4(781.9020, -2961.7751, 5.3872, 68.2932),
    },
    ["mirrorpark"] = {
        label = "Mirror-park Parking",
        type = "normal",
        menuPoint = vector4(1036.2964, -763.3453, 57.9930, 247.7920),
        parkingPoint = vector4(1040.6742, -778.2584, 58.0229, 186.2578),
        outCoords = vector4(1022.1745, -764.0208, 57.9550, 316.5579),
        previewCarCoords = vector4(1029.7362, -788.1813, 57.4505, 309.2905),
    },
    ["golf"] = {
        label = "Golf-club Parking",
        type = "normal",
        menuPoint = vector4(-1380.4015, 55.0638, 53.2641, 4.1483),
        parkingPoint = vector4(-1396.1028, 50.8829, 53.0585, 6.0929),
        outCoords = vector4(-1399.8026, 30.1410, 52.7223, 243.7851),
        previewCarCoords = vector4(-1407.1669, 93.5938, 52.5885, 236.2256),
    },
    ["lamesa"] = {
        label = "La-mesa Parking",
        type = "normal",
        menuPoint = vector4(1206.1460, -1535.6393, 39.4028, 299.6482),
        parkingPoint = vector4(1176.0016, -1540.7377, 38.9874, 90.6027),
        outCoords = vector4(1199.4426, -1540.7443, 38.9879, 90.3405),
        previewCarCoords = vector4(1188.3619, -1571.2111, 38.9872, 0.3239),
    },
    ["boatgarage"] = {
        label = "Boat Garage",
        type = "boat",
        menuPoint = vector4(-721.6501, -1324.3300, 1.5963, 3.8009),
        parkingPoint = vector4(-727.1355, -1326.4590, 3.5347, 227.0647),
        outCoords = vector4(-214.1295, -1709.4401, 32.7811, 309.9681),
        previewCarCoords = vector4(-727.1355, -1326.4590, 3.5347, 227.0647),
    },
}

Config.Impounds = {
    ["impoundlot"] = {
        label = "Impound",
        menuPoint = vector4(409.2840, -1623.0396, 29.2919, 234.2715),
        outCoords = vector4(405.1895, -1636.5958, 29.2919, 319.3445),
        previewCarCoords = vector4(403.2789, -1650.5002, 29.2940, 316.5453),
    },
}

Config.CustomVehicles = {
    -- ["blista"] = {
    --     label = "Custom Blista Name",
    --     image = "image url | local image file placed in 'html/vehicleimages'"
    -- }
}
