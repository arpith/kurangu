Gem::Specification.new do |s|
  s.name        = "kurangu"
  s.version     = "0.0.6"
  s.executables << "kurangu"
  s.date        = "2018-02-21"
  s.summary     = "Generate type annotations"
  s.description = "Runtime inferrence of RDL type annotations"
  s.authors     = ["Arpith Siromoney"]
  s.email       = "arpith@feedreader.co"
  s.files       = ["lib/kurangu.rb", "lib/trace.rb", "lib/signature.rb"]
  s.homepage    = "https://github.com/arpith/kurangu"
  s.license     = "MIT"
end
