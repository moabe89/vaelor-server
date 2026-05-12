-- =====================================================================
-- Funny Trader - NPC vendedor sandbox para o servidor FunnyOt
-- =====================================================================
-- Vende TODOS os supplies (potions, runas, ammo, ferramentas) com precos
-- padrao Tibia, e COMPRA todos os loots comuns (incluindo armaduras,
-- armas, joias) pelos mesmos precos que o Rashid pagaria.
--
-- Spawn: feito via scripts/globalevents/sandbox_funny_trader_spawner.lua
-- (uma copia em cada templo de cidade ao subir o servidor).
-- =====================================================================

local internalNpcName = "Funny Trader"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 0

-- Outfit notavel: roxo/dourado, com adornos. lookType 130 = sorcerer male,
-- cores fortes para destaca-lo dos NPCs comuns.
npcConfig.outfit = {
	lookType = 130,
	lookHead = 132, -- roxo
	lookBody = 76,  -- amarelo dourado
	lookLegs = 132, -- roxo
	lookFeet = 76,  -- dourado
	lookAddons = 3,
}

-- NPCs em Canary nao sao atacaveis por default (engine NPC, nao monster).
-- floorchange=false impede que ele desca/suba escadas e suma do templo.
npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Funny Trader: tudo que voce precisa, em qualquer lugar!" },
	{ text = "Compro tudo, vendo de tudo. Diga {trade}!" },
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

-- Dialogo
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "Sou o Funny Trader. Compro e vendo praticamente qualquer coisa em Tibia! Diga {trade} para ver." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "Sou o Funny Trader, o mercador que veio para servir todo o servidor." })
keywordHandler:addKeyword({ "help" }, StdModule.say, { npcHandler = npcHandler, text = "Diga {trade} para abrir minha loja. Eu vendo potions, runas, ammo, ferramentas e compro praticamente todo loot." })

npcHandler:setMessage(MESSAGE_GREET, "Bem-vindo, |PLAYERNAME|! Eu compro e vendo de quase tudo em Tibia. Diga {trade} para ver minhas ofertas.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Volte sempre, |PLAYERNAME|!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Volte sempre!")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Veja minhas ofertas - eu compro e vendo!")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- =====================================================================
-- SHOP TABLE
-- =====================================================================
-- "buy" = preco que o NPC vende ao player
-- "sell" = preco que o NPC paga ao comprar do player
-- Items com ambos: compra e venda. Items com so um: unidirecional.
-- Precos canonicos extraidos de Xodet, Willard, Asnarus, Rashid, Alaistar.
-- =====================================================================
npcConfig.shop = {
	-- ---------------- POTIONS ----------------
	{ itemName = "health potion", clientId = 266, buy = 50, sell = 5 },
	{ itemName = "mana potion", clientId = 268, buy = 56, sell = 5 },
	{ itemName = "strong health potion", clientId = 236, buy = 115, sell = 10 },
	{ itemName = "strong mana potion", clientId = 237, buy = 108, sell = 10 },
	{ itemName = "great health potion", clientId = 239, buy = 225, sell = 20 },
	{ itemName = "great mana potion", clientId = 238, buy = 158, sell = 15 },
	{ itemName = "great spirit potion", clientId = 7642, buy = 254, sell = 25 },
	{ itemName = "ultimate health potion", clientId = 7643, buy = 379, sell = 35 },
	{ itemName = "ultimate mana potion", clientId = 23373, buy = 488, sell = 50 },
	{ itemName = "ultimate spirit potion", clientId = 23374, buy = 488, sell = 50 },
	{ itemName = "supreme health potion", clientId = 23375, buy = 650, sell = 65 },
	{ itemName = "empty potion flask", clientId = 283, sell = 5 },
	{ itemName = "empty potion flask", clientId = 284, sell = 5 },
	{ itemName = "empty potion flask", clientId = 285, sell = 5 },
	{ itemName = "vial", clientId = 2874, sell = 5 },

	-- ---------------- RUNES (combat) ----------------
	{ itemName = "light magic missile rune", clientId = 3174, buy = 4 },
	{ itemName = "heavy magic missile rune", clientId = 3198, buy = 12 },
	{ itemName = "great fireball rune", clientId = 3191, buy = 64 },
	{ itemName = "fireball rune", clientId = 3189, buy = 30 },
	{ itemName = "explosion rune", clientId = 3200, buy = 31 },
	{ itemName = "sudden death rune", clientId = 3155, buy = 162 },
	{ itemName = "avalanche rune", clientId = 3161, buy = 64 },
	{ itemName = "stone shower rune", clientId = 3175, buy = 41 },
	{ itemName = "thunderstorm rune", clientId = 3202, buy = 52 },
	{ itemName = "icicle rune", clientId = 3158, buy = 30 },
	{ itemName = "holy missile rune", clientId = 3182, buy = 16 },
	{ itemName = "energy bomb rune", clientId = 3149, buy = 203 },
	{ itemName = "poison bomb rune", clientId = 3173, buy = 85 },
	{ itemName = "fire bomb rune", clientId = 3192, buy = 147 },

	-- ---------------- RUNES (utility) ----------------
	{ itemName = "ultimate healing rune", clientId = 3160, buy = 175 },
	{ itemName = "intense healing rune", clientId = 3152, buy = 95 },
	{ itemName = "cure poison rune", clientId = 3153, buy = 65 },
	{ itemName = "magic wall rune", clientId = 3180, buy = 116 },
	{ itemName = "wild growth rune", clientId = 3156, buy = 160 },
	{ itemName = "fire wall rune", clientId = 3190, buy = 61 },
	{ itemName = "energy wall rune", clientId = 3166, buy = 85 },
	{ itemName = "poison wall rune", clientId = 3176, buy = 52 },
	{ itemName = "fire field rune", clientId = 3188, buy = 28 },
	{ itemName = "energy field rune", clientId = 3164, buy = 38 },
	{ itemName = "poison field rune", clientId = 3172, buy = 21 },
	{ itemName = "stalagmite rune", clientId = 3179, buy = 12 },
	{ itemName = "destroy field rune", clientId = 3148, buy = 15 },
	{ itemName = "soulfire rune", clientId = 3195, buy = 46 },
	{ itemName = "desintegrate rune", clientId = 3197, buy = 26 },
	{ itemName = "animate dead rune", clientId = 3203, buy = 375 },
	{ itemName = "paralyze rune", clientId = 3165, buy = 700 },
	{ itemName = "chameleon rune", clientId = 3178, buy = 210 },
	{ itemName = "convince creature rune", clientId = 3177, buy = 80 },
	{ itemName = "blank rune", clientId = 3147, buy = 10 },

	-- ---------------- AMMO: ARROWS ----------------
	{ itemName = "arrow", clientId = 3447, buy = 3, sell = 1 },
	{ itemName = "burst arrow", clientId = 3449, buy = 15, sell = 1 },
	{ itemName = "poison arrow", clientId = 3448, buy = 10, sell = 1 },
	{ itemName = "earth arrow", clientId = 774, buy = 5, sell = 1 },
	{ itemName = "flaming arrow", clientId = 763, buy = 5, sell = 1 },
	{ itemName = "flash arrow", clientId = 761, buy = 5, sell = 1 },
	{ itemName = "shiver arrow", clientId = 762, buy = 5, sell = 1 },
	{ itemName = "sniper arrow", clientId = 7364, buy = 5, sell = 1 },
	{ itemName = "onyx arrow", clientId = 7365, buy = 7, sell = 1 },
	{ itemName = "tarsal arrow", clientId = 14251, buy = 6, sell = 1 },
	{ itemName = "vortex arrow", clientId = 14252, buy = 6, sell = 1 },
	{ itemName = "envenomed arrow", clientId = 16143, buy = 12, sell = 1 },
	{ itemName = "crystalline arrow", clientId = 15793, buy = 20, sell = 1 },
	{ itemName = "diamond arrow", clientId = 35901, buy = 130, sell = 5 },
	{ itemName = "simple arrow", clientId = 21470, buy = 1, sell = 1 },
	{ itemName = "crystal arrow", clientId = 3239, buy = 5, sell = 1 },

	-- ---------------- AMMO: BOLTS ----------------
	{ itemName = "bolt", clientId = 3446, buy = 4, sell = 1 },
	{ itemName = "power bolt", clientId = 3450, buy = 7, sell = 1 },
	{ itemName = "piercing bolt", clientId = 7363, buy = 5, sell = 1 },
	{ itemName = "infernal bolt", clientId = 6528, buy = 13, sell = 1 },
	{ itemName = "drill bolt", clientId = 16142, buy = 12, sell = 1 },
	{ itemName = "prismatic bolt", clientId = 16141, buy = 20, sell = 1 },
	{ itemName = "spectral bolt", clientId = 35902, buy = 70, sell = 5 },
	{ itemName = "crystal bolt", clientId = 15792, buy = 5, sell = 1 },

	-- ---------------- AMMO: SPEARS / THROWN ----------------
	{ itemName = "spear", clientId = 3277, buy = 9, sell = 3 },
	{ itemName = "royal spear", clientId = 7378, buy = 15, sell = 5 },
	{ itemName = "hunting spear", clientId = 3347, buy = 25, sell = 10 },
	{ itemName = "enchanted spear", clientId = 7367, buy = 30, sell = 10 },
	{ itemName = "throwing star", clientId = 3287, buy = 42, sell = 10 },
	{ itemName = "throwing knife", clientId = 3298, buy = 25, sell = 2 },
	{ itemName = "throwing axe", clientId = 35515, buy = 30, sell = 5 },
	{ itemName = "assassin star", clientId = 7368, buy = 100, sell = 20 },
	{ itemName = "royal star", clientId = 25759, buy = 100, sell = 20 },

	-- ---------------- QUIVERS / RANGED WEAPONS ----------------
	{ itemName = "quiver", clientId = 35562, buy = 400 },
	{ itemName = "blue quiver", clientId = 35848, buy = 400 },
	{ itemName = "red quiver", clientId = 35849, buy = 400 },
	{ itemName = "bow", clientId = 3350, buy = 400, sell = 100 },
	{ itemName = "crossbow", clientId = 3349, buy = 500, sell = 120 },

	-- ---------------- WANDS / RODS ----------------
	{ itemName = "wand of vortex", clientId = 3074, buy = 500, sell = 50 },
	{ itemName = "wand of dragonbreath", clientId = 3075, buy = 1000, sell = 100 },
	{ itemName = "wand of decay", clientId = 3072, buy = 5000, sell = 500 },
	{ itemName = "necrotic rod", clientId = 3069, buy = 5000, sell = 500 },
	{ itemName = "wand of cosmic energy", clientId = 3073, buy = 10000, sell = 1000 },
	{ itemName = "terra rod", clientId = 3065, buy = 10000, sell = 1000 },
	{ itemName = "moonlight rod", clientId = 3070, buy = 1000, sell = 100 },
	{ itemName = "snakebite rod", clientId = 3066, buy = 500, sell = 50 },
	{ itemName = "springsprout rod", clientId = 8084, buy = 18000, sell = 1800 },
	{ itemName = "spellwand", clientId = 651, sell = 299 },
	{ itemName = "spellbook", clientId = 3059, buy = 150 },

	-- ---------------- FERRAMENTAS ----------------
	{ itemName = "rope", clientId = 3003, buy = 50, sell = 8 },
	{ itemName = "shovel", clientId = 3457, buy = 10, sell = 2 },
	{ itemName = "pick", clientId = 3456, buy = 50, sell = 15 },
	{ itemName = "torch", clientId = 2920, buy = 2, sell = 1 },
	{ itemName = "machete", clientId = 3308, buy = 35, sell = 6 },
	{ itemName = "scythe", clientId = 3453, buy = 12, sell = 5 },
	{ itemName = "fishing rod", clientId = 3483, buy = 150, sell = 30 },
	{ itemName = "worm", clientId = 3492, buy = 1 },
	{ itemName = "parchment", clientId = 2817, buy = 8 },
	{ itemName = "scroll", clientId = 2815, buy = 5 },
	{ itemName = "crowbar", clientId = 3304, buy = 260, sell = 50 },
	{ itemName = "backpack", clientId = 2854, buy = 10, sell = 1 },
	{ itemName = "bag", clientId = 2853, buy = 4, sell = 1 },
	{ itemName = "wooden hammer", clientId = 3459, sell = 15 },
	{ itemName = "watch", clientId = 2906, buy = 20, sell = 6 },
	{ itemName = "hand auger", clientId = 31334, buy = 25 },

	-- ---------------- ARMAS (1H) ----------------
	{ itemName = "dagger", clientId = 3267, buy = 5, sell = 2 },
	{ itemName = "rapier", clientId = 3272, buy = 15, sell = 5 },
	{ itemName = "sabre", clientId = 3273, buy = 35, sell = 12 },
	{ itemName = "short sword", clientId = 3294, buy = 26, sell = 10 },
	{ itemName = "sickle", clientId = 3293, buy = 7, sell = 3 },
	{ itemName = "sword", clientId = 3264, buy = 85, sell = 25 },
	{ itemName = "katana", clientId = 3300, sell = 35 },
	{ itemName = "longsword", clientId = 3285, buy = 160, sell = 51 },
	{ itemName = "carlin sword", clientId = 3283, buy = 473, sell = 118 },
	{ itemName = "spike sword", clientId = 3271, buy = 8000, sell = 240 },
	{ itemName = "crimson sword", clientId = 7385, buy = 610, sell = 250 },
	{ itemName = "crystal sword", clientId = 7449, sell = 600 },
	{ itemName = "fire sword", clientId = 3280, sell = 1000 },
	{ itemName = "silver dagger", clientId = 3290, sell = 500 },
	{ itemName = "bone sword", clientId = 3338, buy = 75, sell = 20 },
	{ itemName = "bone club", clientId = 3337, sell = 5 },
	{ itemName = "club", clientId = 3270, buy = 5, sell = 1 },
	{ itemName = "mace", clientId = 3286, buy = 90, sell = 30 },
	{ itemName = "battle hammer", clientId = 3305, buy = 350, sell = 120 },
	{ itemName = "clerical mace", clientId = 3311, buy = 540, sell = 170 },
	{ itemName = "morning star", clientId = 3282, buy = 430, sell = 100 },
	{ itemName = "studded club", clientId = 3336, sell = 10 },
	{ itemName = "daramian mace", clientId = 3327, sell = 110 },
	{ itemName = "swampling club", clientId = 17824, sell = 40 },
	{ itemName = "taurus mace", clientId = 7425, sell = 500 },
	{ itemName = "hand axe", clientId = 3268, buy = 8, sell = 4 },
	{ itemName = "axe", clientId = 3274, buy = 20, sell = 7 },
	{ itemName = "hatchet", clientId = 3276, sell = 25 },
	{ itemName = "small axe", clientId = 3462, sell = 5 },
	{ itemName = "battle axe", clientId = 3266, buy = 235, sell = 80 },
	{ itemName = "barbarian axe", clientId = 3317, buy = 590, sell = 185 },
	{ itemName = "orcish axe", clientId = 3316, sell = 350 },
	{ itemName = "daramian waraxe", clientId = 3328, sell = 1000 },
	{ itemName = "beastslayer axe", clientId = 3344, sell = 1500 },
	{ itemName = "headchopper", clientId = 7380, sell = 6000 },
	{ itemName = "noble axe", clientId = 7456, sell = 10000 },

	-- ---------------- ARMAS (2H) ----------------
	{ itemName = "two handed sword", clientId = 3265, buy = 950, sell = 450 },
	{ itemName = "halberd", clientId = 3269, sell = 400 },
	{ itemName = "double axe", clientId = 3275, sell = 260 },
	{ itemName = "war hammer", clientId = 3279, buy = 10000, sell = 450 },
	{ itemName = "war axe", clientId = 3342, sell = 12000 },
	{ itemName = "naginata", clientId = 3314, sell = 2000 },
	{ itemName = "epee", clientId = 3326, sell = 8000 },
	{ itemName = "abyss hammer", clientId = 7414, sell = 20000 },
	{ itemName = "berserker", clientId = 7403, sell = 40000 },
	{ itemName = "blessed sceptre", clientId = 7429, sell = 40000 },
	{ itemName = "chaos mace", clientId = 7427, sell = 9000 },
	{ itemName = "cranial basher", clientId = 7415, sell = 30000 },
	{ itemName = "demonrage sword", clientId = 7382, sell = 36000 },
	{ itemName = "djinn blade", clientId = 3339, sell = 15000 },
	{ itemName = "dragon slayer", clientId = 7402, sell = 15000 },
	{ itemName = "dreaded cleaver", clientId = 7419, sell = 10000 },
	{ itemName = "guardian halberd", clientId = 3315, sell = 11000 },
	{ itemName = "hammer of wrath", clientId = 3332, sell = 30000 },
	{ itemName = "heavy mace", clientId = 3340, sell = 50000 },
	{ itemName = "heroic axe", clientId = 7389, sell = 30000 },
	{ itemName = "mercenary sword", clientId = 7386, sell = 12000 },
	{ itemName = "mystic blade", clientId = 7384, sell = 30000 },
	{ itemName = "nightmare blade", clientId = 7418, sell = 35000 },
	{ itemName = "orcish maul", clientId = 7392, sell = 6000 },
	{ itemName = "pharaoh sword", clientId = 3334, sell = 23000 },
	{ itemName = "relic sword", clientId = 7383, sell = 25000 },
	{ itemName = "royal axe", clientId = 7434, sell = 40000 },
	{ itemName = "ruthless axe", clientId = 6553, sell = 45000 },
	{ itemName = "rift lance", clientId = 22727, sell = 30000 },
	{ itemName = "the justice seeker", clientId = 7390, sell = 40000 },
	{ itemName = "vile axe", clientId = 7388, sell = 30000 },
	{ itemName = "blacksteel sword", clientId = 7406, sell = 6000 },
	{ itemName = "assassin dagger", clientId = 7404, sell = 20000 },
	{ itemName = "crystal mace", clientId = 3333, sell = 12000 },
	{ itemName = "amber staff", clientId = 7426, sell = 8000 },
	{ itemName = "brutetamer's staff", clientId = 7379, sell = 1500 },
	{ itemName = "dragonbone staff", clientId = 7430, sell = 3000 },
	{ itemName = "furry club", clientId = 7432, sell = 1000 },
	{ itemName = "jade hammer", clientId = 7422, sell = 25000 },
	{ itemName = "lunar staff", clientId = 7424, sell = 5000 },
	{ itemName = "sapphire hammer", clientId = 7437, sell = 7000 },
	{ itemName = "spiked squelcher", clientId = 7452, sell = 5000 },
	{ itemName = "diamond sceptre", clientId = 7387, sell = 3000 },
	{ itemName = "heavy trident", clientId = 12683, sell = 2000 },
	{ itemName = "wyvern fang", clientId = 7408, sell = 1500 },
	{ itemName = "elvish bow", clientId = 7438, sell = 2000 },
	{ itemName = "composite hornbow", clientId = 8027, sell = 25000 },
	{ itemName = "chain bolter", clientId = 8022, sell = 40000 },
	{ itemName = "crystal crossbow", clientId = 16163, sell = 35000 },
	{ itemName = "mycological bow", clientId = 16164, sell = 35000 },
	{ itemName = "rift bow", clientId = 22866, sell = 45000 },
	{ itemName = "rift crossbow", clientId = 22867, sell = 45000 },

	-- ---------------- ARMORS ----------------
	{ itemName = "coat", clientId = 3562, buy = 8, sell = 1 },
	{ itemName = "doublet", clientId = 3379, buy = 16, sell = 3 },
	{ itemName = "jacket", clientId = 3561, buy = 12, sell = 1 },
	{ itemName = "leather armor", clientId = 3361, buy = 35, sell = 12 },
	{ itemName = "studded armor", clientId = 3378, buy = 90, sell = 25 },
	{ itemName = "chain armor", clientId = 3358, buy = 200, sell = 70 },
	{ itemName = "scale armor", clientId = 3377, buy = 260, sell = 75 },
	{ itemName = "brass armor", clientId = 3359, buy = 450, sell = 150 },
	{ itemName = "plate armor", clientId = 3357, buy = 1200, sell = 400 },
	{ itemName = "golden armor", clientId = 3360, sell = 20000 },
	{ itemName = "magic plate armor", clientId = 3366, sell = 90000 },
	{ itemName = "dragon scale mail", clientId = 3386, sell = 40000 },
	{ itemName = "dwarven armor", clientId = 3397, sell = 30000 },
	{ itemName = "albino plate", clientId = 19358, sell = 1500 },
	{ itemName = "crystalline armor", clientId = 8050, sell = 16000 },
	{ itemName = "divine plate", clientId = 8057, sell = 55000 },
	{ itemName = "lavos armor", clientId = 8049, sell = 16000 },
	{ itemName = "leopard armor", clientId = 3404, sell = 1000 },
	{ itemName = "paladin armor", clientId = 8063, sell = 15000 },
	{ itemName = "skullcracker armor", clientId = 8061, sell = 18000 },
	{ itemName = "swamplair armor", clientId = 8052, sell = 16000 },
	{ itemName = "glacier robe", clientId = 824, sell = 11000 },
	{ itemName = "lightning robe", clientId = 825, sell = 11000 },
	{ itemName = "magma coat", clientId = 826, sell = 11000 },
	{ itemName = "terra mantle", clientId = 811, sell = 11000 },

	-- ---------------- HELMETS ----------------
	{ itemName = "leather helmet", clientId = 3355, buy = 12, sell = 4 },
	{ itemName = "chain helmet", clientId = 3352, buy = 52, sell = 17 },
	{ itemName = "studded helmet", clientId = 3376, buy = 63, sell = 20 },
	{ itemName = "brass helmet", clientId = 3354, buy = 120, sell = 30 },
	{ itemName = "soldier helmet", clientId = 3375, buy = 110, sell = 16 },
	{ itemName = "legion helmet", clientId = 3374, sell = 22 },
	{ itemName = "iron helmet", clientId = 3353, buy = 390, sell = 150 },
	{ itemName = "viking helmet", clientId = 3367, buy = 265, sell = 66 },
	{ itemName = "steel helmet", clientId = 3351, buy = 580, sell = 293 },
	{ itemName = "devil helmet", clientId = 3356, sell = 1000 },
	{ itemName = "bonelord helmet", clientId = 3408, sell = 7500 },
	{ itemName = "krimhorn helmet", clientId = 7461, sell = 200 },
	{ itemName = "ragnir helmet", clientId = 7462, sell = 400 },
	{ itemName = "helmet of the lost", clientId = 17852, sell = 2000 },
	{ itemName = "glacier mask", clientId = 829, sell = 2500 },
	{ itemName = "lightning headband", clientId = 828, sell = 2500 },
	{ itemName = "magma monocle", clientId = 827, sell = 2500 },
	{ itemName = "terra hood", clientId = 830, sell = 2500 },
	{ itemName = "witch hat", clientId = 9653, sell = 5000 },
	{ itemName = "pirate hat", clientId = 6096, sell = 1000 },
	{ itemName = "bandana", clientId = 5917, sell = 150 },

	-- ---------------- LEGS ----------------
	{ itemName = "leather legs", clientId = 3559, buy = 10, sell = 9 },
	{ itemName = "studded legs", clientId = 3362, buy = 50, sell = 15 },
	{ itemName = "chain legs", clientId = 3558, buy = 80, sell = 25 },
	{ itemName = "brass legs", clientId = 3372, buy = 195, sell = 49 },
	{ itemName = "plate legs", clientId = 3557, sell = 115 },
	{ itemName = "golden legs", clientId = 3364, sell = 30000 },
	{ itemName = "glacier kilt", clientId = 823, sell = 11000 },
	{ itemName = "lightning legs", clientId = 822, sell = 11000 },
	{ itemName = "magma legs", clientId = 821, sell = 11000 },
	{ itemName = "terra legs", clientId = 812, sell = 11000 },
	{ itemName = "mammoth fur shorts", clientId = 7464, sell = 850 },
	{ itemName = "leaf legs", clientId = 9014, sell = 500 },
	{ itemName = "pirate knee breeches", clientId = 5918, sell = 200 },

	-- ---------------- BOOTS ----------------
	{ itemName = "leather boots", clientId = 3552, buy = 10, sell = 2 },
	{ itemName = "patched boots", clientId = 3550, sell = 2000 },
	{ itemName = "steel boots", clientId = 3554, sell = 30000 },
	{ itemName = "crocodile boots", clientId = 3556, sell = 1000 },
	{ itemName = "fur boots", clientId = 7457, sell = 2000 },
	{ itemName = "coconut shoes", clientId = 9017, sell = 500 },
	{ itemName = "pirate boots", clientId = 5461, sell = 3000 },
	{ itemName = "glacier shoes", clientId = 819, sell = 2500 },
	{ itemName = "lightning boots", clientId = 820, sell = 2500 },
	{ itemName = "magma boots", clientId = 818, sell = 2500 },
	{ itemName = "terra boots", clientId = 813, sell = 2500 },
	{ itemName = "oriental shoes", clientId = 21981, sell = 15000 },

	-- ---------------- SHIELDS ----------------
	{ itemName = "wooden shield", clientId = 3412, buy = 15, sell = 5 },
	{ itemName = "studded shield", clientId = 3426, buy = 50, sell = 16 },
	{ itemName = "brass shield", clientId = 3411, buy = 65, sell = 25 },
	{ itemName = "battle shield", clientId = 3413, sell = 95 },
	{ itemName = "plate shield", clientId = 3410, buy = 125, sell = 45 },
	{ itemName = "steel shield", clientId = 3409, buy = 240, sell = 80 },
	{ itemName = "viking shield", clientId = 3431, buy = 260, sell = 85 },
	{ itemName = "copper shield", clientId = 3430, sell = 50 },
	{ itemName = "dwarven shield", clientId = 3425, buy = 500, sell = 100 },
	{ itemName = "dark shield", clientId = 3421, sell = 400 },
	{ itemName = "bone shield", clientId = 3441, sell = 80 },
	{ itemName = "tortoise shield", clientId = 6131, sell = 150 },
	{ itemName = "norse shield", clientId = 7460, sell = 1500 },
	{ itemName = "castle shield", clientId = 3435, sell = 5000 },
	{ itemName = "griffin shield", clientId = 3433, sell = 3000 },
	{ itemName = "medusa shield", clientId = 3436, sell = 9000 },
	{ itemName = "scarab shield", clientId = 3440, sell = 2000 },
	{ itemName = "demon shield", clientId = 3420, sell = 30000 },
	{ itemName = "mastermind shield", clientId = 3414, sell = 50000 },
	{ itemName = "tempest shield", clientId = 3442, sell = 35000 },
	{ itemName = "rift shield", clientId = 22726, sell = 50000 },

	-- ---------------- JEWELRY ----------------
	{ itemName = "silver brooch", clientId = 3017, sell = 150 },
	{ itemName = "scarab amulet", clientId = 3018, sell = 200 },
	{ itemName = "ancient amulet", clientId = 3025, sell = 200 },
	{ itemName = "crystal necklace", clientId = 3008, sell = 400 },
	{ itemName = "crystal ring", clientId = 3007, sell = 250 },
	{ itemName = "emerald bangle", clientId = 3010, sell = 800 },
	{ itemName = "ruby necklace", clientId = 3016, sell = 2000 },
	{ itemName = "platinum amulet", clientId = 3055, sell = 2500 },
	{ itemName = "gold ring", clientId = 3063, sell = 8000 },
	{ itemName = "death ring", clientId = 6299, sell = 1000 },
	{ itemName = "demonbone amulet", clientId = 3019, sell = 32000 },
	{ itemName = "beetle necklace", clientId = 10457, sell = 1500 },
	{ itemName = "glacier amulet", clientId = 815, sell = 1500 },
	{ itemName = "lightning pendant", clientId = 816, sell = 1500 },
	{ itemName = "magma amulet", clientId = 817, sell = 1500 },
	{ itemName = "terra amulet", clientId = 814, sell = 1500 },
	{ itemName = "leviathan's amulet", clientId = 9303, sell = 3000 },
	{ itemName = "sacred tree amulet", clientId = 9302, sell = 3000 },
	{ itemName = "shockwave amulet", clientId = 9304, sell = 3000 },
	{ itemName = "onyx pendant", clientId = 22195, sell = 3500 },
	{ itemName = "ring of the sky", clientId = 3006, sell = 30000 },
	{ itemName = "skull helmet", clientId = 5741, sell = 40000 },
	{ itemName = "cobra crown", clientId = 11674, sell = 50000 },

	-- ---------------- MONSTER LOOTS / DIVERSOS ----------------
	{ itemName = "bowl of terror sweat", clientId = 20204, sell = 500 },
	{ itemName = "broken visor", clientId = 20184, sell = 1900 },
	{ itemName = "dead weight", clientId = 20202, sell = 450 },
	{ itemName = "frazzle skin", clientId = 20199, sell = 400 },
	{ itemName = "frazzle tongue", clientId = 20198, sell = 700 },
	{ itemName = "goosebump leather", clientId = 20205, sell = 650 },
	{ itemName = "hemp rope", clientId = 20206, sell = 350 },
	{ itemName = "pool of chitinous glue", clientId = 20207, sell = 430 },
	{ itemName = "sight of surrenders eye", clientId = 20183, sell = 3000 },
	{ itemName = "silencer claws", clientId = 20200, sell = 390 },
	{ itemName = "silencer resonating chamber", clientId = 20201, sell = 600 },
	{ itemName = "trapped bad dream monster", clientId = 20203, sell = 900 },
	{ itemName = "goo shell", clientId = 19372, sell = 4000 },
	{ itemName = "horn", clientId = 19359, sell = 300 },
	{ itemName = "buckle", clientId = 17829, sell = 7000 },
	{ itemName = "pair of iron fists", clientId = 17828, sell = 4000 },
	{ itemName = "doll", clientId = 2991, sell = 200 },
	{ itemName = "flower dress", clientId = 9015, sell = 1000 },
	{ itemName = "flower wreath", clientId = 9013, sell = 500 },
	{ itemName = "hibiscus dress", clientId = 8045, sell = 3000 },
	{ itemName = "hieroglyph banner", clientId = 12482, sell = 500 },
	{ itemName = "light shovel", clientId = 5710, sell = 300 },
	{ itemName = "mammoth fur cape", clientId = 7463, sell = 6000 },
	{ itemName = "mammoth whopper", clientId = 7381, sell = 300 },
	{ itemName = "model ship", clientId = 2994, sell = 1000 },
	{ itemName = "pharaoh banner", clientId = 12483, sell = 1000 },
	{ itemName = "pirate shirt", clientId = 6095, sell = 500 },
	{ itemName = "pirate voodoo doll", clientId = 5810, sell = 500 },
	{ itemName = "voodoo doll", clientId = 3002, sell = 400 },
	{ itemName = "war horn", clientId = 2958, sell = 8000 },
	{ itemName = "heavy machete", clientId = 3330, sell = 90 },
}

-- =====================================================================
-- HOOKS
-- =====================================================================
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end

npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_TRADE, string.format("Vendido %ix %s por %i gp.", amount, name, totalCost))
end

npcType.onCheckItem = function(npc, player, clientId, subType) end

npcType:register(npcConfig)
