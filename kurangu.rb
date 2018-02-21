require 'rbconfig'
require 'fileutils'

RUBY = File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])

INPUT_FILE = File.expand_path(ARGV[0])
TRACE_FILE = File.expand_path("trace.rb")

puts "\ngenerating annotations\n"
system(RUBY, "-r", TRACE_FILE, INPUT_FILE)


puts "\nthe annotations generated are:\n"
File.open("annotations_paths.txt", "r") do |f|
  f.each_line do |annotation_file|
    puts annotation_file
    File.open(annotation_file, "r") do |f|
      f.each_line.with_index do |line, index|
        if index > 2
          puts line
        end
      end
    end
  end
end

ANNOTATIONS_FILE = File.expand_path("annotations.rb")

File.open("annotations_paths.txt", "r") do |f|
  f.each_line do |annotation_path|
    original_path = annotation_path.chomp('.annotations')
    annotated_path = "#{original_path}.annotated"
    puts "\ngenerating annotated file #{annotated_path}\n"
    lines = ["require 'rdl'\n", "require 'types/core'\n"]
    annotations = Hash.new
    File.open(annotation_path, "r") do |f|
      f.each_line do |line|
        split = line.split(" ", 2)
        index = split[0].to_i
        annotations[index] = "#{split[1]}\n"
      end
    end
    lines << "\n"
    File.open(original_path, "r") do |f|
      f.each_line.with_index do |line, index|
        if annotations.key?(index + 1)
          lines << "extend RDL::Annotate\n"
          lines << annotations[index + 1]
        end
        lines << line
      end
    end
    IO.write(annotated_path, lines.join())
    puts "\napplying annotations for #{original_path}\n"
    FileUtils.mv(annotated_path, original_path)
  end
end


puts "\nrunning rdl\n"
system(RUBY, INPUT_FILE)
