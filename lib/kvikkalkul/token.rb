require 'ruby-enum'

module Kvikkalkul
  class Token
    include Ruby::Enum

    define :NEWLINE, :NEWLINE
    define :SPACE,   :SPACE

    define :ZERO,  :ZERO
    define :ONE,   :ONE
    define :TWO,   :TWO
    define :THREE, :THREE
    define :FOUR,  :FOUR
    define :FIVE,  :FIVE
    define :SIX,   :SIX
    define :SEVEN, :SEVEN
    define :EIGHT, :EIGHT
    define :NINE,  :NINE

    define :PERIOD, :PERIOD
    define :COMMA,  :COMMA
    define :QUOTE,  :QUOTE
    define :COLON,  :COLON
    define :DASH,   :DASH
    define :SLASH,  :SLASH
    define :LPAREN, :LPAREN
    define :RPAREN, :RPAREN
  end
end
