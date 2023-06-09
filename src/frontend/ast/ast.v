module ast

// Example []number = array_of: true, object_of: false, typename: number

// NodeKind represents the different types of nodes in the abstract syntax tree (AST).
pub enum NodeKind {
	// Statements
	block_stmt
	for_stmt
	while_stmt
	if_stmt
	type_stmt
	extern_stmt

	return_stmt

	fn_param
	fn_declaration

	var_declaration
	// Complex Expressions
	assignment_expr
	fn_expr
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
pub type Expr = NumberExpr | StringExpr | IdentExpr | BinaryExpr | AssignmentExpr |
UnaryExpr | CallExpr | ArrayExpr | ObjectExpr | ObjectProp | InExpr | MemberExpr | FnExpr

// Stmt is a union type that represents the different types of statements in the AST.
pub type Stmt = Expr | BlockStmt | VarDeclarationStmt | IfStmt | ForStmt | WhileStmt | FnDeclaration | ReturnStmt |
TypeStmt | ExternStmt

// Node is a union type that represents both statements and expressions in the AST.
pub type Node = Stmt | Expr
