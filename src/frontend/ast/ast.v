module ast

// Example []number = array_of: true, object_of: false, typename: number

// NodeKind represents the different types of nodes in the abstract syntax tree (AST).
pub enum NodeKind {
	// Statements
	block_stmt
	var_declaration
	// Complex Expressions
	binary_expr
	unary_expr
	call_expr
	in_expr

	// Complex Literals
	array_literal
	object_property
	object_literal
	member_expr

	// Primary Expression
	number_expr
	string_expr
	ident_expr
}

// Expr is a union type that represents the different types of expressions in the AST.
pub type Expr = NumberExpr | StringExpr | IdentExpr | BinaryExpr |
UnaryExpr | CallExpr | ArrayExpr | ObjectExpr | ObjectProp | InExpr | MemberExpr

// Stmt is a union type that represents the different types of statements in the AST.
pub type Stmt = Expr | BlockStmt | VarDeclarationStmt

// Node is a union type that represents both statements and expressions in the AST.
pub type Node = Stmt | Expr
