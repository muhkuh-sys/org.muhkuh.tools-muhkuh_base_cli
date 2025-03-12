local class = require 'pl.class'
local TesterBase = require 'tester_base'
local TesterWebGui = class(TesterBase)


function TesterWebGui:_init()
  self:super()

  self.zmq = require 'lzmq'

  self.tLog = nil
end



function TesterWebGui:setLog(tLog)
  self.tLog = tLog
end



function TesterWebGui:getCommonPlugin(strInterfacePattern, atPluginOptions)
  atPluginOptions = atPluginOptions or {}

  -- Does the interface pattern start with a number?
  local ulPrefix
  local strPrefix = string.match(strInterfacePattern, '^(%d+):')
  if strPrefix~=nil then
    ulPrefix = tonumber(strPrefix)

    -- Cut off the prefix from the pattern.
    strInterfacePattern = string.sub(strInterfacePattern, string.len(strPrefix)+2)
  end
  -- Use a default of 0 for the prefix.
  ulPrefix = ulPrefix or 0

  -- Is a plugin open?
  local tPlugin = self.atCommonPlugin[ulPrefix]
  local strPluginName = self.astrCommonPluginName[ulPrefix]
  if tPlugin~=nil then
    -- Yes -> does it match the interface?
    local fMatches = false
    if strInterfacePattern==nil then
      -- An empty pattern matches all interfaces.
      fMatches = true
    elseif string.match(strPluginName, strInterfacePattern)~=nil then
      fMatches = true
    end
    if fMatches~=true then
      -- The current plugin does not match the pattern.
      -- Close it and select a new one.
      self:closeCommonPlugin(ulPrefix)
    end
  end

  if tPlugin==nil then
    -- Open a new plugin.

    -- Detect all interfaces.
    local aDetectedInterfaces = {}
    local atPlugins = _G.__MUHKUH_PLUGINS
    if atPlugins==nil then
      error('No plugins registered!')
    else
      for _, tPlugin in ipairs(atPlugins) do
        tPlugin:DetectInterfaces(aDetectedInterfaces, atPluginOptions)
      end
    end

    local iSelectedInterfaceIndex = nil
    if #aDetectedInterfaces==0 then
      print('No interface found.')
    else
      -- Search all detected interfaces for the pattern.
      if strInterfacePattern==nil then
        print('No interface pattern provided. Using the first interface.')
        iSelectedInterfaceIndex = 1
      else
        print(string.format('Searching for an interface with the pattern "%s".', strInterfacePattern))
        for iInterfaceIdx, tInterface in ipairs(aDetectedInterfaces) do
          local strName = tInterface:GetName()
          if string.match(strName, strInterfacePattern)==nil then
            print(string.format('Not connection to plugin "%s" as it does not match the interface pattern.', strName))
          else
            iSelectedInterfaceIndex = iInterfaceIdx
            break
          end
        end

        if iSelectedInterfaceIndex==nil then
          print(string.format('No interface matched the pattern "%s".', strInterfacePattern))
        end
      end
    end

    -- Found the interface?
    if iSelectedInterfaceIndex~=nil then
      local tInterface = aDetectedInterfaces[iSelectedInterfaceIndex]
      if tInterface==nil then
        print(string.format('The interface with the index %d does not exist.', iSelectedInterfaceIndex))
      else
        local strInterfaceName = tInterface:GetName()
        print(string.format('Connecting to interface "%s".', strInterfaceName))

        tPlugin = tInterface:Create()
        tPlugin:Connect()
        if tPlugin==nil then
          print(string.format('Failed to connect to the interface "%s".', strInterfaceName))
        else
          self.atCommonPlugin[ulPrefix] = tPlugin
          self.astrCommonPluginName[ulPrefix] = strInterfaceName
        end
      end
    end
  end

  return tPlugin
end



function TesterWebGui:setInteraction(strFilename, atReplace)
  local tResult

  -- Read the interaction code.
  local strJsxTemplate, strErr = self.pl.file.read(strFilename)
  if strJsxTemplate==nil then
    self.tLog.error('Failed to read JSX from "%s": %s', strFilename, strErr)
  else
    local strJsx

    -- Replace something?
    if atReplace==nil then
      strJsx = strJsxTemplate
    else
      strJsx = string.gsub(strJsxTemplate, '@([%w_]+)@', atReplace)
    end

    self.tSocket:send(string.format('INT%s', strJsx))

    tResult = true
  end

  return tResult
end



function TesterWebGui:getInteractionResponse()
  local strResponse

  repeat
    local strMessage = self.tSocket:recv()
    strResponse = string.match(strMessage, '^RSP(.*)')
    if strResponse==nil then
      self.tLog.debug('Ignoring invalid response: %s', strMessage)
    end
  until strResponse~=nil

  return strResponse
end



function TesterWebGui:getInteractionResponseNonBlocking()
  local strResponse

  local strMessage = self.tSocket:recv(self.zmq.DONTWAIT)
  if strMessage~=nil then
    strResponse = string.match(strMessage, '^RSP(.*)')
    if strResponse==nil then
      self.tLog.debug('Ignoring invalid response: %s', tostring(strMessage))
    end
  end

  return strResponse
end



function TesterWebGui:setInteractionGetJson(strFilename, atReplace)
  local tLog = self.tLog

  local tResult = self:setInteraction(strFilename, atReplace)
  if tResult==true then
    local strResponseRaw = self:getInteractionResponse()
    if strResponseRaw~=nil then
      local tJson, uiPos, strJsonErr = self.json.decode(strResponseRaw)
      if tJson==nil then
        tLog.error('JSON Error: %d %s', uiPos, strJsonErr)
      else
        tResult = tJson
      end
    end
  end

  return tResult
end



function TesterWebGui:clearInteraction()
  self.tSocket:send('INT')
end



function TesterWebGui:setInteractionData(strData)
  local strMsg = string.format('IDA%s', strData)
  self.tSocket:send(strMsg)
end



function TesterWebGui:getCurrentPeerName()
  -- Send the request.
  local strMsg = 'GPN'
  self.tSocket:send(strMsg)

  -- Wait for the response.
  local strResponse

  repeat
    local strMessage = self.tSocket:recv()
    strResponse = string.match(strMessage, '^SPN(.*)')
    if strResponse==nil then
      self.tLog.debug('Ignoring invalid response: %s', strMessage)
    end
  until strResponse~=nil

  return strResponse
end


return TesterWebGui
