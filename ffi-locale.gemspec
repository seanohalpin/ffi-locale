# -*- coding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

require 'ffi-locale/version'

date         = "2011-09-25"
authors      = ["Sean O'Halpin"]
email        = "sean.ohalpin@gmail.com"
project      = FFI::Locale
description  = "An FFI wrapper for the C library setlocale and localeconv functions."
dependencies = [
                ["ffi", ">= 1.0.9"],
               ]


Gem::Specification.new do |s|
  s.authors     = authors
  s.email       = email
  s.date        = date
  s.description = description
  dependencies.each do |dep|
    s.add_dependency *dep
  end
  s.files =
    [
     "#{project::NAME}.gemspec",
     "lib/#{project::NAME}.rb",
     "COPYING",
     "History.txt",
     "README.rdoc",
     "Rakefile",
     "Gemfile",
     "Gemfile.lock",
    ] +
    Dir["examples/**/*"] +
    Dir["lib/**/*.rb"] +
    Dir["spec/**/*.rb"]

  s.name          = project::NAME
  s.version       = project::VERSION
  s.homepage      = "http://github.com/seanohalpin/#{project::NAME}"
  s.summary       = s.description
  s.require_paths = ["lib"]
end
