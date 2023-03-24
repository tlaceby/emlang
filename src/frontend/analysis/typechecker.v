module analysis

import frontend.ast { BlockStmt, Stmt, Expr }
import term

struct TypeInfo {
	identifier string [required]
	typename string   [required]
	i_type Type
}

pub enum TypeKind {
	null
	@none
	any
	number
	string
	boolean

	// Complex Types
	array
	@interface
	@union
	function
}

interface Type {
	kind TypeKind
	name string
}

pub struct Primitive {
	kind TypeKind = .number
	name string [required]
}


pub struct TypeChecker {
mut:
	ident_types map[string]TypeInfo
	types map[string]Type
	errors []TypeError
}

pub fn (mut checker TypeChecker) perform_type_analysis (tree Stmt) {
	checker.declare_global_types()
	checker.check(tree)

	for err in checker.errors {
		err.display()
	}

	if checker.errors.len > 0 {
		exit(1)
	}
}

pub fn (mut checker TypeChecker) check (node Stmt) Type {
	match node.kind {
		// Statements
		.block_stmt { return checker.block_stmt(node as BlockStmt) }
		.var_declaration {}
		// Expressions
		.assignment_expr {}
		.fn_expr {}
		.binary_expr { return checker.binary(node as Expr as ast.BinaryExpr )}
		.unary_expr {}
		.call_expr {}
		.in_expr {}
		.array_literal {}
		.object_property {}
		.object_literal {}
		.member_expr {}
		.number_expr,
		.string_expr,
		.ident_expr { return checker.literal (node as Expr) }
		else {
			checker.produce_error(.unknown_ast, "Unknown AST node encountered: ${term.bright_magenta(node.kind.str())}")
		}
	}

	return Primitive{kind: .@none, name: "none" }
}


fn (mut checker TypeChecker) declare_global_types () {
	checker.types['true'] = Primitive{kind: .boolean, name: "boolean" }
	checker.types['false'] = Primitive{kind: .boolean, name: "boolean" }
	checker.types['null'] = Primitive{kind: .null, name: "boolean" }
	checker.types['any'] = Primitive{kind: .any, name: "boolean" }
}
