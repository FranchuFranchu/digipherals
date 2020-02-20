--[[display_api.register_display_entity("digipherals:basic_screen_entity")
display_api.register_display_entity("digipherals:null_screen_entity")



]]
display_api.register_display_entity("digipherals:entity1")
display_api.register_display_entity("digipherals:entity2")



display_api.register_display_entity("digipherals:basic_screen_entity")
display_api.register_display_entity("digipherals:null_screen_entity")


local modpath = minetest.get_modpath("digipherals") .. '/'

digipherals = {}
digipherals.helpers = {}
digipherals.api = {}

dofile(modpath .. "peripheral_helpers.lua")
dofile(modpath .. "screen_helpers.lua")
dofile(modpath .. "screen_api.lua")
dofile(modpath .. "sample_screen.lua")

