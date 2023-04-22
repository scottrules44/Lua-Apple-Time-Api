local serverTime = require "serverTime.serverTime"

local localTimeTxt = display.newText( "loading...", display.contentCenterX, display.contentCenterY, native.systemFont, 40 )
local utcTimeTxt = display.newText( "loading...", display.contentCenterX, display.contentCenterY-80, native.systemFont, 40 )

serverTime.getCurrentTime(function(event)
	if(event.isError)then
		localTimeTxt.text = "Error loading time"
		utcTimeTxt.text = event.error
	else
		local localTime = event.localTime -- this return an os.date https://docs.coronalabs.com/api/library/os/date.html
		local utcTime = event.utcTime -- this return an os.date https://docs.coronalabs.com/api/library/os/date.html
		localTimeTxt.text = "Local Date:"..localTime.month.."/"..localTime.day.." "..localTime.hour..":"..localTime.min
		utcTimeTxt.text = "UTC Date:"..utcTime.month.."/"..utcTime.day.." "..utcTime.hour..":"..utcTime.min
	end
end)
