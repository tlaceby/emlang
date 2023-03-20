module lexer

import os

pub struct SourceFile {
pub:
	name string [required]
	path string [required]
	is_module bool
}


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

pub fn build_lexer (file SourceFile) !Lexer {
	path := file.path + file.name
	source := os.read_file(path) or {
		return err
	}

	return Lexer{
		file: file,
		source: "{" + source + " } "
	}
}

pub fn (mut lexer Lexer) tokenize () []Token {
	for lexer.not_eof() {
		match lexer.at() {
			'\n' { lexer.new_line() }
			' ', '\s', '\t' { lexer.next() }
			'\"', '\'', '`' { lexer.build_string() }
			'(' { lexer.mk_single_tk(.open_paren) }
			'=' { lexer.mk_single_tk(.equals) }
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

	return lexer.tokens
}
