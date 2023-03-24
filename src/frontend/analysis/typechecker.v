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
	any
	number
	string
	boolean
	complex
}

interface Type {
	kind TypeKind
	satisfies (typename string) bool
}

pub struct Primitive {
	kind TypeKind = .number
}

pub fn (t Primitive) satisfies (typename string) bool {
	return t.kind.str() == typename && t.kind.str() != 'complex'
}


pub struct TypeChecker {
mut:
	ident_types map[string]TypeInfo
	types map[string]Type
	errors bool
}

pub fn (mut checker TypeChecker) perform_type_analysis (tree Stmt) bool {
	checker.declare_global_types()
	checker.check_stmt(tree)
	return checker.errors
}

pub fn (mut checker TypeChecker) check_stmt (node Stmt) {
	match node.kind {
		// Statements
		.block_stmt { checker.block_stmt(node as BlockStmt) }
		// 	Expressions
		// .assignment_expr,
		// .fn_expr,
		// .binary_expr,
		// .unary_expr,
		// .call_expr,
		// .in_expr,
		// .array_literal,
		// .object_property,
		// .object_literal,
		// .member_expr,
		.number_expr,
		.string_expr,
		.ident_expr { checker.check(node as Expr) }
		else {
			checker.errors = true
			print(term.bright_red("Error::TypeAnalysis: "))
			println("Unknown Type encountered in `check`: ")
			println(node)
			exit(1)
		}
	}
}


fn (mut checker TypeChecker) declare_global_types () {
	checker.types['true'] = Primitive{kind: .boolean }
	checker.types['false'] = Primitive{kind: .boolean }
	checker.types['null'] = Primitive{kind: .null }
	checker.types['any'] = Primitive{kind: .any }
}
