module parser

import frontend.ast { Stmt }
import frontend.parser.lexer { build_lexer, SourceFile , Token }

pub struct Parser {
mut:
	tokens []Token
	position int
}

pub fn (mut parser Parser) produce_ast (file SourceFile) ast.BlockStmt {
	mut lex := build_lexer(file) or {
		println(err)
		exit(1)
	}

	parser.tokens = lex.tokenize()

	for tk in parser.tokens {
		println(tk)
	}


	mut body := []Stmt{}

	for {
		// parse tokens until eof
		break
	}

	return ast.BlockStmt{ body: body }
}

