

digipherals.helpers.superpose_table =  function (base, exceptions)
  local result = table.copy(base)
  for key, value in pairs(exceptions) do
        if type(value) == 'table' then
      result[key] = digipherals.helpers.superpose_table(result[key] or {}, value)
    else
      result[key] = value
    end
  end
  return result
end


digipherals.helpers.check_meta = function (pos, objref) 
    local meta = minetest.get_meta(pos)
    local tmp = minetest.deserialize(meta:get_string("digipherals"))

    local nodename = minetest.get_node(pos).name
    local tmp_ = minetest.registered_nodes[nodename]["digipherals"]

    if tmp_ == nil then
        return
    end
    if tmp == nil then
        tmp = {}
    end
    if tmp_.screen ~= nil then
        if tmp.screen == nil then
            tmp.screen = {}
            tmp.screen.pixels = {}
            tmp.screen.resolution = tmp_.screen.resolution
        end
        if tmp.screen.pallete == nil then
            tmp.screen.pallete = tmp_.screen.pallete
        end

    end

    if tmp.global == nil then
        tmp.global = {channel_i="peripheral1"}
    end
    meta:set_string("digipherals", minetest.serialize(tmp))
end 

digipherals.helpers.formspec_construct = function(pos)
    digipherals.helpers.check_meta(pos)

    local meta = minetest.get_meta(pos)
    local tmp = minetest.deserialize(meta:get_string("digipherals"))
    meta:set_string("channel", tmp.global.channel_i)
    meta:set_string("formspec", "field[channel;Channel;${channel}]")
end

digipherals.helpers.set_channel = function (pos, channel)
    digipherals.helpers.check_meta(pos)
    local tmp = minetest.deserialize(minetest.get_meta(pos):get_string("digipherals"))
    tmp.global.channel_i = channel
    minetest.get_meta(pos):set_string("digipherals",minetest.serialize(tmp))
    minetest.get_meta(pos):set_string("channel", tmp.global.channel_i)
end

digipherals.helpers.on_receive_fields = function(pos, _, fields, sender)
    local name = sender:get_player_name()
    if minetest.is_protected(pos, name) and not minetest.check_player_privs(name, {protection_bypass=true}) then
        minetest.record_protection_violation(pos, name)
        return
    end
    if (fields.channel) then
        digipherals.helpers.set_channel(pos, fields.channel)
    end
end

digipherals.helpers.on_digiline_receive = function(pos, _,channel, msg)
    
    local meta = minetest.get_meta(pos)
    local tmp = minetest.deserialize(meta:get_string("digipherals"))

    if channel ~= tmp.global.channel_i then return end
    digipherals.helpers.execute_msg(pos, msg)

end

digipherals.helpers.execute_msg = function(pos, msg)

    local meta = minetest.get_meta(pos)
    local tmp = minetest.deserialize(meta:get_string("digipherals"))
    local channel = tmp.global.channel_i

    if type(msg) ~= "table" then digilines.receptor_send(pos, digilines.rules.default, channel .. "_o", {"ERR", 0, "Message must be table"}) return end

    local funcname = msg[1]
    local func = minetest.registered_nodes[minetest.get_node(pos).name].digipherals.api[funcname]

    if func == nil then digilines.receptor_send(pos, digilines.rules.default, channel .. "_o", {"ERR", 1, "Unknown function"}) return end

    table.remove(msg, 1)
    local ret = func(pos, table.unpack(msg))

    if ret ~= true then
        digilines.receptor_send(pos, digilines.rules.default, channel .. "_o", {"RET", table.unpack(ret)})
    end

end

-- add the following line to the enviroment on mesecon_luacontroller/init.lua if you want it
-- digipherals_wrapper = digipherals.helpers.get_wrapper(get_digiline_send(pos, itbl, send_warning)),
digipherals.helpers.get_wrapper = function(digiline_send) 
    return function(channel) 
        return setmetatable({channel=channel,digiline_send=digiline_send},{__index=digipherals.helpers.wrapper_func})
    end
end

digipherals.helpers.wrapper_func = function(mytable, key)
    return function(...)
        mytable.digiline_send(mytable.channel,{key, ...})
    end
end