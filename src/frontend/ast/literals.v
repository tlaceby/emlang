module ast

pub struct NumberExpr {
	kind NodeKind = .number_expr
	value f64
}

pub struct IdentExpr {
	kind NodeKind = .ident_expr
	value string
}

pub struct StringExpr {
	kind NodeKind = .string_expr
	value string
}
