
Gem::Specification.new do |s|
  s.name = "realistic-russian-names"
  s.version = "0.0.2"
  s.authors = ["ulzr"]
  s.date = "2017-04-15"
  s.summary = "Collection of russian names and information on their popularity"
  s.description = "A relatively large collection of russian first, last names and patronymics, information on their popularity and utilities for making their derivatives. With this gem you can form pretty realistic russian names."
  s.email = "ulzr@apssdc.ml"
  s.files = Dir["lib/**/*", "README.md"]
  s.rdoc_options << "--exclude" << "lib\/.*\\.yaml"
  s.licenses = ["Unlicense"]
  s.require_paths = ["lib"]
  s.executables << "gen-realistic-russian-names"
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
end
