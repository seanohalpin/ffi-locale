# -*- coding: utf-8 -*-
require 'minitest/spec'
require 'minitest/autorun'
require 'ffi-locale'

locales = {
  "en_GB.UTF-8" => { :currency_symbol => "£", :int_curr_symbol => "GBP " },
  "en_US.UTF-8" => { :currency_symbol => "$", :int_curr_symbol => "USD " },
}

locales.each do |name, values|

  describe "localeconv #{name}" do
    before do
      FFI::Locale.setlocale(FFI::Locale::LC_ALL, name)
      @locale = FFI::Locale.localeconv
    end

    it 'should return an FFI::Locale::LocaleConv struct' do
      @locale.class.must_equal FFI::Locale::LocaleConv
    end

    values.each do |key, value|
      it 'should return the correct value for #{key}' do
        res = @locale.send(key)
        res.must_equal value
      end
    end
  end

end
