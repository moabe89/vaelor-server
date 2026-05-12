-- Sandbox FunnyOt: a cada 60s reverte qualquer decay aplicado pelo
-- data/events/scripts/player.lua quando o player ganha exp.

local STAMINA_MAX = 2520

local sandboxStaminaTick = GlobalEvent("SandboxStaminaTick")

function sandboxStaminaTick.onThink(interval)
	for _, player in ipairs(Game.getPlayers()) do
		if player:getStamina() < STAMINA_MAX then
			player:setStamina(STAMINA_MAX)
		end
	end
	return true
end

sandboxStaminaTick:interval(60 * 1000)
sandboxStaminaTick:register()
