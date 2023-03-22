module ast

// NumberExpr represents a numeric literal expression in the abstract syntax tree
// (AST), containing a floating-point value.
pub struct NumberExpr {
	pub:
	kind NodeKind = .number_expr    // The node type of the numeric expression
	value f64                       // The numeric value of the expression
}

// IdentExpr represents an identifier expression in the abstract syntax tree (AST),
// containing a variable or function name.
pub struct IdentExpr {
	pub:
	kind NodeKind = .ident_expr     // The node type of the identifier expression
	value string                    // The name of the identifier
}

// StringExpr represents a string literal expression in the abstract syntax tree
// (AST), containing a string value.
pub struct StringExpr {
	pub:
	kind NodeKind = .string_expr    // The node type of the string expression
	value string                    // The string value of the expression
}



pub struct ArrayExpr {
	pub:
	kind NodeKind = .array_literal
	values []Expr
}

pub struct ObjectProp {
	pub:
	kind NodeKind = .object_property
	label string   [required]
	value Expr     [required]
}
pub struct ObjectExpr {
	pub:
	kind NodeKind = .object_literal
	values []ObjectProp
}
