local class = require 'pl.class'
local _M = class()


function _M:_init(tPort, dTimeoutBase, dTimeoutInMsPerChar)
  self.m_tPort = tPort
  self.m_aucData = ''
  self.m_dTimeoutBase = dTimeoutBase
  self.m_dTimeoutInMsPerChar = dTimeoutInMsPerChar
end



function _M:fill(sizRequiredSize)
  local fResult = true
  local strError
  local tPort = self.m_tPort

  -- Get the current fill level of the RX buffer.
  repeat
    local sizFill = self:getFillLevel()
    local sizLeft = sizRequiredSize - sizFill
    if sizLeft>0 then
      local dTimeout = self.m_dTimeoutBase + self.m_dTimeoutInMsPerChar * sizLeft
      local aucData, strReceiveError = tPort:read(sizLeft, dTimeout)
      if type(aucData)~='string' then
        fResult = false
        strError = 'Failed to receive data from the netX: ' .. tostring(strReceiveError)
        break
      elseif string.len(aucData)==0 then
        -- No data was received within the timeout.
        fResult = false
        strError = 'Timeout reached when receiving data from the netX.'
        break
      else
        self:write(aucData)
      end
    end
  until sizLeft<=0

  return fResult, strError
end



function _M:getFillLevel()
  return string.len(self.m_aucData)
end



function _M:read(sizChunk)
  local aucData = self.m_aucData
  local strChunk = string.sub(aucData, 1, sizChunk)
  self.m_aucData = string.sub(aucData, sizChunk+1)
  return strChunk
end



function _M:write(aucData)
  self.m_aucData = self.m_aucData .. aucData
end



function _M:peek(sizOffset, sizData)
  return string.sub(self.m_aucData, sizOffset+1, sizOffset+sizData)
end


return _M
