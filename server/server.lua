local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('qb-board:server:GetScoreboardData', function(_, cb)
    local totalPlayers = 0
    local policeCount = 0
    local ambulanceCount = 0
    local players = {}

    for _, v in pairs(QBCore.Functions.GetQBPlayers()) do
        if v then
            totalPlayers += 1

            if v.PlayerData.job.name == 'police' and v.PlayerData.job.onduty then
                policeCount += 1
            end
            if v.PlayerData.job.name == 'ambulance' and v.PlayerData.job.onduty then
                ambulanceCount += 1
            end

            players[v.PlayerData.source] = {}
            players[v.PlayerData.source].optin = QBCore.Functions.IsOptin(v.PlayerData.source)
        end
    end
    cb(totalPlayers, policeCount, ambulanceCount, players)
end)

RegisterNetEvent('qb-board:server:SetActivityBusy', function(activity, bool)
    Config.IllegalActions[activity].busy = bool
    TriggerClientEvent('qb-board:client:SetActivityBusy', -1, activity, bool)
end)




