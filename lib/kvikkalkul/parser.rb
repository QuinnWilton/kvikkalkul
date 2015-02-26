require 'kvikkalkul/token'

module Kvikkalkul
  class Parser
    class ParseError < RuntimeError; end

    def parse(tokens)
      tokens.map { |statement| decode_statement(statement)}
    end

    private

    def decode_statement(statement)
      statement.map { |node| decode_node(node) }
    end

    def decode_node(node)
      case node
      when []
        Token::EOF
      when [Token::LPAREN, Token::DASH]
        Token::ASSIGNMENT
      when [Token::DASH, Token::RPAREN]
        Token::POINTS_TO
      when [Token::LPAREN, Token::LPAREN]
        Token::PREVIOUS
      when [Token::RPAREN, Token::RPAREN]
        Token::NEXT
      when [Token::DASH, Token::SLASH, Token::DASH]
        Token::PLUS
      when [Token::DASH, Token::DASH]
        Token::MINUS
      when [Token::LPAREN, Token::RPAREN]
        Token::Times
      when [Token::DASH, Token::COLON, Token::DASH]
        Token::DIVIDE
      when [Token::DASH]
        Token::UNARY_MINUS
      when [Token::COLON, Token::COLON]
        Token::EQUAL
      when [Token::COLON, Token::SLASH, Token::COLON]
        Token::NOT_EQUAL
      when [Token::LPAREN]
        Token::LESS
      when [Token::RPAREN]
        Token::GREATER
      when [Token::LPAREN, Token::COLON]
        Token::LESS_OR_EQUAL
      when [Token::RPAREN, Token::COLON]
        Token::GREATER_OR_EQUAL
      else
        if node.first == Token::PERIOD && node.length == 2
          decode_register(node)
        elsif node.first == Token::COMMA
          decode_number(node)
        elsif node.first == Token::SLASH
          decode_data_pointer(node)
        elsif node.first == Token::COLON
          decode_program_pointer(node)
        elsif node.last == Token::SLASH
          decode_allocate_data_pointer(node)
        elsif node.last == Token::COLON
          decode_declare_program_pointer(node)
        elsif node.first == Token::LPAREN && node.last == Token::RPAREN && node.length == 3
          decode_channel(node)
        elsif node.first == Token::QUOTE && node.length == 2
          decode_constant(node)
        else
          decode_literal(node)
        end
      end
    end

    def decode_register(node)
      [Token::REGISTER, Token.digit_to_integer(node[1])]
    end

    def decode_number(node)
      number = '0.'
      node[1..-1].each do |digit|
        raise ParseError, "Expected digit, got #{digit}" unless Token.digit?(digit)

        number << Token.digit_to_integer(digit).to_s
      end

      [Token::NUMBER, number.to_f]
    end

    def decode_data_pointer(node)
      [Token::DATA_POINTER, decode_literal(node[1..-1])]
    end

    def decode_program_pointer(node)
      [Token::PROGRAM_POINTER, decode_literal(node[1..-1])]
    end

    def decode_allocate_data_pointer(node)
      [Token::ALLOCATE_DATA_POINTER, decode_literal(node[0..-2])]
    end

    def decode_declare_program_pointer(node)
      [Token::DECLARE_PROGRAM_POINTER, decode_literal(node[0..-2])]
    end

    def decode_channel(node)
      [Token::CHANNEL, decode_literal(node[1])]
    end

    def decode_constant(node)
      [Token::CONSTANT, decode_literal(node[1])]
    end

    def decode_literal(node)
      number = ''
      node.each do |digit|
        raise ParseError, "Expected digit, got #{digit}" unless Token.digit?(digit)

        number << Token.digit_to_integer(digit).to_s
      end

      [Token::LITERAL, number.to_i]
    end
  end
end
