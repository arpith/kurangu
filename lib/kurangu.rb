require 'rbconfig'
require 'fileutils'

class Kurangu
  def generate_annotations(input_file)
    ruby = File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])
    trace_file = File.expand_path("lib/trace.rb")
    puts "\ngenerating annotations\n"
    system(ruby, "-r", trace_file, input_file)
  end

  def print_annotations
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
  end

  def generate_annotated_files
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
            whitespace = line.chomp(line.lstrip)
            if annotations.key?(index + 1)
              lines << "#{whitespace}extend RDL::Annotate\n"
              lines << "#{whitespace}#{annotations[index + 1]}"
            end
            lines << line
          end
        end
        IO.write(annotated_path, lines.join())
      end
    end
  end

  def apply_annotation(annotated_path, original_path)
    puts "\napplying annotations for #{original_path}\n"
    FileUtils.mv(annotated_path, original_path)
  end

  def apply_annotations
    File.open("annotations_paths.txt", "r") do |f|
      f.each_line do |annotation_path|
        original_path = annotation_path.chomp('.annotations')
        annotated_path = "#{original_path}.annotated"
        apply_annotation(annotated_path, original_path)
      end
    end
  end

  def run_rdl(input_file)
    puts "\nrunning rdl\n"
    ruby = File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])
    system(ruby, input_file)
  end

  def run(input_file_path)
    input_file = File.expand_path(input_file_path)
    self.generate_annotations(input_file)
    self.print_annotations
    self.generate_annotated_files
    self.apply_annotations
    self.run_rdl(input_file)
  end
end
