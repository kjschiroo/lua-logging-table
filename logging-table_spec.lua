local logging_table = require('logging-table')

do
    local t = {}
    setmetatable( t, { __pairs = function() return 1, 2, 3 end } )
    local f = pairs( t )
    if f ~= 1 then
        local old_pairs = pairs
        pairs = function ( t )
            local mt = getmetatable( t )
            local f, s, var = ( mt and mt.__pairs or old_pairs )( t )
            return f, s, var
        end
        local old_ipairs = ipairs
        ipairs = function ( t )
            local mt = getmetatable( t )
            local f, s, var = ( mt and mt.__ipairs or old_ipairs )( t )
            return f, s, var
        end
    end
end

describe('logging-table', function()
  it('logs access to an individual index', function()
    local some_table = {foo = "bar", baz = "buz"}
    some_table = logging_table.add_logger(some_table)

    local buz = some_table["foo"]
    local baz = some_table["baz"]

    local metatable = getmetatable(some_table)
    assert.are.equal(metatable.log, "foobaz")
  end)


  it('logs access when iterating', function()
    local some_table = {foo = "bar", baz = "buz"}

    some_table = logging_table.add_logger(some_table)
    local expected = ""

    for k, v in pairs(some_table) do
        expected = expected .. k
    end

    local metatable = getmetatable(some_table)
    assert.are_not.equal(expected, "")
    assert.are.equal(expected, metatable.log)

  end)
end)
