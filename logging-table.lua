local module = {}

module.add_logger = function(table)
    real_table = table
    fake_table = {}

    metatable = {log = ""}
    metatable.__index = function(empty_table, key)
        metatable.log = metatable.log .. key
        return real_table[propertyID]
    end

    our_next = function(empty_table, key)
        if key ~= nil then
            metatable.log = metatable.log .. key
        end
        return next(real_table, key)
    end

    metatable.__pairs = function(empty_table)
        return our_next, empty_table, nil
    end

    setmetatable(fake_table, metatable)
    return fake_table
end

return module
