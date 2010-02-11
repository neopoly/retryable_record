#!/usr/bin/env watchr
 
begin
  require File.join(ENV["HOME"], ".watchr.test.rb")
rescue LoadError
  warn "Unable to load #{File.join(ENV["HOME"], ".watchr.test.rb")}"
  warn "You might try this: http://gist.github.com/raw/273574/8804dff44b104e9b8706826dc8882ed985b4fd13/.watchr.test.rb"
  exit
end
 
run_tests
 
watch('test/.*_test\.rb')   { |md| run md[0] }
watch('lib/(.*)\.rb')       { |md| run "test/#{underscore(md[1])}_test.rb" }
watch('test/teststrap.rb')  { run_tests }
