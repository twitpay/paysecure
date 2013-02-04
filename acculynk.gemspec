# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "acculynk"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["John Ford"]
  s.date = "2012-03-02"
  s.description = "Ruby wrapper for Acculynk's Web Services API"
  s.email = "jwford@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "acculynk.gemspec",
    "lib/acculynk.rb",
    "lib/acculynk/acculynk.rb",
    "lib/acculynk/api.rb",
    "lib/acculynk/client.rb",
    "lib/acculynk/configuration.rb",
    "lib/acculynk/request.rb",
    "lib/acculynk/version.rb",
    "spec/acculynk_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://github.com/JohnFord/acculynk"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Ruby wrapper for Acculynk's Web Services API"

  s.add_runtime_dependency(%q<savon>, ["~> 2.1.0"])
  s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
  s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
  s.add_development_dependency(%q<bundler>)
  s.add_development_dependency(%q<jeweler>, ["~> 1.8.3"])
  if RUBY_VERSION < "1.9.0" 
    s.add_development_dependency(%q<rcov>, [">= 0"])
  else
    s.add_development_dependency(%q<simplecov>, [">= 0"])
  end
end

