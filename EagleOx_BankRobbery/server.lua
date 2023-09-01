ESX = exports['es_extended']:getSharedObject()

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end
    print('^6The resource "^4' .. resourceName .. '^6" has been started.')
end)

require('config')

local LEO_AlertText = LEO_Config.LEO_AlertText
local SelectedWinRate = RobberyConfig.WinRate

RegisterServerEvent('eagleBankRobberyWinner')
AddEventHandler('eagleBankRobberyWinner', function(wonAmount, hackChance)
    local playerId = source -- Use source to get the player's server ID
    local xPlayer = ESX.GetPlayerFromId(playerId)

    local winRate = nil
    local loseRate = nil

    if SelectedWinRate == '1' then
        winRate = 50
        loseRate = 50
    elseif SelectedWinRate == '2' then
        winRate = 75
        loseRate = 25
    end

    local hackchance = hackChance
    if hackchance < winRate then
        local amountToAdd = wonAmount -- Adjust the amount as needed

        TriggerClientEvent('RobberyWinNotify', playerId, amountToAdd)

        if xPlayer then
            exports.ox_inventory:AddItem(playerId, 'money', amountToAdd)
        end
    elseif hackchance > loseRate then
        TriggerClientEvent('RobberyLossNotify', playerId)
    end
end)


RegisterServerEvent('CheckHackTablet')
AddEventHandler('CheckHackTablet', function()
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)

    local hasHackTablet = xPlayer.getInventoryItem('hack_tablet').count > 0

    if hasHackTablet then
        exports.ox_inventory:RemoveItem(playerId, 'hack_tablet', 1, nil, nil)
    end

    TriggerClientEvent('HackTabletStatus', playerId, hasHackTablet)
end)

RegisterServerEvent('policeNotify')
AddEventHandler('policeNotify', function()
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local Job = xPlayer.job.name

    print(Job)

    if xPlayer ~= nil and Job == 'police' then
        TriggerClientEvent('showPoliceAlert', -1, LEO_AlertText)
    end
end)