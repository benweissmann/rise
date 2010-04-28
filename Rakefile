require 'fileutils'
include FileUtils::Verbose

task :build_demos do
  find_demos.each do |demo|
  	build_demo demo
  end
end

task :demo, :demo_n do |task, args|
  demos = find_demos
  
  if nil == args.demo_n
    puts 'Pick a demo by number:'
    demos.each_with_index do |demo, index|
  	  puts "#{index}) #{demo.split('/')[1]}"
    end
    print '> '
    demo_n = STDIN.gets.to_i
  else
    demo_n = args.demo_n.to_i
  end

  build_demo demos[demo_n]
  
  if (RUBY_PLATFORM =~ /darwin/) == nil
    system "ruby #{demos[demo_n] + 'runner.rb'}"
  else
    system "rsdl #{demos[demo_n] + 'runner.rb'}"
  end
end

task :docs do
  rm_r 'doc'
  system 'rdoc src/lib README.TXT --main=README.TXT'
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
