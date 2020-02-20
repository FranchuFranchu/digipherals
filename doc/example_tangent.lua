-- Graph tan(x)

if event.type == "program" then
 digiline_send("monitor1", {"clear_screen"})
 digiline_send("monitor1", {"set_resolution", 64, 64})
 mem.counter = 0
end



digiline_send("monitor1", 
  {"set_pixel", 
  mem.counter, 
  math.tan((mem.counter/10))+32, -- some scaling to draw the wave at a confortable scale
  mem.counter %15+1})  

mem.counter = mem.counter + 1

if mem.counter == 64 then
 digiline_send("monitor1", {"clear_screen"}) -- repeat
 mem.counter = 0
end

interrupt(0.1)