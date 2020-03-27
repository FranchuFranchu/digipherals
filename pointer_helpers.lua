digipherals.helpers.pointer = {}


digipherals.helpers.pointer.on_use = function(itemstack, user, pointed_thing)
    if not digipherals.helpers.screen.is_screen(pointed_thing.under) then
        return
    end

    local look_dir = user:get_look_dir()
    local pos1 = user:get_pos()
    pos1.y = pos1.y + user:get_properties().eye_height
    local pos2 = vector.add(pos1, vector.apply(look_dir, function(i) return i * digipherals.MAX_POINTER_RANGE end))
    local ray = minetest.raycast(pos1, pos2, false)
 
    local pointed_thing = ray:next()

    if pointed_thing == nil then
        return
    end


    local relative_left, relative_up = digipherals.helpers.screen.get_relative_vectors(pointed_thing.under)
    local relative_up_index = 0
    local relative_left_index = 0
    for k,v in pairs(relative_left) do
        if v ~= 0 then
            relative_left_index = k 
        end
    end
    for k,v in pairs(relative_up) do
        if v ~= 0 then
            relative_up_index = k 
        end
    end
    local xc = pointed_thing.intersection_point[relative_left_index]
    local yc = pointed_thing.intersection_point[relative_up_index]
    xc = pointed_thing.under[relative_left_index] - xc
    yc = pointed_thing.under[relative_up_index] - yc
    xc = xc * relative_left[relative_left_index]
    yc = yc * relative_up[relative_up_index]
    xc = xc + 0.5
    yc = yc + 0.5

    local res = digipherals.api.screen.get_resolution(pointed_thing.under)
    xc = xc * res[1]
    yc = yc * res[2]
    digipherals.helpers.screen.pointer_action(pointed_thing.under, xc, yc, {})


end