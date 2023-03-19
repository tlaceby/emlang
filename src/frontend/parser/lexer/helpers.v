module lexer

fn (mut lexer Lexer) not_eof () bool {
	return lexer.position < lexer.source.len
}
fn (mut lexer Lexer) at () string {
	return lexer.source[lexer.position].ascii_str()
}

fn (mut lexer Lexer) at_u8 () u8 {
	return lexer.source[lexer.position]
}

fn (mut lexer Lexer) peak () string {
	// Handle bounds checks TODO:
	return lexer.source[lexer.position + 1].ascii_str()
}

fn (mut lexer Lexer) next () string {
	lexer.offset += 1
	ch := lexer.source[lexer.position].ascii_str()
	lexer.position += 1
	return ch
}

fn (mut lexer Lexer) new_line () {
	lexer.line += 1
	lexer.position += 1
	lexer.offset = 0
}

fn (mut lexer Lexer) is_numeric () bool {
	return lexer.at_u8().is_digit()
}

fn (mut lexer Lexer) is_letter () bool {
	return lexer.at_u8().is_letter()
}

fn (mut lexer Lexer) is_allowed_symbol () bool {
	return lexer.is_letter() || lexer.at() in ["_", "$"]
}

fn (mut lexer Lexer) location () TokenLocation {
	return TokenLocation{
		line: lexer.line
		offset: lexer.offset
	}
}

fn (mut lexer Lexer) build_identifier () {
	start := lexer.location()
	mut ident := ""

	for lexer.not_eof() && (lexer.is_allowed_symbol() || lexer.is_numeric()) {
		ident += lexer.next()
	}


	if ident in reserved_keywords {
		lexer.tokens << mk_token(reserved_keywords[ident], ident, start)
	} else {
		lexer.tokens << mk_token(.symbol, ident, start)
	}
}

fn (mut lexer Lexer) build_numeric () {
	start_pos := lexer.location()
	mut decimal := 0 // count of found decimals
	mut num_str := lexer.next()

	for lexer.not_eof() && (lexer.is_numeric() || lexer.at() == '.'){
		// Handle decimal points
		if lexer.at() == '.' {
			decimal += 1
		}


		num_str += lexer.next()

	}

	// check for more than one decimal
	if decimal > 1 {
		// TODO: Throw better error
		println("Number cannot contain multiple decimal points ${num_str}")
		exit(1)
	}

	lexer.tokens << mk_token(.number, num_str, start_pos)
}
fn (mut lexer Lexer) build_string () {
	start := lexer.location()
	opening_delim := lexer.next()
	mut contents := ""
	for lexer.not_eof() && lexer.at() != opening_delim  {
		contents = lexer.next()
	}

	// check that we reached delim not eof
	if lexer.at() == opening_delim {
		lexer.next()
		lexer.tokens << mk_token(.string, contents, start)
		return
	}

	// TODO: Handle unexpected eof
	println("String literal ended unexpectedly! Expected to find ${opening_delim} but instead reached eof")
	exit(1)
}

fn (mut lexer Lexer) handle_comments () {
	for lexer.not_eof() && lexer.at() != '\n' {
		lexer.next()
	}
}

fn (mut lexer Lexer) mk_literal_token (kind TokenKind, value string ) {
	lexer.tokens << mk_token(kind, value, lexer.location())

	for i := 0; i < value.len; i++ {
		lexer.next()
	}
}

fn (mut lexer Lexer) mk_single_tk (kind TokenKind) {
	pos := lexer.location()
	lexer.tokens << mk_token(kind, lexer.next(), pos)
}
