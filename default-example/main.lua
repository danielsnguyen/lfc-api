local commlib = {}

function commlib:init(cname)
    local handle = io.open(cname,"w")
    handle:close()
end

function commlib:send(cname,message)
    local handle = io.open(cname,"w")
    handle:write(message.."\n"..os.clock()+os.time())
    handle:close()
end

function commlib:waitrecieve(cname, timeout)
    local start_time = os.clock()
    local handle = io.open(cname,"r")
    local buffer = handle:read("*all")
    handle:close()
    if timeout ~= nil then
        while true do
            if start_time + timeout <= os.clock() then
                break
            end
            local handle = io.open(cname,"r")
            if buffer ~= handle:read("*all") then
                buffer = handle:read("*all")
                handle:close()
                break
            end
            handle:close()
        end
    else
        while true do
            local handle = io.open(cname,"r")
            if buffer ~= handle:read("*all") then
                handle:close()
                while true do
                    handle = io.open(cname,"r")
                    buffer = handle:read("*all")
                    handle:close()
                    if buffer ~= "" then break end
                end
                break
            end
            handle:close()
        end
    end
    local tbl = {}
    for x in string.gmatch(buffer, "([^\n]+)") do
        table.insert(tbl,x)
    end
    table.remove(tbl, #tbl)
    return table.concat(tbl,'\n')
end

return commlib