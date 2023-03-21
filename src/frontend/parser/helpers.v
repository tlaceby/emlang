module parser

import frontend.parser.lexer { Token, TokenKind }
import term

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
