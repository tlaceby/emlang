module lexer

fn (mut lex Lexer) not_eof () bool {
	return lex.position < lex.source.len
}

fn (mut lex Lexer) next () string {
	lex.offset += 1
	ch := lex.source[lex.position]
	lex.position += 1
	return ch.ascii_str()
}

fn (mut lex Lexer) add_tk (kind TokenKind, val string) {
	location := Location{line: lex.line, offset: lex.offset }
	lex.tokens << token(kind, val, location)
	lex.next()
}

fn (mut lex Lexer) new_line () string {
	lex.line++
	ch := lex.next()
	lex.offset = 0
	return ch
}

fn (mut lex Lexer) at () string {
	return lex.source[lex.position].ascii_str()
}

fn (mut lex Lexer) peak () char {
	if lex.position + 1 < lex.source.len {
		return lex.source[lex.position + 1]
	}

	// Handle out of bounds error
	println("Unexpected end of file inside tokenizer:peak()")
	exit(1)
}

fn (mut lex Lexer) is_numeric () bool {
	ch := u8(lex.at()[0])
	return ch.is_digit()
}

fn (mut lex Lexer) is_symbol () bool {
	s := lex.at()
	ch := s.u8()

	if ch.is_alnum() { return true }
	// if s in ['+', '-', '/', '*', '%', '@', '!', '=', '^', '?', ".", ":"] { return true }
	return false
}
