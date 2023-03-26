module analysis

import frontend.ast
import term { bold, cyan, red, magenta }

fn (mut checker TypeChecker) literal (e ast.Expr) Type {
	match e.kind {
		.number_expr { return Primitive{kind: .number, name: "number" }}
		.string_expr { return Primitive{kind: .string, name: "string" }}
		.ident_expr {
			ident := e as ast.IdentExpr
			return checker.env.resolve_var_type(ident.value) or {
				return checker.hint_error(.undefined_identifier, "${ident.value}", "Unknown identifier could not be resolved")
			}
		}
		else {
			panic("Unknown ast in expr_check ${e}")
		}
	}
}

fn (mut checker TypeChecker) array_literal (a ast.ArrayExpr) Type {
	// Return a empty array type which specifies its any kind
	if a.values.len == 0 {
		return ArrayType { contains: Primitive{ name: "any", kind: .any },  name: "[]any" }
	}

	mut found_types := []Type{}
	// Make sure all elements in the array match the first type
	for t in a.values {
		t_kind := checker.check(t)
		if !(t_kind in found_types) {
			found_types << t_kind
		}
	}

	if found_types.len == 1 {
		return ArrayType{name: "[]${found_types[0].name}", contains: found_types[0] }
	}

	// Construct Union Type
	mut name := "("
	for t in found_types[0..found_types.len - 1] {
		name += t.name + " | "
	}

	name += found_types[found_types.len - 1].name + ")"

	union_type := UnionType{
		name: name,
		contains: found_types
	}

	return ArrayType{name: "[]${union_type.name}", contains: union_type}
}

fn (mut checker TypeChecker) binary (e ast.BinaryExpr) Type {
	l_val := checker.check(e.left)
	r_val := checker.check(e.right)

	hint := bold("[${magenta(l_val.name)} ${e.operator.str()} ${magenta(r_val.name)}]")
	if l_val.kind == r_val.kind {
		allowed_binary_types := [TypeKind.string, .number]
		if l_val.kind in allowed_binary_types {
			return l_val
		}

		return checker.hint_error(.invalid_operation, hint, "Cannot perform a binary operation with these types.\n")
	}

	return checker.hint_error(.mismatching_types, hint, "Binary expression must contain matching types. \nInstead found binary expression with operands: ${e}")
}
