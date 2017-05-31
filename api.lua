clothing = {
	formspec = "size[8,8.5]"..
		default.gui_bg..
		default.gui_bg_img..
		default.gui_slots..
		"list[current_player;main;0,4.7;8,1;]"..
		"list[current_player;main;0,5.85;8,3;8]"..
		default.get_hotbar_bg(0,4.7),
}

clothing.set_player_clothing = function(self, player)
	if not player then
		return
	end
	local name = player:get_player_name()
	local player_inv = player:get_inventory()
	if not name or not player_inv then
		return
	end
	local layer = {
		clothing = {},
		cape = {},
	}
	local capes = {}
	for i=1, 6 do
		local stack = player_inv:get_stack("clothing", i)
		local item = stack:get_name()
		if stack:get_count() == 1 then
			local def = stack:get_definition()
			if def.uv_image then
				if def.groups.clothing == 1 then
					table.insert(layer.clothing, def.uv_image)
				elseif def.groups.cape == 1 then
					table.insert(layer.cape, def.uv_image)
				end
			end
		end
	end
	local clothing = table.concat(layer.clothing, "^")
	local cape = table.concat(layer.cape, "^")
	if clothing == "" then
		clothing = "blank.png"
	end
	if cape == "" then
		cape = "blank.png"
	end
	local skin = multiskin.skins[name]
	if skin then
		skin.clothing = clothing
		skin.cape = cape
		multiskin.update_player_visuals(player)
	end
end

clothing.update_inventory = function(self, player)
	local name = player:get_player_name()
	if clothing.inv_mod == "unified_inventory" then
		if unified_inventory.current_page[name] == "clothing" then
			unified_inventory.set_inventory_formspec(player, "clothing")
		end
	else
		local formspec = clothing.formspec..
			"list[detached:"..name.."_clothing;clothing;0,0.5;2,3;]"
		if clothing.inv_mod == "inventory_plus" then
			local page = player:get_inventory_formspec()
			if page:find("detached:"..name.."_clothing") then
				inventory_plus.set_inventory_formspec(player, formspec..
					"listring[current_player;main]"..
					"listring[detached:"..name.."_clothing;clothing]")
			end
		end
	end
end
