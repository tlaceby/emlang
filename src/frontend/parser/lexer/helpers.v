module lexer

// not_eof checks if the lexer has reached the end of the input source.
// Returns true if the lexer position is within the bounds of the source, false otherwise.
fn (mut lexer Lexer) not_eof () bool {
	return lexer.position < lexer.source.len
}

// at returns the character at the current lexer position as a string.
// Note: This function assumes the lexer position is within the bounds of the source.
fn (mut lexer Lexer) at () string {
	return lexer.source[lexer.position].ascii_str()
}

// at_u8 returns the character at the current lexer position as a u8 (byte).
// Note: This function assumes the lexer position is within the bounds of the source.
fn (mut lexer Lexer) at_u8 () u8 {
	return lexer.source[lexer.position]
}

// peak returns the character immediately after the current lexer position as a string.
// Note: This function does not perform bounds checks and may cause errors if the lexer.position is at the end of the source.
// TODO: Add proper bounds checks for this function.
fn (mut lexer Lexer) peak () string {
	return lexer.source[lexer.position + 1].ascii_str()
}

fn (mut lexer Lexer) next () string {
	// Increment the offset by 1.
	lexer.offset += 1
	// Get the character at the current lexer position as a string.
	ch := lexer.source[lexer.position].ascii_str()
	lexer.position += 1
	// Return the character as a string.
	return ch
}

// new_line updates the lexer state when encountering a newline character.
// It increments the line count, resets the offset, and moves the lexer position to the next character.
fn (mut lexer Lexer) new_line () {
	lexer.line += 1
	lexer.position += 1
	lexer.offset = 0
}

// is_numeric checks if the character at the current lexer position is a numeric digit.
// Returns true if the character is a digit, false otherwise.
fn (mut lexer Lexer) is_numeric () bool {
	return lexer.at_u8().is_digit()
}

// is_letter checks if the character at the current lexer position is a letter (alphabetic character).
// Returns true if the character is a letter, false otherwise.
fn (mut lexer Lexer) is_letter () bool {
	return lexer.at_u8().is_letter()
}

// is_allowed_symbol checks if the character at the current lexer position is an allowed symbol.
// Allowed symbols are letters, underscores ("_"), and dollar signs ("$").
// Returns true if the character is an allowed symbol, false otherwise.
fn (mut lexer Lexer) is_allowed_symbol () bool {
	return lexer.is_letter() || lexer.at() in ["_", "$"]
}

// location creates a new TokenLocation instance with the current line number and offset.
// Returns the created TokenLocation instance.
fn (mut lexer Lexer) location () TokenLocation {
	return TokenLocation{
		line: lexer.line
		offset: lexer.offset
	}
}

// build_identifier constructs an identifier token from the input source.
// It appends characters to the identifier as long as they are allowed symbols or numeric digits.
// If the resulting identifier matches a reserved keyword, a corresponding keyword token is created.
// Otherwise, a symbol token is created for the identifier.
fn (mut lexer Lexer) build_identifier () {
	start := lexer.location()
	mut ident := ""

	for lexer.not_eof() && (lexer.is_allowed_symbol() || lexer.is_numeric()) {
		ident += lexer.next()
	}

	mut reserved_keywords := map[string]TokenKind{}

	reserved_keywords["mut"] = .@mut
	reserved_keywords["var"] = .var
	reserved_keywords["fn"] = .@fn
	reserved_keywords["continue"] = .@continue
	reserved_keywords["break"] = .@break
	reserved_keywords["return"] = .@return

	reserved_keywords["module"] = .@module
	reserved_keywords["import"] = .@import
	reserved_keywords["pub"] = .@pub

	reserved_keywords["if"] = .@if
	reserved_keywords["else"] = .@else
	reserved_keywords["match"] = .@match
	reserved_keywords["while"] = .while
	reserved_keywords["for"] = .@for

	reserved_keywords["type"] = .@type
	reserved_keywords["extern"] = .extern
	reserved_keywords["union"] = .@union
	reserved_keywords["typeof"] = .@typeof
	reserved_keywords["in"] = .@in
	reserved_keywords["or"] = .@or
	reserved_keywords["and"] = .and
	reserved_keywords["not"] = .not

	if ident in reserved_keywords {
		lexer.tokens << mk_token(reserved_keywords[ident], ident, start)
	} else {
		lexer.tokens << mk_token(.symbol, ident, start)
	}

}

// build_numeric constructs a numeric token from the input source.
// It appends characters to the numeric string as long as they are numeric digits or decimal points.
// If more than one decimal point is encountered, an error is thrown and the program exits.
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

// build_string constructs a string token from the input source.
// It appends characters to the string until the closing delimiter is encountered or the input source ends.
// If the closing delimiter is not encountered, an error is thrown and the program exits.
fn (mut lexer Lexer) build_string () {
	start := lexer.location()
	opening_delim := lexer.next()
	mut contents := ""
	for lexer.not_eof() && lexer.at() != opening_delim  {
		contents += lexer.next()
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

// handle_comments skips over comment text in the input source.
// It advances the lexer position until a newline character or the end of the input source is encountered.
fn (mut lexer Lexer) handle_comments () {
	for lexer.not_eof() && lexer.at() != '\n' {
		lexer.next()
	}
}

// mk_literal_token creates a new token with the specified kind and value and appends it to the lexer's tokens.
// It advances the lexer position by the length of the value string.
fn (mut lexer Lexer) mk_literal_token (kind TokenKind, value string) {
	lexer.tokens << mk_token(kind, value, lexer.location())

	for i := 0; i < value.len; i++ {
		lexer.next()
	}
}

// mk_single_tk creates a new single-character token with the specified kind and appends it to the lexer's tokens.
// It advances the lexer position by one character.
fn (mut lexer Lexer) mk_single_tk (kind TokenKind) {
	pos := lexer.location()
	lexer.tokens << mk_token(kind, lexer.next(), pos)
}
