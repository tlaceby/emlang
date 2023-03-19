module parser

import frontend.parser.lexer { Token, TokenKind }

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

	println("Unexpected token found: ${parser.current()}. Expected type: ${expected}")
	exit(1)
}

fn (mut parser Parser) not_eof () bool {
	return parser.position < parser.tokens.len
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
