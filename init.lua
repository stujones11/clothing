CLOTHING_COLORS = {
	["wool:white"] = "white",
	["wool:grey"] = "grey",
	["wool:black"] = "black",
	["wool:red"] = "red",
	["wool:yellow"] = "yellow",
	["wool:green"] = "green",
	["wool:cyan"] = "cyan",
	["wool:blue"] = "blue",
	["wool:magenta"] = "magenta",
	["wool:orange"] = "orange",
	["wool:violet"] = "violet",
	["wool:brown"] = "brown",
	["wool:pink"] = "pink",
	["wool:dark_grey"] = "dark_grey",
	["wool:dark_green"] = "dark_green",
}

local modpath = minetest.get_modpath(minetest.get_current_modname())

dofile(modpath.."/clothing.lua")

if CLOTHING_ENABLE_CRAFTING and minetest.get_modpath("wool") then
	for _, color in pairs(CLOTHING_COLORS) do
		local color_name = color:gsub("%a", string.upper, 1)
		minetest.register_craftitem("clothing:hat_"..color, {
			description = color_name.." Cotton Hat",
			inventory_image = "clothing_inv_hat_"..color..".png",
			uv_image = "clothing_uv_hat_"..color..".png",
			preview_image = "clothing_preview_hat_"..color..".png",
			groups = {clothing=1},
		})
		minetest.register_craftitem("clothing:shirt_"..color, {
			description = color_name.." Cotton Shirt",
			inventory_image = "clothing_inv_shirt_"..color..".png",
			uv_image = "clothing_uv_shirt_"..color..".png",
			preview_image = "clothing_preview_shirt_"..color..".png",
			groups = {clothing=1},
		})
		minetest.register_craftitem("clothing:pants_"..color, {
			description = color_name.." Cotton Pants",
			inventory_image = "clothing_inv_pants_"..color..".png",
			uv_image = "clothing_uv_pants_"..color..".png",
			preview_image = "clothing_preview_pants_"..color..".png",
			groups = {clothing=1},
		})
		minetest.register_craftitem("clothing:cape_"..color, {
			description = color_name.." Cotton Cape",
			inventory_image = "clothing_inv_cape_"..color..".png",
			uv_image = "clothing_uv_cape_"..color..".png",
			groups = {clothing=1},
		})
	end
	dofile(modpath.."/loom.lua")
end



