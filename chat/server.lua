ESX.RegisterServerCallback("leszedemamunkat", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local munkanev = xPlayer.getJob().name
        local neved = xPlayer.getName()
        local frakifrang = xPlayer.getJob().grade_label
        cb(munkanev, neved, frakifrang)
    else
        cb(nil)
    end
end)

RegisterServerEvent("szeríocsek")
AddEventHandler("szeríocsek", function(frakineve, uzenet, color, image, neved, frakifrang)
    TriggerClientEvent("Frakiuzenet", -1, frakineve, uzenet, color, image, neved, frakifrang)
end)