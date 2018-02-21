require 'rbconfig'

RUBY = File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])

INPUT_FILE = File.expand_path(ARGV[0])
TRACE_FILE = File.expand_path("trace.rb")

puts "\ngenerating annotations\n"
system(RUBY, "-r", TRACE_FILE, INPUT_FILE)

puts "\nthe annotations generated are:\n"
File.open("annotations.rb", "r") do |f|
  f.each_line.with_index do |line, index|
    if index > 1
      puts line
    end
  end
end

ANNOTATIONS_FILE = File.expand_path("annotations.rb")

puts "\nrunning rdl with these annotations\n"
system(RUBY, "-r", INPUT_FILE, ANNOTATIONS_FILE)
