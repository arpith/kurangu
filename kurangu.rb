require 'rbconfig'

RUBY = File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])

puts ARGV
INPUT_FILE = File.expand_path(ARGV[0])
TRACE_FILE = File.expand_path("trace.rb")

success = system(RUBY, "-r", TRACE_FILE, INPUT_FILE)
puts "[parent] success: #{success}"
