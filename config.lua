Config = {}

-- Kit
Config.loadout = true

Config.kits = {
    tec9kit = {
        price = 1000,
        items = {
            { item = "weapon_machinepistol", amount = 1 },
            { item = "ammo-9", amount = 500 },
            { item = "armour", amount = 10 },
            { item = "radio", amount = 1 }
        }
    },
    shotgunkit = {
        price = 1500,
        items = {
            { item = "weapon_pumpshotgun", amount = 1 },
            { item = "ammo-shotgun", amount = 50 },
            { item = "armour", amount = 5 },
            { item = "bandage", amount = 5 }
        }
    }
}

-- FPS Boost

Config.FPSBoost = false -- true/false -- be és ki kapcsolja az automatikus FPS boostot

-- /FH
Config.Frakik = {
    ["unemployed"] = {
        name = "Békefenntartó",
        color = "#38AEE6", -- Hex, RGB, RGBA
        image = "https://upload.wikimedia.org/wikipedia/commons/2/2f/Flag_of_the_United_Nations.svg" -- bármien URL a képedhez
    },
    ["police"] = {
        name = "Rendőrség",
        color = "#38AEE6", -- Hex, RGB, RGBA
        image = "https://cdn.worldvectorlogo.com/logos/police-department.svg" -- bármien URL a képedhez
    },
}
-- NPCK
Config.Peds = {
    {
        location = vector3(1113.6499, 2645.4548, 37.9962), -- NPC KORDINÁTÁLJA
        model = 'a_m_y_business_01', -- NPC Modelle
        text = "~g~[E] ~w~- Felszerelés megvétele ", -- NPC fölötti üzenet
        textOffset = 1.0, -- NE Nyulj hozzá
        event = "militaryalap:loadout" -- CLIENT OLDALI EVENTET TRIGGEREL
    },
    {
        location = vector3(1120.4039, 2645.1375, 37.9962), 
        model = 'a_f_y_business_01',
        text = "~r~[E] ~w~- Ruha Bolt",
        textOffset = 1.0,
        event = "illenium-appearance:client:openClothingShopMenu",
        args = { type = "clothing" }
    },
    {
        location = vector3(1127.7164, 2644.9719, 37.9962), 
        model = 'a_f_y_business_01',
        text = "~b~[E] ~w~- Tároló",
        textOffset = 1.0,
        event = "militaryalap:tarolo"
    },
    {
        location = vector3(1135.4669, 2644.9360, 37.9961), 
        model = 'a_f_y_business_01',
        text = "~g~[E] ~w~- Bolt",
        textOffset = 1.0,
        event = "militaryalap:Bolt"
    },
    {
        location = vector3(1105.3440, 2661.0879, 37.9754), 
        model = 'a_f_y_business_01',
        text = "~o~[E] ~w~- Autó kikérö",
        textOffset = 1.0,
        event = "militaryalap:autokiker"
    }
    
}


-- HALÁL

Config.DeathRespawnTime = 15 -- Másodpercbe

Config.RespawnLocations = {
    ["police"] = {x = 450.0, y = -980.0, z = 30.0}, -- Random hely most

}

Config.DefaultRespawn = {x = 1124.2117, y =  2654.8804, z = 37.9969} -- Spawn

-- Kocsi kikérő

Config.kocsikiker = {
    bf400 = {
        model = "bf400", -- kocsi lehívója
        lebol = "Bf400 motor", -- Kocsi neve
        icon = "car"
    },
    valami = {
        model = "t20", -- kocsi lehívója
        lebol = "T20 kocsi", -- Kocsi neve
        icon = "car"
    },
}

Config.kocsisapwn = vector3(1108.8363, 2670.0549, 38.1291)

Config.kocsidel = vector3(1122.3158, 2669.1519, 37.0445)

-- Boltba Itemek

Config.boltitems = {
    { name = 'bandage', price = 20, count = 5000 }, -- a count az az hogy max mennyit lehesen venni ha nem akkarod akkor kitörölheted
    { name = 'parachute', price = 500, count = 500 },
    { name = 'radio', price = 50, count = 5000 },
    { name = 'armour', price = 500, count = 50000 },
    -- Lőszer:
    { name = 'ammo', price = 5 },
}

-- SafeZone By fusti:

Config.useBlip = true

Config.SafeZones = {
    player = {
        godMode = true
    },
    vehicle = {
        limit = true,
        metric = 'mph',  -- 'kph' (*3.6) / 'mph' (*2.23)
        maxSpeed = 5.0
    },
    alpha = {
        setEntityAlpha = true,
        alphaLevel = 151 -- The alpha level ranges from 0 to 255, but changes occur every 20% (every 51).
    },
    blip = {
        size = 40.0,
        colour = 2,
        alpha = 150
    },
    positions = {
        {coord = vector3(1128.5974, 2655.8181, 37.9969), radius = 70.0, debug = false},
        -- {coord = vector3(245.4583, -771.6877, 30.7168), radius = 70.0, debug = false}, Több hozzáadás...
    },
    notify = {
        EnterTitle = 'Információ',
        EnterDescription = 'Beléptél a Biztonsági zónába',
        EnterType = 'inform',
        EnterDuration = 3000,
        -----------------------------------------------------
        LeftTitle = 'Információ',
        LeftDescription = 'Kiléptél a Biztonsági zónából',
        LeftType = 'error',
        LeftDuration = 3000
    }
}