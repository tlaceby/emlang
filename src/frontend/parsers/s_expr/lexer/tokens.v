module lexer

pub enum TokenKind {
	eof
	numeric
	identifier
	open_paren
	close_paren
}

pub struct Location {
pub:
	line u64 		[required]
	offset u64		[required]
}

pub struct Token {
pub:
	value string
	kind TokenKind
	location Location
}

pub fn token (kind TokenKind, value string, location Location) Token {
	return Token{ value: value, kind: kind, location: location  }
}
