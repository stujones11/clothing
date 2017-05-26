CLOTHING_COLORS = {
	["wool:white"] = {name="white", hex="#FFFFFF"},
	["wool:grey"] = {name="grey", hex="#C0C0C0"},
	["wool:black"] = {name="black", hex="#232323"},
	["wool:red"] = {name="red", hex="#0A0000"},
	["wool:yellow"] = {name="yellow", hex="#FFEE00"},
	["wool:green"] = {name="green", hex="#32CD32"},
	["wool:cyan"] = {name="cyan", hex="#00959D"},
	["wool:blue"] = {name="blue", hex="#003376"},
	["wool:magenta"] = {name="magenta", hex="#D80481"},
	["wool:orange"] = {name="orange", hex="#E0601A"},
	["wool:violet"] = {name="violet", hex="#480080"},
	["wool:brown"] = {name="brown", hex="#391A00"},
	["wool:pink"] = {name="pink", hex="#FFA5A5"},
	["wool:dark_grey"] = {name="dark_grey", hex="#696969"},
	["wool:dark_green"] = {name="dark_green", hex="#154F00"},
}

local modpath = minetest.get_modpath(minetest.get_current_modname())

dofile(modpath.."/clothing.lua")

if CLOTHING_ENABLE_CRAFTING and minetest.get_modpath("wool") then
	for _, color in pairs(CLOTHING_COLORS) do
		local desc = color.name:gsub("%a", string.upper, 1)
		desc = desc:gsub("_", " ")
		minetest.register_craftitem("clothing:hat_"..color.name, {
			description = desc.." Cotton Hat",
			inventory_image = "clothing_inv_hat.png^[multiply:"..color.hex,
			uv_image = "(clothing_uv_hat.png^[multiply:"..color.hex..")",
			groups = {clothing=1},
		})
		minetest.register_craftitem("clothing:shirt_"..color.name, {
			description = desc.." Cotton Shirt",
			inventory_image = "clothing_inv_shirt.png^[multiply:"..color.hex,
			uv_image = "(clothing_uv_shirt.png^[multiply:"..color.hex..")",
			groups = {clothing=1},
		})
		minetest.register_craftitem("clothing:pants_"..color.name, {
			description = desc.." Cotton Pants",
			inventory_image = "clothing_inv_pants.png^[multiply:"..color.hex,
			uv_image = "(clothing_uv_pants.png^[multiply:"..color.hex..")",
			groups = {clothing=1},
		})
		minetest.register_craftitem("clothing:cape_"..color.name, {
			description = desc.." Cotton Cape",
			inventory_image = "clothing_inv_cape.png^[multiply:"..color.hex,
			uv_image = "(clothing_uv_cape.png^[multiply:"..color.hex..")",
			groups = {cape=1},
		})
	end
	dofile(modpath.."/loom.lua")
end
