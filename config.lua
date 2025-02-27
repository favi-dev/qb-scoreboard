Config = Config or {}

-- Key to open the scoreboard
Config.OpenKey = 'HOME' -- https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/

Config.Toggle = true -- If false, the scoreboard remains open only while the OpenKey is pressed, if true, the scoreboard opens and closes with the OpenKey.

-- Maximum number of players on the server
Config.MaxPlayers = GetConvarInt('sv_maxclients', 120) -- If the value is not found, it will return 48

-- Minimum police for actions
Config.IllegalActions = {
    [1] = {
        minimumPolice = 2,
        busy = false,
        label = "Kidnapping"
    },
    [2] = {
        minimumPolice = 2,
        busy = false,
        label = "Store Robbery"
    },
    [3] = {
        minimumPolice = 3,
        busy = false,
        label = "ATM Robbery"
    },
    [4] = {
        minimumPolice = 3,
        busy = false,
        label = "Home Robbery"
    },
    [5] = {
        minimumPolice = 7,
        busy = false,
        label = "CashExchange Robbery"
    },
    [6] = {
        minimumPolice = 8,
        busy = false,
        label = "Laundromat Robbery"
    },
    [7] = {
        minimumPolice = 9,
        busy = false,
        label = "Fleeca Robbery"
    },
}
