require 'rbconfig'
require 'fileutils'
require 'open3'

class Kurangu
  def generate_annotations(input_file)
    ruby = File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])
    trace_file = File.expand_path("lib/trace.rb")
    puts "\ngenerating annotations\n"
    Open3.popen2("#{ruby} -r #{trace_file} #{input_file}") {|stdin, stdout, wait_thr|
      stdin.puts(input_file)
    }
  end

  def print_annotations(paths_file)
    puts "\nthe annotations generated are:\n"
    File.open(paths_file, "r") do |f|
      f.each_line do |annotation_file|
        puts annotation_file
        File.open(annotation_file, "r") do |f|
          contents = f.read
          puts contents
        end
      end
    end
  end

  def generate_annotated_files(paths_file)
    File.open(paths_file, "r") do |f|
      f.each_line do |annotation_path|
        original_path = annotation_path.chomp('.annotations')
        annotated_path = "#{original_path}.annotated"
        puts "\ngenerating annotated file #{annotated_path}\n"
        annotations = Hash.new
        File.open(annotation_path, "r") do |f|
          f.each_line do |line|
            split = line.split(" ", 2)
            index = split[0].to_i
            annotations[index] = "#{split[1]}\n"
          end
        end
        lines = []
        has_types = false
        File.open(original_path, "r") do |f|
          f.each_line.with_index do |line, index|
            whitespace = line.chomp(line.lstrip)
            if annotations.key?(index + 1)
              if lines.last and lines.last.start_with?('type')
                has_types = true
                lines.last = "#{whitespace}#{annotations[index + 1]}"
              else
                lines << "#{whitespace}extend RDL::Annotate\n"
                lines << "#{whitespace}#{annotations[index + 1]}"
              end
            end
            lines << line
          end
        end
        if !has_types
          lines.unshift "require 'types/core'\n\n"
          lines.unshift "require 'rdl'\n"
        end
        IO.write(annotated_path, lines.join())
      end
    end
  end

  def apply_annotation(annotated_path, original_path)
    puts "\napplying annotations for #{original_path}\n"
    FileUtils.mv(annotated_path, original_path)
  end

  def apply_annotations(paths_file)
    File.open(paths_file, "r") do |f|
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
    paths_file = "#{File.dirname(input_file)}/annotations_paths.txt"
    self.generate_annotations(input_file)
    self.print_annotations(paths_file)
    self.generate_annotated_files(paths_file)
    self.apply_annotations(paths_file)
    self.run_rdl(input_file)
  end
end
