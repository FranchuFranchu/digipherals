digipherals.helpers.formspec_construct = function(pos)
    local meta = minetest.get_meta(pos)
    local tmp = minetest.deserialize(meta:get_string("digipherals"))
    meta:set_string("channel",tmp.global.channel_i)
    meta:set_string("formspec", "field[channel;Channel;${channel}]")
end

digipherals.helpers.on_receive_fields = function(pos, _, fields, sender)
    local name = sender:get_player_name()
    if minetest.is_protected(pos, name) and not minetest.check_player_privs(name, {protection_bypass=true}) then
        minetest.record_protection_violation(pos, name)
        return
    end
    if (fields.channel) then
        local tmp = minetest.deserialize(minetest.get_meta(pos):get_string("digipherals"))
        tmp.global.channel_i = fields.channel
        minetest.get_meta(pos):set_string("digipherals",minetest.serialize(tmp))
    end
end

digipherals.helpers.on_digiline_receive = function(pos, _,channel, msg)
    local function unpack (t, i)
     i = i or 1
      if t[i] ~= nil then
        return t[i], unpack(t, i + 1)
      end
    end
    local meta = minetest.get_meta(pos)
    local tmp = minetest.deserialize(meta:get_string("digipherals"))

    if channel ~= tmp.global.channel_i then return end

    if type(msg) ~= "table" then digilines.receptor_send(pos, digilines.rules.default, channel .. "_o", {"ERR", 0, "Message must be table"}) return end

    local funcname = msg[1]
    local func = minetest.registered_nodes[minetest.get_node(pos).name].digipherals.api[funcname]

    if func == nil then digilines.receptor_send(pos, digilines.rules.default, channel .. "_o", {"ERR", 1, "Unknown function"}) return end

    table.remove(msg, 1)
    local ret = func(pos, unpack(msg))

    if ret ~= true then
        digilines.receptor_send(pos, digilines.rules.default, channel .. "_o", {"RET", unpack(ret)})
    end

end

