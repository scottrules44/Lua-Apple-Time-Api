local ntp = {}
local sockTable = {}
function ntp:Create(Server, Port, callback)
   local socket = require "socket"
   local err = false

   if Server then
      sockTable._server = Server
   end

   if Port then
      sockTable._port = Port
   end

   if not (sockTable._server and sockTable._port) then
      error("need server and port defined")
   end

   local ip = socket.dns.toip(sockTable._server)
   if(ip == nil)then
     return callback({isError=true, error="cannot connect to ntp server"})
   end
   sockTable._udpSocket = socket.udp()
   sockTable._udpSocket:setpeername(sockTable._server, sockTable._port)
   sockTable._udpSocket:settimeout(3)
   callback()
end

function ntp:Send(Data)
   local sent = 0
   if Data then
      sent, err = sockTable._udpSocket:send(Data)
      if err then
         error("send " ..err)
      end
   end

   return sent
end

function ntp:Receive()
   local datagram, err = sockTable._udpSocket:receive()
   if not datagram then
      error("receive: " ..err)
   end

   return datagram
end

return ntp
