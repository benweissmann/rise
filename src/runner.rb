# Default runner for EasyRubygame apps.
# Don't change this unless you know what you're doing!

# Add game's top dir to ruby PATH
$:.push(File.dirname(__FILE__))

# Load Rubygame
require 'rubygame'
include Rubygame

# Load EasyRubygame
require 'lib/easy-rubygame'

# Autoload resources from resources directories
resources_dir = File.dirname(__FILE__)
Surface.autoload_dirs = [ resources_dir + 'resources/images' ]
Sound.autoload_dirs = [ resources_dir + 'resources/sounds']

# Load game code
require 'src/main.rb'

# Start game!
EasyRubygame.run()