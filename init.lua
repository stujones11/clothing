CLOTHING_WOOL_COLORS = {
	"white", "grey", "black", "red", "yellow", "green", "cyan", "blue",
	"magenta", "orange", "violet", "brown", "pink", "dark_grey", "dark_green",
}

dofile(minetest.get_modpath(minetest.get_current_modname()).."/clothing.lua")

local function get_preview_hat(color)
	local texture = "clothing_preview_bg.png^[combine:128x256"
	for x = 32, 80, 16 do
		for y = 8, 40, 16 do
			if y == 8 or x == 32 or x == 80 then
				texture = texture..":"..x..","..y.."=clothing_wool_"..color..".png"
			end
		end
	end
	return texture
end

local function get_preview_shirt(color)
	local texture = "clothing_preview_bg.png^[combine:128x256"
	for x = 8, 112, 16 do
		for y = 64, 144, 16 do
			texture = texture..":"..x..","..y.."=clothing_wool_"..color..".png"
		end
	end
	return texture
end

local function get_preview_pants(color)
	local texture = "clothing_preview_bg.png^[combine:128x256"
	for x = 32, 80, 16 do
		for y = 160, 224, 16 do
			texture = texture..":"..x..","..y.."=clothing_wool_"..color..".png"
		end
	end
	return texture
end

for _, color in pairs(CLOTHING_WOOL_COLORS) do
	local color_name = color:gsub("%a", string.upper, 1)
	minetest.register_craftitem("clothing:hat_"..color, {
		description = color_name.." Wool Hat",
		inventory_image = "clothing_wool_"..color..".png^clothing_inv_hat_mask.png^[makealpha:255,126,126",
		uv_image = "clothing_uv_bg.png^[combine:64x32:32,0=clothing_wool_"..color..".png:"
				.."48,0=clothing_wool_"..color..".png^clothing_uv_mask.png^[makealpha:255,126,126",
		preview_image = get_preview_hat(color),
		groups = {clothing=1},
	})
	minetest.register_craftitem("clothing:shirt_"..color, {
		description = color_name.." Wool Shirt",
		inventory_image = "clothing_wool_"..color..".png^clothing_inv_shirt_mask.png^[makealpha:255,126,126",
		uv_image = "clothing_uv_bg.png^[combine:64x32:16,16=clothing_wool_"..color..".png:"
				.."32,16=clothing_wool_"..color..".png:40,16=clothing_wool_"..color..".png^"
				.."clothing_uv_mask.png^[makealpha:255,126,126",
		preview_image = get_preview_shirt(color),
		groups = {clothing=1},
	})
	minetest.register_craftitem("clothing:pants_"..color, {
		description = color_name.." Wool Pants",
		inventory_image = "clothing_wool_"..color..".png^clothing_inv_pants_mask.png^[makealpha:255,126,126",
		uv_image = "clothing_uv_bg.png^[combine:64x32:0,16=clothing_wool_"..color..".png"
				.."^clothing_uv_mask.png^[makealpha:255,126,126",
		preview_image = get_preview_pants(color),
		groups = {clothing=1},
	})
	minetest.register_craftitem("clothing:cape_"..color, {
		description = color_name.." Wool Cape",
		inventory_image = "clothing_wool_"..color..".png^clothing_inv_cape_mask.png^[makealpha:255,126,126",
		uv_image = "clothing_uv_bg.png^[combine:64x32:56,16=clothing_wool_"..color..".png"
				.."^clothing_uv_mask.png^[makealpha:255,126,126",
		groups = {clothing=1},
	})
end

