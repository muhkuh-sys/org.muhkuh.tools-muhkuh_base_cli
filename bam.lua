local atEnv = require 'mbs2'

-- Create all compiler environments.
atEnv:createEnv('Muhkuh', {}, {})

---------------------------------------------------------------------------------------------------------------------
--
-- Create an archive.
--

-- Construct the archive contents.
local dir,file = require 'mbs2.archive_helper':getHelper()
local tArchiveContents = {
  dir('lua', {
    dir('muhkuh', {
      dir('plugins', {
        file('lua/muhkuh/plugins/reference.lua'),
        file('lua/muhkuh/plugins/ringbuffer.lua'),
        file('lua/muhkuh/plugins/uarthelper.lua')
      })
    }),

    file('lua/parameter_instances.lua'),
    file('lua/parameter.lua'),
    file('lua/parameter_multi_choice.lua'),
    file('lua/parameter_single_choice.lua'),
    file('lua/parameter_uint16.lua'),
    file('lua/parameter_uint32.lua'),
    file('lua/parameter_uint8.lua'),
    file('lua/test_class.lua'),
    file('lua/test_description.lua'),
    file('lua/tester_base.lua'),
    file('lua/tester_cli.lua'),
    file('lua/tester_webgui.lua')
  }),
  file('installer/jonchki/install.lua')
}

local astrGroup = atEnv.astrProjectGroup
local strModule = atEnv.strProjectModule
local strArtifact = 'lua5.4-muhkuh_base_cli'
local astrVersion = atEnv.astrProjectVersion
local strRepositoryBasePath = 'targets/jonchki/repository'

local tEnv = atEnv:cloneAnyEnv({ label='archive' })
tEnv:Artifact(
  strRepositoryBasePath,
  astrGroup,
  strModule,
  strArtifact,
  astrVersion,
  tArchiveContents,
  {
    ENABLE_SNAPSHOT_MARKER = false
  }
)
