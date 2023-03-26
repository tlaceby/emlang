module lexer


// TokenKind represents different types of tokens recognized by the lexer.
pub enum TokenKind {

	eof
	number
	string
	symbol

	open_paren
	close_paren
	open_bracket
	close_bracket
	open_brace
	close_brace

	is_equals
	not_equals
	not
	less
	less_eq
	greater
	greater_eq

	equals
	semicolon
	colon
	dot
	comma
	question
	bar

	percent
	plus
	plus_plus
	plus_eq
	star
	star_eq
	star_star
	slash
	slash_eq
	minus
	minus_eq
	minus_minus

	// Reserved Keywords
	@mut
	var
	@fn
	@continue
	@break
	@return

	@module
	@import
	@pub

	@if
	@else
	@match
	while
	@for

	@typeof
	@union
	@type
	@in // in
	@or // ||
	and // &&
}

// TokenLocation holds the line and offset information for a token's position in the source code.
pub struct TokenLocation {
	pub:
	// line represents the vertical line in the source code where the token begins.
	line int = 1
	// offset represents the position inside the line where the token starts.
	offset int
}

// Token represents a single token parsed by the lexer, including its kind, value, and location.
[noinit]
pub struct Token {
	kind TokenKind          [required]
	value string            [required]
	position TokenLocation  [required]
}

// kind returns the TokenKind of a Token.
pub fn (tk Token) kind () TokenKind {
	return tk.kind
}

// val returns the value (text representation) of a Token.
pub fn (tk Token) val () string {
	return tk.value
}

// loc returns the TokenLocation (line and offset) of a Token.
pub fn (tk Token) loc () TokenLocation {
	return tk.position
}

// mk_token creates a new Token with the given kind, value, and position.
pub fn mk_token (kind TokenKind, value string, position TokenLocation) Token {
	return Token{
		kind
		value
		position
	}
}
