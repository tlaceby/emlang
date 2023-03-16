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
	lexer.position += 1
	lexer.offset += 1
	return lexer.source[lexer.position].ascii_str()
}

fn (mut lexer Lexer) new_line () {
	lexer.position += 1
	lexer.offset = 0
}

fn (mut lexer Lexer) is_numeric () bool {
	return lexer.at_u8().is_digit()
}

fn (mut lexer Lexer) is_space () bool {
	return lexer.at_u8().is_space()
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
	panic("Unimplimented method: Build_Identifier")
}
fn (mut lexer Lexer) build_numeric () {
	start_pos := lexer.location()
	mut decimal := 0 // count of found decimals
	mut num_str := ""

	for {
		if lexer.not_eof() && (lexer.is_numeric() || lexer.at() == '.') {
			// Handle decimal points
			if lexer.at() == '.' {
				decimal += 1
			}

			num_str += lexer.next()
		}
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
	panic("unimplimented BuildString")
}

fn (mut lexer Lexer) handle_comments () {
	panic("unimplimented HandleComments")
}

