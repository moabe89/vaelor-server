-- =====================================================================
-- FunnyOt sandbox: bonus de level (lvl 20 = 40k de ouro)
-- =====================================================================
-- Quando o player avanca para o level 20 pela primeira vez, recebe 40000
-- gold coins (40k) como bonus de boas-vindas.
-- Usa storage value 90020 para marcar quem ja recebeu (impede duplicacao).
-- =====================================================================

local STORAGE_BONUS_LVL20 = 90020
local BONUS_LEVEL = 20
local BONUS_GOLD = 40000

local levelBonus = CreatureEvent("SandboxLevelBonus")

function levelBonus.onAdvance(player, skill, oldLevel, newLevel)
	-- So aplica em level (nao skill/magic level)
	if skill ~= SKILL_LEVEL then
		return true
	end

	-- So aplica quando atinge o BONUS_LEVEL pela primeira vez
	if newLevel < BONUS_LEVEL then
		return true
	end

	-- Ja recebeu antes?
	if player:getStorageValue(STORAGE_BONUS_LVL20) > 0 then
		return true
	end

	-- Marca como recebido e adiciona o ouro
	player:setStorageValue(STORAGE_BONUS_LVL20, 1)
	player:addMoney(BONUS_GOLD)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(
		"Parabens por chegar ao level %d! Voce recebeu %s de bonus de boas-vindas.",
		BONUS_LEVEL, FormatNumber(BONUS_GOLD)
	))
	player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_YELLOW)

	return true
end

levelBonus:register()

-- Registrar no onLogin pra que o evento seja capturado
local loginRegister = CreatureEvent("SandboxLevelBonusLogin")

function loginRegister.onLogin(player)
	player:registerEvent("SandboxLevelBonus")
	return true
end

loginRegister:register()
