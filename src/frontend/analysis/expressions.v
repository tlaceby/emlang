module analysis

import frontend.ast
import term { bold, cyan, red, magenta }

fn (mut checker TypeChecker) literal (e ast.Expr) Type {
	match e.kind {
		.number_expr { return Primitive{kind: .number, name: "number" }}
		.string_expr { return Primitive{kind: .string, name: "string" }}
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

fn (mut checker TypeChecker) binary (e ast.BinaryExpr) Type {
	l_val := checker.check(e.left)
	r_val := checker.check(e.right)

	if l_val.kind == r_val.kind { return l_val }
	hint := bold("[${magenta(l_val.name)} ${e.operator.str()} ${magenta(r_val.name)}]")
	return checker.hint_error(.mismatching_types, hint, "Binary expression must contain matching types. \nInstead found binary expression with operands: ${e}")
}
