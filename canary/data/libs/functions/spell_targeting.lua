-- =====================================================================
-- FunnyOt sandbox: redirecionamento de spells direcionais
-- =====================================================================
-- Helper que ajusta a `var` de uma spell direcional (wave/beam) para sair
-- na direcao do target marcado pelo player, SEM rotacionar visualmente o
-- player. Se o player nao tem target marcado, mantem comportamento padrao.
--
-- Uso em spell.onCastSpell:
--   var = SpellTargeting.redirectToTarget(creature, var)
--   return combat:execute(creature, var)
-- =====================================================================

SpellTargeting = {}

-- Retorna direcao CARDINAL (N/S/L/W) do pos1 ate pos2. Sem diagonal.
function SpellTargeting.getCardinalDirection(pos1, pos2)
	local dx = pos2.x - pos1.x
	local dy = pos2.y - pos1.y
	if math.abs(dx) >= math.abs(dy) then
		return (dx > 0) and DIRECTION_EAST or DIRECTION_WEST
	else
		return (dy > 0) and DIRECTION_SOUTH or DIRECTION_NORTH
	end
end

-- Se o creature for player com target marcado, ajusta var.pos para
-- representar a casa imediatamente a frente NA DIRECAO DO TARGET.
-- Se nao tem target, mantem var original (que ja foi calculada pelo engine
-- com base na direcao visual do player).
function SpellTargeting.redirectToTarget(creature, var)
	if not creature or not creature:isPlayer() then
		return var
	end

	local target = creature:getAttackedCreature()
	if not target or target:isRemoved() then
		return var
	end

	-- Mesma altura (z) - senao deixa engine tratar
	local cPos = creature:getPosition()
	local tPos = target:getPosition()
	if cPos.z ~= tPos.z then
		return var
	end

	-- Mesma posicao = ignora (nao da pra ter direcao)
	if cPos.x == tPos.x and cPos.y == tPos.y then
		return var
	end

	local dir = SpellTargeting.getCardinalDirection(cPos, tPos)

	-- Criar nova posicao 1 passo a frente NA DIRECAO DO TARGET
	-- (mesmo calculo que Spells::getCasterPosition faz em C++)
	local newPos = Position(cPos.x, cPos.y, cPos.z)
	newPos:getNextPosition(dir, 1)

	-- Substituir o var.pos com a nova posicao direcionada
	var.type = VARIANT_POSITION
	var.pos = newPos

	return var
end
