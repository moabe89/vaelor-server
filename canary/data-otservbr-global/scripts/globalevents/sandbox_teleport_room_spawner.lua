-- =====================================================================
-- Sandbox FunnyOt: Sala Central de Teleportes
-- =====================================================================
-- Spawna dinamicamente uma "Sala de Teleportes" off-map e:
--   - 1 TP em cada templo (25 cidades) que leva ate a sala central
--   - 1 placa explicativa em cada templo
--   - ~28 TPs na sala central, cada um para um destino (quest/hunt/boss)
--   - 1 TP de volta para a sala central no destino de cada hunt
--   - 1 TP especial no centro da sala que volta para o templo de Thais
--
-- IDEMPOTENTE: ao rodar varias vezes (reload/restart), nao duplica.
-- Verifica se ja existe TP (id 1949) na posicao alvo:
--   - se sim, atualiza destino via setDestination
--   - se nao, cria via Game.createItem(1949, 1, pos)
--
-- Para a sala off-map em Position(1000, 1000, 7) — coordenada que nao
-- conflita com o mapa otservbr-global (que usa 30000-34000). Os tiles
-- da sala sao materializados dinamicamente via Game.createTile(pos, true).
-- =====================================================================

local TELEPORT_ITEM_ID = 1949  -- magic forcefield (teleport visivel classico)
local STONE_FLOOR_ITEM_ID = 416  -- stone floor (chao da sala central)
local SIGN_ITEM_ID = 2012  -- sign (placa legivel a distancia)

-- Posicao base da SALA CENTRAL DE TELEPORTES (off-map, nao colide com mapa).
-- Layout (vista do alto, norte = topo, eixo x cresce para leste):
--    [TOP-SIGN]y=992   placa "[ FunnyOt - Servidor Sandbox ]"
--    [TPs Q]   y=994   quests classicas (7 TPs em x=997..1003)
--    [TPs H1]  y=996   hunts populares parte 1 (7 TPs)
--    [TPs H2]  y=998   hunts populares parte 2 (7 TPs)
--    [TPs B]   y=1000  bosses + hunts avancadas (7 TPs)
--    [SIGNS]   y=1003  arrival no centro (1000, 1003), placa boas-vindas
--                       a oeste (999), placa lista a leste (1001)
--    [EXIT]    y=1005  x=1000 (2 tiles ao SUL do arrival, isolado)
--
-- O player entra em ARRIVAL e caminha para NORTE para escolher destino.
-- O nome de cada TP esta na sua DESCRIPTION (ver examinando o item).
-- Para SAIR, o player anda para SUL ate o EXIT.
local ROOM_CENTER = Position(1000, 998, 7)

-- Posicao do TP de SAIDA (volta para Thais), isolado ao SUL do arrival.
local ROOM_EXIT_POS = Position(1000, 1005, 7)
local ROOM_EXIT_DESTINATION = Position(32369, 32241, 7)  -- Temple de Thais

-- Posicao onde o player CHEGA quando pega o TP do templo (entrada sul da sala).
local ROOM_ARRIVAL_POS = Position(1000, 1003, 7)

-- =====================================================================
-- DESTINOS (28 TPs em grid 7 colunas x 4 linhas)
-- Coordenadas validadas em scripts oficiais do otservbr-global
-- (POI bridge, Anni lever, Inquisition teleport_main, Demon Helmet lever,
--  Demon Oak quest lib, Soul War lib, Ferumbras vortex, raids/*.xml etc).
--
-- Layout no eixo X: 7 colunas em x=997..1003 (centradas em x=1000)
-- Layout no eixo Y (so TPs, sem signs entre eles):
--   y=994 = TP da linha 1 (QUESTS CLASSICAS)
--   y=996 = TP da linha 2 (HUNTS PARTE 1)
--   y=998 = TP da linha 3 (HUNTS PARTE 2)
--   y=1000= TP da linha 4 (HUNTS AVANCADAS / BOSSES)
-- Entre as linhas, tiles vazios servem de corredor norte-sul.
-- =====================================================================
local DESTINATIONS = {
	-- =================== LINHA 1: QUESTS CLASSICAS (y=994) ===================
	{
		name = "Pits of Inferno (POI)",
		roomPos = Position(997, 994, 7),
		destPos = Position(32851, 32310, 11),
		backPos = Position(32851, 32311, 11),
	},
	{
		name = "Annihilator",
		roomPos = Position(998, 994, 7),
		destPos = Position(33222, 31671, 13),
		backPos = Position(33222, 31672, 13),
	},
	{
		name = "Demon Helmet",
		roomPos = Position(999, 994, 7),
		destPos = Position(33316, 31574, 15),
		backPos = Position(33316, 31575, 15),
	},
	{
		name = "Demon Oak",
		roomPos = Position(1000, 994, 7),
		destPos = Position(32716, 32347, 7),
		backPos = Position(32716, 32348, 7),
	},
	{
		name = "Inquisition (Retreat)",
		roomPos = Position(1001, 994, 7),
		destPos = Position(33165, 31709, 14),
		backPos = Position(33166, 31709, 14),
	},
	{
		name = "Ferumbras Ascendant",
		roomPos = Position(1002, 994, 7),
		destPos = Position(33392, 31473, 14),
		backPos = Position(33393, 31473, 14),
	},
	{
		name = "Heart of Destruction (Soul War)",
		roomPos = Position(1003, 994, 7),
		destPos = Position(33780, 31634, 14),
		backPos = Position(33781, 31634, 14),
	},

	-- =================== LINHA 2: HUNTS PARTE 1 (y=996) ===================
	{
		name = "Orc Fortress",
		roomPos = Position(997, 996, 7),
		destPos = Position(32953, 31602, 7),
		backPos = Position(32953, 31603, 7),
	},
	{
		name = "Liches (Edron Hell)",
		roomPos = Position(998, 996, 7),
		destPos = Position(33191, 31915, 13),
		backPos = Position(33192, 31915, 13),
	},
	{
		name = "Hydras (Liberty Bay)",
		roomPos = Position(999, 996, 7),
		destPos = Position(32683, 32757, 9),
		backPos = Position(32684, 32757, 9),
	},
	{
		name = "Sea Serpents",
		roomPos = Position(1000, 996, 7),
		destPos = Position(32108, 32412, 9),
		backPos = Position(32109, 32412, 9),
	},
	{
		name = "Demons (Edron Hell)",
		roomPos = Position(1001, 996, 7),
		destPos = Position(33216, 31816, 13),
		backPos = Position(33217, 31816, 13),
	},
	{
		name = "Dragon Lords (Cyclopolis)",
		roomPos = Position(1002, 996, 7),
		destPos = Position(33291, 31787, 9),
		backPos = Position(33292, 31787, 9),
	},
	{
		name = "Drakens (Razachai/Yalahar)",
		roomPos = Position(1003, 996, 7),
		destPos = Position(33390, 31188, 8),
		backPos = Position(33391, 31188, 8),
	},

	-- =================== LINHA 3: HUNTS PARTE 2 (y=998) ===================
	{
		name = "Behemoths (Edron)",
		roomPos = Position(997, 998, 7),
		destPos = Position(33217, 31933, 14),
		backPos = Position(33218, 31933, 14),
	},
	{
		name = "Vampires (Drefia)",
		roomPos = Position(998, 998, 7),
		destPos = Position(33077, 32426, 11),
		backPos = Position(33078, 32426, 11),
	},
	{
		name = "Wyrms (Cyclopolis)",
		roomPos = Position(999, 998, 7),
		destPos = Position(33294, 31818, 8),
		backPos = Position(33295, 31818, 8),
	},
	{
		name = "Giant Spiders (Elven Bane)",
		roomPos = Position(1000, 998, 7),
		destPos = Position(32664, 31745, 9),
		backPos = Position(32665, 31745, 9),
	},
	{
		name = "Werewolves (Grimvale)",
		roomPos = Position(1001, 998, 7),
		destPos = Position(33444, 31578, 9),
		backPos = Position(33445, 31578, 9),
	},
	{
		name = "Hellhounds (Demona)",
		roomPos = Position(1002, 998, 7),
		destPos = Position(33034, 32296, 9),
		backPos = Position(33035, 32296, 9),
	},
	{
		name = "Cobra Bastion",
		roomPos = Position(1003, 998, 7),
		destPos = Position(33397, 32606, 7),
		backPos = Position(33398, 32606, 7),
	},

	-- =================== LINHA 4: AVANCADAS + BOSSES (y=1000) ===================
	{
		name = "Souleaters (Roshamuul)",
		roomPos = Position(997, 1000, 7),
		destPos = Position(33532, 32330, 11),
		backPos = Position(33533, 32330, 11),
	},
	{
		name = "Forbidden Lands",
		roomPos = Position(998, 1000, 7),
		destPos = Position(32881, 31698, 8),
		backPos = Position(32882, 31698, 8),
	},
	{
		name = "Yalahar Sewers",
		roomPos = Position(999, 1000, 7),
		destPos = Position(32787, 31261, 8),
		backPos = Position(32788, 31261, 8),
	},
	{
		name = "Falcon Bastion",
		roomPos = Position(1000, 1000, 7),
		destPos = Position(33330, 31477, 9),
		backPos = Position(33331, 31477, 9),
	},
	{
		name = "Ferumbras (Boss raid spawn)",
		roomPos = Position(1001, 1000, 7),
		destPos = Position(32124, 32687, 4),
		backPos = Position(32125, 32687, 4),
	},
	{
		name = "Ghazbaran (Boss raid spawn)",
		roomPos = Position(1002, 1000, 7),
		destPos = Position(32228, 31163, 15),
		backPos = Position(32229, 31163, 15),
	},
	{
		name = "Morgaroth (Boss raid spawn)",
		roomPos = Position(1003, 1000, 7),
		destPos = Position(32063, 32612, 14),
		backPos = Position(32064, 32612, 14),
	},
}

-- TEMPLOS: Cidades onde plantamos o TP de IDA para a sala.
-- Replica a lista usada em sandbox_funny_trader_spawner.lua.
-- Tentamos varios offsets a partir do templo, do mais proximo ao mais distante,
-- ate encontrar um tile valido (sem parede, sem outro item bloqueante).
-- Offsets como tabela simples {dx, dy} (z nao muda).
local TEMPLE_TP_OFFSET_CANDIDATES = {
	{ 1, 0 },    -- 1 leste
	{ -1, 0 },   -- 1 oeste
	{ 0, 1 },    -- 1 sul
	{ 0, -1 },   -- 1 norte
	{ 2, 0 },    -- 2 leste
	{ -2, 0 },   -- 2 oeste
	{ 0, 2 },    -- 2 sul
	{ 0, -2 },   -- 2 norte
}

local SPAWN_TOWNS = {
	{ townId = TOWNS_LIST.ROOKGAARD,         label = "Rookgaard" },
	{ townId = TOWNS_LIST.DAWNPORT,          label = "Dawnport" },
	{ townId = TOWNS_LIST.AB_DENDRIEL,       label = "Ab'Dendriel" },
	{ townId = TOWNS_LIST.THAIS,             label = "Thais" },
	{ townId = TOWNS_LIST.CARLIN,            label = "Carlin" },
	{ townId = TOWNS_LIST.KAZORDOON,         label = "Kazordoon" },
	{ townId = TOWNS_LIST.VENORE,            label = "Venore" },
	{ townId = TOWNS_LIST.EDRON,             label = "Edron" },
	{ townId = TOWNS_LIST.ANKRAHMUN,         label = "Ankrahmun" },
	{ townId = TOWNS_LIST.DARASHIA,          label = "Darashia" },
	{ townId = TOWNS_LIST.PORT_HOPE,         label = "Port Hope" },
	{ townId = TOWNS_LIST.LIBERTY_BAY,       label = "Liberty Bay" },
	{ townId = TOWNS_LIST.SVARGROND,         label = "Svargrond" },
	{ townId = TOWNS_LIST.YALAHAR,           label = "Yalahar" },
	{ townId = TOWNS_LIST.FARMINE,           label = "Farmine" },
	{ townId = TOWNS_LIST.GRAY_BEACH,        label = "Gray Beach" },
	{ townId = TOWNS_LIST.KRAILOS,           label = "Krailos" },
	{ townId = TOWNS_LIST.RATHLETON,         label = "Rathleton" },
	{ townId = TOWNS_LIST.ROSHAMUUL,         label = "Roshamuul" },
	{ townId = TOWNS_LIST.ISSAVI,            label = "Issavi" },
	{ townId = TOWNS_LIST.COBRA_BASTION,     label = "Cobra Bastion" },
	{ townId = TOWNS_LIST.BOUNAC,            label = "Bounac" },
	{ townId = TOWNS_LIST.FEYRIST,           label = "Feyrist" },
	{ townId = TOWNS_LIST.ISLAND_OF_DESTINY, label = "Island of Destiny" },
}

-- Texto da placa em todos os templos.
local TEMPLE_SIGN_TEXT = table.concat({
	"[ Sala de Teleportes - FunnyOt ]",
	"",
	"Pise no portal magico ao lado para",
	"acessar a Sala Central de Teleportes.",
	"",
	"De la voce escolhe seu destino:",
	"hunts populares, quests classicas",
	"e arenas de boss.",
	"",
	"Para voltar, use o portal AZUL",
	"no centro da sala (volta para Thais),",
	"ou os portais de cada destino.",
}, "\n")

-- =====================================================================
-- HELPERS
-- =====================================================================

-- Garante que ha um tile na posicao (cria dinamicamente se nao houver).
-- Retorna o Tile (ou nil em caso de falha).
local function ensureTile(pos)
	local tile = Tile(pos)
	if tile then
		return tile
	end
	-- isDynamic=true → tile fica vivo enquanto o servidor estiver up
	Game.createTile(pos, true)
	return Tile(pos)
end

-- Garante que ha chao (id STONE_FLOOR_ITEM_ID) no tile.
-- So usado para a sala off-map (tiles dinamicos sem ground).
local function ensureFloor(pos)
	local tile = ensureTile(pos)
	if not tile then
		return false
	end
	-- Se ja tem chao da sala, ok
	if tile:getItemById(STONE_FLOOR_ITEM_ID) then
		return true
	end
	-- Se ja tem QUALQUER ground item, ok tambem
	if tile:getGround() then
		return true
	end
	Game.createItem(STONE_FLOOR_ITEM_ID, 1, pos)
	return Tile(pos) ~= nil
end

-- Cria ou atualiza um TP visivel na posicao com destino dado.
-- Se descriptionText for fornecido, define como descricao do item (mostrada
-- ao examinar o TP no jogo).
-- Retorna true em sucesso, false em falha.
local function placeTeleport(pos, destination, contextLabel, descriptionText)
	if not pos or pos.x == 0 then
		logger.warn("[TeleportRoom] Posicao invalida para TP '{}'", contextLabel)
		return false
	end

	local tile = Tile(pos)
	if not tile then
		logger.warn("[TeleportRoom] Sem tile em ({}, {}, {}) para TP '{}' - skipping", pos.x, pos.y, pos.z, contextLabel)
		return false
	end

	-- Ja existe TP nesse tile? Atualiza destino + descricao.
	local existing = tile:getItemById(TELEPORT_ITEM_ID)
	if existing then
		existing:setDestination(destination)
		if descriptionText and descriptionText ~= "" then
			existing:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, descriptionText)
		end
		logger.info("[TeleportRoom] TP '{}' ja existia em ({}, {}, {}). Destino atualizado para ({}, {}, {}).",
			contextLabel, pos.x, pos.y, pos.z, destination.x, destination.y, destination.z)
		return true
	end

	-- Cria novo TP
	local tp = Game.createItem(TELEPORT_ITEM_ID, 1, pos)
	if not tp then
		logger.warn("[TeleportRoom] FALHA Game.createItem(1949) em ({}, {}, {}) para TP '{}'",
			pos.x, pos.y, pos.z, contextLabel)
		return false
	end
	tp:setDestination(destination)
	if descriptionText and descriptionText ~= "" then
		tp:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, descriptionText)
	end
	pos:sendMagicEffect(CONST_ME_TELEPORT)
	logger.info("[TeleportRoom] TP '{}' criado em ({}, {}, {}) -> ({}, {}, {})",
		contextLabel, pos.x, pos.y, pos.z, destination.x, destination.y, destination.z)
	return true
end

-- Cria ou atualiza uma placa com texto. Idempotente.
local function placeSign(pos, text, contextLabel)
	if not pos or pos.x == 0 then
		return false
	end

	local tile = Tile(pos)
	if not tile then
		logger.warn("[TeleportRoom] Sem tile em ({}, {}, {}) para placa '{}'", pos.x, pos.y, pos.z, contextLabel)
		return false
	end

	local existing = tile:getItemById(SIGN_ITEM_ID)
	if existing then
		existing:setAttribute(ITEM_ATTRIBUTE_TEXT, text)
		return true
	end

	local sign = Game.createItem(SIGN_ITEM_ID, 1, pos)
	if not sign then
		logger.warn("[TeleportRoom] FALHA criar placa em ({}, {}, {}) para '{}'", pos.x, pos.y, pos.z, contextLabel)
		return false
	end
	sign:setAttribute(ITEM_ATTRIBUTE_TEXT, text)
	return true
end

-- =====================================================================
-- BUILDERS
-- =====================================================================

-- Constroi a SALA CENTRAL off-map.
-- 1) Cria tiles dinamicamente + chao em toda a area
-- 2) Cria 28 TPs de destino (descricao = nome do destino)
-- 3) Cria TP de saida (volta para Thais) ao sul do arrival
-- 4) Cria placas: boas-vindas (canto SO), lista (canto SE), saida (lado do exit),
--    decorativa (norte).
local function buildCentralRoom()
	local placed, failed = 0, 0

	-- Bounding box: cobre TODA a sala incluindo corredores
	-- x: 996 (corredor oeste) ate 1004 (corredor leste), 9 colunas
	-- y: 992 (placa decorativa) ate 1006 (sul do EXIT), 15 linhas
	local fromX, toX = 996, 1004
	local fromY, toY = 992, 1006
	local z = ROOM_CENTER.z

	-- 1. Materializa tiles + chao da sala (toda a area)
	for x = fromX, toX do
		for y = fromY, toY do
			local pos = Position(x, y, z)
			if not ensureFloor(pos) then
				logger.warn("[TeleportRoom] Falha ao garantir chao em ({}, {}, {})", x, y, z)
			end
		end
	end

	-- 2. Cria TPs de destino. O nome do destino e gravado como descricao do
	-- item (visivel ao examinar o portal no jogo). Sem placas no chao para
	-- nao bloquear o caminho do player no corredor.
	for _, dest in ipairs(DESTINATIONS) do
		local roomPos = dest.roomPos
		local desc = "Portal para: " .. dest.name
		if placeTeleport(roomPos, dest.destPos, dest.name, desc) then
			placed = placed + 1
		else
			failed = failed + 1
		end
	end

	-- 3. TP DE SAIDA (volta para Thais) — 2 tiles ao SUL do arrival.
	-- ROOM_ARRIVAL=(1000,1003), ROOM_EXIT=(1000,1005). Player precisa andar
	-- pra SUL deliberadamente para sair (nao tropeca por engano).
	if placeTeleport(ROOM_EXIT_POS, ROOM_EXIT_DESTINATION, "SAIDA-Thais", "Portal para: Templo de Thais (saida)") then
		placed = placed + 1
	else
		failed = failed + 1
	end

	-- Placa de saida 1 tile A LESTE do TP de saida (nao bloqueia o caminho).
	local exitSignPos = Position(ROOM_EXIT_POS.x + 1, ROOM_EXIT_POS.y, ROOM_EXIT_POS.z)
	placeSign(exitSignPos, table.concat({
		"[ SAIDA - Voltar a Thais ]",
		"",
		"Pise no portal AZUL ao lado",
		"para voltar ao templo de Thais.",
	}, "\n"), "exit-sign")

	-- Placas de boas-vindas e lista FORA da linha de arrival (y=1002).
	-- Assim o player pode caminhar livremente em y=1003 sem barragens.
	local welcomePos = Position(996, 1002, 7)  -- canto SO
	placeSign(welcomePos, table.concat({
		"[ Sala Central de Teleportes - FunnyOt ]",
		"",
		"Bem-vindo! Caminhe para o NORTE",
		"para escolher seu destino.",
		"",
		"Examine (olhe) cada portal para",
		"ver o nome do destino.",
		"",
		"Linhas (norte -> sul):",
		"  1) Quests classicas (7 portais)",
		"  2) Hunts parte 1 (7 portais)",
		"  3) Hunts parte 2 (7 portais)",
		"  4) Avancadas e bosses (7 portais)",
		"",
		"Use os corredores nas extremidades",
		"(x=996 oeste ou x=1004 leste) para",
		"chegar a cada linha sem ativar",
		"portais por engano.",
		"",
		"Para SAIR: caminhe 2 tiles para o",
		"SUL e pise no portal azul (volta",
		"para o templo de Thais).",
	}, "\n"), "welcome-sign")

	-- Placa lista detalhada de destinos no canto SE.
	local listSignPos = Position(1004, 1002, 7)
	placeSign(listSignPos, table.concat({
		"[ Lista de Destinos ]",
		"",
		"Linha 1 (quests): POI, Anni,",
		"Demon Helmet, Demon Oak,",
		"Inquisition, Ferumbras Asc,",
		"Soul War.",
		"",
		"Linha 2: Orc Fortress, Liches,",
		"Hydras, Sea Serpents, Demons,",
		"Dragon Lords, Drakens.",
		"",
		"Linha 3: Behemoths, Vampires,",
		"Wyrms, Giant Spiders,",
		"Werewolves, Hellhounds, Cobra.",
		"",
		"Linha 4: Souleaters, Forbidden,",
		"Yalahar, Falcon, Ferumbras,",
		"Ghazbaran, Morgaroth.",
	}, "\n"), "list-sign")

	-- Placa decorativa no extremo norte da sala (centro x=1000, y=992).
	-- y=992 esta fora da grade de TPs (TPs comecam em y=994), ok.
	local topSignPos = Position(1000, 992, 7)
	placeSign(topSignPos, table.concat({
		"[ FunnyOt - Servidor Sandbox ]",
		"",
		"Rates altas, itens infinitos,",
		"acesso a todas as hunts!",
	}, "\n"), "top-sign")

	return placed, failed
end

-- Para cada destino, cria 1 TP de VOLTA no backPos apontando para ROOM_ARRIVAL_POS.
local function placeReturnTeleports()
	local placed, failed = 0, 0
	for _, dest in ipairs(DESTINATIONS) do
		local desc = "Portal de retorno: volta para a Sala Central de Teleportes"
		if placeTeleport(dest.backPos, ROOM_ARRIVAL_POS, "VOLTA-" .. dest.name, desc) then
			placed = placed + 1
		else
			failed = failed + 1
		end
	end
	return placed, failed
end

-- Procura um tile valido (walkable + livre) a partir de basePos testando offsets.
-- Retorna a Position do primeiro tile valido, ou nil se nenhum servir.
local function findFreeTileAroundTemple(basePos)
	for _, off in ipairs(TEMPLE_TP_OFFSET_CANDIDATES) do
		local p = Position(basePos.x + off[1], basePos.y + off[2], basePos.z)
		local tile = Tile(p)
		if tile then
			-- Tem que ter chao (ground)
			if tile:getGround() then
				-- Nao pode ser bloqueante (parede)
				if not tile:hasProperty(CONST_PROP_BLOCKSOLID) then
					-- Nao pode ja ter TP de outro tipo (mas se ja tem 1949 nosso, ok)
					return p
				end
			end
		end
	end
	return nil
end

-- Coloca em cada templo 1 TP de IDA + 1 placa em tile adjacente.
local function placeTempleTeleports()
	local placed, failed = 0, 0

	for _, entry in ipairs(SPAWN_TOWNS) do
		local town = Town(entry.townId)
		if not town then
			logger.warn("[TeleportRoom] Town '{}' (id {}) nao encontrada - skipping", entry.label, entry.townId or "?")
			failed = failed + 1
		else
			local templePos = town:getTemplePosition()
			if not templePos or templePos.x == 0 then
				logger.warn("[TeleportRoom] Templo de '{}' tem posicao invalida - skipping", entry.label)
				failed = failed + 1
			else
				-- Procura tile livre ao redor do templo
				local tpPos = findFreeTileAroundTemple(templePos)
				if not tpPos then
					logger.warn("[TeleportRoom] Nenhum tile livre ao redor do templo '{}' - skipping", entry.label)
					failed = failed + 1
				else
					local desc = "Portal para: Sala Central de Teleportes (FunnyOt)"
					if placeTeleport(tpPos, ROOM_ARRIVAL_POS, "TEMPLO-" .. entry.label, desc) then
						placed = placed + 1
						-- Tenta colocar a placa em um tile adjacente diferente do TP
						for _, signOff in ipairs(TEMPLE_TP_OFFSET_CANDIDATES) do
							local sp = Position(templePos.x + signOff[1], templePos.y + signOff[2], templePos.z)
							if sp.x ~= tpPos.x or sp.y ~= tpPos.y then
								local stile = Tile(sp)
								if stile and stile:getGround() and not stile:hasProperty(CONST_PROP_BLOCKSOLID) then
									placeSign(sp, TEMPLE_SIGN_TEXT, "TEMPLE-SIGN-" .. entry.label)
									break
								end
							end
						end
					else
						failed = failed + 1
					end
				end
			end
		end
	end

	return placed, failed
end

-- =====================================================================
-- GLOBAL EVENT
-- =====================================================================

local teleportRoomSpawner = GlobalEvent("SandboxTeleportRoomSpawner")

function teleportRoomSpawner.onStartup()
	logger.info("[TeleportRoom] Iniciando spawn da Sala Central de Teleportes...")

	local roomPlaced, roomFailed = buildCentralRoom()
	local templePlaced, templeFailed = placeTempleTeleports()
	local backPlaced, backFailed = placeReturnTeleports()

	local totalPlaced = roomPlaced + templePlaced + backPlaced
	local totalFailed = roomFailed + templeFailed + backFailed

	logger.info("[TeleportRoom] === RESUMO ===")
	logger.info("[TeleportRoom] Sala Central:     {} TPs OK, {} falhas", roomPlaced, roomFailed)
	logger.info("[TeleportRoom] Templos cidades:  {} TPs OK, {} falhas", templePlaced, templeFailed)
	logger.info("[TeleportRoom] TPs de volta:     {} TPs OK, {} falhas", backPlaced, backFailed)
	logger.info("[TeleportRoom] TOTAL:            {} TPs spawned, {} falhas.", totalPlaced, totalFailed)
	logger.info("[TeleportRoom] Sala central em ({}, {}, {}). Arrival em ({}, {}, {}). Saida em ({}, {}, {}).",
		ROOM_CENTER.x, ROOM_CENTER.y, ROOM_CENTER.z,
		ROOM_ARRIVAL_POS.x, ROOM_ARRIVAL_POS.y, ROOM_ARRIVAL_POS.z,
		ROOM_EXIT_POS.x, ROOM_EXIT_POS.y, ROOM_EXIT_POS.z)

	return true
end

teleportRoomSpawner:register()
