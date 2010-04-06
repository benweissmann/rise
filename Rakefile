require 'fileutils'
include FileUtils::Verbose

task :build_demos do
  find_demos.each do |demo|
  	build_demo
  end
end

task :demo do
  demos = find_demos
  puts 'Pick a demo by number:'
  demos.each_with_index do |demo, index|
  	puts "#{index}) #{demo.split('/')[1]}"
  end
  print '> '
  demo_n = STDIN.gets.to_i

  build_demo demos[demo_n]
  `ruby #{demos[demo_n] + 'runner.rb'}`
end

def find_demos
  Dir['demo/*/runner.rb'].collect{|f| f.rpartition('/')[0..1].join}
end

def build_demo demo
  cd demo

  # backup properties and main
  mkdir '._ergtmp'
  cp 'properties.yml', '._ergtmp'
  cp 'src/main.rb', '._ergtmp'

  # copy new source in
  cp_r Dir['../../src/*'], '.'

  # restore backups
  cp '._ergtmp/properties.yml', '.'
  cp '._ergtmp/main.rb', 'src'
  rm_r '._ergtmp'
  
  cd '../..'
end
