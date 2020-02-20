from PIL import Image

cols = [
    "#000000", # black, 0x0
    "#0000AA", # blue, 0x1
    "#00AA00", # green, 0x2
    "#00AAAA", # cyan, 0x3
    "#AA0000", # red, 0x4
    "#AA00AA", # magenta, 0x5
    "#AA5500", # brown, 0x6
    "#AAAAAA", # gray, 0x7
    "#555555", # dark gray, 0x8
    "#5555FF", # bright blue, 0x9
    "#55FF55", # bright green, 0xA
    "#55FFFF", # bright cyan, 0xB
    "#FF5555", # bright red, 0xC
    "#FF55FF", # bright magenta, 0xD
    "#FFFF55", # yellow, 0xE
    "#FFFFFF", # white, 0xF
]
PALLETE_NAME = "vga16"

for idx, i in enumerate(cols):
    Image.new("RGB", (1,1), i).save("textures/digipherals_pallete_{}_{}.png".format(PALLETE_NAME, idx))