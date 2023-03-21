module ast

import frontend.parser.lexer

pub struct BinaryExpr {
pub:
	kind NodeKind = .binary_expr
	operator lexer.TokenKind
	left Expr
	right Expr
}


pub struct UnaryExpr {
	pub:
	kind NodeKind = .unary_expr
	operator lexer.TokenKind
	right Expr
}
