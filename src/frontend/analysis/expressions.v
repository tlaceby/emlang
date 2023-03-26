module analysis

import frontend.ast
import term { bold, cyan, red, magenta, bright_yellow, bright_magenta }

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

fn (mut checker TypeChecker) assignment (e ast.AssignmentExpr) Type {
	rhs_type := checker.check(e.rvalue)
	lhs_type := checker.check(e.lvalue)

	// Make sure right hand type is compatible with left hand side of expression
	if checker.type_implements(rhs_type, lhs_type) {
		return rhs_type
	}

	hint := "${bold(bright_magenta(lhs_type.name))} = ${bold(bright_yellow(rhs_type.name))}"
	message := "Assignment expression contains mismatching types.\nlvalue is typeof ${lhs_type.name} however rvalue is typeof ${rhs_type.name}"
	checker.hint_error(.invalid_assignment, hint, message)
	return checker.none_type()
}

fn (mut checker TypeChecker) call_expr (e ast.CallExpr) Type {
	caller := checker.check(e.caller)
	args := e.args

	match caller {
		FunctionType {
			arg_types := args.map(fn[mut checker](arg ast.Expr) Type {
				return checker.check(arg)
			})

			expected_params := caller.params as []Type
			// Validate function arity
			if arg_types.len != expected_params.len {
				hint := "Bad Function Call ${caller.name}"
				message := "Function call expected ${expected_params.len} args but received ${arg_types.len} instead.\n${e.str()}"
				checker.hint_error(.bad_function_call, hint, message)
			} else {

				for index, calling_arg in arg_types {
					expected_arg := checker.check(args[index])
					if checker.type_implements(calling_arg, expected_arg) == false {
						hint := "args don't match"
						expected_message := "Expected: ${bold(bright_magenta(expected_arg.name))} but received ${bold(bright_yellow(calling_arg.name))} instead"
						message := "Argument at position ${index + 1} of arguments list does not match expected type.\n${expected_message}"
						checker.hint_error(.bad_function_call, hint, message)
					}
				}

				return caller.result as Type
			}
		}
		else {
			hint := "Bad Call ${caller.name}"
			message := "lvalue of call is not callable.\n${e.str()}"
			checker.hint_error(.bad_function_call, hint, message)
		}
	}

	return checker.none_type()
}
