cp -R src test
rm -r test/src/src/main.rb
cp test/new_main.rb test/src/src/main.rb 
ruby test/src/runner.rb

