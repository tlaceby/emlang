module lexer

import frontend.parsers
import os

[noinit]
pub struct Lexer {
	file parsers.SourceFile  [required]
	source string
mut:
	tokens []Token
	position u64
	line u64 = 1
	offset u64
}

pub fn construct_lexer (file parsers.SourceFile) Lexer {
	file_path := file.path + file.name
	contents := os.read_file(file_path) or {
		println(err)
		exit(1)
	}

	return Lexer { file: file, source: contents }
}

pub fn (mut lex Lexer) produce_tokens () []Token {
	for {
		// If the lexer reaches eof the break
		if !lex.not_eof() { break }
		lex.produce_token()
	}

	return lex.tokens
}

fn (mut lex Lexer) produce_token () {
	match lex.at() {
		// Punctuation and new lines
		' ' , '\s', '\t' { lex.next() }
		'\n' { lex.new_line() }
		// Parens
		'(' { lex.add_tk(.open_paren, "(") }
		')' { lex.add_tk(.close_paren, ")") }

		else {
			if lex.is_numeric() {
				lex.build_numeric()
				return
			}

			lex.build_identifier()
		}
	}
}


