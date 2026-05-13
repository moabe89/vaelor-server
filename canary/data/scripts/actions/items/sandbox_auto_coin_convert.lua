-- =====================================================================
-- FunnyOt sandbox: auto-conversao de moedas ao clicar
-- =====================================================================
-- Action que detecta uso direto em pilha de gold/platinum/crystal coin
-- e converte automaticamente sem precisar de Gold Converter:
--   100 gold coin    -> 1 platinum coin
--   100 platinum     -> 1 crystal coin
--   1 crystal coin   -> 100 platinum (volta)
--   1 platinum coin  -> 100 gold (volta)
-- =====================================================================

local ITEM_GOLD = 3031
local ITEM_PLATINUM = 3035
local ITEM_CRYSTAL = 3043

local conversionMap = {
	-- [itemId] = { up = {id, ratio}, down = {id, ratio} }
	[ITEM_GOLD] = {
		up = { id = ITEM_PLATINUM, ratio = 100 }, -- 100 gold -> 1 platinum
	},
	[ITEM_PLATINUM] = {
		up = { id = ITEM_CRYSTAL, ratio = 100 },  -- 100 platinum -> 1 crystal
		down = { id = ITEM_GOLD, ratio = 100 },   -- 1 platinum -> 100 gold
	},
	[ITEM_CRYSTAL] = {
		down = { id = ITEM_PLATINUM, ratio = 100 }, -- 1 crystal -> 100 platinum
	},
}

local autoConvert = Action()

function autoConvert.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not item or not player then
		return false
	end

	local config = conversionMap[item:getId()]
	if not config then
		return false
	end

	local count = item:getCount() or 1

	-- Se eh GOLD: tem 100+ -> sobe pra platinum (1 platinum por cada 100 gold)
	-- Se eh PLATINUM: tem 100+ -> sobe pra crystal; OU se tem < 100 -> desce pra gold
	-- Se eh CRYSTAL: tem 1+ -> desce pra platinum

	if config.up and count >= config.up.ratio then
		-- Sobe: ex: 250 gold -> 2 platinum + 50 gold sobrando
		local upCount = math.floor(count / config.up.ratio)
		local remaining = count % config.up.ratio

		item:remove(count)
		player:addItem(config.up.id, upCount)
		if remaining > 0 then
			player:addItem(item:getId(), remaining)
		end

		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(
			"%d %s convertidos em %d %s.",
			upCount * config.up.ratio,
			(item:getId() == ITEM_GOLD) and "gold coins" or "platinum coins",
			upCount,
			(config.up.id == ITEM_PLATINUM) and "platinum coin" or "crystal coin"
		))
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
		return true
	elseif config.down and count >= 1 then
		-- Desce: ex: 1 crystal -> 100 platinum; 1 platinum -> 100 gold
		item:remove(1)
		player:addItem(config.down.id, config.down.ratio)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(
			"1 %s convertido em %d %s.",
			(item:getId() == ITEM_CRYSTAL) and "crystal coin" or "platinum coin",
			config.down.ratio,
			(config.down.id == ITEM_PLATINUM) and "platinum coins" or "gold coins"
		))
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
		return true
	end

	-- Sem condicao atendida: ex: 50 gold (menos que 100), nada acontece
	return false
end

autoConvert:id(ITEM_GOLD, ITEM_PLATINUM, ITEM_CRYSTAL)
autoConvert:register()
