#!/usr/bin/env ruby
# $ ruby -rubygems -rffi-locale -e'FFI::Locale.setlocale(FFI::Locale::LC_ALL, ""); p FFI::Locale.localeconv'

require 'ffi-locale'
require 'pp'

initial_locale = FFI::Locale.localeconv
pp initial_locale

rv = FFI::Locale.setlocale(FFI::Locale::LC_ALL, "")
p [:rv, rv]
locale = FFI::Locale.localeconv
pp locale

rv = FFI::Locale.setlocale(FFI::Locale::LC_ALL, "BOGUS")
p [:rv, rv]
