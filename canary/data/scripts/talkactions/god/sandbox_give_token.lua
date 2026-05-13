-- =====================================================================
-- FunnyOt sandbox: comando GOD para dar Mount/Outfit Token
-- =====================================================================
-- Uso:
--   /token mount [quantidade]   -> da N Mount Tokens (default 1)
--   /token outfit [quantidade]  -> da N Outfit Tokens (default 1)
-- =====================================================================

local TOKEN_MOUNT_ID = 6526  -- christmas token sprite
local TOKEN_OUTFIT_ID = 3534 -- white token sprite

local tokenCmd = TalkAction("/token")

function tokenCmd.onSay(player, words, param)
	logCommand(player, words, param)

	local split = param:split(" ")
	local kind = split[1]
	local amount = tonumber(split[2]) or 1

	if not kind or (kind ~= "mount" and kind ~= "outfit") then
		player:sendCancelMessage("Uso: /token mount [N]  ou  /token outfit [N]")
		return true
	end

	if amount < 1 or amount > 99 then
		amount = 1
	end

	local itemId, name
	if kind == "mount" then
		itemId = TOKEN_MOUNT_ID
		name = "Mount Token"
	else
		itemId = TOKEN_OUTFIT_ID
		name = "Outfit Token"
	end

	for i = 1, amount do
		player:addItem(itemId, 1)
	end

	player:sendTextMessage(MESSAGE_ADMINISTRATOR, string.format(
		"%d x %s adicionados ao seu inventario. Use os items para resgatar uma mount/outfit premium aleatoria.",
		amount, name
	))
	return false
end

tokenCmd:separator(" ")
tokenCmd:groupType("god")
tokenCmd:register()
