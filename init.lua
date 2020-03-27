display_api.register_display_entity("digipherals:entity1")
display_api.register_display_entity("digipherals:entity2")



display_api.register_display_entity("digipherals:basic_screen_entity")
display_api.register_display_entity("digipherals:null_screen_entity")


if table.unpack == nil then
    table.unpack = function (t, i)
        i = i or 1
        if t[i] ~= nil then
            return t[i], unpack(t, i + 1)
        end
    end
end

local modpath = minetest.get_modpath("digipherals") .. '/'

digipherals = {}

digipherals.MAX_POINTER_RANGE = 20

digipherals.helpers = {}
digipherals.api = {}

dofile(modpath .. "peripheral_helpers.lua")
dofile(modpath .. "peripheral_api.lua")

dofile(modpath .. "pointer_helpers.lua")
dofile(modpath .. "pointer.lua")

dofile(modpath .. "graphics_card_helpers.lua")
dofile(modpath .. "graphics_card_api.lua")
dofile(modpath .. "graphics_card.lua")

dofile(modpath .. "screen_helpers.lua")
dofile(modpath .. "screen_api.lua")
dofile(modpath .. "sample_screen.lua")


