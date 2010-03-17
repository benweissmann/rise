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