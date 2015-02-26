require 'ruby-enum'

module Kvikkalkul
  class Token
    include Ruby::Enum

    define :NEWLINE, :NEWLINE
    define :SPACE,   :SPACE
    define :EOF,     :EOF

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

    define :LITERAL,  :LITERAL
    define :NUMBER,   :NUMBER
    define :CONSTANT, :CONSTANT

    define :ASSIGNMENT, :ASSIGNMENT
    define :POINTS_TO, :POINTS_TO
    define :PREVIOUS, :PREVIOUS
    define :NEXT, :NEXT

    define :PLUS,  :PLUS
    define :MINUS, :MINUS
    define :TIMES, :TIMES
    define :DIVIDE, :DIVIDE
    define :UNARY_MINUS, :UNARY_MINUS

    define :EQUAL,            :EQUAL
    define :NOT_EQUAL,        :NOT_EQUAL
    define :LESS,             :LESS
    define :GREATER,          :GREATER
    define :LESS_OR_EQUAL,    :LESS_OR_EQUAL
    define :GREATER_OR_EQUAL, :GREATER_OR_EQUAL

    define :REGISTER,        :REGISTER

    define :ALLOCATE_DATA_POINTER, :ALLOCATE_DATA_POINTER
    define :DATA_POINTER,          :DATA_POINTER

    define :DECLARE_PROGRAM_POINTER, :DECLARE_PROGRAM_POINTER
    define :PROGRAM_POINTER,         :PROGRAM_POINTER

    define :CHANNEL,         :CHANNEL

    def self.digit?(token)
      [
        ZERO,
        ONE,
        TWO,
        THREE,
        FOUR,
        FIVE,
        SIX,
        SEVEN,
        EIGHT,
        NINE
      ].include? token
    end

    def self.digit_to_integer(digit)
      case digit
      when ZERO
        0
      when ONE
        1
      when TWO
        2
      when THREE
        3
      when FOUR
        4
      when FIVE
        5
      when SIX
        6
      when SEVEN
        7
      when EIGHT
        8
      when NINE
        9
      else
        raise ArgumentError, "Expected digit, got #{digit}"
      end
    end
  end
end
