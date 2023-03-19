module parser

import frontend.parser.lexer { Token }

fn (mut parser Parser) advance () Token {
	// TODO: Handle bounds checks
	cur := parser.tokens[parser.position]
	parser.position += 1
	return cur
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
