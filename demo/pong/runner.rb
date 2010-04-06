#! /usr/bin/env ruby

# Copyright (C) 2010 Ben Weissmann <benweissmann@gmail.com>
#
# This file is part of EasyRubygame.
#
# EasyRubygame is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.
#
# EasyRubygame is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with EasyRubygame, in a file called COPYING.LESSER.
# in addition, your should have received a copy of the GNU General
# Public License, in a file called COPYING. If you did not
# receive a copy of either of these documents, see
# <http://www.gnu.org/licenses/>.


# Default runner for EasyRubygame apps.
# Don't change this unless you know what you're doing!

# The base directory (this directory this file is in)
BASE_DIR = File.dirname(__FILE__) + '/'

# Various other directories
SRC_DIR = BASE_DIR + 'src/'
RESOURCE_DIR = BASE_DIR + 'resources/'

# Add game's top dir to ruby PATH
$:.unshift(BASE_DIR)
$:.unshift(SRC_DIR)

# Load Rubygame
require 'rubygame'
include Rubygame
include Rubygame::Events
include Rubygame::EventActions
include Rubygame::EventTriggers

# Autoload resources from resources directories
Surface.autoload_dirs = [ RESOURCE_DIR + 'images/' ]
Sound.autoload_dirs = [ RESOURCE_DIR + 'sounds/']

# Load EasyRubygame
require 'lib/easy-rubygame'
include EasyRubygame

# Run Rubygame initialization
EasyRubygame.init

# Load scenes and sprites
(Dir[SRC_DIR + 'scenes/**/*.rb'] + Dir[SRC_DIR + 'sprites/**/*.rb']).each do |script|
  require script
end


# Load game code
require 'src/main'

# Start game!
EasyRubygame.run