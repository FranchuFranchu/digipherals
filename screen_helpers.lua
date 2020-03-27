digipherals.helpers.screen = {}


digipherals.helpers.screen.is_screen = function(pos)     

    digipherals.helpers.check_meta(pos)
    local meta = minetest.get_meta(pos)
    local meta_ = meta:get_string("digipherals")
    if meta_ == "" then
        return false
    end
    local tmp = minetest.deserialize(meta_)
    if tmp.screen ~= nil then
        return true
    else
        return false
    end
end

digipherals.helpers.screen.clear_screen = function(pos, objref)
    digipherals.helpers.check_meta(pos, objref)

    local meta = minetest.get_meta(pos)
    local tmp = minetest.deserialize(meta:get_string("digipherals"))

    tmp.screen.pixels = {}
    meta:set_string("digipherals", minetest.serialize(tmp))
end

digipherals.helpers.screen.get_relative_vectors = function(pos) 

    local param2 = minetest.get_node(pos).param2
    local front_vector = vector.subtract(vector.new(),minetest.facedir_to_dir(param2))
    local left_vector = vector.new(-1, 0, 0)
    local up_vector = vector.new(0, 1, 0)
    local relative_up = vector.cross(left_vector, front_vector)
    local relative_left = vector.cross(up_vector, front_vector)
    if vector.equals(relative_left, vector.new()) then
        relative_left = vector.new(1, 0, 0)
    end
    if vector.equals(relative_up, vector.new()) then
        relative_up = vector.new(0, 1, 0)
    end

    return relative_left, relative_up
end

digipherals.helpers.screen.display_update = function(pos, objref)
    digipherals.helpers.check_meta(pos, objref)
    local meta = minetest.get_meta(pos)
    local tmp = minetest.deserialize(meta:get_string("digipherals"))

    local texture = string.format("[combine:%dx%d", tmp.screen.resolution.x, tmp.screen.resolution.y)

    for coords, i in pairs(tmp.screen.pixels) do
        
        texture = texture .. string.format(":%s=%s_%d.png", coords, tmp.screen.pallete, i)
    end


    objref:set_properties({ 
        textures= {
           texture
        },
        visual_size = {x=1, y=1} 
    })
end

digipherals.helpers.screen.display_null = function(pos, objref)
    objref:set_properties({
        textures = {
            "[combine:1x1:0,0=digipherals_pallete_vga16_0.png"
        },  
        visual_size = {x=1, y=1} 
    })
end

local function _autoconnect_edges(pos, placer, itemstack, pointed_thing) 
    local function starts_with(str, start)
       return str:sub(1, #start) == start
    end

    local node = minetest.get_node(pos)
    if node.name:match(".+_[0-9]+") then
        node.name = node.name:sub(1, #node.name-5)
    end
    minetest.set_node(pos, node)




    local param2 = minetest.get_node(pos).param2
    local front_vector = vector.subtract(vector.new(),minetest.facedir_to_dir(param2))
    local left_vector = vector.new(-1, 0, 0)
    local up_vector = vector.new(0, 1, 0)
    local relative_up = vector.cross(left_vector, front_vector)
    local relative_left = vector.cross(up_vector, front_vector)
    if vector.equals(relative_left, vector.new()) then
        relative_left = vector.new(1, 0, 0)
    end
    if vector.equals(relative_up, vector.new()) then
        relative_up = vector.new(0, 1, 0)
    end

    local relative_right = vector.subtract(vector.new(), relative_left)
    local relative_down = vector.subtract(vector.new(), relative_up)

    local connections_vals = {
        [minetest.serialize(relative_right)] = 1,
        [minetest.serialize(relative_left)] = 3,
        [minetest.serialize(relative_up)] = 2,
        [minetest.serialize(relative_down)] = 4,
    }

    local connections = {1,1,1,1}
    for _, i in ipairs({relative_right, relative_left, relative_down, relative_up}) do
        local offset = i
        local offsetpos = vector.add(pos, offset)
        if digipherals.helpers.screen.is_screen(offsetpos) then
            
            local index = connections_vals[minetest.serialize(i)]
            if index == nil then
                
                
            else 
                connections[index] = 0
            end

        end
    end

    local newname = minetest.get_node(pos).name.."_"..connections[1] .. connections[2] .. connections[3] .. connections[4]
    minetest.set_node(pos, digipherals.helpers.superpose_table(minetest.get_node(pos), {name=newname}))
end

digipherals.helpers.screen.autoconnect_edges = function(pos, placer, itemstack, pointed_thing) 
    
    for k, v in pairs(pos) do
        pos2 = vector.new(pos)
        pos2[k] = pos2[k] + 1
        digipherals.helpers.check_meta(pos2)
        if digipherals.helpers.screen.is_screen(pos2) then _autoconnect_edges(pos2, placer, itemstack, pointed_thing) end
        pos2[k] = pos2[k] - 2
        digipherals.helpers.check_meta(pos2)
        if digipherals.helpers.screen.is_screen(pos2) then _autoconnect_edges(pos2, placer, itemstack, pointed_thing) end
    end
    _autoconnect_edges(pos, placer, itemstack, pointed_thing)
 
end
