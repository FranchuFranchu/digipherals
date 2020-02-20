-- Sending batch commands can be useful so you don't overheat your controller due to receiving too much responses for the peripheral or so other controllers connected to you don't overheat
-- As you see, digiline_send is only called once after you program it

function range(from, to, step)
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

if event.type == "program" then

 digiline_send("monitor1", {"clear_screen"}) -- reset


 digiline_send("monitor1", {"set_resolution", 64, 64})

 local off = 0
 commands = {"batch"}
 for i in range(0,64) do
  commands[#commands+1] = {
      "set_pixel", 
       (i + off) % 64,
       math.sin((i)/3)*20+32,
       15
  }
 end
  
 digiline_send("monitor1", commands)

end