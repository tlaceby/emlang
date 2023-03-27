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
		.type_stmt { return checker.type_stmt (node as ast.TypeStmt)}
		.extern_stmt { return checker.extern_stmt (node as ast.ExternStmt)}
		.var_declaration { return checker.var_declaration(node as ast.VarDeclarationStmt) }
		.fn_declaration  { return checker.function_declaration( node as ast.FnDeclaration) }
		.return_stmt 	 { return checker.return_stmt (node as ast.ReturnStmt) }
		// Expressions
		.assignment_expr { return checker.assignment(node as Expr as ast.AssignmentExpr)}
		// .fn_expr {}
		.binary_expr { return checker.binary(node as Expr as ast.BinaryExpr )}
		// .unary_expr {}
		.call_expr { return checker.call_expr(node as Expr as ast.CallExpr) }
		// .in_expr {}
		.array_literal { return checker.array_literal(node as Expr as ast.ArrayExpr) }
		// .object_property {}
		// .object_literal {}
		// .member_expr {}
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
	checker.env.define_type("boolean", checker.bool_type())
	checker.env.define_type("any", checker.any_type())
	checker.env.define_type("none", checker.none_type())
	checker.env.define_type("uninitialized", checker.uninitialized_type())
	// uninitialized

	// Define literals to a type
	checker.env.lookup["none"] = checker.env.types["none"]
	checker.env.lookup["any"] = checker.env.types["any"]
	checker.env.lookup["true"] = checker.env.types["boolean"]
	checker.env.lookup["false"] = checker.env.types["boolean"]
	checker.env.lookup["uninitialized"] = checker.env.types["uninitialized"]
}
