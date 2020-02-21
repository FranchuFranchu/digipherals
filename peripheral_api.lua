digipherals.api.global = {}

digipherals.api.global.batch = function(pos, ...) 
    for _, arg in ipairs({...}) do
        digipherals.helpers.execute_msg(pos, arg)
    end
    return true
end

digipherals.api.global.locate = function(pos) 
    return {pos}
end


