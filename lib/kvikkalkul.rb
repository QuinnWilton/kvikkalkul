require 'kvikkalkul/lexer'
require 'kvikkalkul/parser'
require 'kvikkalkul/token'

program = <<-eos
666/ 5
/0 -) 666
:1 -) 550
:0 -) 1010
-) :1
1010:
:1 -) 888
:0 -) 1020
-) :1
1020:
/0 -) 666
:1 -) 1030
:2 -) 1040
:0 -) 1050
:3 -) 560
.9 (- ,0
1030:
.8 (- ,0
1040:
-) :3
1050:
.8 (- .8 -/- ,0005
.8 ( ,49975 -) :2
.9 (- .9 -/- ,0005
.9 ( ,49975 -) :1
:1 -) 666
-) :1
eos

lexer     = Kvikkalkul::Lexer.new
tokenized = lexer.lex(program)

parser    = Kvikkalkul::Parser.new
parsed    = parser.parse(tokenized)

require 'pry'; binding.pry
