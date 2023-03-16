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
		source: source
	}
}

pub fn (mut lexer Lexer) tokenize () []Token {
	//

	return lexer.tokens
}
