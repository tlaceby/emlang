module ast

enum BinaryOperator {
	// ---- logical expression ----
	logical_and
	logical_or

	// ---- comparison expr ----
	less
	less_eq
	greater
	greater_eq
	is_equals
	not_equals

	// ---- additive expr ----
	add
	subtract

	// // ---- multiplicative expr ---
	divide
	multiply
	modulus
}
pub struct BinaryExpr {
	kind NodeKind = .binary_expr
	operator BinaryOperator
	left Expr
	right Expr				
}
