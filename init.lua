-- one_for_all init.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2017
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)

one_for_all = {}

local mod = one_for_all
local mod_name = "one_for_all"

mod.settings.kick = core.settings:get_bool("one_for_all.kick", false)
mod.settings.perma_kick = core.settings:get_bool("one_for_all.perma_kick", false)
mod.settings.chat_join_msg = core.settings:get_bool("one_for_all.chat_join_msg", true)

function mod.kill(player_name)
	local player = core.get_player_by_name(player_name)
	if player then -- make sure player exists
		if mod.settings.kick then
			core.kick_player(player_name)
			if mod.settings.perma_kick then
				core.after(1,
					function()
						core.remove_player(player_name)
						core.remove_player_auth(player_name)
					end,
					player_name
				)
				core.log("info", mod_name .. ": permanently kicked", player_name)
			end
		else
			player:set_hp(0)
		end
	end
end

core.register_on_dieplayer(function()
	for _, pl in ipairs(core.get_connected_players()) do
		if not core.check_player_privs(pl, "server") then
			mod.kill(pl)
		end
	end
end)

core.register_on_newplayer(function(player)
	local pname = player:get_player_name()
	if mod.settings.chat_join_msg then
		core.chat_send_player(pname, "If anyone dies then you die too!")
	end
end)
