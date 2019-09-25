-- one_for_all init.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2017
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)

one_for_all = {}
local mod = one_for_all
local mod_name = 'one_for_all'
mod.version = '20190923'
mod.path = minetest.get_modpath(minetest.get_current_modname())
mod.world = minetest.get_worldpath()

local xdata = minetest.get_mod_storage()


local function permakill(player_name)
	minetest.kick_player(player_name)
	minetest.after(1, function(player_name)
		minetest.remove_player(player_name)
		minetest.remove_player_auth(player_name)
	end, player_name)
	minetest.log('info', mod_name .. ': permanently killed', player_name)

	local players = xdata:get_string('players') or ''
	players = players:gsub(',*' .. player_name .. ',*', ',')
	players = players:gsub(',$', '')
	xdata:set_string('players', players)
	--print(players)
end


minetest.register_on_dieplayer(function(player, reason)
	local players = xdata:get_string('players') or ''
	if players == '' then
		return
	end

	for pl in players:gmatch('[^,]+') do
		if not minetest.check_player_privs(pl, 'server') then
			permakill(pl)
		end
	end
end)


minetest.register_on_newplayer(function(player)
	local players = xdata:get_string('players') or ''
	local player_name = player:get_player_name()
	if players == '' then
		players = player_name
	else
		players = players .. ',' .. player_name
	end
	xdata:set_string('players', players)
end)
