require 'active_support/test_case'
require "test/unit"

def run_kurangu(dir)
  input = "#{dir}input.rb"
  system('kurangu', input)
end

def run_expected(dir)
  expected = "#{dir}expected.rb"
  system('ruby', expected)
end

def get_test_subdirectories
  subdir_list = Dir["test/*/"]
  return subdir_list
end

class TestKurangu < Test::Unit::TestCase
  def test_directories
    subdirectories = get_test_subdirectories
    subdirectories.each do |dir|
      assert_equal(run_kurangu(dir), run_expected(dir))
    end
  end
end
