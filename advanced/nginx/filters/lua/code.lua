function code_to_integer(tag, timestamp, record)
    new_status = record["status"]
    record["status"] = tonumber(new_status)

    return 2, timestamp, record
    -- return code, timestamp, record
    -- code description : 후속 조치
    -- -1 : record 삭제
    --  0 : 아무것도 하지 않음
    --  1 : timestamp, record를 모두 변경
    --  2 : record만 변경
end