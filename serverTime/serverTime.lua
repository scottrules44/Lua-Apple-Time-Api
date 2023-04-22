local m = {}
local ntp = require "serverTime.ntp"
function parse_json_date(json_date)
    local pattern = "(%d+)%-(%d+)%-(%d+)%a(%d+)%:(%d+)%:([%d%.]+)([Z%+%-])(%d?%d?)%:?(%d?%d?)"
    local year, month, day, hour, minute,
        seconds, offsetsign, offsethour, offsetmin = json_date:match(pattern)
    local timestamp = os.time{year = year, month = month,
        day = day, hour = hour, min = minute, sec = seconds}
    local offset = 0
    if offsetsign ~= 'Z' then
      offset = tonumber(offsethour) * 60 + tonumber(offsetmin)
      if xoffset == "-" then offset = offset * -1 end
    end

    return timestamp + offset
end
function m.getCurrentTime(callback)

  local request=string.char(227, 0, 6, 236, 0,0,0,0,0,0,0,0, 49, 78, 49, 52, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
  port = 123
  ntp:Create("time.apple.com", 123, function(event)
    if(event and event.isError)then
      callback(event)
    else
      ntp:Send(request)
      RetData = ntp:Receive()

      local hw = RetData:byte(41) * 256 + RetData:byte(42)
      local lw = RetData:byte(43) * 256 + RetData:byte(44)
      local utc = hw * 65536 + lw - 1104494400 - 1104494400
      callback({isError = false, utcTime = os.date( "!*t", utc ), localTime = os.date( "*t", utc )})
    end

  end)


end
return m
