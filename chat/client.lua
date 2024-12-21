RegisterCommand("fh", function(source, args, rawCommand)
    local uzenet = table.concat(args, " ")
    ESX.TriggerServerCallback("leszedemamunkat", function(jobName, neved, frakifrang)
        local jobConfig = Config.Frakik[jobName]
        local neved = neved
        local frakifrang = frakifrang
        if jobConfig then
            local frakineve = jobConfig.name
            local color = jobConfig.color
            local image = jobConfig.image
            TriggerServerEvent("szeríocsek", frakineve, uzenet, color, image, neved, frakifrang)
        else
            TriggerServerEvent("szeríocsek", "Ismeretlen", uzenet, "white", "")
        end
    end)
end, false)

RegisterNetEvent("Frakiuzenet")
AddEventHandler("Frakiuzenet", function(frakineve, uzenet, color, image, neved, frakifrang)
    TriggerEvent('chat:addMessage', {
        template = string.format(
            '<div style="position: relative; padding: 0.5vw; margin: 0.5vw; background-color: rgba(15, 15, 15, 0.5); border-radius: 5px;">' ..
            '<span style="font-size: 1.2em; color: %s; font-family: Arial;"><b>{0}</b></span> {2} <span style="color: #ababab; font-size:15px; vertical-align: top; position:absolute; right:42px; top:-2px;">({3})</span> » ^0 {1}' ..
            '<img src="%s" style="position: absolute; top: -5px; right: -10px; width: 50px; height: 30px;" /></div>',
            color, image
        ),
        args = { frakineve, uzenet, neved, frakifrang }
    })
end)
