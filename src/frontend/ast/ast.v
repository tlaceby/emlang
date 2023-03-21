module ast
pub enum NodeKind {
	// Statements
	block_stmt
	var_declaration
	// Complex Expressions
	binary_expr
	unary_expr

	// Primary Expression
	number_expr
	string_expr
	ident_expr
}

pub type Expr = NumberExpr | StringExpr | IdentExpr | BinaryExpr | UnaryExpr
pub type Stmt = Expr | BlockStmt | VarDeclarationStmt

pub type Node = Stmt | Expr
