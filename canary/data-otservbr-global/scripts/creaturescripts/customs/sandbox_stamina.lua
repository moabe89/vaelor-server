-- Sandbox FunnyOt: stamina sempre cheia ao logar (2520 = 42h).
-- O tick global que mantem o cap esta em globalevents/sandbox_stamina_tick.lua.

local STAMINA_MAX = 2520

local sandboxStaminaLogin = CreatureEvent("SandboxStaminaLogin")

function sandboxStaminaLogin.onLogin(player)
	if player then
		player:setStamina(STAMINA_MAX)
	end
	return true
end

sandboxStaminaLogin:register()
