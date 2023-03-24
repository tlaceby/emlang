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
	kind NodeKind = .var_declaration            // The node type of the variable declaration statement
	mutable bool                                 // Whether the variable is defined as mut
	assigned_type string	  = "inferred"      // Type the user declared variable to be
	ident string                                // The name of the variable being declared
	rhs    Expr                                 // The right-hand side expression for the variable declaration
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
