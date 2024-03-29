# -*- coding: utf-8 -*-
#-------------------------------------------------------------------------#
#   Copyright (C) 2015 by Christoph Thelen                                #
#   doc_bacardi@users.sourceforge.net                                     #
#                                                                         #
#   This program is free software; you can redistribute it and/or modify  #
#   it under the terms of the GNU General Public License as published by  #
#   the Free Software Foundation; either version 2 of the License, or     #
#   (at your option) any later version.                                   #
#                                                                         #
#   This program is distributed in the hope that it will be useful,       #
#   but WITHOUT ANY WARRANTY; without even the implied warranty of        #
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
#   GNU General Public License for more details.                          #
#                                                                         #
#   You should have received a copy of the GNU General Public License     #
#   along with this program; if not, write to the                         #
#   Free Software Foundation, Inc.,                                       #
#   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             #
#-------------------------------------------------------------------------#


#----------------------------------------------------------------------------
#
# Set up the Muhkuh Build System.
#

SConscript('mbs/SConscript')
Import('atEnv')

import os.path


#----------------------------------------------------------------------------
#
# Build the artifacts.
#

strGroup = 'org.muhkuh.tools'
strModule = 'muhkuh_base_cli'

# Split the group by dots.
aGroup = strGroup.split('.')
# Build the path for all artifacts.
strModulePath = 'targets/jonchki/repository/%s/%s/%s' % ('/'.join(aGroup), strModule, PROJECT_VERSION)


# Set the name of the LUA5.4 artifact.
strArtifact54 = 'lua5.4-muhkuh_base_cli'

tArcList54 = atEnv.DEFAULT.ArchiveList('zip')

tArcList54.AddFiles('',
                   'installer/jonchki/lua5.4/install.lua')

tArcList54.AddFiles('lua/',
                   'lua/parameter_instances.lua',
                   'lua/parameter.lua',
                   'lua/parameter_multi_choice.lua',
                   'lua/parameter_single_choice.lua',
                   'lua/parameter_uint16.lua',
                   'lua/parameter_uint32.lua',
                   'lua/parameter_uint8.lua',
                   'lua/test_class.lua',
                   'lua/test_description.lua',
                   'lua/tester_base.lua',
                   'lua/tester_cli.lua',
                   'lua/tester_webgui.lua')

tArtifact54 = atEnv.DEFAULT.Archive(os.path.join(strModulePath, '%s-%s.zip' % (strArtifact54, PROJECT_VERSION)), None, ARCHIVE_CONTENTS = tArcList54)
tArtifact54Hash = atEnv.DEFAULT.Hash('%s.hash' % tArtifact54[0].get_path(), tArtifact54[0].get_path(), HASH_ALGORITHM='md5,sha1,sha224,sha256,sha384,sha512', HASH_TEMPLATE='${ID_UC}:${HASH}\n')
tConfiguration54 = atEnv.DEFAULT.Version(os.path.join(strModulePath, '%s-%s.xml' % (strArtifact54, PROJECT_VERSION)), 'installer/jonchki/lua5.4/%s.xml' % strModule)
tConfiguration54Hash = atEnv.DEFAULT.Hash('%s.hash' % tConfiguration54[0].get_path(), tConfiguration54[0].get_path(), HASH_ALGORITHM='md5,sha1,sha224,sha256,sha384,sha512', HASH_TEMPLATE='${ID_UC}:${HASH}\n')
tArtifact54Pom = atEnv.DEFAULT.ArtifactVersion(os.path.join(strModulePath, '%s-%s.pom' % (strArtifact54, PROJECT_VERSION)), 'installer/jonchki/lua5.4/pom.xml')
