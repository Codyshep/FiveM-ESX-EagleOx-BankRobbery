--[[Keep in mind the lengths below are in milliseconds and not seconds.
For example 1000 milliseconds is 1 second]]

RobberyConfig = {
    RobTime = 5000, -- Time it takes to hack into the vault
    MinimumWinAmmount = 1200, -- Minimum Win Ammount
    MaximumWinAmmount = 10000, -- Maximum Win Ammount
    WinRate = '2' -- 1 means 50-50 | 2 means 75-25 | I personally do 2
}

LEO_Config = {
    LEO_AlertTitle = 'Attention LEO!', -- Title of notification that pops up for your job of choice
    LEO_AlertText = 'Attention all units: There is a bank robbery marked on your map, head to the suspects location!', -- Description of notification that pops up for your job of choice
    LEO_BlipTitle = 'Bank Robber | LEO Notified',
    LEO_BlipLength = 30000 -- Amount of time that LEO can see you on the map after robbing
}

-- Dont touch anything below unless you actually know what you are doing
MiniGameConfig = {
    Minigame = function()
        exports["glow_minigames"]:StartMinigame(function(success)
            if success then
                local wonAmount = math.random(RobberyConfig.MinimumWinAmmount, RobberyConfig.MaximumWinAmmount)
                local hackChance = math.random(1, 100)
                TriggerServerEvent('eagleBankRobberyWinner', wonAmount, hackChance)
                TriggerServerEvent('policeNotify')
            else
                print("lose")
                TriggerServerEvent('policeNotify')
            end
        end, "path")
    end
}