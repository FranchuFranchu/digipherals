

-- generate possible connections array
local function get_combinations(tab, sample)
    if (sample == 1) then
        local newtab = {}
        for _, i in ipairs(tab) do
            newtab[#newtab+1] = {i}
        end
        return newtab
    end
    local vals = get_combinations(tab, sample - 1)
    local newtab = {}
    local nvals = table.copy(vals)
    nvals[#nvals+1] = 0

    for _, i in ipairs(vals) do
        for _, possibility in ipairs(tab) do
            local nval = table.copy(i)
            nval[#nval+1] = possibility
            newtab[#newtab+1] = nval
        end
    end
    return newtab
end

local function get_node_box(connections)
    box = {{8/16, 8/16, 8/16, -8/16, -8/16, 7/16}}
    -- side of the monitor
    if connections[1] == 1 then box[#box+1] = {8/16, 8/16, 8/16, 7/16, -8/16, 6/16}   end
    if connections[2] == 1 then box[#box+1] = {8/16, 8/16, 8/16, -8/16, 7/16, 6/16}   end
    if connections[3] == 1 then box[#box+1] = {-8/16, -8/16, 8/16, -7/16, 8/16, 6/16} end
    if connections[4] == 1 then box[#box+1] = {-8/16, -8/16, 8/16, 8/16, -7/16, 6/16} end
    
    return box
    

end

local base_table = {
    light_source = minetest.LIGHT_MAX,
    paramtype2 = "facedir",
    drawtype = "nodebox",

    tiles = { "digipherals_sample_led.png"},
    
    groups = { display_api = 1, oddly_breakable_by_hand=3},

    
    display_entities = {
        ["digipherals:entity1"] = {
            depth = 6.5/16,
            on_display_update = digipherals.helpers.screen.display_update },
        ["digipherals:entity2"] = {
            depth = 6.51/16,
            on_display_update = digipherals.helpers.screen.display_null },
    },

    digipherals = {
        api = digipherals.helpers.superpose_table(
            digipherals.api.screen,
            digipherals.api.global
        ),
        screen = {
            resolution = {x=10,y=10},
            pallete = "digipherals_pallete_vga16",
        }
    },
    on_place = display_api.on_place,
    on_construct = function(...)
        display_api.on_construct(...)
        digipherals.helpers.formspec_construct(...) 
    end,
    on_destruct = display_api.on_destruct,
    on_rotate = display_api.on_rotate,
    after_place_node = digipherals.helpers.screen.autoconnect_edges,
    on_receive_fields = digipherals.helpers.on_receive_fields,
    drop = "digipherals:sample_screen",
    digiline = {
        receptor = {},
        effector = {
            action =  digipherals.helpers.on_digiline_receive,
        },
    },
}

minetest.register_node("digipherals:sample_screen", digipherals.helpers.superpose_table(base_table,{description = "Basic Screen",
    node_box = {
        type = "fixed",
        fixed = {
            {8/16, 8/16, 8/16, -8/16, -8/16, 7/16}, -- base backplate
            -- side of the monitor
            {8/16, 8/16, 8/16, 7/16, -8/16, 6/16},  
            {8/16, 8/16, 8/16, -8/16, 7/16, 6/16},  
            {-8/16, -8/16, 8/16, -7/16, 8/16, 6/16},  
            {-8/16, -8/16, 8/16, 8/16, -7/16, 6/16},  
        }
    },}))

for _, connections in ipairs(get_combinations({1,0},4)) do
    minetest.register_node(
            "digipherals:sample_screen_" .. connections[1] .. connections[2] .. connections[3] .. connections[4],
            digipherals.helpers.superpose_table(base_table, {node_box={type="fixed", fixed=get_node_box(connections)}})
        )
        
end