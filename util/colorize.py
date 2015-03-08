#!/usr/bin/python

# Colorize base textures with minetest base dye colors
# Requires Python Imaging Library (PIL)

import os
import PIL
from PIL import Image
from PIL import ImageOps

colors = {
	"white": (0xFF, 0xFF, 0xFF),
	"black": (0x23, 0x23, 0x23),
	"grey": (0xC0, 0xC0, 0xC0),
	"red": (0xA0, 0x00, 0x00),
	"yellow": (0xFF, 0xEE, 0x00),
	"green": (0x32, 0xCD, 0x32),
	"cyan": (0x00, 0x95, 0x9D),
	"blue": (0x00, 0x33, 0x76),
	"magenta": (0xD8, 0x04, 0x81),
	"orange": (0xE0, 0x60, 0x1A),
	"violet": (0x48, 0x00, 0x80),
	"brown": (0x39, 0x1A, 0x00),
	"pink": (0xFF, 0xA5, 0xA5),
	"dark_grey": (0x69, 0x69, 0x69),
	"dark_green": (0x15, 0x4f, 0x00)
}

files = os.listdir('base_textures')

for f in files:
	n = os.path.splitext(f)[0]
	for color, rgb in colors.iteritems():
		img_org = Image.open("base_textures/" + f).convert('RGBA')
		img_new = ImageOps.colorize(img_org.convert('L'), (0,0,0), rgb)
		img_new.putalpha(img_org.split()[3])
		img_new.save("../textures/" + n + "_" + color + ".png")
		print n + "_" + color + ".png"

