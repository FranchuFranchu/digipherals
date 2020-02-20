digipherals.helpers.screen = {}


digipherals.helpers.screen.clear_screen = function(pos, objref)
    digipherals.helpers.check_meta(pos, objref)

    local meta = minetest.get_meta(pos)
    local tmp = minetest.deserialize(meta:get_string("digipherals"))

    tmp.screen.pixels = {}
    meta:set_string("digipherals", minetest.serialize(tmp))
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
