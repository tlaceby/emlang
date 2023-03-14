module ast
pub enum NodeKind {
	// Statements
	block_stmt

	// Complex Expressions
	binary_expr

	// Primary Expression
	number_expr
	string_expr
	ident_expr
}
[required]
pub interface ASTNode {
	kind NodeKind
}


pub interface Stmt 	{
	ASTNode
}

pub interface Expr {
	Stmt
}
