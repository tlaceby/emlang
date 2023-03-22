module parser

import frontend.parser.lexer { Token, TokenKind }
import term
import frontend.ast { TypeKind }

fn (mut parser Parser) advance () Token {
	// TODO: Handle bounds checks
	cur := parser.tokens[parser.position]
	parser.previous = cur
	parser.position += 1
	return cur
}

fn (mut parser Parser) expect (expected TokenKind) Token {
	if parser.current().kind() == expected {
		return parser.advance()
	}

	exp := term.bright_cyan("Token.${expected.str()}")
	instead := term.red("Token.${parser.current().kind().str()}")
	parser.error(mk_basic_err(.unexpected_token, "Unexpected token found! Expected to find ${exp} but instead found ${instead}"))
	exit(1)
}

fn (mut parser Parser) expect_hint (expected TokenKind, hint string) Token {
	if parser.current().kind() == expected {
		return parser.advance()
	}

	exp := term.bright_cyan("Token.${expected.str()}")
	instead := term.red("Token.${parser.current().kind().str()}")
	parser.error(mk_error("Unexpected token found! Expected to find ${exp} but instead found ${instead}", hint, .unexpected_token))
	exit(1)
}

fn (mut parser Parser) not_eof () bool {
	return parser.position < parser.tokens.len
	&& parser.tokens[parser.position].kind() != .eof
}

fn (mut parser Parser) peak () Token {
	// TODO: Check bounds
	return parser.tokens[parser.position + 1]
}

fn (mut parser Parser) current () Token {
	return parser.tokens[parser.position]
}

fn (mut parser Parser) prev () Token {
	// TODO: Check bounds
	return parser.previous
}

fn (mut parser Parser) type_at () TypeKind {
	mut array_of := false
	mut tk := parser.advance()

	match tk.kind() {
		.open_brace {
			parser.expect_hint(.close_brace, "Type started with [ must have following ] included. ex: []number")
			tk = parser.advance()
			array_of = true
		}
		.symbol {}
		else {
			msg := mk_basic_err(.bad_type_assertion, "Unknown type specified in type assertion.")
			parser.error(msg)
			exit(1)
		}
	}

	return TypeKind {
		array_of: array_of,
		typename: tk.val()
	}
}
