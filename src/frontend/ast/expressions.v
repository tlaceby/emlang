module ast

pub struct BinaryExpr {
	kind NodeKind = .binary_expr
	operator string
	left Expr
	right Expr
}
