local function superpose_table(base, exceptions)
  local result = table.copy(base)
  for key, value in pairs(exceptions) do
        if type(value) == 'table' then
      result[key] = superpose_table(result[key] or {}, value)
    else
      result[key] = value
    end
  end
  return result
end


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

local function autoconnect_edges(pos, placer, itemstack, pointed_thing) 

    local function starts_with(str, start)
       return str:sub(1, #start) == start
    end

    -- super hacky and hard to extend but it works
    -- param2: 0 = y+    1 = z+    2 = z-    3 = x+    4 = x-    5 = y-
    local function getoffset_param2(param2)
        if param2 == 1 then
            return {x=0, y=1, z=0}
        elseif param2 == 0 then
            return {x=0, y=0, z=-1}
        elseif param2 == 5 then
            return {x=0, y=0, z=1}
        elseif param2 == 3 then
            return {x=1, y=0, z=0}
        elseif param2 == 4 then
            return {x=-1, y=0, z=0}
        elseif param2 == 2 then
            return {x=0, y=-1, z=0}
        end
    end

    local function get_direction_vector(basepos, offsetpos, param2)
        local normal = getoffset_param2(param2)
        local up = vector.new(normal.z,normal.x,normal.y)
        local right = vector.cross(normal, up)
        local left = vector.cross(up, normal)
        local below = vector.cross(normal, right)
        local above = vector.cross(right, normal)

        local pointing = vector.direction(basepos, offsetpos)


        if normal.z ~= 0 then
            -- it just works
            pointing = vector.cross(vector.new(0,0,1),pointing)
        end

        if normal.y ~= 0 then
            -- it just works
            pointing = vector.cross(vector.new(0,1,0),pointing)
        end

        if vector.equals(right, pointing) then
            return {x=1, y=0, z=0}
        elseif vector.equals(left, pointing) then
            return {x=-1, y=0, z=0}
        elseif vector.equals(above, pointing) then
            return {x=0, y=-1, z=0}
        elseif vector.equals(below, pointing) then
            return {x=0, y=1, z=0}
        end
        return {x=0, y=0, z=0}

    end

    local connections_vals = {
        [minetest.serialize({x=1, y=0, z=0})] = 1,
        [minetest.serialize({x=-1, y=0, z=0})] = 3,
        [minetest.serialize({x=0, y=-1, z=0})] = 2,
        [minetest.serialize({x=0, y=1, z=0})] = 4,
    }

    local param2 = minetest.get_node(pos).param2

    local connections = {1,1,1,1}
    for _, i in ipairs({0,1,2,3,4,5}) do
        local delta = 1
        local offset = getoffset_param2(i)
        local offsetpos = vector.add(pos, offset)
        if minetest.get_node(offsetpos).name:match("^digipherals:sample_screen") ~= nil then
            local delta = get_direction_vector(pos, offsetpos, param2)
            local index = connections_vals[minetest.serialize(delta)]
            if index == nil then
                
                
            else 
                connections[index] = 0
            end

        end
    end

    local newname = minetest.get_node(pos).name.."_"..connections[1] .. connections[2] .. connections[3] .. connections[4]
    minetest.set_node(pos, superpose_table(minetest.get_node(pos), {name=newname}))
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
        api = superpose_table(
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
    after_place_node = autoconnect_edges,
    on_receive_fields = digipherals.helpers.on_receive_fields,
    drop = "digipherals:sample_screen",
    digiline = {
        receptor = {},
        effector = {
            action =  digipherals.helpers.on_digiline_receive,
        },
    },
}

minetest.register_node("digipherals:sample_screen", superpose_table(base_table,{description = "Basic Screen",
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
            superpose_table(base_table, {node_box={type="fixed", fixed=get_node_box(connections)}})
        )
        
end