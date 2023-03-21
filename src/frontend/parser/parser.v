module parser

import frontend.ast { Expr, Stmt, BlockStmt }
import frontend.parser.lexer { build_lexer, SourceFile , Token, TokenKind, mk_token }

pub struct Parser {
mut:
	file SourceFile = SourceFile{name: "test.em", path: "src/"}
	// Default token will never actually be used
	previous Token = mk_token(.eof, "eof", lexer.TokenLocation{})
	tokens []Token
	position int
}

pub fn (mut parser Parser) produce_ast (file SourceFile) Stmt {
	parser.file = file
	mut lex := build_lexer(file) or {
		println(err)
		exit(1)
	}

	parser.tokens = lex.tokenize()

	mut block := []Stmt{}

	for parser.not_eof() {
		block << parser.statement()
	}

	return BlockStmt{ body: block }
}


pub fn (mut parser Parser) expression (rbp int) Expr {
	mut tk := parser.advance()

	// Validates the lookup for a <nud>()
	parser.validate_nud()

	mut nud := nud_lookup[tk.kind()]
	mut left := nud(mut parser)

	for parser.not_eof() && rbp < int(bp_lookup[parser.current().kind()]) {
		tk = parser.advance()

		parser.validate_led()

		led := led_lookup[tk.kind()]
		left = led(mut parser, left, int(bp_lookup[tk.kind()]))
	}

	return left
}
