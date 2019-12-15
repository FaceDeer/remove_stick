core.register_privilege("remove_stick", {
	description = "Can use the remove stick tool to delete nodes or entities",
	give_to_singleplayer = false,
	give_to_admin = true,
})

minetest.register_craftitem("remove_stick:remove_stick", {
	description = "Admin Remove Stick",
	inventory_image = "admin_tools_removestick.png",
	on_use = function(item, user, pointed_thing)
		local user_name = user:get_player_name()
		if not minetest.check_player_privs(user, "remove_stick") then
			minetest.chat_send_player(user_name, "You need the remove_stick priviledge to use this tool.")
			return
		end	
		if pointed_thing.type == "node" then
			local node = minetest.get_node(pointed_thing.under)
			minetest.remove_node(pointed_thing.under)
			minetest.log("action", user_name .. " used a remove stick to remove " .. node.name .. " at " .. minetest.pos_to_string(pointed_thing.under))
		elseif pointed_thing.type == "object" then
			local obj = pointed_thing.ref
			local obj_pos = obj:get_pos()
			if obj ~= nil then
				if obj:is_player() then
					-- Player
					if minetest.settings:get_bool("enable_damage") == false then
						minetest.log("action", user_name .. " tried to use a remove stick to kill player " .. obj:get_player_name() .. " at " .. minetest.pos_to_string(obj_pos) .. " but damage is not enabled.")
					else
						obj:set_hp(0)
						minetest.log("action", user_name .. " used a remove stick to kill player " .. obj:get_player_name() .. " at " .. minetest.pos_to_string(obj_pos))
					end
				else
					-- Mob or other entity
					obj:remove()
					minetest.log("action", user_name .. " used a remove stick to remove entity " .. obj:get_entity_name() .. " at " .. minetest.pos_to_string(obj_pos))
				end
			end
		end
	end,
	stack_max = 1,
	liquids_pointable = true,
})