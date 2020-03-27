-- You'll need a pointer (digipherals:pointer) to play this

function restart() 
    digiline_send("monitor1", {"set_resolution", 32, 32})
    digiline_send("monitor1", {"clear_screen"})
    mem.snake_pixels = {{5,5}, {4,5}, {3,5}}
    mem.snake_dir = {1,0}
    mem.apple = {15,15}
end

function eat_apple() 
    -- since the lua controller has no randomseed function
    -- we'll have to develop our own RNG
    xpos = (os.time() * 234190) % 24 + 4
    ypos = (os.time() * 654135) % 24 + 4
    mem.apple = {xpos, ypos}
end


if event.type == "program" then
    restart()
    interrupt(0.1)
end

if event.type == "interrupt" then

    commands = {"batch", 
        {"clear_screen"},
        {"set_pixel", mem.apple[1], mem.apple[2], 4}
    }

    for idx, i in ipairs(mem.snake_pixels) do
        commands[#commands+1] = {"set_pixel", i[1], i[2], 10}
        if idx ~= 1 then
            if (i[1] == mem.snake_pixels[1][1]) and (i[2] == mem.snake_pixels[1][2]) then
                restart()
            end
        end
    end
    
    -- check for out of bounds
    if math.max(mem.snake_pixels[1][1], mem.snake_pixels[1][2]) > 32 then
        restart()
    end
    if math.min(mem.snake_pixels[1][1], mem.snake_pixels[1][2]) < 0 then
        restart()
    end

    -- advance snake head
    table.insert(mem.snake_pixels, 1, {
        mem.snake_pixels[1][1]+mem.snake_dir[1],
        mem.snake_pixels[1][2]+mem.snake_dir[2]}) 

    -- only remove last block if snake didn't eat an apple
    if (mem.apple[1] == mem.snake_pixels[1][1]) and (mem.apple[2] == mem.snake_pixels[1][2]) then
        eat_apple()
    else
        table.remove(mem.snake_pixels)
    end
    digiline_send("monitor1", commands)
    interrupt(0.1)
end

if event.type == "digiline" then
    if event.channel == "monitor1_o" then
        -- get click position relative to snake head
        local relative_x = event.msg[2]-mem.snake_pixels[1][1]
        local relative_y = event.msg[3]-mem.snake_pixels[1][2]

        -- get the largest axis
        largest_idx = (math.abs(relative_x) > math.abs(relative_y)) and  2 or 3


        negative = 1
        if event.msg[largest_idx]-mem.snake_pixels[1][largest_idx-1] < 0 then
            negative = -1
        end
        
        -- dont allow 180 turns
        if mem.snake_dir[largest_idx-1] ~= negative * -1 then
            mem.snake_dir = {0,0}
            mem.snake_dir[largest_idx-1] = negative
        end
  
    end
end