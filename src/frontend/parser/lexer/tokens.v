module lexer

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
	global
	local
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
	@in // in
	@or // ||
	and // &&
}

pub struct TokenLocation  {
pub:
	line int = 1    // Vertical line which token begins
	offset int      // Position inside the line which token starts at
}

[noinit]
pub struct Token {
	kind TokenKind			[required]
	value string        	[required]
	position TokenLocation  [required]
}

pub fn (tk Token) kind () TokenKind {
	return tk.kind
}

pub fn (tk Token) val () string {
	return tk.value
}

pub fn (tk Token) loc () TokenLocation {
	return tk.position
}

pub fn mk_token (kind TokenKind, value string, position TokenLocation) Token {
	return Token{
		kind
		value
		position
	}
}
