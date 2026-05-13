-- =====================================================================
-- FunnyOt sandbox: Mount Token e Outfit Token (premium)
-- =====================================================================
-- Sao items que ao usar dao uma mount ou outfit aleatoria de uma lista
-- "premium" (raras/exclusivas que nao saem no !mounts/!outfits).
--
-- Items base (reaproveitam sprites existentes):
--   Mount Token  = christmas token (id 6526)  + actionId 60001
--   Outfit Token = white token     (id 3534)  + actionId 60002
--
-- Como dar pro player:
--   Use o comando /token mount   (cria 1 Mount Token na inbox)
--   Use o comando /token outfit  (cria 1 Outfit Token na inbox)
--
-- Cada uso do token consome 1 unidade e da 1 mount/outfit aleatoria.
-- Se ja tem todas, avisa.
-- =====================================================================

-- IDs de actionId que diferenciam tokens "normais" de tokens FunnyOt
local MOUNT_TOKEN_ACTIONID = 60001
local OUTFIT_TOKEN_ACTIONID = 60002

-- Lista de mounts PREMIUM (raras, geralmente eventos sazonais ou top tier)
-- IDs validadas em data/XML/mounts.xml
local PREMIUM_MOUNTS = {
	158, -- Crystal Wolf (event)
	159, -- Bat
	170, -- Glooth Glider
	171, -- Shadow Hart
	185, -- Death Crawler
	194, -- Singeing Steed
	195, -- Eldritch Dragon
	250, -- Husky
	309, -- Phant
	350, -- Cunning Hyaena
	1742, -- ID alto recente
	1743,
	1744,
	1810,
	1833,
	1834,
	1835,
}

-- Lista de outfits PREMIUM (raras)
-- looktypes validados em data/XML/outfits.xml
local PREMIUM_OUTFITS = {
	-- {male, female}
	{ 1808, 1809 }, -- recente
	{ 1774, 1775 },
	{ 1776, 1777 },
	{ 1824, 1825 },
	{ 1831, 1832 },
}

local function pickRandom(list)
	return list[math.random(#list)]
end

-- ============= ACTION: Mount Token =============
local mountTokenAction = Action()

function mountTokenAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player or not item then
		return true
	end

	-- Tentar achar uma mount que o player ainda nao tem
	local attempts = 0
	local maxAttempts = 30
	local givenId = nil

	while attempts < maxAttempts do
		attempts = attempts + 1
		local mountId = pickRandom(PREMIUM_MOUNTS)
		if not player:hasMount(mountId) then
			player:addMount(mountId)
			givenId = mountId
			break
		end
	end

	if not givenId then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce ja possui todas as mountarias premium do FunnyOt!")
		return true
	end

	item:remove(1)
	player:getPosition():sendMagicEffect(CONST_ME_HOLYDAMAGE)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(
		"Mount Token consumido. Voce ganhou uma nova mountaria premium! (ID %d)",
		givenId
	))
	return true
end

mountTokenAction:id(6526) -- christmas token
mountTokenAction:register()

-- ============= ACTION: Outfit Token =============
local outfitTokenAction = Action()

function outfitTokenAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player or not item then
		return true
	end

	-- Tentar achar um outfit que o player ainda nao tem
	local attempts = 0
	local maxAttempts = 20
	local givenName = nil

	while attempts < maxAttempts do
		attempts = attempts + 1
		local outfit = pickRandom(PREMIUM_OUTFITS)
		local male, female = outfit[1], outfit[2]

		-- Considera "tem" se ja tem o look base; senao adiciona ambos
		if not player:hasOutfit(male) or not player:hasOutfit(female) then
			player:addOutfit(male)
			player:addOutfit(female)
			player:addOutfitAddon(male, 3)
			player:addOutfitAddon(female, 3)
			givenName = string.format("M:%d / F:%d", male, female)
			break
		end
	end

	if not givenName then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce ja possui todos os outfits premium do FunnyOt!")
		return true
	end

	item:remove(1)
	player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(
		"Outfit Token consumido. Voce ganhou um novo outfit premium com todos os addons! (%s)",
		givenName
	))
	return true
end

outfitTokenAction:id(3534) -- white token
outfitTokenAction:register()
