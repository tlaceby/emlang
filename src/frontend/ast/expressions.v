module ast

pub struct BinaryExpr {
pub:
	kind NodeKind = .binary_expr
	operator string
	left Expr
	right Expr
}
