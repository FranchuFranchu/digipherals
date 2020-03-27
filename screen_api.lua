digipherals.api.screen = {}

digipherals.api.screen.clear_screen = function(pos)

    digipherals.helpers.check_meta(pos)
    
    local meta = minetest.get_meta(pos)
    local tmp = minetest.deserialize(meta:get_string("digipherals"))

    tmp.screen.pixels = {}

    meta:set_string("digipherals", minetest.serialize(tmp))
    display_api.update_entities(pos)

    return true
end

digipherals.api.screen.set_resolution = function(pos,w,h)
    
    local meta = minetest.get_meta(pos)
    local tmp = minetest.deserialize(meta:get_string("digipherals"))

    tmp.screen.resolution = {x=w, y=h}

    meta:set_string("digipherals", minetest.serialize(tmp))
    display_api.update_entities(pos)

    return true
end


digipherals.api.screen.get_resolution = function(pos,w,h)
    digipherals.helpers.check_meta(pos)
    
    local meta = minetest.get_meta(pos)
    local tmp = minetest.deserialize(meta:get_string("digipherals"))

    return {tmp.screen.resolution.x, tmp.screen.resolution.y}
end


digipherals.api.screen.set_pixel = function(pos,x, y, colorindex)

    digipherals.helpers.check_meta(pos)
    
    local meta = minetest.get_meta(pos)
    local tmp = minetest.deserialize(meta:get_string("digipherals"))

    tmp.screen.pixels[x .. "," .. y] = colorindex

    meta:set_string("digipherals", minetest.serialize(tmp))
    display_api.update_entities(pos)

    return true
end

digipherals.api.screen.get_pixel = function(pos,x, y)

    digipherals.helpers.check_meta(pos)
    
    local meta = minetest.get_meta(pos)
    local tmp = minetest.deserialize(meta:get_string("digipherals"))

    return tmp.screen.pixels[x .. "," .. y]
end