module lexer

import os

// SourceFile represents a source code file with its name, path, and whether it is a module.
pub struct SourceFile {
	pub:
	name string [required]
	path string [required]
	is_module bool
}

// Lexer is responsible for tokenizing the input source code from a SourceFile.
// It maintains state including the current position, line number, and offset within the input source.
[noinit]
pub struct Lexer {
	file      SourceFile
	source    string
	mut:
	tokens    []Token
	position  int
	line      int
	offset    int
}

// build_lexer creates a new Lexer instance for the given SourceFile.
// It reads the contents of the SourceFile and initializes the Lexer with the appropriate state.
pub fn build_lexer (file SourceFile) !Lexer {
	path := file.path + file.name
	source := os.read_file(path) or {
		return err
	}

	return Lexer{
		file: file,
		source: source
	}
}

// tokenize processes the input source code and generates a list of tokens.
// It iterates through the source, handling different characters and lexemes, and appends the corresponding tokens
// to the lexers token list. It returns the list of tokens once the end of the input source is reached.
pub fn (mut lexer Lexer) tokenize () []Token {
	for lexer.not_eof() {
		match lexer.at() {

			// special characters and ascii special opcodes
			'\n' { lexer.new_line() }
			' ' { lexer.next() }
			'\"', '\'', '`' { lexer.build_string() }

			// single character tokens
			'(' { lexer.mk_single_tk(.open_paren) }
			')' { lexer.mk_single_tk(.close_paren) }
			'[' { lexer.mk_single_tk(.open_brace) }
			']' { lexer.mk_single_tk(.close_brace) }
			'{' { lexer.mk_single_tk(.open_bracket) }
			'}' { lexer.mk_single_tk(.close_bracket) }
			',' { lexer.mk_single_tk(.comma) }
			':' { lexer.mk_single_tk(.colon ) }
			"?" { lexer.mk_single_tk(.question) }
			';' { lexer.mk_single_tk(.semicolon) }
			'.' { lexer.mk_single_tk(.dot) }
			'#' { lexer.handle_comments() }

			// Binary Operators
			'+' {
				if lexer.peak() == '+' {
					lexer.mk_literal_token(.plus_plus, "++")
				} else if lexer.peak() == '=' {
					lexer.mk_literal_token(.plus_eq, "+=")
				} else {
					lexer.mk_single_tk(.plus)
				}
			}
			'-' {
				if lexer.peak() == '-' {
					lexer.mk_literal_token(.minus_minus, "--")
				} else if lexer.peak() == '=' {
					lexer.mk_literal_token(.minus_eq, "-=")
				} else {
					lexer.mk_single_tk(.minus)
				}
			}
			'*' {
				if lexer.peak() == '*' {
					lexer.mk_literal_token(.star_star, "**")
				} else if lexer.peak() == '=' {
					lexer.mk_literal_token(.star_eq, "*=")
				} else {
					lexer.mk_single_tk(.star)
				}
			}
			'/' {
				if lexer.peak() == '=' {
					lexer.mk_literal_token(.slash_eq, "/=")
				} else {
					lexer.mk_single_tk(.slash)
				}
			}
			// Logical & Conditionals
			'=' {
				if lexer.peak() == '=' {
					lexer.mk_literal_token(.is_equals, "==")
				} else {
					lexer.mk_single_tk(.equals)
				}
			}
			'!' {
				if lexer.peak() == '=' {
					lexer.mk_literal_token(.not_equals, "!=")
				} else {
					lexer.mk_single_tk(.not)
				}
			}
			'<' {
				if lexer.peak() == '=' {
					lexer.mk_literal_token(.less_eq, "<=")
				} else {
					lexer.mk_single_tk(.less)
				}
			}
			'>' {
				if lexer.peak() == '=' {
					lexer.mk_literal_token(.greater_eq, ">=")
				} else {
					lexer.mk_single_tk(.greater)
				}
			}

			// Handle numbers, identifiers, reserved keywords and unknown opcodes
			else {
				if lexer.is_numeric() {
					lexer.build_numeric()
				} else if lexer.is_allowed_symbol() {
					lexer.build_identifier()
				} else {
					//TODO: Handle error for unknown token
					println("Unknown token found in source ${lexer.at()} ")
					exit(1)
				}
			}
		}
	}

	// Add ending eof to ensure proper end of file is there for parser
	lexer.tokens << mk_token(.eof, "END_OF_FILE", TokenLocation{})
	return lexer.tokens
}
