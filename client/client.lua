local QBCore = exports['qb-core']:GetCoreObject()
local scoreboardOpen = false
local playerOptin = {}
local Hours = 0
local Minutes = 0
local hidden = {}
local disPlayerNames = 8

-- Functions

function DrawText3DID(x,y,z, text, textColor)
    local color = { r = 41, g = 202, b = 214, alpha = 255 } 
    if textColor ~= nil then 
        color = {r = textColor[1] or 22, g = textColor[2] or 55, b = textColor[3] or 155, alpha = textColor[4] or 255}
    end

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px,py,pz) - vector3(x,y,z))

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    
    if onScreen then
        SetTextScale(0.0*scale, 0.75*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(color.r, color.g, color.b, color.alpha)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end
local function GetTime()
    return Hours .. 'H:' .. Minutes .. 'M'
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        if Minutes < 60 then
            Minutes = Minutes + 1
        else
            Minutes = 0
            Hours = Hours + 1
        end
    end
end)


local function GetPlayers()
    local players = {}
    local activePlayers = GetActivePlayers()
    for i = 1, #activePlayers do
        local player = activePlayers[i]
        local ped = GetPlayerPed(player)
        if DoesEntityExist(ped) then
            players[#players + 1] = player
        end
    end
    return players
end

local function GetPlayersFromCoords(coords, distance)
    local players = GetPlayers()
    local closePlayers = {}

    coords = coords or GetEntityCoords(PlayerPedId())
    distance = distance or 5.0

    for i = 1, #players do
        local player = players[i]
        local target = GetPlayerPed(player)
        local targetCoords = GetEntityCoords(target)
        local targetdistance = #(targetCoords - vector3(coords.x, coords.y, coords.z))
        if targetdistance <= distance then
            closePlayers[#closePlayers + 1] = player
        end
    end

    return closePlayers
end



local PlayerOptin = {}

DrawText3D = function(x, y, z, text)
    SetTextScale(0.85, 0.85)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255,255,255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    ClearDrawOrigin()
end
-- Events

RegisterNetEvent('qb-board:client:SetActivityBusy', function(activity, busy)
    Config.IllegalActions[activity].busy = busy
end)

-- Command

if Config.Toggle then
    RegisterCommand('scoreboard', function()
        if not scoreboardOpen then
            QBCore.Functions.TriggerCallback('qb-board:server:GetScoreboardData', function(players, cops, ambulance, playerList)
                playerOptin = playerList

                SendNUIMessage({
                    action = 'open',
                    players = players,
                    maxPlayers = Config.MaxPlayers,
                    requiredCops = Config.IllegalActions,
                    currentCops = cops,
                    currentambulance = ambulance,
                    time = GetTime();

                })

                scoreboardOpen = true
            end)
        else
            SendNUIMessage({
                action = 'close',
            })

            scoreboardOpen = false
        end
    end, false)

    RegisterKeyMapping('scoreboard', 'Open Scoreboard', 'keyboard', Config.OpenKey)
else
    RegisterCommand('+scoreboard', function()
        if scoreboardOpen then return end
        QBCore.Functions.TriggerCallback('qb-board:server:GetScoreboardData', function(players, cops, ambulance, playerList)
            playerOptin = playerList

            SendNUIMessage({
                action = 'open',
                players = players,
                maxPlayers = Config.MaxPlayers,
                requiredCops = Config.IllegalActions,
                currentCops = cops,
                currentambulance = ambulance
            })

            scoreboardOpen = true
        end)
    end, false)

    RegisterCommand('-scoreboard', function()
        if not scoreboardOpen then return end
        SendNUIMessage({
            action = 'close',
        })

        scoreboardOpen = false
    end, false)

    RegisterKeyMapping('+scoreboard', 'Open Scoreboard', 'keyboard', Config.OpenKey)
end

RegisterNetEvent("hud:HidePlayer")
AddEventHandler("hud:HidePlayer", function(player, toggle)
    if type(player) == "table" then
        for k,v in pairs(player) do
            local id = GetPlayerFromServerId(k)
            hidden[id] = k
        end
        return
    end
    local id = GetPlayerFromServerId(player)
    if toggle == true then hidden[id] = player
    else
        for k,v in pairs(hidden) do
            if v == player then hidden[k] = nil end
        end
    end
end)

-- Threads

CreateThread(function()
    Wait(1000)
    local actions = {}
    for k, v in pairs(Config.IllegalActions) do
        actions[k] = v.label
    end
    SendNUIMessage({
        action = 'setup',
        items = actions
    })
end)

Citizen.CreateThread(function()
    while true do
        if scoreboardOpen then
            for i=0,128 do
                N_0x31698aa80e0223f8(i)
            end
            for id = 0, 128 do
                if NetworkIsPlayerActive( id ) then
                    local playerped = PlayerPedId()
                    local HeadBone = 0x796e
                    local ped = GetPlayerPed(id)
                    local playerCoords = GetPedBoneCoords(playerped, HeadBone)
                    if ped == playerped then
                        DrawText3DID(playerCoords.x, playerCoords.y, playerCoords.z+0.5, " ".. GetPlayerServerId(id) .. " ", {0,148,187, 255})
                    else
                        local pedCoords = GetPedBoneCoords(ped, HeadBone)
                        local distance = math.floor(#(playerCoords - pedCoords))

                        local isDucking = IsPedDucking(GetPlayerPed( id ))
                        local cansee = HasEntityClearLosToEntity( GetPlayerPed( -1 ), GetPlayerPed( id ), 17 )
                        local isReadyToShoot = IsPedWeaponReadyToShoot(GetPlayerPed( id ))
                        local isStealth = GetPedStealthMovement(GetPlayerPed( id ))
                        local isDriveBy = IsPedDoingDriveby(GetPlayerPed( id ))
                        local isInCover = IsPedInCover(GetPlayerPed( id ),true)
                        if isStealth == nil then
                            isStealth = 0
                        end

                        if isDucking or isStealth == 1 or isDriveBy or isInCover then
                            cansee = false
                        end

                        if hidden[id] then cansee = false end
                        
                        if (distance < disPlayerNames) then
                            if(NetworkIsPlayerTalking(id)) then
                                if cansee then
                                    DrawText3DID(pedCoords.x, pedCoords.y, pedCoords.z+0.5, " ".. GetPlayerServerId(id) .. " ", {140, 204, 239, 255})
                                end
                            else
                                if cansee then
                                    DrawText3DID(pedCoords.x, pedCoords.y, pedCoords.z+0.5, " ".. GetPlayerServerId(id) .. " ", {255, 255, 255, 255})
                                end
                            end
                        end
                            
                    end
                end
            end
            Citizen.Wait(0)
        else
            Citizen.Wait(500)
        end
    end
end)