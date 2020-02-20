digipherals.api.screen = {}

digipherals.api.screen.clear_screen = function(pos)

    digipherals.helpers.screen.check_meta(pos)
    
    local meta = minetest.get_meta(pos)
    local tmp = minetest.deserialize(meta:get_string("digipherals"))

    tmp.screen.pixels = {}

    meta:set_string("digipherals", minetest.serialize(tmp))
    display_api.update_entities(pos)

    return true
end

digipherals.api.screen.set_resolution = function(pos,w,h)
    digipherals.helpers.screen.check_meta(pos)
    
    local meta = minetest.get_meta(pos)
    local tmp = minetest.deserialize(meta:get_string("digipherals"))

    tmp.screen.resolution = {x=w, y=h}

    meta:set_string("digipherals", minetest.serialize(tmp))
    display_api.update_entities(pos)

    return true
end

digipherals.api.screen.set_pixel = function(pos,x, y, colorindex)

    digipherals.helpers.screen.check_meta(pos)
    
    local meta = minetest.get_meta(pos)
    local tmp = minetest.deserialize(meta:get_string("digipherals"))

    tmp.screen.pixels[x .. "," .. y] = colorindex

    meta:set_string("digipherals", minetest.serialize(tmp))
    display_api.update_entities(pos)

    return true
end

digipherals.api.screen.get_pixel = function(pos,x, y)

    digipherals.helpers.screen.check_meta(pos)
    
    local meta = minetest.get_meta(pos)
    local tmp = minetest.deserialize(meta:get_string("digipherals"))

    return tmp.screen.pixels[x .. "," .. y]
end