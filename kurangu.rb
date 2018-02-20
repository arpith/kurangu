require 'rbconfig'

RUBY = File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])

INPUT_FILE = File.expand_path(ARGV[0])
TRACE_FILE = File.expand_path("trace.rb")

puts "generating annotations"
system(RUBY, "-r", TRACE_FILE, INPUT_FILE)

puts "the annotations generated are:"
File.open("annotations.rb", "r") do |f|
  f.each_line do |line|
    puts line
  end
end

ANNOTATIONS_FILE = File.expand_path("annotations.rb")

puts "running rdl with these annotations"
system(RUBY, "-r", ANNOTATIONS_FILE, INPUT_FILE)
