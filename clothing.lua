CLOTHING_INIT_DELAY = 1
CLOTHING_INIT_TIMES = 1
CLOTHING_ENABLE_CRAFTING = true
CLOTHING_ENABLE_PREVIEW = true

-- Load Clothing Configs

local modpath = minetest.get_modpath(minetest.get_current_modname())
local worldpath = minetest.get_worldpath()
local input = io.open(modpath.."/clothing.conf", "r")
if input then
	dofile(modpath.."/clothing.conf")
	input:close()
	input = nil
end
input = io.open(worldpath.."/clothing.conf", "r")
if input then
	dofile(worldpath.."/clothing.conf")
	input:close()
	input = nil
end

-- Clothing API

local inv_mod = nil

clothing = {
	formspec = "size[8,8.5]list[detached:player_name_clothing;clothing;0,1;2,3;]"
		.."image[2,0.75;2,4;clothing_preview]"
		.."list[current_player;main;0,4.5;8,4;]"
		.."list[current_player;craft;4,1;3,3;]"
		.."list[current_player;craftpreview;7,2;1,1;]",
	textures = {},
}

if minetest.get_modpath("inventory_plus") then
	inv_mod = "inventory_plus"
	clothing.formspec = "size[8,8.5]button[0,0;2,0.5;main;Back]"
		.."list[detached:player_name_clothing;clothing;0,1;2,3;]"
		.."image[2.5,0.75;2,4;clothing_preview]"
		.."list[current_player;main;0,4.5;8,4;]"
elseif minetest.get_modpath("unified_inventory") then
	inv_mod = "unified_inventory"
	unified_inventory.register_button("clothing", {
		type = "image",
		image = "inventory_plus_clothing.png",
	})
	unified_inventory.register_page("clothing", {
		get_formspec = function(player)
			local name = player:get_player_name()
			local offset = 0
			if minetest.setting_getbool("unified_inventory_lite") then
				offset = 0.5
			end
			local formspec = "background[0.06,"..(0.99 - offset)
				..";7.92,7.52;clothing_ui_form.png]"
				.."label[0,0;Clothing]"
				.."list[detached:"..name.."_clothing;clothing;0,"..(1 - offset)
				..";2,3;]"
			if CLOTHING_ENABLE_PREVIEW then
				formspec = formspec.."image[2.5,"..(0.75 - offset)..";2,4;"
					..clothing.textures[name].preview.."]"
			end
			return {formspec=formspec}
		end,
	})
end

clothing.set_player_clothing = function(self, player)
	if not player then
		return
	end
	local name = player:get_player_name()
	local player_inv = player:get_inventory()
	if not name or not player_inv then
		return
	end
	local clothing_texture = "multiskin_trans.png"
	local textures = {}
	local preview = multiskin:get_preview(name) or "clothing_preview.png"
	for i=1, 6 do
		local stack = player_inv:get_stack("clothing", i)
		local item = stack:get_name()
		if stack:get_count() == 1 then
			local def = stack:get_definition()
			if def.groups["clothing"] == 1 then
				if def.uv_image then
					table.insert(textures, def.uv_image)
				end
				if def.preview_image then
					preview = preview.."^"..def.preview_image
				end
			end
		end
	end
	if #textures > 0 then
		clothing_texture = table.concat(textures, "^")
	end
	self.textures[name].clothing = clothing_texture
	self.textures[name].preview = preview
	multiskin[name].clothing = clothing_texture
	multiskin:update_player_visuals(player)
end

clothing.get_clothing_formspec = function(self, name)
	local texture = "multiskin_trans.png"
	if CLOTHING_ENABLE_PREVIEW then
		texture = clothing.textures[name].preview
	end
	local formspec = clothing.formspec:gsub("player_name", name)
	return formspec:gsub("clothing_preview", texture)
end

clothing.update_inventory = function(self, player)
	local name = player:get_player_name()
	if inv_mod == "unified_inventory" then
		if unified_inventory.current_page[name] == "clothing" then
			unified_inventory.set_inventory_formspec(player, "clothing")
		end
	else
		local formspec = clothing:get_clothing_formspec(name)
		if inv_mod == "inventory_plus" then
			local page = player:get_inventory_formspec()
			if page:find("detached:"..name.."_clothing") then
				inventory_plus.set_inventory_formspec(player, formspec)
			end
		else
			player:set_inventory_formspec(formspec)
		end
	end
end

-- Register Callbacks

minetest.register_on_player_receive_fields(function(player, formname, fields)
	local name = player:get_player_name()
	if inv_mod == "inventory_plus" and fields.clothing then
		local formspec = clothing:get_clothing_formspec(name)
		inventory_plus.set_inventory_formspec(player, formspec)
		return
	end
end)

minetest.register_on_joinplayer(function(player)
	multiskin:init(player)
	local name = player:get_player_name()
	local player_inv = player:get_inventory()
	local clothing_inv = minetest.create_detached_inventory(name.."_clothing",{
		on_put = function(inv, listname, index, stack, player)
			player:get_inventory():set_stack(listname, index, stack)
			clothing:set_player_clothing(player)
			clothing:update_inventory(player)
		end,
		on_take = function(inv, listname, index, stack, player)
			player:get_inventory():set_stack(listname, index, nil)
			clothing:set_player_clothing(player)
			clothing:update_inventory(player)
		end,
		on_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			local plaver_inv = player:get_inventory()
			local stack = inv:get_stack(to_list, to_index)
			player_inv:set_stack(to_list, to_index, stack)
			player_inv:set_stack(from_list, from_index, nil)
			clothing:set_player_clothing(player)
			clothing:update_inventory(player)
		end,
		allow_put = function(inv, listname, index, stack, player)
			return 1
		end,
		allow_take = function(inv, listname, index, stack, player)
			return stack:get_count()
		end,
		allow_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			return count
		end,
	})
	if inv_mod == "inventory_plus" then
		inventory_plus.register_button(player,"clothing", "Clothing")
	end
	clothing_inv:set_size("clothing", 6)
	player_inv:set_size("clothing", 6)
	for i=1, 6 do
		local stack = player_inv:get_stack("clothing", i)
		clothing_inv:set_stack("clothing", i, stack)
	end	
	clothing.textures[name] = {
		clthing = "multiskin_trans.png",
		preview = "clothing_preview.png",
	}
	-- FIXME There really has to be a better way of doing this..?
	for i=1, CLOTHING_INIT_TIMES do
		minetest.after(CLOTHING_INIT_DELAY * i, function(player)
			clothing:set_player_clothing(player)
			if not inv_mod then
				clothing:update_inventory(player)
			end
		end, player)
	end
end)

