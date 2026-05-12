-- =====================================================================
-- Sandbox FunnyOt: Spawner do "Funny Trader" em cada templo de cidade
-- =====================================================================
-- Ao subir o servidor, este script spawna 1 NPC "Funny Trader" no templo
-- de cada cidade definida em TOWNS_LIST + uma posicao hardcoded para
-- Marapur (que nao e uma town oficial, apenas um destino de voo).
--
-- Idempotente: se ja existe um Funny Trader na posicao alvo, nao duplica.
-- =====================================================================

local NPC_NAME = "Funny Trader"

-- Cidades onde o NPC deve aparecer.
-- Cada entrada usa o ID de TOWNS_LIST para pegar a temple position via API.
-- Cidades sem entrada oficial (ex: Marapur) sao definidas como fallback.
local SPAWN_TOWNS = {
	-- ID em TOWNS_LIST            | nome amigavel para log
	{ townId = TOWNS_LIST.ROOKGAARD,        label = "Rookgaard" },
	{ townId = TOWNS_LIST.DAWNPORT,         label = "Dawnport" },
	{ townId = TOWNS_LIST.AB_DENDRIEL,      label = "Ab'Dendriel" },
	{ townId = TOWNS_LIST.THAIS,            label = "Thais" },
	{ townId = TOWNS_LIST.CARLIN,           label = "Carlin" },
	{ townId = TOWNS_LIST.KAZORDOON,        label = "Kazordoon" },
	{ townId = TOWNS_LIST.VENORE,           label = "Venore" },
	{ townId = TOWNS_LIST.EDRON,            label = "Edron" },
	{ townId = TOWNS_LIST.ANKRAHMUN,        label = "Ankrahmun" },
	{ townId = TOWNS_LIST.DARASHIA,         label = "Darashia" },
	{ townId = TOWNS_LIST.PORT_HOPE,        label = "Port Hope" },
	{ townId = TOWNS_LIST.LIBERTY_BAY,      label = "Liberty Bay" },
	{ townId = TOWNS_LIST.SVARGROND,        label = "Svargrond" },
	{ townId = TOWNS_LIST.YALAHAR,          label = "Yalahar" },
	{ townId = TOWNS_LIST.FARMINE,          label = "Farmine" },
	{ townId = TOWNS_LIST.GRAY_BEACH,       label = "Gray Beach" },
	{ townId = TOWNS_LIST.KRAILOS,          label = "Krailos" },
	{ townId = TOWNS_LIST.RATHLETON,        label = "Rathleton" },
	{ townId = TOWNS_LIST.ROSHAMUUL,        label = "Roshamuul" },
	{ townId = TOWNS_LIST.ISSAVI,           label = "Issavi" },
	{ townId = TOWNS_LIST.COBRA_BASTION,    label = "Cobra Bastion" },
	{ townId = TOWNS_LIST.BOUNAC,           label = "Bounac" },
	{ townId = TOWNS_LIST.FEYRIST,          label = "Feyrist" },
	{ townId = TOWNS_LIST.ISLAND_OF_DESTINY, label = "Island of Destiny" },
}

-- Cidades/destinos que nao estao em TOWNS_LIST mas sao destinos do mapa.
-- Posicao para Marapur extraida de npc/chemar.lua (addTravelKeyword).
local EXTRA_SPAWNS = {
	{ position = Position(33805, 32767, 2), label = "Marapur" },
}

-- Verifica se ja existe um NPC com nome `npcName` proximo a `pos`.
-- Usa Game.getSpectators (onlyPlayers=false) para varrer criaturas no raio.
-- Evita duplicar NPCs em reloads / multiplos onStartup.
local function isNpcAlreadyAt(npcName, pos)
	local spectators = Game.getSpectators(pos, false, false, 1, 1, 1, 1)
	for _, creature in ipairs(spectators) do
		if creature:isNpc() and creature:getName() == npcName then
			return true
		end
	end
	return false
end

local function trySpawnAt(pos, label)
	if not pos or pos.x == 0 then
		logger.warn("[FunnyTraderSpawner] Posicao invalida para {} - skipping", label)
		return false
	end

	if isNpcAlreadyAt(NPC_NAME, pos) then
		logger.info("[FunnyTraderSpawner] {} ja existe em {} ({}, {}, {}). Skipping.", NPC_NAME, label, pos.x, pos.y, pos.z)
		return true
	end

	local npc = Game.createNpc(NPC_NAME, pos)
	if not npc then
		logger.warn("[FunnyTraderSpawner] FALHA ao criar NPC em {} ({}, {}, {})", label, pos.x, pos.y, pos.z)
		return false
	end

	npc:setMasterPos(pos)
	pos:sendMagicEffect(CONST_ME_TELEPORT)
	logger.info("[FunnyTraderSpawner] Funny Trader spawnado em {} ({}, {}, {})", label, pos.x, pos.y, pos.z)
	return true
end

local funnyTraderSpawner = GlobalEvent("SandboxFunnyTraderSpawner")

function funnyTraderSpawner.onStartup()
	local spawned = 0
	local failed = 0

	-- Spawns nas cidades oficiais (via Town:getTemplePosition)
	for _, entry in ipairs(SPAWN_TOWNS) do
		if not entry.townId then
			logger.warn("[FunnyTraderSpawner] townId nao definido para {} - skipping", entry.label)
			failed = failed + 1
		else
			local town = Town(entry.townId)
			if not town then
				logger.warn("[FunnyTraderSpawner] Town ID {} ({}) nao encontrada - skipping", entry.townId, entry.label)
				failed = failed + 1
			else
				local pos = town:getTemplePosition()
				if trySpawnAt(pos, entry.label) then
					spawned = spawned + 1
				else
					failed = failed + 1
				end
			end
		end
	end

	-- Spawns extras (Marapur etc., posicoes hardcoded)
	for _, entry in ipairs(EXTRA_SPAWNS) do
		if trySpawnAt(entry.position, entry.label) then
			spawned = spawned + 1
		else
			failed = failed + 1
		end
	end

	logger.info("[FunnyTraderSpawner] Concluido: {} NPCs criados, {} falhas.", spawned, failed)
	return true
end

funnyTraderSpawner:register()
