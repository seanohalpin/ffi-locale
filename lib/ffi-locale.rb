# -*- coding: utf-8 -*-
require 'ffi'

module FFI
  # @author Sean O'Halpin
  #
  # FFI adapter for the C-library functions +setlocale+ and +localeconv+.
  #
  # FFI is the Ruby Foreign Function Interface library. See
  # https://github.com/ffi/ffi/wiki for more details.
  #
  # For example:
  #
  #     if RUBY_VERSION < '1.9.0'
  #       # 1.8.x doesn't set the locale - use this to handle UTF-8 input correctly
  #       FFI::Locale.setlocale(FFI::Locale::LC_ALL, "")
  #     end
  #
  # This call is in fact the reason for the existence of this
  # library. MRI Ruby 1.8.x does not set this so C extensions and FFI
  # adapters that call C library functions that deal with multi-byte or
  # widechars will not function correctly unless this call has been
  # made.
  #
  # The definitions used here come from Ubuntu 11.04,
  # /usr/include/locale.h and /usr/include/bits/locale.h.
  #
  module Locale
    extend FFI::Library
    ffi_lib FFI::Library::LIBC

    LC_CTYPE = 0
    LC_NUMERIC = 1
    LC_TIME = 2
    LC_COLLATE = 3
    LC_MONETARY = 4
    LC_MESSAGES = 5
    LC_ALL = 6
    LC_PAPER = 7
    LC_NAME = 8
    LC_ADDRESS = 9
    LC_TELEPHONE = 10
    LC_MEASUREMENT = 11
    LC_IDENTIFICATION = 12

    attach_function :_localeconv, :localeconv, [], :pointer
    attach_function :_setlocale, :setlocale, [:int, :string], :string

    private :_localeconv
    private :_setlocale

    # Private structure giving information about numeric and monetary notation.
    class LocaleConvStruct < FFI::Struct
      # Numeric (non-monetary) information.
      layout \
      :decimal_point, :string,           # Decimal point character.
      :thousands_sep, :string,           # Thousands separator.
      # Each element is the number of digits in each group;
      # elements with higher indices are farther left.
      # An element with value CHAR_MAX means that no further grouping is done.
      # An element with value 0 means that the previous element is used
      # for all groups farther left.
      :grouping, :string,

      # Monetary information.

      # First three chars are a currency symbol from ISO 4217.
      # Fourth char is the separator.  Fifth char is '\0'.
      :int_curr_symbol, :string,
      :currency_symbol, :string,        # Local currency symbol.
      :mon_decimal_point, :string,      # Decimal point character.
      :mon_thousands_sep, :string,      # Thousands separator.
      :mon_grouping, :string,           # Like `grouping' element (above).
      :positive_sign, :string,          # Sign for positive values.
      :negative_sign, :string,          # Sign for negative values.
      :int_frac_digits, :char,          # Int'l fractional digits.
      :frac_digits, :char,              # Local fractional digits.
      # 1 if currency_symbol precedes a positive value, 0 if succeeds.
      :p_cs_precedes, :char,
      # 1 iff a space separates currency_symbol from a positive value.
      :p_sep_by_space, :char,
      # 1 if currency_symbol precedes a negative value, 0 if succeeds.
      :n_cs_precedes, :char,
      # 1 iff a space separates currency_symbol from a negative value.
      :n_sep_by_space, :char,

      # Positive and negative sign positions:
      #
      # 0 Parentheses surround the quantity and currency_symbol.
      # 1 The sign string precedes the quantity and currency_symbol.
      # 2 The sign string follows the quantity and currency_symbol.
      # 3 The sign string immediately precedes the currency_symbol.
      # 4 The sign string immediately follows the currency_symbol.
      #
      :p_sign_posn, :char,
      :n_sign_posn, :char,
      # ISOC99
      # 1 if int_curr_symbol precedes a positive value, 0 if succeeds.
      :int_p_cs_precedes, :char,
      # 1 iff a space separates int_curr_symbol from a positive value.
      :int_p_sep_by_space, :char,
      # 1 if int_curr_symbol precedes a negative value, 0 if succeeds.
      :int_n_cs_precedes, :char,
      # 1 iff a space separates int_curr_symbol from a negative value.
      :int_n_sep_by_space, :char,
      # Positive and negative sign positions:
      # 0 Parentheses surround the quantity and int_curr_symbol.
      # 1 The sign string precedes the quantity and int_curr_symbol.
      # 2 The sign string follows the quantity and int_curr_symbol.
      # 3 The sign string immediately precedes the int_curr_symbol.
      # 4 The sign string immediately follows the int_curr_symbol.
      :int_p_sign_posn, :char,
      :int_n_sign_posn, :char
    end

    # Structure returned by {FFI::Locale#localeconv} containing information about numeric and monetary
    # notation.
    class LocaleConv
      # @return [String] Decimal point character.
      attr_reader :decimal_point

      # @return  [String] Thousands separator.
      attr_reader :thousands_sep

      # @return  [Array] Grouping.
      # Each element is the number of digits in each group;
      # elements with higher indices are farther left.
      # An element with value CHAR_MAX means that no further grouping is done.
      # An element with value 0 means that the previous element is used
      # for all groups farther left.
      attr_reader :grouping

      # Monetary information.

      # @return [String] Int'l currency symbol.
      # First three chars are a currency symbol from ISO 4217.
      # Fourth char is the separator. For example, <tt>"GBP "</tt>, <tt>"USD "</tt>.
      attr_reader :int_curr_symbol

      # @return [String] Local currency symbol, e.g. <tt>"£"</tt>, <tt>"$"</tt>.
      attr_reader :currency_symbol

      # @return [String] Decimal point character, e.g. <tt>"."</tt>, <tt>","</tt>.
      attr_reader :mon_decimal_point

      # @return [String] Thousands separator.
      attr_reader :mon_thousands_sep

      # @return [Array] Like {#grouping} element.
      # @see #grouping
      attr_reader :mon_grouping

      # @return [String] Sign for positive values.
      attr_reader :positive_sign

      # @return [String] Sign for negative values.
      attr_reader :negative_sign

      # @return [Integer] Int'l fractional digits.
      attr_reader :int_frac_digits

      # @return [Integer] Local fractional digits.
      attr_reader :frac_digits

      # @return [Boolean] +true+ if {#currency_symbol} precedes a positive value, +false+ if succeeds.
      attr_reader :p_cs_precedes

      # @return [Boolean] +true+ iff a space separates {#currency_symbol} from a positive value.
      attr_reader :p_sep_by_space

      # @return [Boolean] +true+ if {#currency_symbol} precedes a negative value, +false+ if succeeds.
      attr_reader :n_cs_precedes

      # @return [Boolean] +true+ iff a space separates {#currency_symbol} from a negative value.
      attr_reader :n_sep_by_space

      # @return [Integer] Positive sign position.
      #
      # 0 :: Parentheses surround the quantity and {#currency_symbol}.
      # 1 :: The sign string precedes the quantity and {#currency_symbol}.
      # 2 :: The sign string follows the quantity and {#currency_symbol}.
      # 3 :: The sign string immediately precedes the {#currency_symbol}.
      # 4 :: The sign string immediately follows the {#currency_symbol}.
      #
      attr_reader :p_sign_posn

      # @return [Integer]  Negative sign position.
      # @see #p_sign_posn
      attr_reader :n_sign_posn

      # ISOC99

      # @return [Boolean] +true+ if {#int_curr_symbol} precedes a positive value, +false+ if succeeds.
      attr_reader :int_p_cs_precedes

      # @return [Boolean] +true+ iff a space separates {#int_curr_symbol} from a positive value.
      attr_reader :int_p_sep_by_space

      # @return [Boolean] +true+ if {#int_curr_symbol} precedes a negative value, +false+ if succeeds.
      attr_reader :int_n_cs_precedes

      # @return [Boolean] +true+ iff a space separates {#int_curr_symbol} from a negative value.
      attr_reader :int_n_sep_by_space

      # @return [Integer] Positive sign position.
      #
      # 0 :: Parentheses surround the quantity and int_curr_symbol.
      # 1 :: The sign string precedes the quantity and int_curr_symbol.
      # 2 :: The sign string follows the quantity and int_curr_symbol.
      # 3 :: The sign string immediately precedes the int_curr_symbol.
      # 4 :: The sign string immediately follows the int_curr_symbol.
      #
      attr_reader :int_p_sign_posn

      # @return [Integer]  Negative sign position.
      # @see #int_p_sign_posn
      attr_reader :int_n_sign_posn

      #
      # Used by FFI::Locale.localeconv. Should not be called by application code directly.
      #
      # @param [FFI::Pointer] lcs pointer to +lconv+ struct returned by (private) function {FFI::Locale#_localeconv}.
      #
      # @return [FFI::Locale::LocaleConv] instance containing locale attributes.
      #
      def initialize(lcs)
        lcs.layout.members.each do |key|
          value = lcs[key]
          case key
          when :grouping, :mon_grouping
            value = value.each_byte.to_a
          when :p_cs_precedes, :p_sep_precedes, :n_cs_precedes, :p_sep_by_space, :n_sep_by_space,
            :int_p_cs_precedes, :int_p_sep_by_space, :int_n_cs_precedes, :int_n_sep_by_space
            value = (value == 1)
          end
          case value
          when String
            if RUBY_VERSION >= '1.9.0'
              value = value.force_encoding(Encoding.default_external.to_s)
            end
            # For 1.8.x you need to handle this yourself.
          end
          instance_variable_set("@#{key}", value)
        end
      end
    end

    # Returns a {FFI::Locale::LocaleConv} containing the locale
    # information as understood by the underlying C library.
    #
    # @return [FFI::Locale::LocaleConv] locale conv structure containing locale information.
    #
    # The attributes returned are documented in {FFI::Locale::LocaleConv}.
    #
    # See +man localeconv+ and +man 7 locale+ for more details.
    def localeconv
      ptr = FFI::Locale._localeconv
      lcs = FFI::Locale::LocaleConvStruct.new(ptr)
      FFI::Locale::LocaleConv.new(lcs)
    end
    module_function :localeconv

    # The +setlocale+ function is used to set or query the program's current locale.
    #
    # @param [Integer] category One of the constants {FFI::Locale::LC_CTYPE},
    # {FFI::Locale::LC_NUMERIC}, {FFI::Locale::LC_TIME}, {FFI::Locale::LC_COLLATE}, {FFI::Locale::LC_MONETARY},
    # {FFI::Locale::LC_MESSAGES}, {FFI::Locale::LC_ALL}, {FFI::Locale::LC_PAPER}, {FFI::Locale::LC_NAME}, {FFI::Locale::LC_ADDRESS},
    # {FFI::Locale::LC_TELEPHONE}, {FFI::Locale::LC_MEASUREMENT}, {FFI::Locale::LC_IDENTIFICATION}


    # @param  [String]  locale name of locale to switch to, e.g. "en_GB.UTF-8".
    # @return [String]  locale name of locale or nil if request could not be satisfied.
    #
    # On startup, you can specify that your program will use the
    # locale as specified in the user's environment by calling:
    #
    #     FFI::Locale.setlocale(FFI::Locale::LC_ALL, "")
    #
    # This enables the underlying C library to use multi-byte and wide
    # character functions correctly. This call is in fact the reason
    # for the existence of this library. MRI Ruby 1.8.x does not set
    # this so C extensions and FFI adapters that call C library
    # functions that deal with multi-byte or widechars will not
    # function correctly unless this call has been made.
    #
    # If the locale is not <tt>""</tt>, it should be a well-known
    # constant such as "C" or "da_DK" or the value returned from a
    # prior call to {FFI::Locale#setlocale}.
    #
    # The locale <tt>"C"</tt> or <tt>"POSIX"</tt> is a portable
    # locale; its LC_CTYPE part corresponds to the 7-bit ASCII
    # character set.
    #
    # If +locale+ is not nil, the program's current locale is modified
    # according to the arguments.  The argument +category+ determines
    # which parts of the program's current locale should be modified:
    #
    # LC_ALL      :: for all of the locale.
    # LC_COLLATE  :: for regular expression matching (it determines the meaning of  range  expressions  and  equivalence
    #                classes) and string collation.
    # LC_CTYPE    :: for  regular  expression matching, character classification, conversion, case-sensitive comparison,
    #                and wide character functions.
    # LC_MESSAGES :: for localizable natural-language messages.
    # LC_MONETARY :: for monetary formatting.
    # LC_NUMERIC  :: for number formatting (such as the decimal point and the thousands separator).
    # LC_TIME     :: for time and date formatting.
    #
    # See +man setlocale+ for more details.
    #
    # @example Use locale set in environment
    #     FFI::Locale.setlocale(FFI::Locale::LC_ALL, "")
    #
    # @example Use UK UTF-8 locale for character sets only
    #     FFI::Locale.setlocale(FFI::Locale::LC_CTYPE, "en_GB.UTF-8")
    #
    def setlocale(category, locale)
      FFI::Locale._setlocale(category, locale)
    end
    module_function :setlocale

  end
end

