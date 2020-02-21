-- add the following line to the enviroment on mesecon_luacontroller/init.lua if you want this to work
-- digipherals_wrapper = digipherals.helpers.get_wrapper(get_digiline_send(pos, itbl, send_warning)),

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


monitor = digipherals_wrapper("monitor1")

monitor.set_resolution(4,4)
for i in range(0,15) do
 monitor.set_pixel(i%4,math.floor(i/4),i)
end