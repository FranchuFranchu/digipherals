Digipherals
==========================================================

Minetest mod: Attempts to provide a standarized interface for digiline peripherals
![alt text goes here](https://imgur.com/M18iUag.gif)

see [doc/basic.rst](doc/basic.rst) for more info

Luacontroller code:

    if event.type == "program" then
     digiline_send("monitor1", {"clear_screen"})
     digiline_send("monitor1", {"set_resolution", 64, 64})
     mem.counter = 0
    end

    digiline_send("monitor1", 
      {"set_pixel", 
      mem.counter, 
      math.sin((mem.counter)/3)*20+32, -- some scaling to draw the wave at a confortable scale
      mem.counter %15+1} --draw color indexes 1-15 (no black))  

    mem.counter = mem.counter + 1

    if mem.counter == 64 then
     digiline_send("monitor1", {"clear_screen"}) -- repeat
     mem.counter = 0
    end

    interrupt(0.1) -- repeat!

Licensing
=============
Graphics card texture is a modification of a texture from https://github.com/minetest-mods/mesecons, it's CC-BY-SA 3.0 that's why i'm attributing them