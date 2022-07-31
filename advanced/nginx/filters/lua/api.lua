JSON = (loadfile "/Users/mz01-lsjin/Dev/Fluent-bit/fluent-bit-repo/advanced/nginx/filters/lua/lib/json.lua")()
PATH = "/Users/mz01-lsjin/Dev/Fluent-bit/fluent-bit-repo/advanced/nginx/filters/json/api.json"

function jsonRead(path)
    local data = nil
    local handle = io.open(path, "r")

    if handle then
        data = JSON:decode(handle:read("*a"))
        io.close(handle)
    end

    return data
end

function findTarget(api)
    local jsonFile = jsonRead(PATH)

    if jsonFile then
        for _, value in pairs(jsonFile) do
            for i=1, #value do
                -- api.json value 중 *이 있으면 escape 문자로 변환하는 구문
                local matched = string.match(api, "^" .. value[i]:gsub("*", "%%*") .. "$")
                
                if matched ~= nil then
                    -- print("matched : " .. matched)
                    return true
                end
            end
        end
    end
end

function main(tag, timestamp, record)
    -- record={api="/show/getUserIds/*"} -- local test
    -- record={api="/delete/Likes"} -- local test
    -- record={api="abc123"} -- local test

    if findTarget(record["api"]) then
        record["api_target"] = "TARGET"
    else
        record["api_target"] = "NONTARGET"
    end

    -- print(record["api_target"]) -- local test
    return 2, timestamp, record
    -- return code, timestamp, record
    -- code description : 후속 조치
    -- -1 : record 삭제
    --  0 : 아무것도 하지 않음
    --  1 : timestamp, record를 모두 변경
    --  2 : record만 변경
end

-- main() -- local test