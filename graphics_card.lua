minetest.register_node("digipherals:graphics_card", {
    description = "Graphics card",
    drawtype = "nodebox",
    tiles = {
        "graphics_card_top.png",
        "jeija_microcontroller_bottom.png",
        "graphics_card_sides.png",
        "graphics_card_sides.png",
        "graphics_card_sides.png",
        "graphics_card_sides.png"
        },

    sunlight_propagates = true,
    paramtype = "light",
    is_ground_content = false,
    walkable = true,
    groups = {oddly_breakable_by_hand=3},
    selection_box = {
        type = "fixed",
        fixed = { -8/16, -8/16, -8/16, 8/16, -5/16, 8/16 },
    },
    node_box = {
        type = "fixed",
        fixed = {
            { -8/16, -8/16, -8/16, 8/16, -7/16, 8/16 }, -- bottom slab
            { -5/16, -7/16, -5/16, 5/16, -6/16, 5/16 }, -- circuit board
            { -3/16, -6/16, -3/16, 3/16, -5/16, 3/16 }, -- IC
        }
    },

    digipherals = {
        api = digipherals.helpers.superpose_table(
            digipherals.api.graphics_card,
            digipherals.api.global
        ),
    },
    digiline = {
        receptor = {},
        effector = {
            action =  digipherals.helpers.on_digiline_receive,
        },
    },
    on_construct = function(...)
        display_api.on_construct(...)
        digipherals.helpers.formspec_construct(...) 
    end,
    on_receive_fields = digipherals.helpers.on_receive_fields,
})