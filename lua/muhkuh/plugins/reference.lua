local class = require 'pl.class'
local PluginReference = class()


function PluginReference:_init(tLogWriter, strLogLevel, strName, strTyp, atAttributes, fIsUsed, cPlugin, atPluginOptions)
  self.m_tLogWriter = tLogWriter
  self.m_strLogLevel = strLogLevel

  self.m_strName = strName
  self.m_strTyp = strTyp
  self.m_atAttributes = atAttributes
  self.m_fIsUsed = fIsUsed
  self.m_cPlugin = cPlugin
  self.m_atPluginOptions = atPluginOptions
end



function PluginReference:GetName()
  return self.m_strName
end



function PluginReference:GetTyp()
  return self.m_strTyp
end



function PluginReference:IsUsed()
  return self.m_fIsUsed
end



function PluginReference:IsValid()
  return true
end



function PluginReference:Create()
  local tPlugin = self.m_cPlugin(self.m_tLogWriter, self.m_strLogLevel, self.m_strName, self.m_atAttributes, self.m_atPluginOptions)
  return tPlugin
end


return PluginReference
