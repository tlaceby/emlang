module analysis

import frontend.ast { BlockStmt, Stmt, Expr }
import term

pub struct TypeChecker {
mut:
	env TypeEnv
	errors []TypeError
}

pub fn (mut checker TypeChecker) perform_type_analysis (tree Stmt) {
	checker.declare_global_types()
	checker.check(tree)

	if checker.errors.len > 0 {
		println(term.bright_yellow("Type Analysis Failure") + " ${checker.errors.len} issues encountered")
	}
	for err in checker.errors {
		err.display()
	}

	if checker.errors.len > 0 {
		exit(1)
	}

	println(term.bright_cyan("Analysis Complete"))
}

pub fn (mut checker TypeChecker) check (node Stmt) Type {
	match node.kind {
		// Statements
		.block_stmt { return checker.block_stmt(node as BlockStmt) }
		.var_declaration { return checker.var_declaration(node as ast.VarDeclarationStmt) }
		// Expressions
		// .assignment_expr {}
		// .fn_expr {}
		.binary_expr { return checker.binary(node as Expr as ast.BinaryExpr )}
		// .unary_expr {}
		// .call_expr {}
		// .in_expr {}
		.array_literal { return checker.array_literal(node as Expr as ast.ArrayExpr) }
		// .object_property {}
		// .object_literal {}
		// .member_expr {}
		.type_stmt { return checker.type_stmt (node as ast.TypeStmt)}
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
	// Define types
	checker.env.define_type("boolean", Primitive{kind: .boolean, name: "boolean" })
	checker.env.define_type("any", Primitive{kind: .any, name: "any" })
	checker.env.define_type("none", Primitive{kind: .@none, name: "none" })

	// Define literals to a type
	checker.env.lookup["none"] = checker.env.types["none"]
	checker.env.lookup["any"] = checker.env.types["any"]
	checker.env.lookup["true"] = checker.env.types["boolean"]
	checker.env.lookup["false"] = checker.env.types["boolean"]

}
