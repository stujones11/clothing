clothing = {
	formspec = "size[8,8.5]"..
		default.gui_bg..
		default.gui_bg_img..
		default.gui_slots..
		"list[current_player;main;0,4.7;8,1;]"..
		"list[current_player;main;0,5.85;8,3;8]"..
		default.get_hotbar_bg(0,4.7),
	registered_callbacks = {
		on_update = {},
		on_equip = {},
		on_unequip = {},
	},
}

-- CLothing callbacks

clothing.register_on_update = function(self, func)
	if type(func) == "function" then
		table.insert(self.registered_callbacks.on_update, func)
	end
end

clothing.register_on_equip = function(self, func)
	if type(func) == "function" then
		table.insert(self.registered_callbacks.on_equip, func)
	end
end

clothing.register_on_unequip = function(self, func)
	if type(func) == "function" then
		table.insert(self.registered_callbacks.on_unequip, func)
	end
end

clothing.run_callbacks = function(self, callback, player, index, stack)
	if stack then
		local def = stack:get_definition() or {}
		if type(def[callback]) == "function" then
			def[callback](player, index, stack)
		end
	end
	local callbacks = self.registered_callbacks[callback]
	if callbacks then
		for _, func in pairs(callbacks) do
			func(player, index, stack)
		end
	end
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
	self:run_callbacks("on_update", player)
end
