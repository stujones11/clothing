CLOTHING_DYE_COLORS = {
	"white", "grey", "black", "red", "yellow", "green", "cyan", "blue",
	"magenta", "orange", "violet", "brown", "pink", "dark_grey", "dark_green",
}

dofile(minetest.get_modpath(minetest.get_current_modname()).."/clothing.lua")

if CLOTHING_ENABLE_CRAFTING then
	local c = "farming:cotton"
	local x = ""
	local dep = minetest.get_modpath("farming") and minetest.get_modpath("dye")
	for _, color in pairs(CLOTHING_DYE_COLORS) do
		local d = "dye:"..color
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
		if dep then
			minetest.register_craft({
				output = "clothing:hat_"..color,
				recipe = {
					{c, c, c},
					{c, d, c},
				},
			})
			minetest.register_craft({
				output = "clothing:shirt_"..color,
				recipe = {
					{c, c, c},
					{c, c, c},
					{c, d, c},
				},
			})
			minetest.register_craft({
				output = "clothing:pants_"..color,
				recipe = {
					{c, c, c},
					{c, d, c},
					{c, x, c},
				},
			})
			minetest.register_craft({
				output = "clothing:cape_"..color,
				recipe = {
					{c, d, c},
					{c, c, c},
					{c, c, c},
				},
			})
		end
	end
end



