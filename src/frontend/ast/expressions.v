module ast

import frontend.parser.lexer


// BinaryExpr represents a binary expression in the abstract syntax tree (AST),
// containing two expressions combined with a binary operator, such as addition,
// subtraction, or multiplication.
pub struct BinaryExpr {
	pub:
	kind NodeKind = .binary_expr     // The node type of the binary expression
	operator lexer.TokenKind         // The binary operator token kind
	left Expr                        // The left-hand side expression
	right Expr                       // The right-hand side expression
}

// UnaryExpr represents a unary expression in the abstract syntax tree (AST),
// containing a single expression and a unary operator, such as negation or
// logical NOT.
pub struct UnaryExpr {
	pub:
	kind NodeKind = .unary_expr      // The node type of the unary expression
	operator lexer.TokenKind         // The unary operator token kind
	right Expr                       // The operand expression
}

// CallExpr represents a function call expression in the abstract syntax tree
// (AST), containing a function identifier and a list of argument expressions.
pub struct CallExpr {
	pub:
	kind NodeKind = .call_expr       // The node type of the call expression
	caller Expr                      // The function identifier expression
	args []Expr                      // The list of argument expressions
}

pub struct InExpr {
	pub:
	kind NodeKind = .in_expr       // The node type of the in expression
	lhs Expr                       // Should be a literal or more complex expression
	rhs Expr                       // Array, Fn call or identifier etc...
}

pub struct MemberExpr {
pub:
	kind NodeKind = .member_expr
	computed bool
	lhs Expr
	rhs Expr
}
