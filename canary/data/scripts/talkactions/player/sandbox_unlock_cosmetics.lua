-- =====================================================================
-- FunnyOt sandbox: libera mounts e outfits da Game Store (Tibia Coins)
-- =====================================================================
-- Comandos:
--   !mounts   -> libera as 143 mounts pagas com Tibia Coins no Global
--   !outfits  -> libera os 56 outfits pagos com Tibia Coins (com todos os addons)
--
-- O que NAO libera:
--   - Mounts/Outfits exclusivas de quest ou item drop (mantem o normal)
--   - Prey cards extras, blessings, runas, potions da store
--
-- Idempotente: pode rodar varias vezes, nao duplica.
-- =====================================================================

local function getStoreMounts()
	-- Le o catalogo da Game Store e retorna lista de mount IDs
	local catalog = dofile("data/modules/scripts/gamestore/catalog/cosmetics_mounts.lua")
	local ids = {}
	for _, offer in ipairs(catalog.offers or {}) do
		if offer.id and offer.type == GameStore.OfferTypes.OFFER_TYPE_MOUNT then
			table.insert(ids, offer.id)
		end
	end
	return ids
end

local function getStoreOutfits()
	-- Retorna lista de {male, female, addon}
	local catalog = dofile("data/modules/scripts/gamestore/catalog/cosmetics_outfits.lua")
	local outfits = {}
	for _, offer in ipairs(catalog.offers or {}) do
		if offer.sexId and offer.type == GameStore.OfferTypes.OFFER_TYPE_OUTFIT then
			table.insert(outfits, {
				male = offer.sexId.male,
				female = offer.sexId.female,
				addon = offer.addon or 0,
				name = offer.name or "Unknown",
			})
		end
	end
	return outfits
end

-- ===================== Comando !mounts =====================
local mountsCmd = TalkAction("!mounts")

function mountsCmd.onSay(player, words, param)
	local ok, mountIds = pcall(getStoreMounts)
	if not ok then
		player:sendTextMessage(MESSAGE_FAILURE, "Erro ao ler catalogo de mounts. Avise o GOD.")
		logger.error("[!mounts] erro: {}", tostring(mountIds))
		return false
	end

	local added = 0
	for _, id in ipairs(mountIds) do
		if not player:hasMount(id) and player:addMount(id) then
			added = added + 1
		end
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(
		"Voce ganhou %d mountarias novas (das %d disponiveis na Tibia Store). Abre o painel de mountarias (botao no canto) para ver.",
		added, #mountIds
	))
	return false
end

mountsCmd:separator(" ")
mountsCmd:groupType("normal")
mountsCmd:register()

-- ===================== Comando !outfits =====================
local outfitsCmd = TalkAction("!outfits")

function outfitsCmd.onSay(player, words, param)
	local ok, outfits = pcall(getStoreOutfits)
	if not ok then
		player:sendTextMessage(MESSAGE_FAILURE, "Erro ao ler catalogo de outfits. Avise o GOD.")
		logger.error("[!outfits] erro: {}", tostring(outfits))
		return false
	end

	local added = 0
	for _, outfit in ipairs(outfits) do
		-- Adiciona o look base (male e female) com todos os addons (1+2=3)
		if outfit.male and outfit.male > 0 then
			player:addOutfit(outfit.male)
			if outfit.addon > 0 then
				player:addOutfitAddon(outfit.male, outfit.addon)
			end
		end
		if outfit.female and outfit.female > 0 then
			player:addOutfit(outfit.female)
			if outfit.addon > 0 then
				player:addOutfitAddon(outfit.female, outfit.addon)
			end
		end
		added = added + 1
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(
		"Voce ganhou %d outfits novos (com todos os addons). Use 'Set Outfit' para escolher.",
		added
	))
	return false
end

outfitsCmd:separator(" ")
outfitsCmd:groupType("normal")
outfitsCmd:register()

-- ===================== Comando !blessings =====================
-- Libera todas as 8 blessings do Tibia (incluindo Heart of Mountain e Blood of Mountain)
local blessingsCmd = TalkAction("!blessings")

function blessingsCmd.onSay(player, words, param)
	local added = 0
	-- Blessings 1-8: Spiritual Shielding, Embrace of Tibia, Fire of the Suns,
	-- Spark of the Phoenix, Wisdom of Solitude, Twist of Fate (PvP), Blood of Mountain, Heart of Mountain
	for blessingId = 1, 8 do
		player:addBlessing(blessingId, 1)
		added = added + 1
	end
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(
		"Voce recebeu %d blessings. Penalidade de morte reduzida ao maximo.",
		added
	))
	return false
end

blessingsCmd:separator(" ")
blessingsCmd:groupType("normal")
blessingsCmd:register()

-- ===================== Comando !preyslot =====================
-- Libera o 3o prey slot permanente + 50 prey wildcards
local preyslotCmd = TalkAction("!preyslot")

function preyslotCmd.onSay(player, words, param)
	-- Adicionar 3o prey slot (PreySlot_Three = enum no canary)
	pcall(function() player:reloadPreySlot(PreySlot_Three) end)

	-- Adicionar 50 prey wildcards (servem pra rerollar bonus / lockar prey)
	pcall(function() player:addPreyCards(50) end)

	-- Hunting task 3o slot
	pcall(function() player:reloadTaskSlot(PreySlot_Three) end)

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce ganhou 3o prey slot + 50 wildcards + 3o hunting task slot.")
	return false
end

preyslotCmd:separator(" ")
preyslotCmd:groupType("normal")
preyslotCmd:register()

-- ===================== Comando !runes =====================
-- Da 250 unidades de cada runa cara da Game Store (uteis para hunts grandes)
-- (Como runas sao infinitas no FunnyOt, isso so adiciona o item inicial)
local runesCmd = TalkAction("!runes")

local STORE_RUNES = {
	-- Runas caras/uteis da store (250 unidades cada)
	{ id = 3203, name = "Animate Dead" },
	{ id = 3155, name = "Avalanche" },  -- Avalanche
	{ id = 3161, name = "Avalanche (correta)" },
	{ id = 3178, name = "Chameleon" },
	{ id = 3198, name = "Convince Creature" },
	{ id = 3197, name = "Disintegrate" },
	{ id = 3200, name = "Energy Bomb" },
	{ id = 3158, name = "Energy Field" },
	{ id = 3164, name = "Explosion" },
	{ id = 3192, name = "Fire Bomb" },
	{ id = 3188, name = "Fire Field" },
	{ id = 3190, name = "Fireball" },
	{ id = 3180, name = "Great Fireball" },
	{ id = 3191, name = "Heavy Magic Missile" },
	{ id = 3198, name = "Holy Missile" },
	{ id = 3152, name = "Icicle" },
	{ id = 3175, name = "Light Magic Missile" },
	{ id = 3174, name = "Magic Wall" },
	{ id = 3149, name = "Poison Bomb" },
	{ id = 3172, name = "Poison Field" },
	{ id = 3155, name = "Stone Shower" },
	{ id = 3155, name = "Sudden Death" },
	{ id = 3160, name = "Thunderstorm" },
	{ id = 3148, name = "Ultimate Healing" },
	{ id = 3165, name = "Wild Growth" },
}

function runesCmd.onSay(player, words, param)
	local added = 0
	local seen = {}
	for _, rune in ipairs(STORE_RUNES) do
		if not seen[rune.id] then
			seen[rune.id] = true
			player:addItem(rune.id, 100)
			added = added + 1
		end
	end
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(
		"Voce recebeu 100 unidades de %d runas diferentes (acompanha tudo da Tibia Store). Como o FunnyOt tem runas infinitas, voce nao gastara mesmo usando.",
		added
	))
	return false
end

runesCmd:separator(" ")
runesCmd:groupType("normal")
runesCmd:register()
