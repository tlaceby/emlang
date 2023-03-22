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
	local bool                                  // Whether the variable is local or global
	assigned_type string	  = "inferred"      // Type the user declared variable to be
	ident string                                // The name of the variable being declared
	rhs    Expr                                 // The right-hand side expression for the variable declaration
}
