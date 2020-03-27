digipherals.api.graphics_card = {}

digipherals.api.graphics_card.clear_screen = function(pos)
    for idx, pos2 in ipairs(digipherals.helpers.graphics_card.get_all_screens(pos)) do
        digipherals.api.screen.clear_screen(pos2)
    end
    return true
end

digipherals.api.graphics_card.set_resolution = function(pos,w,h)
    if not (w > 0 and h > 0) then
        return {"ERR", "Both width and height must be positive ints"}
    end

    local sw, sh = digipherals.helpers.graphics_card.get_total_size(pos)
    for idx, pos2 in ipairs(digipherals.helpers.graphics_card.get_all_screens(pos)) do
        digipherals.api.screen.set_resolution(pos2, math.floor(w / sw), math.floor(h / sh))
    end

    return true
end


digipherals.api.graphics_card.get_resolution = function(pos,w,h)
    local sw, sh = digipherals.helpers.graphics_card.get_total_size(pos)
    local pos2 = digipherals.helpers.graphics_card.get_attached_screen(pos)
    local resx, resy = table.unpack(digipherals.api.screen.get_resolution(pos2))
    return {resx * sw, resy * sh}
end

digipherals.api.graphics_card.set_pixel = function(pos,x, y, colorindex)
    digipherals.helpers.check_meta(pos)
    
    local meta = minetest.get_meta(pos)
    local tmp = minetest.deserialize(meta:get_string("digipherals"))
    
    local topleft = digipherals.helpers.graphics_card.get_top_left_screen(pos)
    local resolution = digipherals.helpers.graphics_card.get_individual_resolution(pos)
    local relative_left, relative_up = digipherals.helpers.graphics_card.get_relative_vectors(pos)
    local offblockx = math.floor(x / resolution.x)
    local offblocky = math.floor(y / resolution.y)
    local offpixx = math.floor(x % resolution.x)
    local offpixy = math.floor(y % resolution.y)


    local offblockvec = vector.add(vector.apply(relative_left, function(i) return (0-i) * offblockx end), vector.apply(relative_up, function(i) return (0-i) * offblocky end))
    local blockpos = vector.add(topleft, offblockvec)

    if digipherals.helpers.graphics_card.is_screen(blockpos) then
        digipherals.api.screen.set_pixel(blockpos, offpixx, offpixy, colorindex)
    end

    return true
end

digipherals.api.graphics_card.get_pixel = function(pos,x, y)

    digipherals.helpers.check_meta(pos)
    
    local meta = minetest.get_meta(pos)
    local tmp = minetest.deserialize(meta:get_string("digipherals"))
    
    local topleft = digipherals.helpers.graphics_card.get_top_left_screen(pos)
    local resolution = digipherals.helpers.graphics_card.get_individual_resolution(pos)
    local relative_left, relative_up = digipherals.helpers.graphics_card.get_relative_vectors(pos)
    local offblockx = math.floor(x / resolution.x)
    local offblocky = math.floor(y / resolution.y)
    local offpixx = math.floor(x % resolution.x)
    local offpixy = math.floor(y % resolution.y)


    local offblockvec = vector.add(vector.apply(relative_left, function(i) return (0-i) * offblockx end), vector.apply(relative_up, function(i) return (0-i) * offblocky end))
    local blockpos = vector.add(topleft, offblockvec)

    if digipherals.helpers.graphics_card.is_screen(blockpos) then
        return digipherals.api.screen.get_pixel(blockpos, offpixx, offpixy, colorindex)
    end

    return {false}
end