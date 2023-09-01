ESX = exports['es_extended']:getSharedObject()

require('config')

local RobTime = RobberyConfig.RobTime
local LEO_BlipLength = LEO_Config.LEO_BlipLength
local LEO_AlertTitle = LEO_Config.LEO_AlertTitle
local LEO_BlipTitle = LEO_Config.LEO_BlipTitle

local robable = {
    'prop_bank_vaultdoor',
    'v_ilev_cbankvauldoor01',
    'v_ilev_bk_vaultdoor',
    'v_ilev_fin_vaultdoor',
    'v_ilev_gb_vauldr',
    'prop_ld_vault_door',
    'prop_ld_vault_door',
    'ch_prop_ch_vaultdoor01x',
    'ch_des_heist3_vault_01',
    'reh_prop_reh_door_vault_01a',
}

RegisterNetEvent('RobberyWinNotify')
AddEventHandler('RobberyWinNotify', function(amountToAdd)
    local winNotify = lib.notify({title = 'All Feds Notified', description = 'You successfully robbed the bank and received $'..amountToAdd, type = 'success'})
end)

RegisterNetEvent('RobberyLossNotify')
AddEventHandler('RobberyLossNotify', function()
    lib.notify({
        title = 'LEO NOTIFIED',
        description = 'TABLET BROKE',
        position = 'top',
        style = {
            backgroundColor = '#141517',
            color = '#C1C2C5',
            ['.description'] = {
              color = '#909296'
            }
        },
        icon = 'ban',
        iconColor = '#C53030'
    })
end)

exports.ox_target:addModel(robable, {
    {
        label = 'Start Robbery!',
        icon = 'fa-solid fa-sack-dollar',
        iconColor = 'Yellow',
        onSelect = function()
            lib.progressBar({
                duration = RobTime,
                label = 'Hacking Vault..',
                anim = {
                    dict = 'amb@world_human_tourist_map@male@base',
                    clip = 'base'
                },
                prop = {
                    model = 'prop_cs_tablet',
                    bone = 28422,
                    pos = vec3(0.00, 0.00, 0.00),
                    rot = vec3(0.0, 90.0, 0.0)
                },
                disable = {
                    move = true,
                    cobmat = true
                }
            })
            TriggerServerEvent('CheckHackTablet')
        end
    }
})

RegisterNetEvent('showPoliceAlert')
AddEventHandler('showPoliceAlert', function(message)
    local player = PlayerId()

    print(player)

    local alert = lib.alertDialog({
        header = LEO_AlertTitle,
        content = message,
        centered = true,
        cancel = true
    })

    Citizen.CreateThread(function()
        local playerPed = PlayerPedId()
        local blip = AddBlipForEntity(playerPed)
    
        SetBlipSprite(blip, 189) -- Set blip to blue color
        SetBlipDisplay(blip, 2) -- Show the blip on both the minimap and the main map
        SetBlipScale(blip, 1.1) -- Set the blip size (1.0 is default)
        SetBlipColour(blip, 6) -- Set the blip color (3 is blue)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(LEO_BlipTitle) -- Set the blip's name
        EndTextCommandSetBlipName(blip)
    
        Citizen.Wait(LEO_BlipLength) 
        RemoveBlip(blip) 
    end)

end)


RegisterNetEvent('HackTabletStatus')
AddEventHandler('HackTabletStatus', function(hasHackTablet)
    if hasHackTablet then
        print('You have the hack_tablet item in your inventory.')
        MiniGameConfig.Minigame()
    else
        lib.notify({
            title = 'WARNING',
            description = 'You dont have a hacking tablet!',
            position = 'top',
            style = {
                backgroundColor = '#141517',
                color = '#C1C2C5',
                ['.description'] = {
                  color = '#909296'
                }
            },
            icon = 'ban',
            iconColor = '#C53030'
        })
    end
end)

