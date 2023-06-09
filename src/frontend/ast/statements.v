module ast

// BlockStmt represents a block statement in the abstract syntax tree (AST),
// containing a sequence of statements enclosed in braces.
pub struct BlockStmt {
	pub:
	kind NodeKind = .block_stmt   // The node type of the block statement
	body []Stmt                   // The list of statements within the block
}

// VarDeclarationStmt represents a variable declaration statement in the abstract
// syntax tree (AST), containing the scope, identifier, and the right-hand side expression.
pub struct VarDeclarationStmt {
	pub:
	kind NodeKind = .var_declaration           		// The node type of the variable declaration statement
	mutable bool                                	// Whether the variable is defined as mut
	assigned_type  Type = Primitive{value: "any",}  // Type the user declared variable to be
	ident string                                	// The name of the variable being declared
	rhs    Expr                                 	// The right-hand side expression for the variable declaration
}

pub struct FnParam {
pub mut:
	kind NodeKind = .fn_param
	name string     [required]
	param_type Type [required]
}

pub struct ReturnStmt {
pub mut:
	kind NodeKind = .return_stmt
	rvalue Expr
}

pub struct TypeStmt {
pub mut:
	kind NodeKind = .type_stmt
	typename string
	value Type
}

pub struct ExternStmt {
	pub mut:
	kind NodeKind = .extern_stmt
	func_name string   [required]
	func_type Function [required]
}

pub struct FnDeclaration {
pub mut:
	kind NodeKind = .fn_declaration
	name string
	params []FnParam [required]
	fn_type Function [required]
	body BlockStmt   [required]
}

pub struct IfStmt {
pub:
	kind NodeKind = .if_stmt
	test Expr
	consequent Stmt
	alternate ?Stmt
}

pub struct ForStmt {
	pub:
	kind NodeKind = .for_stmt
	value string		// The name of the variable assigned through the loop
	index string 		// optional index variable name
	iterable Expr 		// the value being iterated over
	block BlockStmt
}

pub struct WhileStmt {
pub:
	kind NodeKind = .while_stmt
	condition Expr
	block BlockStmt
}
