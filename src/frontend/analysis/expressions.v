module analysis

import frontend.ast

fn (mut checker TypeChecker) check (e ast.Expr) Type {
	match e.kind {
		.number_expr { return Primitive{kind: .number }}
		.string_expr { return Primitive{kind: .string }}
		.ident_expr {
			ident := e as ast.IdentExpr
			if ident.value in checker.types {
				return checker.types[ident.value]
			}

			println("Identifier's type cannot be resolved: ${ident.value}")
			exit(1)
		}
		else {
			panic("Unknown ast in expr_check ${e}")
		}
	}
}
