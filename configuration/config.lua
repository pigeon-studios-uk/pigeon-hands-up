Config = {}

-- Language for the text players see. 'auto' follows ox_lib's language (setr ox:locale "de" in
-- server.cfg) and is English when that isn't set. Or name a file from locales/, such as 'de' or 'pt-br'.
Config.Locale = 'auto'

-- Hands up: the key and the command. Players can change the key in GTA's Settings -> Key Bindings ->
-- FiveM. Codes: https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
Config.HandsUpKey = 'X'
Config.HandsUpCommand = 'handsup'

-- Kneel with hands behind the head: the key and the command. '' leaves the key unbound until a player
-- chooses one; the command always works.
Config.KneelKey = ''
Config.KneelCommand = 'kneel'

-- Players can walk with their hands up. false keeps them standing still.
Config.WalkWithHandsUp = true

-- Tell players when they can't put their hands up or kneel (in a vehicle, swimming or falling).
Config.ShowMessages = true

-- How messages are shown.
-- 'auto' uses ox_lib notifications if ox_lib is running, otherwise GTA's notification feed.
-- 'ox_lib' or 'gta' to force one.
Config.Notifications = 'auto'

-- Update checks are controlled in server.cfg for every Pigeon Studios resource at once:
--     set pigeon_update_check "on"      (default)  |  "quiet"  |  "off"
