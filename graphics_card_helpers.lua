digipherals.helpers.graphics_card = {}

digipherals.helpers.graphics_card.is_screen = function(pos)     

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

digipherals.helpers.graphics_card.get_attached_screen = function(pos)
    local found = false
    local pos2 = nil
    for k, v in pairs(pos) do
        pos2 = vector.new(pos)
        pos2[k] = pos2[k] + 1
        if digipherals.helpers.graphics_card.is_screen(pos2) then
            found = true
            break
        end
        pos2[k] = pos2[k] - 2
        if digipherals.helpers.graphics_card.is_screen(pos2) then
            found = true
            break
        end
    end
    if not found then return nil end
    return pos2

end

digipherals.helpers.graphics_card.get_individual_resolution = function(pos)


    local pos2 = digipherals.helpers.graphics_card.get_attached_screen(pos)
    if pos2 == nil then return nil end

    -- pos2 now hopefully has the position of a screen
    digipherals.helpers.check_meta(pos2)


    local meta = minetest.get_meta(pos2)
    local tmp = minetest.deserialize(meta:get_string("digipherals"))


    return tmp.screen.resolution

end

digipherals.helpers.graphics_card.get_relative_vectors = function(pos) 
    local attached_screen = digipherals.helpers.graphics_card.get_attached_screen(pos)
    if attached_screen == nil then
        return
    end
    local param2 = minetest.get_node(attached_screen).param2
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

digipherals.helpers.graphics_card.get_top_left_screen = function(pos) 

    local attached_screen = digipherals.helpers.graphics_card.get_attached_screen(pos)
    if attached_screen == nil then
        return
    end
    local relative_left, relative_up = digipherals.helpers.graphics_card.get_relative_vectors(pos)
    local pos2 = vector.new(attached_screen)
    while true
    do
        pos2 = vector.add(pos2, relative_up)
        if not (digipherals.helpers.graphics_card.is_screen(pos2)) then 
            break
        end
    end

    local pos2 = vector.subtract(pos2, relative_up)

    while true
    do
        pos2 = vector.add(pos2, relative_left)
        if not (digipherals.helpers.graphics_card.is_screen(pos2)) then 
            break
        end
    end

    local pos2 = vector.subtract(pos2, relative_left)
    return pos2
end

digipherals.helpers.graphics_card.get_total_size = function(pos) 

    local topleft = digipherals.helpers.graphics_card.get_top_left_screen(pos)

    local relative_left, relative_up = digipherals.helpers.graphics_card.get_relative_vectors(pos)
    local relative_down = vector.subtract(vector.new(), relative_up)
    local relative_right = vector.subtract(vector.new(), relative_left)


    local sw = 0
    local pos2 = vector.new(topleft)
    while true
    do
        pos2 = vector.add(pos2, relative_right)
        if not (digipherals.helpers.graphics_card.is_screen(pos2)) then 
            break
        end
        sw = sw + 1
    end

    local sh = 0
    local pos2 = vector.new(topleft)

    while true
    do
        pos2 = vector.add(pos2, relative_down)
        if not (digipherals.helpers.graphics_card.is_screen(pos2)) then 
            break
        end
        sh = sh + 1
    end
    return sw+1, sh+1
end

digipherals.helpers.graphics_card.get_all_screens = function(pos) 
    local topleft = digipherals.helpers.graphics_card.get_top_left_screen(pos)

    local relative_left, relative_up = digipherals.helpers.graphics_card.get_relative_vectors(pos)
    local relative_down = vector.subtract(vector.new(), relative_up)
    local relative_right = vector.subtract(vector.new(), relative_left)

    local sw, sh = digipherals.helpers.graphics_card.get_total_size(pos)

    local function range(from, to, step)
      step = step or 1
      return function(_, lastvalue)
        local nextvalue = lastvalue + step
        if step > 0 and nextvalue <= to or step < 0 and nextvalue >= to or
           step == 0
        then
          return nextvalue
        end
      end, nil, from - step
    end


    local pos_table = {}

    local hpos = vector.add(vector.new(topleft), relative_up)
    print(minetest.get_node(topleft).name)
    for x in range(0,sw-1) do
        local vpos = vector.new(hpos)
        for y in range(0,sh-1) do
            vpos = vector.add(vpos, relative_down)
            print(minetest.serialize(vpos))
            print(minetest.get_node(vpos).name)
            if not digipherals.helpers.graphics_card.is_screen(vpos) then
                break
            end
            pos_table[#pos_table+1] = vector.new(vpos)
            print(#pos_table)
        end
        hpos = vector.add(hpos, relative_right)

    end

    print(minetest.serialize(pos_table))
    return pos_table

end