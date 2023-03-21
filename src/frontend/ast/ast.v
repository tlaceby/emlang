module ast
pub enum NodeKind {
	// Statements
	block_stmt
	var_declaration
	// Complex Expressions
	binary_expr
	unary_expr
	call_expr

	// Primary Expression
	number_expr
	string_expr
	ident_expr
}

pub type Expr = NumberExpr | StringExpr | IdentExpr | BinaryExpr |
				UnaryExpr | CallExpr
pub type Stmt = Expr | BlockStmt | VarDeclarationStmt

pub type Node = Stmt | Expr
