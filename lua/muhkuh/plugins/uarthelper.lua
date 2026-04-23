local UartHelper = {}


UartHelper.__atBaudrateLookup = {
  [115200] = '_115200',
  [921600] = '_921600',
  [1152000] = '_1152000',
  [1500000] = '_1500000',
  [4000000] = '_4000000'
}



function UartHelper:open(strDevice, ulBaudrate)
  local tResult
  local strError

  local tBaudrate = self.__atBaudrateLookup[ulBaudrate]
  if tBaudrate==nil then
    strError = string.format('Unsupported baudrate: %d', ulBaudrate)

  else
    local rs232 = require 'rs232'
    local tPort, strPortError = rs232.port(
      strDevice,
      {
        baud         = tBaudrate,
        data_bits    = '_8',
        parity       = 'NONE',
        stop_bits    = '_1',
        flow_control = 'OFF',
        rts          = 'OFF'
      }
    )
    if tPort==nil then
      strError = string.format(
        'Failed to create the port %s : %s',
        strDevice,
        tostring(strPortError)
      )

    else
      local tOpenResult, strOpenError = tPort:open()
      if tOpenResult==nil then
        strError = string.format(
          'Failed to open the device %s : %s',
          strDevice,
          tostring(strOpenError)
        )
      else
        tResult = tPort
      end
    end
  end

  return tResult, strError
end



function UartHelper:close(tPort)
  if tPort~=nil then
    tPort:close()
  end
end


return UartHelper
