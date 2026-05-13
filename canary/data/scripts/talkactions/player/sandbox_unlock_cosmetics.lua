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
