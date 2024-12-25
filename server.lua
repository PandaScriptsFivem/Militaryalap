AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        local currentResourceName = GetCurrentResourceName()
        if currentResourceName ~= "Militaryalap" then
            print("^1[ERROR] A script neve nem megfelelő. A Militaryalap script leáll.^0")
            return
        end
        exports.ox_inventory:RegisterStash("military_stash", "Tároló", 500, 500000, true, false, vector3(0, 0, 0))
        exports.ox_inventory:RegisterShop('Bolt', {name = "Felszerelés vétel", inventory = Config.boltitems})
        lib.versionCheck('PandaScriptsFivem/Militaryalap')
    end
end)


-- Halál dolgok:

RegisterServerEvent('militaryalap:getFaction')
AddEventHandler('militaryalap:getFaction', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = xPlayer.getJob().name

    local coords = Config.RespawnLocations[job] or Config.DefaultRespawn

    TriggerClientEvent('militaryalap:respawnPlayer', source, coords)
end)

-- Loudout

RegisterServerEvent("militaryalap:getkit")
AddEventHandler("militaryalap:getkit", function(kitName)
    local xPlayer = ESX.GetPlayerFromId(source)

    local kit = Config.kits[kitName]
    if not kit then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Rendszer',
            description = 'Ez a kit nem létezik',
            type = 'error'
        })
        return
    end

    local playerMoney = xPlayer.getAccount("money").money
    if playerMoney >= kit.price then
        xPlayer.removeAccountMoney("money", kit.price)
        
        for _, itemData in pairs(kit.items) do
            xPlayer.addInventoryItem(itemData.item, itemData.amount)
        end

        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Rendszer',
            description = 'Sikeresen megvásároltad a '.. kitName ..' készletet',
            type = 'success'
        })
    else
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Rendszer',
            description = 'Nincs elég pénzed',
            type = 'error'
        })
    end
end)


ESX.RegisterServerCallback('militaryalap:penzakurvanak', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local money = xPlayer.getMoney()  
        cb(money)
    else
        cb(0)
    end
end)


RegisterServerEvent("militaryalap:forcetarolo")
AddEventHandler("militaryalap:forcetarolo", function()
    local playerSource = source
    exports.ox_inventory:forceOpenInventory(playerSource, 'stash', "military_stash")
end)
