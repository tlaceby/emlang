module ast

pub struct NumberExpr {
pub:
	kind NodeKind = .number_expr
	value f64
}

pub struct IdentExpr {
pub:
	kind NodeKind = .ident_expr
	value string
}

pub struct StringExpr {
pub:
	kind NodeKind = .string_expr
	value string
}
